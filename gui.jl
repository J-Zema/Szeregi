using Gtk

struct GUI
    function GUI()
        win = GtkWindow("Szeregi", 800, 900)

        #Fourier
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

        e_pi1 = GtkEntry() #na zakres -pi, 0
        e_pi2 = GtkEntry() #na zakres 0, pi
        e_fn = GtkEntry() #dokładność
        e_fxmin = GtkEntry()
        e_fxmax = GtkEntry()
        e_fymin = GtkEntry()
        e_fymax = GtkEntry()
        e_ftit = GtkEntry() #tytuł

        b_fshow = GtkButton("Pokaż wykres")
        b_fclean = GtkButton("Zresetuj")
        b_fanim = GtkButton("Pokaż animację")

        cb_fleg = GtkCheckButton("Legenda")
        #cb_showt = GtkCheckButton("Pokaż z szeregiem T")

        i_fourier = GtkImage("Manik\\empty_plot.png")

        #próbne png
        image = "Manik\\wykres.png"

        #czyste
        empty = "Manik\\empty_plot.png"

        #Taylor
        l_taylor = GtkLabel("Szereg Taylora")
        l_tfunc = GtkLabel("Podaj funkcję f(x) =")
        l_p = GtkLabel("Podaj punkt x₀ =")
        l_tn = GtkLabel("Podaj dokładność n = ")
        l_tx = GtkLabel("Zakres x: ")
        l_txs = GtkLabel(" < x < ")
        l_ty = GtkLabel("Zakres y: ")
        l_tys = GtkLabel(" < y < ")
        l_ttit = GtkLabel("Tytuł")

        e_tfunc = GtkEntry() #wzór f
        e_tp = GtkEntry() #x₀
        set_gtk_property!(e_tp, :text, "0")
        e_tn = GtkEntry() #dokładność
        e_txmin = GtkEntry()
        e_txmax = GtkEntry()
        e_tymin = GtkEntry()
        e_tymax = GtkEntry()
        e_ttit = GtkEntry() #tytuł

        b_tshow = GtkButton("Pokaż wykres")
        b_tclean = GtkButton("Zresetuj")
        b_tanim = GtkButton("Pokaż animację")

        cb_tleg = GtkCheckButton("Legenda")
        #cb_showf = GtkCheckButton("Pokaż z szeregiem Fouriera")

        #grafika
        i_taylor = GtkImage("Manik\\empty_plot.png")

        #animacja
        anima = "Manik\\animation.gif"

        #zakończ
        b_end = GtkButton("Zakończ")

        #na odstęp
        between1 = GtkImage()
        between2 = GtkImage()

        grid = GtkGrid()

        #musze jeszcze przeskalować

        #Fourier
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
        grid[5:7, 6] = l_fx#zakresx
        grid[8:9, 6] = e_fxmin
        grid[10:11, 6] = l_fxs
        grid[12:13, 6] = e_fxmax
        grid[5:7, 7] = l_fy#zakresy
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

        #Taylor
        grid[22:23, 2] = l_taylor
        grid[17:19, 3] = l_tfunc
        grid[20:21, 3] = e_tfunc
        grid[17:19, 4] = l_p
        grid[20:21, 4] = e_tp
        grid[17:19, 5] = l_tn
        grid[20:21, 5] = e_tn
        grid[17:19, 6] = l_tx#zakresx
        grid[20:21, 6] = e_txmin
        grid[22:23, 6] = l_txs
        grid[24:25, 6] = e_txmax
        grid[17:19, 7] = l_ty#zakresy
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

        #odstęp między wierszami
        set_gtk_property!(grid, :row_spacing, 5)
        #set_gtk_property!(grid, :resize_mode, 3)

        #wrzuca animacje Fouriera
        function show_anim_f(win)
            set_gtk_property!(i_fourier, :file, anima)
        end

        show_anim_ff = signal_connect(show_anim_f, b_fanim, "clicked")

        #wrzuca animacje Taylora
        function show_anim_t(win)
            set_gtk_property!(i_taylor, :file, anima)
        end
        show_anim_tt = signal_connect(show_anim_t, b_tanim, "clicked")


        #wrzuca Fouriera
        function load_image_f(win)
            set_gtk_property!(i_fourier, :file, image)
        end

        load_fourier = signal_connect(load_image_f, b_fshow, "clicked")

        #wrzuca Taylora
        function load_image_t(win)
            set_gtk_property!(i_taylor, :file, image)
        end

        load_taylor = signal_connect(load_image_t, b_tshow, "clicked")

        #czyści Fouriera
        function clean_f(win)
            set_gtk_property!(i_fourier, :file, empty)
        end

        clean_ff = signal_connect(clean_f, b_fclean, "clicked")

        #czyści Taylora
        function clean_t(win)
            set_gtk_property!(i_taylor, :file, empty)
        end

        clean_tt = signal_connect(clean_t, b_tclean, "clicked")

        #pobiera dane Fouriera
        function get_data_fourier(win)

            #funkcje
            fun_pi0 = get_gtk_property(e_pi1, :text, String)
            fun_0pi = get_gtk_property(e_pi2, :text, String)

            #dokładność
            d_nf = get_gtk_property(e_fn, :text, String)

            #zakres x
             xmin_f = get_gtk_property(e_fxmin, :text, String)
             xmax_f = get_gtk_property(e_fxmax, :text, String)

             #zakres y
             ymin_f = get_gtk_property(e_fymin, :text, String)
             ymax_f = get_gtk_property(e_fymax, :text, String)

             #tytuł
             title_f = get_gtk_property(e_ftit, :text, String)

             #legenda
             legend_f = get_gtk_property(cb_fleg, :active, Bool)
         end

         get_data_f = signal_connect(get_data_fourier, b_fshow, "clicked")

         #pobiera dane Taylora
         function get_data_taylor(win)

             #funkcja
             fun_t = get_gtk_property(e_tfunc, :text, String)

             #punkt
             point = get_gtk_property(e_tp, :text, String)

             #Dokładność
             d_nt = get_gtk_property(e_tn, :text, String)

             #Zakres x
             xmin_t = get_gtk_property(e_txmin, :text, String)
             xmax_t = get_gtk_property(e_txmax, :text, String)

             #Zakres y
             ymin_t = get_gtk_property(e_tymin, :text, String)
             ymax_t = get_gtk_property(e_tymax, :text, String)

             #Tytuł
             title_t = get_gtk_property(e_ttit, :text, String)

             #legenda
             legend_t = get_gtk_property(cb_tleg, :active, Bool)
        end

        get_data_t = signal_connect(get_data_taylor, b_tshow, "clicked")

        #Zakończ
        signal_connect(b_end, :clicked) do widget
            Gtk.destroy(win)
        end


        push!(win, grid)
        showall(win)

    end
end
GUI()
