using Gtk
using Plots
using .SeriesOfFunction

struct GUI
    function GUI()
        win = GtkWindow("Szeregi", 800, 900)
        # stworzenie czystego wykresu do wyświetlenia
        plot(framestyle=:origin,
            xlim = (-3, 3),
            ylim = (-4, 4)
            );
        savefig("empty_plot.png")
        # Fourier
        l_fourir = GtkLabel("Szereg Fouriera")
        l_ffunc = GtkLabel("Podaj funkcję f(x) =")
        l_pi = GtkLabel("Dla: ")
        l_pi1 = GtkLabel("(-pi, 0)")
        l_pi2 = GtkLabel("(0, pi)")
        l_fn = GtkLabel("Podaj dokładność n =")
        l_fx = GtkLabel("Zakres x: ")
        l_fxs = GtkLabel("< x <")
        l_fy = GtkLabel("Zakres y: ")
        l_fys = GtkLabel("< y <")
        l_ftit = GtkLabel("Tytuł")

        e_pi1 = GtkEntry() # na zakres -pi, 0
        set_gtk_property!(e_pi1, :text, "2cos(3x/2)")
        e_pi2 = GtkEntry() # na zakres 0, pi
        set_gtk_property!(e_pi2, :text, "sin(5x/4)")
        e_fn = GtkEntry() # dokładność
        set_gtk_property!(e_fn, :text, "3")
        e_fxmin = GtkEntry()
        set_gtk_property!(e_fxmin, :text, "-2")
        e_fxmax = GtkEntry()
        set_gtk_property!(e_fxmax, :text, "2")
        e_fymin = GtkEntry()
        set_gtk_property!(e_fymin, :text, "-4")
        e_fymax = GtkEntry()
        set_gtk_property!(e_fymax, :text, "4")
        e_ftit = GtkEntry() # tytuł
        set_gtk_property!(e_ftit, :text, "Tytuł")

        b_fshow = GtkButton("Pokaż wykres")
        b_fclean = GtkButton("Zresetuj")
        b_fanim = GtkButton("Pokaż animację")

        # do legendy
        cb_fleg = GtkCheckButton("Legenda")

        i_fourier = GtkImage("empty_plot.png")

        # ostrzeżenie
        warning_f = GtkLabel("")
        warning_text = "któreś z pól zostało nieprawidłowo wypełnione"

        # Taylor
        l_taylor = GtkLabel("Szereg Taylora")
        l_tfunc = GtkLabel("Podaj funkcję f(x) =")
        l_p = GtkLabel("Podaj punkt x₀ =")
        l_tn = GtkLabel("Podaj dokładność n = ")
        l_tx = GtkLabel("Zakres x: ")
        l_txs = GtkLabel(" < x < ")
        l_ty = GtkLabel("Zakres y: ")
        l_tys = GtkLabel(" < y < ")
        l_ttit = GtkLabel("Tytuł")

        e_tfunc = GtkEntry() # wzór f
        set_gtk_property!(e_tfunc, :text, "sin(2x)cos(x)")
        e_tp = GtkEntry() # x₀
        set_gtk_property!(e_tp, :text, "0")
        e_tn = GtkEntry() # dokładność
        set_gtk_property!(e_tn, :text, "3")
        e_txmin = GtkEntry()
        set_gtk_property!(e_txmin, :text, "-2")
        e_txmax = GtkEntry()
        set_gtk_property!(e_txmax, :text, "2")
        e_tymin = GtkEntry()
        set_gtk_property!(e_tymin, :text, "-4")
        e_tymax = GtkEntry()
        set_gtk_property!(e_tymax, :text, "4")
        e_ttit = GtkEntry() # tytuł
        set_gtk_property!(e_ttit, :text, "Tytuł")

        b_tshow = GtkButton("Pokaż wykres")
        b_tclean = GtkButton("Zresetuj")
        b_tanim = GtkButton("Pokaż animację")

        cb_tleg = GtkCheckButton("Legenda")

        # ostrzeżenie
        warning_t = GtkLabel("")

        # grafika
        i_taylor = GtkImage("empty_plot.png")

        # czysty wykres
        empty = "empty_plot.png"

        # zakończ
        b_end = GtkButton("Zakończ")

        # na odstęp
        between1 = GtkImage()
        between2 = GtkImage()

        grid = GtkGrid()

        # Fourier
        grid[1:32, 1] = between1
        grid[10:11, 2] = l_fourir
        grid[5:7, 3] = l_pi
        grid[8:9, 3] = l_pi1
        grid[11:12, 3] = l_pi2
        grid[5:7, 4] = l_ffunc
        grid[8:9, 4] = e_pi1
        grid[11:12, 4] = e_pi2
        grid[5:7, 5] = l_fn
        grid[8:9, 5] = e_fn
        grid[5:7, 6] = l_fx  # zakresx
        grid[8:9, 6] = e_fxmin
        grid[10:11, 6] = l_fxs
        grid[12:13, 6] = e_fxmax
        grid[5:7, 7] = l_fy  # zakresy
        grid[8:9, 7] = e_fymin
        grid[10:11, 7] = l_fys
        grid[12:13, 7] = e_fymax
        grid[12:13, 8] = cb_fleg#
        grid[5:7, 8] = l_ftit#
        grid[8:9, 8] = e_ftit#
        grid[5:7, 9] = b_fshow
        grid[8:9, 9] = b_fanim
        grid[12:13, 9] = b_fclean
        grid[1:32, 10] = between2
        grid[1:16, 11:14] = i_fourier
        grid[2:16, 16] = warning_f

        # Taylor
        grid[22:23, 2] = l_taylor
        grid[17:19, 3] = l_tfunc
        grid[20:21, 3] = e_tfunc
        grid[17:19, 4] = l_p
        grid[20:21, 4] = e_tp
        grid[17:19, 5] = l_tn
        grid[20:21, 5] = e_tn
        grid[17:19, 6] = l_tx  # zakresx
        grid[20:21, 6] = e_txmin
        grid[22:23, 6] = l_txs
        grid[24:25, 6] = e_txmax
        grid[17:19, 7] = l_ty  # zakresy
        grid[20:21, 7] = e_tymin
        grid[22:23, 7] = l_tys
        grid[24:25, 7] = e_tymax
        grid[24:25, 8] = cb_tleg#
        grid[17:19, 8] = l_ttit#
        grid[20:21, 8] = e_ttit#
        grid[17:19, 9] = b_tshow
        grid[20:21, 9] = b_tanim
        grid[24:25, 9] = b_tclean
        grid[15:31, 11:14] = i_taylor
        grid[24:26, 15] = b_end
        grid[15:31, 16] = warning_t

        # odstęp między wierszami
        set_gtk_property!(grid, :row_spacing, 5)

        # wrzuca animacje Fouriera
        function show_anim_f(win)
            fun_pi0 = get_gtk_property(e_pi1, :text, String)
            fun_0pi = get_gtk_property(e_pi2, :text, String)

            d_nf = parse(Int, get_gtk_property(e_fn, :text, String))

            xmin_f = parse(Float64, get_gtk_property(e_fxmin, :text, String))
            xmax_f = parse(Float64, get_gtk_property(e_fxmax, :text, String))

            ymin_f = parse(Float64, get_gtk_property(e_fymin, :text, String))
            ymax_f = parse(Float64, get_gtk_property(e_fymax, :text, String))

            title_f = get_gtk_property(e_ftit, :text, String)

            legend_f = get_gtk_property(cb_fleg, :active, Bool)

            eval(Meta.parse("f(x) = x>= 0 ? " * fun_0pi * " : " * fun_pi0))
            g = fourier(f, d_nf)
            animation_maker([f, g], xmin_f, xmax_f, ymin_f, ymax_f, legend_f, title_f, ["funkcja" "szereg"])
            anima = "animation.gif"
            set_gtk_property!(i_fourier, :file, anima)
            rm("animation.gif")
        end

        show_anim_ff = signal_connect(show_anim_f, b_fanim, "clicked")

        # wrzuca animacje Taylora
        function show_anim_t(win)
            fun_t = get_gtk_property(e_tfunc, :text, String)

            point = parse(Float64, get_gtk_property(e_tp, :text, String))

            d_nt = parse(Int, get_gtk_property(e_tn, :text, String))

            xmin_t = parse(Float64, get_gtk_property(e_txmin, :text, String))
            xmax_t = parse(Float64, get_gtk_property(e_txmax, :text, String))

            ymin_t = parse(Float64, get_gtk_property(e_tymin, :text, String))
            ymax_t = parse(Float64, get_gtk_property(e_tymax, :text, String))

            title_t = get_gtk_property(e_ttit, :text, String)

            legend_t = get_gtk_property(cb_tleg, :active, Bool)

            eval(Meta.parse("f(x) = " * fun_t))
            g = taylor_formula(f, d_nt, point)
            animation_maker([f, g], xmin_t, xmax_t, ymin_t, ymax_t, legend_t, title_t, ["funkcja" "szereg"])
            anima = "animation.gif"
            set_gtk_property!(i_taylor, :file, anima)
            rm("animation.gif")
        end

        show_anim_tt = signal_connect(show_anim_t, b_tanim, "clicked")


        # wrzuca Fouriera
        function load_image_f(win)
            fun_pi0 = get_gtk_property(e_pi1, :text, String)
            fun_0pi = get_gtk_property(e_pi2, :text, String)

            d_nf = parse(Int, get_gtk_property(e_fn, :text, String))

            xmin_f = parse(Float64, get_gtk_property(e_fxmin, :text, String))
            xmax_f = parse(Float64, get_gtk_property(e_fxmax, :text, String))

            ymin_f = parse(Float64, get_gtk_property(e_fymin, :text, String))
            ymax_f = parse(Float64, get_gtk_property(e_fymax, :text, String))

            title_f = get_gtk_property(e_ftit, :text, String)
            legend_f = get_gtk_property(cb_fleg, :active, Bool)

            eval(Meta.parse("f(x) = x>= 0 ? " * fun_0pi * " : " * fun_pi0))
            g = fourier(f, d_nf)
            plotter([f, g], xmin_f, xmax_f, ymin_f, ymax_f, legend_f, title_f, ["funkcja" "szereg"])
            image = "plot.png"
            set_gtk_property!(i_fourier, :file, image)
            rm("plot.png")
        end

        load_fourier = signal_connect(load_image_f, b_fshow, "clicked")

        # wrzuca Taylora
        function load_image_t(win)
            fun_t = get_gtk_property(e_tfunc, :text, String)

            point = parse(Int, get_gtk_property(e_tp, :text, String))

            d_nt = parse(Int, get_gtk_property(e_tn, :text, String))

            xmin_t = parse(Float64, get_gtk_property(e_txmin, :text, String))
            xmax_t = parse(Float64, get_gtk_property(e_txmax, :text, String))

            ymin_t = parse(Float64, get_gtk_property(e_tymin, :text, String))
            ymax_t = parse(Float64, get_gtk_property(e_tymax, :text, String))

            title_t = get_gtk_property(e_ttit, :text, String)

            legend_t = get_gtk_property(cb_tleg, :active, Bool)

            eval(Meta.parse("f(x) = " * fun_t))
            g = taylor_formula(f, d_nt, point)
            plotter([f, g], xmin_t, xmax_t, ymin_t, ymax_t, legend_t, title_t, ["funkcja" "szereg"])
            image = "plot.png"
            set_gtk_property!(i_taylor, :file, image)
            rm("plot.png")
        end

        load_taylor = signal_connect(load_image_t, b_tshow, "clicked")

        # czyści Fouriera
        function clean_f(win)
            set_gtk_property!(i_fourier, :file, empty)
        end

        clean_ff = signal_connect(clean_f, b_fclean, "clicked")

        # czyści Taylora
        function clean_t(win)
            set_gtk_property!(i_taylor, :file, empty)
        end

        clean_tt = signal_connect(clean_t, b_tclean, "clicked")

        # Zakończ
        signal_connect(b_end, :clicked) do widget
            rm("empty_plot.png")
            Gtk.destroy(win)
        end

        push!(win, grid)
        showall(win)
    end
end
GUI()
