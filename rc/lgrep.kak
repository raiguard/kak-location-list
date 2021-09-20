declare-option -docstring "name of the client in which utilities display information" \
    str toolsclient

define-command -params .. -file-completion -docstring %{
    lggrep [<arguments>]: ripgrep utility wrapper
    The output of this command will be sent to the global location list
    All optional arguments are forwarded to the ripgrep utility
} lggrep %{ evaluate-commands %sh{
     if [ $# -eq 0 ]; then
         set -- "${kak_selection}"
     fi

     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-grep.XXXXXXXX)/fifo
     rg --vimgrep --trim  "$@" | tr -d '\r' > ${output} 2>&1

    eval set -- "$kak_quoted_buflist"

    $kak_opt_loli_cmd grep "${output}" -t $kak_timestamp --this-buffer $kak_bufname -b "$@"
}}

define-command -params .. -file-completion -docstring %{
    lcgrep [<arguments>]: ripgrep utility wrapper
    The output of this command will be sent to the client location list
    All optional arguments are forwarded to the ripgrep utility
} lcgrep %{ evaluate-commands %sh{
     if [ $# -eq 0 ]; then
         set -- "${kak_selection}"
     fi

     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-grep.XXXXXXXX)/fifo
     rg --vimgrep --trim  "$@" | tr -d '\r' > ${output} 2>&1

    eval set -- "$kak_quoted_buflist"

    $kak_opt_loli_cmd -c $kak_client grep "${output}" -t $kak_timestamp --this-buffer $kak_bufname -b "$@"
}}
