function fish_user_key_bindings
  if command -v fzf >/dev/null 2>&1
    fzf --fish | source
  end
end
