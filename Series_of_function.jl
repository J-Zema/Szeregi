"""
    SeriesOfFunction
Moduł służący tworzeniu szeregów Fouriera i Taylora/Maclaurina podanej funkcji
i ich wizualizacji
"""
module SeriesOfFunction

using Plots

export integral, fourier, derivatives, maclaurin_sum, taylor_sum, maclaurin_formula, taylor_formula, plotter, animation_maker


"""
    integral(f, a::Real, b::Real)
Funkcja zwraca wartość całki oznaczonej funkcji f na obszarze całkowania
[a,b], na którym funkcja ta jest ciągła( przy czym to użytkownik musi
zatroszczyć się o prawidłowość inputu); całka przybliżana jest metodą trapezów.
# Przykład:
```jldoctest
julia> integral(x -> sin(x), 0, pi)
1.9999833163940608
```
"""
function integral(f, a::Real, b::Real)
    n = Int(round(100*(b-a), digits=0))
    h = (b-a)/n
    return h * (0.5*f(a) + sum(f.(LinRange(a+h, a+(n-1)*h, n-1))) + 0.5*f(b))
end

"""
    fourier(f, n::Int)
Funkcja zwraca funkcję będącą szeregiem Fouriera funkcji f;
n to ilość pierwszych wyrazów szeregu, którymi przybliżamy funkcję.
Funkcja korzysta z przybliżeń wartości całek metodą trapezów.
# Przykład:
```julia-repl
julia> g = fourier(x -> exp(x), 4)
#3 (generic function with 1 method)

julia> g(12)
0.847053810764935
```
"""
function fourier(f, n::Int)
    a₀ = 1/π * integral(f, -π, π)
    sum_ = collect(1:n)
    aₙ = 1/π * integral.(x->f(x)*cos.(sum_ .* x), -π, π)
    bₙ = 1/π * integral.(x->f(x)*sin.(sum_ .* x), -π, π)
    return x -> a₀/2 + sum(aₙ .* cos.(x .* sum_) .+ bₙ .* sin.(x .* sum_))
end

"""
    derivatives(func::Function, k::Int, x_min::Real, x_max::Real, points::Int=1001)
Funkcja zwraca macierz o budowie:
- pierwszy wiersz to points argumentów z przedziału [x_min, x_max] (domyślnie 1001)
- drugi wiersz - wartości funkcji func dla powyższych argumentów
- dalsze wiersze to kolejne pochodne funkcji func w danych punktach
  (do k-tej pochodnej włącznie).
Przy przybliżaniu wartości pochodnych funkcja korzysta
z metody dwupunktowych różnic centralnych,
jednak to użytkownik powinien zadbać o to,
czy wyliczone pochodne istnieją/mają senes analityczny.
# Przykład
```jldoctest
julia> derivatives(x -> 3*x^2, 3, -0.2, 0.2, 21)
5×21 Array{Float64,2}:
 -0.2   -0.18    -0.16    -0.14    -0.12    -0.1   -0.08    -0.06    -0.04    -0.02    0.0  0.02    0.04    0.06    0.08    0.1   0.12    0.14    0.16    0.18    0.2
  0.12   0.0972   0.0768   0.0588   0.0432   0.03   0.0192   0.0108   0.0048   0.0012  0.0  0.0012  0.0048  0.0108  0.0192  0.03  0.0432  0.0588  0.0768  0.0972  0.12
 -1.2   -1.08    -0.96    -0.84    -0.72    -0.6   -0.48    -0.36    -0.24    -0.12    0.0  0.12    0.24    0.36    0.48    0.6   0.72    0.84    0.96    1.08    1.2
  6.0    6.0      6.0      6.0      6.0      6.0    6.0      6.0      6.0      6.0     6.0  6.0     6.0     6.0     6.0     6.0   6.0     6.0     6.0     6.0     6.0
  0.0    0.0      0.0      0.0      0.0      0.0    0.0      0.0      0.0      0.0     0.0  0.0     0.0     0.0     0.0     0.0   0.0     0.0     0.0     0.0     0.0
```
"""
function derivatives(func::Function, k::Int, x_min::Real, x_max::Real, points::Int=1001)
    h = (x_max-x_min)/(points-1)
    new_points = points+2*k
    X = LinRange(x_min-k*h, x_max+k*h, new_points)

    D = zeros(Float64, k+2, new_points)
    D[1,:] = X
    D[2,:] = func.(X)

    for i in 3:k+2
        for j in i-1:new_points-i+2
            D[i,j] = (D[i-1,j+1] - D[i-1,j-1])/(2*h)
            if abs(D[i,j]) < 0.005
                D[i,j] = 0
            elseif abs(D[i,j]) == Inf
                D[i,j] = NaN
            end
        end
    end

    return D[:,k+1:end-k]
end

"""
    maclaurin_sum(func::Function, k::Int, x::Real)
Funkcja zwraca wartość funkcji func w punkcie x,
korzystając z rozwinięcia Maclaurina funkcji func do k-tego wyrazu.
Przy wyznaczaniu pochodnych w punkcie 0 korzysta z funkcji derivatives.
# Przykład:
```jldoctest
julia> maclaurin_sum(x -> 3*x^2 + cos(x), 4, pi)
29.72217350056467154944058123248894873368532017699634374566057537503382945942576
```
"""
function maclaurin_sum(func::Function, k::Int, x::Real)
    D = derivatives(func, k, -1, 1, 21)
    D_0 = D[:,11]

    index = collect(1:k)
    return D_0[2] + sum(D_0[3:end] ./ factorial.(big.(index)) .* x .^ index)
end

"""
    maclaurin_formula(func::Function, k::Int)
Funkcja zwraca wzór funkcji func w postaci szeregu Maclaurina tej
funkcji składającego się z k wyrazów. Przy wyznaczaniu pochodnych w punkcie 0
korzysta z funkcji derivatives.
# Przykład:
```jldoctest
julia> h = maclaurin_formula(x -> sin(x), 5)
#7 (generic function with 1 method)
julia> h(0)
0.0
```
"""
function maclaurin_formula(func::Function, k::Int)
    D = derivatives(func, k, -1, 1, 21)
    D_0 = D[:,11]
    index = collect(1:k)
    return x -> D_0[2] + sum(D_0[3:end] ./ factorial.(big.(index)) .* x .^ index)
end

"""
    taylor_sum(func::Function, k::Int, x::Real, x_0::Real)
Funkcja zwraca wartość funkcji func w punkcie x,
korzystając z rozwinięcia Taylora funkcji func do k-tego wyrazu.
Przy wyznaczaniu pochodnych w punkcie x_0 korzysta z funkcji derivatives.
# Przykład:
```jldoctest
julia> taylor_sum(x -> cos(x), 4, 0, 0)
1.0
```
"""
function taylor_sum(func::Function, k::Int, x::Real, x_0::Real)
    D_x = derivatives(func, k, x_0-1, x_0+1, 21)
    D_x_0 = D_x[:,11]

    index = collect(1:k)
    return D_x_0[2] + sum(D_x_0[3:end] ./ factorial.(big.(index)) .* (x - x_0) .^ index)
end

"""
    taylor_formula(func::Function, k::Int, x_0::Real)
Funkcja zwraca wzór funkcji w postaci szeregu k-wyrazów będącego
rozwinięciem Taylora funkcji f na otoczeniu punktu x_0.
Przy wyznaczaniu pochodnych w punkcie x_0 korzysta z funkcji derivatives.
# Przykład:
```jldoctest
julia> e = taylor_formula(x -> exp(x), 25, 1)
#9 (generic function with 1 method)

julia> e(1)
2.718281828459045090795598298427648842334747314453125
```
"""
function taylor_formula(func::Function, k::Int, x_0::Real)
    D_x = derivatives(func, k, x_0-1, x_0+1, 21)
    D_x_0 = D_x[:,11]
    index = collect(1:k)
    return x -> D_x_0[2] + sum(D_x_0[3:end] ./ factorial.(big.(index)) .* (x - x_0) .^ index)
end

"""
    animation_maker(func, x_min::Real, x_max::Real, y_min::Real, y_max::Real,
                    if_leg::Bool, title_::String)
Funkcja tworzy plik animation.gif z animacją rysowania wykresów funkcji z wektora
func, pozostałe argumenty funkcji decydują o zakresach na osiach, pojawieniu się
legendy, nadaniu animacji podanego tytułu.
# Przykład:
```jldoctest
julia> animation_maker([x->x, x->x^2], -2, 2, -3, 3, true, "Plots", ["x" "x^2"])
```
"""
function animation_maker(func::Array, x_min::Real, x_max::Real,
                        y_min::Real, y_max::Real, if_leg::Bool, title_::String, labels::Array)
    p = plot(func, zeros(0),
            framestyle = :origin,
            xlim = (x_min, x_max),
            ylim = (y_min, y_max),
            xlabel = "X",
            ylabel = "Y",
            title = title_,
            leg = if_leg,
            label = labels
            );
    xs = LinRange(x_min, x_max, Int(round(100*(x_max-x_min), digits=0)))
    anim = Animation()
    for i in xs
        push!(p, i, [k(i) for k in func])
        frame(anim)
    end
    gif(anim, "animation.gif", fps=50);
end


"""
    plotter(func, x_min::Real, x_max::Real, y_min::Real, y_max::Real,
                if_leg::Bool, title_::String, labels::Array)
Funkcja rysuje wykres funkcji podanych w wektorze func, pozostałe argumenty funkcji
decydują o zakresach na osiach, pojawieniu się legendy, nadaniu podanego tytułu,
opisaniu krzywych
# Przykład:
```jldoctest
julia> plotter([x->x, x->x^2], -2, 2, -3, 3, true, "Plots", ["x" "x^2"])
```
"""
function plotter(func::Array, x_min::Real, x_max::Real, y_min::Real, y_max::Real,
                if_leg::Bool, title_::String, labels::Array)
    n = 100*Int(round(x_max-x_min, digits=0))
    plot()
    plot!(func, LinRange(x_min, x_max, n),
        framestyle = :origin,
        xlim = (x_min, x_max),
        ylim = (y_min, y_max),
        title = title_,
        xlabel = "X",
        ylabel = "Y",
        legend = if_leg,
        label = labels
        );
        savefig("plot.png")
end

end

using .SeriesOfFunction
