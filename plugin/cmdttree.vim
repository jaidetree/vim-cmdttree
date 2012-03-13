command! NiceT :call s:DirectorySelector("CommandT")
command! MyTree :call s:DirectorySelector("NERDTree")


fun! s:DirectorySelector(command)
    let command=a:command
    let dir = expand("%:p:h")
    let path = input("directory: ", dir, "file")

    if path == ""
        return 0
    endif

    call inputrestore()
    exec ":" . command . " " . path
endf

