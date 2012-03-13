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

fun! GetProjectDir(parents, children, num_children)
    let parents=a:parents
    let children=a:children
    let num_children=a:num_children

    if num_children == 0
        return "/" . join(parents, "/")
    endif
    if match(children[0], "Python") > -1
        if children[1] == children[2]
            return CompileParent(parents, children, 2)
        else
            return CompileParent(parents, children, 1)
        endif
    endif

endf
fun! CompileParent(parents, children, endidx)
    let parents=a:parents
    let children=a:children
    let endidx=a:endidx
    return "/" . join(parents, "/") . "/" . join(children[0:endidx], "/")
endf
fun! GetParents(path)
    let path=a:path
    let dirs=split(path, '/')
    let parent_found=0
    let used_dirs=[]
    let child_dirs=[]
    let i=0
    for dir in dirs

        if parent_found == 1
            let i += 1
            let child_dirs += [dir]
        else
            let used_dirs += [dir]
        endif

        if stridx(dir, 'Projects') == 0 && parent_found == 0
            let parent_found = 1
        endif

    endfor
    return [used_dirs, child_dirs, i]
endf
fun! ProjectTo(amount)
    let amount=a:amount
    let paths=CurProjectDir()

    if paths[2] == 0 || paths[2] < amount
        return "/" . join(paths[0]) . "/"
    endif

    if amount < 0
        let endidx = paths[2] - amount

    else
        let endidx = amount
    endif
        return CompileParent(paths[0], paths[1], endidx)

endf
fun! CurProjectDir()
    return GetParents(expand("%:p:h"))
endf
fun! ProjectDir()
    let paths=CurProjectDir()
    return GetProjectDir(paths[0], paths[1], paths[2])
endf

