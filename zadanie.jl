using Plots

"""
Funkcja przekształca String'a z wzorem pewnej funckji zmiennej x
tak, aby możliwe było wywołanie na nim funkcji function_maker
"""
function input_parser(a::String)  # taki naiwny trochę, do poprawy
    A = ["arcsin", "arccos", "arcctg", "arctg", "ctg", "tg"]
    B = ["asin", "acos", "acot", "atan", "cot", "tan"]
    for (i, j) in enumerate(A)
        if occursin(j, a)
            a = replace(a, j => B[i])
        end
    end
    return a
end

"""
Funkcja zwraca funkcję zmiennej x, której wzór został podany w String'u
"""
function function_maker(s::String)
    return eval(Meta.parse("x->" * "$(s)"))
end

# przykład
s = "x^3 - x + tan(x)"
t = function_maker(s)
t(π)|>display

"""
Funkcja tworzy plik animation.gif z animacją rysowania wykresów funkcji z wektora
func, pozostałe argumenty funkcji decydują o zakresach na osiach, pojawieniu się
legendy, nadaniu animacji podanego tytułu
"""
function animation_maker(func, x_min::Real, x_max::Real,
                        y_min::Real, y_max::Real, if_leg::Bool, title_::String)
    p = plot(func, zeros(0),
            framestyle=:origin,
            xlim=(x_min, x_max),
            ylim=(y_min, y_max),
            xlabel = "X",
            ylabel = "Y",
            title = title_,
            leg = if_leg,
            label = "" # do poprawy
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
Funkcja rysuje wykres funkcji podanych w wektorze func, pozostałe argumenty funkcji
decydują o zakresach na osiach, pojawieniu się legendy, nadaniu podanego tytułu
"""
function plotter(func, x_min::Real, x_max::Real, y_min::Real, y_max::Real,
                if_leg::Bool, title_::String)
    n = 100*Int(round(x_max-x_min, digits=0))
    plot()
    for i in func
        plot!(LinRange(x_min, x_max, n), i,
            framestyle = :origin,
            xlim = (x_min, x_max),
            ylim = (y_min, y_max),
            title = title_,
            xlabel = "X",
            ylabel = "Y",
            legend = if_leg,
            label = "" # do poprawy
            );
            savefig("plot.png")
    end
end
