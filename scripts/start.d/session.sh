if [[ ! -z "$SESSION_PATH" ]]; then
  mkdir -p "$SESSION_PATH"
  chown -R www-data:www-data "$SESSION_PATH"
  chmod -R ug+rwX,o-rwx "$SESSION_PATH"

  sed -i \
    "s|\[Session\]|[Session]\nsession.save_path = $SESSION_PATH|" \
    /usr/local/etc/php/php.ini
fi
