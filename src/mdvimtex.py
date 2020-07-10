import vim, subprocess

def get_buf_names():
    return [ buf.name for buf in vim.buffers ]

def get_win_idx(buf_idx):
    if buf_idx == -1:
        return -1
    buf_name = vim.buffers[buf_idx].name
    for win in vim.windows:
        if win.buffer.name == buf_name:
            return win.number
    return -1

def get_buf_idx_by_name(path):
    if path.startswith("./"):
        path = path[2:]

    buf_names = get_buf_names()
    buf_idx = [ i+1 for i, buf in enumerate(buf_names) if buf.endswith(path) and path != "" ]
    if len(buf_idx) == 0:
        return -1
    else:
        buf_idx = buf_idx[0]
        return buf_idx

def update_tex(**kwargs):
    path         = vim.eval(kwargs["tex_path"])
    open_tex     = bool(int(kwargs["open_tex"]))
    open_tex_cmd = kwargs["open_tex_cmd"]

    init_buf_idx = vim.current.buffer.number
    init_win_idx = vim.current.window.number

    template = \
            r'\documentclass[uplatex]{jsarticle}'        + "\n" +\
            r'\usepackage[dvipdfmx]{graphicx, hyperref}' + "\n" +\
            r'\providecommand{\tightlist}{%'             + "\n" +\
            r'  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}' + "\n" +\
            r'}' + "\n"+\
            r'\begin{document}' + "\n"+\
            r'<<converted>>'    + "\n"+\
            r'\end{document}'

    ps = subprocess.Popen(
            ['echo', '{}'.format("\n".join(vim.buffers[init_buf_idx][:]))],
            stdout=subprocess.PIPE)
    texbuf = subprocess.check_output(['pandoc', '-f', 'markdown', '-t', 'latex'], stdin=ps.stdout)
    ps.wait()

    texbuf = texbuf.decode('utf-8')
    main = template.replace("<<converted>>", texbuf)
    main = main.replace(r"\includegraphics", r"\includegraphics[width=\linewidth]")
    main = main.replace(r"\begin{figure}", r"\begin{figure}[htbp]")

    with open(path, "w") as f:
        f.write(main)

    if open_tex:
        buf_idx = get_buf_idx_by_name(path)
        win_idx = get_win_idx(buf_idx)

        if win_idx == -1:
            # tex buffer does not exist in current windows
            #vim.command("botright 5sp {}".format(path))
            vim.command(open_tex_cmd + " {}".format(path))
            vim.command("{}wincmd w".format(init_win_idx)) # back to init window
        else:
            # already exist in current windows. no need to split
            vim.command("{}wincmd w".format(win_idx))
            vim.command("e") # update
            vim.command("{}wincmd w".format(init_win_idx)) # back to init window
            pass

