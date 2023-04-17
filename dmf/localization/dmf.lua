return {
  mods_options = {
    en = "Mod Options",
    es = "Configuración de mods",
    ru = "Настройки модов",
    ["zh-cn"] = "模组选项",
    ja = "Modオプション",
  },
  open_dmf_options = {
    en = "Open Options Menu",
    es = "Abrir el menu de configuración",
    ru = "Открыть меню настроек",
    ["zh-cn"] = "打开选项菜单",
    ja = "オプションメニューを開く",
  },
  open_dmf_options_description = {
    en = "Keybind for opening and closing mods options menu.",
    es = "Atajo para abrir/cerrar el menu de configuración de mods.",
    ru = "Клавиша/сочетание клавиш для открытия и закрытия меню настроек модов.",
    ["zh-cn"] = "打开关闭模组选项菜单的按键绑定。",
    ja = "オプションメニューを開閉するキーバインド",
  },
  dmf_options_scrolling_speed = {
    en = "Options Menu Scrolling Speed",
    es = "Velocidad de desplazamiento en el menu",
    ru = "Скорость прокрутки меню",
    ["zh-cn"] = "选项菜单滚动速度",
    ja = "オプションメニューのスクロール速度",
  },
  dmf_first_run_notification = {
    en = "Welcome to the Darktide Mod Framework. Mod options have been added to the Options Menu.",
    es = "Bienvenidos a el Mod Framework de Darktide. Hemos agregado las opciones de Mod a el menu de opciones.",
    de = "Willkommen beim Darktide Mod Framework. Ein Button für Mod-Optionen wurde dem Hauptmenu hinzugefügt.",
    ["zh-cn"] = "欢迎使用 Darktide Mod Framework。模组选项已添加到选项菜单。",
    ru = "Добро пожаловать в Darktide Mod Framework. Параметры мода были добавлены в меню параметров.",
    ja = "Darktide Mod Frameworkのご利用ありがとうございます。Modオプションがオプションメニューに追加されました。",
  },
  percent = {
    en = "%%",
  },
  toggle_mods = {
    en = "Toggle Mods",
    ["zh-cn"] = "开启关闭模组",
    ru = "Включение/выключение модов",
    ja = "Modのオン/オフ",
  },
  toggle_mods_description = {
    en = "Enable or disable your mods.",
    ["zh-cn"] = "启用或禁用安装的模组。",
    ru = "Включите или отключите ваши моды.",
    ja = "Modを有効化/無効化します。",
  },
  ui_scaling = {
    en = "UI Scaling for FHD+ Resolutions",
    es = "Reescalado de la interfaz para resoluciones Full HD+",
    ru = "Нормализация масштаба интерфейса для FHD+ разрешений",
    ["zh-cn"] = "高分辨率 UI 缩放",
    ja = "解像度FHD以上でのUIスケーリング",
  },
  ui_scaling_description = {
    en = "Automatically scale UI when resolution exceeds 1080p.",
    es = "Redimensionar automáticamente la interfaz cuando la resolución exceda 1080p.",
    ru = "Нормализует масштаб элементов интерфейса, если разрешений экрана превышает 1080p.",
    ["zh-cn"] = "分辨率超过 1080p 时自动缩放 UI",
    ja = "1080pを超える解像度でUIの大きさを自動調節します。",
  },
  developer_mode = {
    en = "Developer Mode",
    es = "Modo de desarrollo",
    ru = "Режим разработчика",
    ["zh-cn"] = "开发者模式",
    ja = "開発者モード",
  },
  developer_mode_description = {
    en = "Allows you to reload DMF and mods (CTRL+SHIFT+R), gives you access to some debug features.",
    es = "Permite recargar los mods (CTRL+SHIFT+R) y configurar herramientas de depuración.",
    ru = "Позволяет перезагружать DMF и моды (CTRL+SHIFT+R), даёт доступ к инструментам отладки.",
    ["zh-cn"] = "允许重新加载 DMF 和模组（CTRL+SHIFT+R），并启用一些调试功能。",
    ja = "DMFとModのリロード (CTRL+SHIFT+R) や、いくつかのデバッグ機能へのアクセスを可能にします。",
  },
  show_developer_console = {
    en = "Show Developer Console",
    es = "Mostrar el registro (log) a tiempo real",
    ru = "Консоль разработчика",
    ["zh-cn"] = "显示开发者控制台",
    ja = "開発者コンソールの表示",
  },
  show_developer_console_description = {
    en = "Opens up the new window showing game log in real time.",
    es = "Abre una ventana que muestra el registro (log) del juego en tiempo real.",
    ru = "Открывает новое окно, в которое в реальном времени выводится игровой лог.",
    ["zh-cn"] = "在一个新窗口中显示游戏实时日志。",
    ja = "ゲームのログをリアルタイムで表示する新たなウィンドウを開きます。",
  },
  toggle_developer_console = {
    en = "Toggle Developer Console",
    es = "Abrir el registro (log) a tiempo real",
    ru = "Открыть/закрыть консоль разработчика",
    ["zh-cn"] = "开关开发者控制台",
    ja = "開発者コンソールの表示/非表示",
  },
  show_network_debug_info = {
    en = "Log Network Calls",
    es = "Depurar las llamadas de red",
    ru = "Логирование сетевых вызовов",
    ["zh-cn"] = "记录网络调用日志",
    ja = "ネットワーク呼び出しの記録",
  },
  show_network_debug_info_description = {
    en = "Log all the DMF network calls and all the data transfered with them.\n\n" ..
         "The method 'info' is used for the logging.",
    es = "Escribe en el registro todas las llamadas de red (RPCs) que se ejecuten a través de DMF.\n\n" ..
         "Esta información se registra en el nivel 'info'.",
    ru = "Логирование всех сетевых вызовов DMF и передаваемых с ними данных.\n\n" ..
         "Для логирования используется метод 'info'.",
    ["zh-cn"] = "记录所有 DMF 网络调用及其所传输数据的日志。\n\n" ..
         "记录日志时会使用 'info' 方法。",
    ja = "すべてのDMFのネットワーク呼び出しと通信データをログに記録します。\n\n" ..
         "記録には 'info' メソッドが使用されます。",
  },
  log_ui_renderers_info = {
    en = "Log UI Renderers Creation Info",
    es = "Depurar la renderización de la interfaz de usuario",
    ru = "Логирование информации при создании UI Renderer",
    ["zh-cn"] = "记录 UI 渲染器创建信息",
    ja = "UIレンダラー生成情報の記録",
  },
  log_ui_renderers_info_description = {
    en = "Log the UI Renderer's creator name and all the materials passed as the arguments.\n\n" ..
         "The method 'info' is used for the logging.",
    es = "Escribe en el registro cada vez que se inicialize un renderizador de la interfaz.\n\n" ..
         "Esta información se registra en el nivel 'info'.",
    ru = "Логирование имени создателя UI Renderer'а и всех материалов, переданных в качестве аргументов.\n\n" ..
         "Для логирования используется метод 'info'.",
    ["zh-cn"] = "记录 UI 渲染器的创建者名称以及作为参数传入的所有材质。\n\n" ..
         "记录日志时会使用 'info' 方法。",
    ja = "UIレンダラー生成元の名称と、引数として渡されたすべてのマテリアルをログに記録します。\n\n" ..
         "記録には 'info' メソッドが使用されます。",
  },
  logging_mode = {
    en = "Logging Settings",
    es = "Opciones de logging",
    ru = "Настройки логирования",
    ["zh-cn"] = "日志设置",
    ja = "ログの設定",
  },
  settings_default = {
    en = "Default",
    es = "Valor por defecto",
    ru = "Стандартные",
    ["zh-cn"] = "默认",
    ja = "デフォルト",
  },
  settings_custom = {
    en = "Custom",
    es = "Personalizado",
    ru = "Пользовательские",
    ["zh-cn"] = "自定义",
    ja = "カスタム",
  },
  output_mode_notification = {
    en = "'Notification' Output",
    ["zh-cn"] = "'Notification' 通知输出",
    ru = "Вывод 'Notification'",
    ja = "'Notification' の出力",
  },
  output_mode_echo = {
    en = "'Echo' Output",
    es = "Mensajes de 'Echo'",
    ru = "Вывод 'Echo'",
    ["zh-cn"] = "'Echo' 回显输出",
    ja = "'Echo' の出力",
  },
  output_mode_error = {
    en = "'Error' Output",
    es = "Mensajes de 'Error'",
    ru = "Вывод 'Error'",
    ["zh-cn"] = "'Error' 错误输出",
    ja = "'Error' の出力",
  },
  output_mode_warning = {
    en = "'Warning' Output",
    es = "Mensajes de 'Warning'",
    ru = "Вывод 'Warning'",
    ["zh-cn"] = "'Warning' 警告输出",
    ja = "'Warning' の出力",
  },
  output_mode_info = {
    en = "'Info' Output",
    es = "Mensajes de 'Info'",
    ru = "Вывод 'Info'",
    ["zh-cn"] = "'Info' 信息输出",
    ja = "'Info' の出力",
  },
  output_mode_debug = {
    en = "'Debug' Output",
    es = "Mensajes de 'Debug'",
    ru = "Вывод 'Debug'",
    ["zh-cn"] = "'Debug' 调试输出",
    ja = "'Debug' の出力",
  },
  output_disabled = {
    en = "Disabled",
    es = "Desactivado",
    ru = "Выключен",
    ["zh-cn"] = "禁用",
    ja = "無効",
  },
  output_log = {
    en = "Log",
    es = "Registro (log)",
    ru = "Лог",
    ["zh-cn"] = "日志",
    ja = "ログ",
  },
  output_chat = {
    en = "Chat",
    es = "Chat",
    ru = "Чат",
    ["zh-cn"] = "聊天",
    ja = "チャット",
  },
  output_notification = {
    en = "Notification",
    ["zh-cn"] = "通知",
    ru = "Уведомление",
    ja = "通知",
  },
  output_log_and_chat = {
    en = "Log & Chat",
    es = "Registro (log) y chat",
    ru = "Лог и чат",
    ["zh-cn"] = "日志与聊天",
    ja = "ログとチャット",
  },
  output_all = {
    en = "All",
    ["zh-cn"] = "全部",
    ru = "Все",
    ja = "すべて",
  },
  output_log_and_notification = {
    en = "Log & Notification",
    ["zh-cn"] = "日志与通知",
    ru = "Лог и Уведомление",
    ja = "ログと通知",
  },
  output_chat_and_notification = {
    en = "Chat & Notification",
    ["zh-cn"] = "聊天与通知",
    ru = "Чат и Уведомление",
    ja = "チャットと通知",
  },
  chat_history_enable = {
    en = "Chat Input History",
    es = "Historial de chat",
    ru = "История ввода чата",
    ["zh-cn"] = "聊天输入历史记录",
    ja = "チャット入力の履歴",
  },
  chat_history_enable_description = {
    en = "Saves all the messages and commands you typed in the chat window.\n\n" ..
         "You can browse your input history by opening the chat and pressing \"Arrow Up\" and \"Arrow Down\".",
    es = "Guarda todos los mensajes y comandos que escribas en la ventana de chat.\n\n" ..
         "Puedes navegar por tu historial de comandos abriendo el chat y usando las flechas del teclado.",
    ru = "Сохраняет все сообщения и команды, введённые в чате.\n\n" ..
         "Чтобы пролистывать историю ввода, откройте чат и используйте клавиши \"стрелка вверх\" и \"стрелка вниз\".",
    ["zh-cn"] = "保存所有你在聊天窗口内输入过的消息和命令。\n\n" ..
         "你可以打开聊天窗口，按“上下方向键”浏览输入历史记录。",
    ja = "チャット欄に記入したすべてのメッセージとコマンドを保存します。\n\n" ..
         "入力履歴はチャットを開いて「上矢印」と「下矢印」キーで表示できます。",
  },
  chat_history_save = {
    en = "Save Input History Between Game Sessions",
    es = "Guardar la entrada",
    ru = "Сохранять историю ввода между сеансами игры",
    ["zh-cn"] = "重启游戏仍保留输入历史",
    ja = "ゲームセッション間での入力履歴の保存",
  },
  chat_history_save_description = {
    en = "Your chat input history will be saved even after reloading your game (or just DMF).",
    es = "El texto que introduzcas en el chat se guardara incluso al recargar el juego (o solo DMF)",
    ru = "Когда игрок выключает игру (или перезагружает DMF), DMF cохраняет историю ввода в файл настроек, чтобы загрузить её при следующем запуске игры.",
    ["zh-cn"] = "即使重新启动游戏（或者重新加载 DMF），仍然保存聊天输入历史记录。",
    ja = "ゲームの再起動 (またはDMFのリロード) 後もチャットの入力履歴が保持されます。",
  },
  chat_history_buffer_size = {
    en = "Input History Buffer Size",
    es = "Número de comandos antiguos guardados",
    ru = "Размер буфера истории ввода",
    ["zh-cn"] = "输入历史记录大小",
    ja = "入力履歴のバッファサイズ",
  },
  chat_history_buffer_size_description = {
    en = "Maximum number of saved entries.\n\n" ..
         "WARNING: Changing this setting will erase your chat history.",
    es = "Máximo número de comandos antiguos guardados.\n\n" ..
         "ATENCIÓN: Cambiar esta preferencia borra el historial del chat.",
    ru = "Максимальное количество сохраняемых записей.\n\n" ..
         "ВНИМАНИЕ: изменение этой настройки очистит вашу историю ввода.",
    ["zh-cn"] = "最大保存记录条数。\n\n" ..
         "警告：更改此设置会删除所有聊天历史记录。",
    ja = "履歴の最大保存数。\n\n" ..
         "警告：この設定を変更するとチャット履歴が消去されます。",
  },
  chat_history_remove_dups = {
    en = "Remove Duplicate Entries",
    es = "Eliminar lineas repetidas",
    ru = "Удалять повторяющиеся записи",
    ["zh-cn"] = "删除重复记录",
    ja = "重複する履歴の削除",
  },
  chat_history_remove_dups_mode = {
    en = "Removal Mode",
    es = "Modo de eliminación de repetidos",
    ru = "Режим удаления",
    ["zh-cn"] = "删除模式",
    ja = "削除方式",
  },
  chat_history_remove_dups_mode_description = {
    en = "Which duplicate entries should be removed.\n\n" ..
         "-- LAST --\nRemoves previous entry if it matches the last one.\n\n" ..
         "-- ALL --\nRemoves all entries if it matches the last one.",
    es = "Que lineas antiguas seran borradas cuando se escriba una nueva.\n\n" ..
        "-- ÚLTIMA --\nSolo la última, si es igual que la nueva.",
        "-- TODAS --\nTodas las lineas antiguas que sean iguales que la nueva. ",
    ru = "Повторяющиеся записи, которые будут удалены.\n\n" ..
         "-- ПОСЛЕДНИЕ --\nПредпоследняя запись будет удалена, если она совпадает с последней.\n\n" ..
         "-- ВСЕ --\nВсе записи, совпадающие с последней записью, будут удалены.",
    ["zh-cn"] = "应该删除哪些重复记录。\n\n" ..
         "-- 最新 --\n如果和最新一条匹配，则删除上一条记录。\n\n" ..
         "-- 所有 --\n如果和最新一条匹配，则删除所有匹配的记录。",
    ja = "重複した際にどの履歴を削除するか。\n\n" ..
         "-- 直前 --\n直前の履歴が重複する場合、それを削除します。\n\n" ..
         "-- すべて --\n重複するすべての履歴を削除します。",
  },
  settings_last = {
    en = "Last",
    es = "Última",
    ru = "Последние",
    ["zh-cn"] = "最新",
    ja = "直前",
  },
  settings_all = {
    en = "All",
    es = "Todas",
    ru = "Все",
    ["zh-cn"] = "所有",
    ja = "すべて",
  },
  chat_history_commands_only = {
    en = "Save only executed commands",
    es = "Salvar unicamente los comandos ejecutados",
    ru = "Сохранять только выполненные команды",
    ["zh-cn"] = "只保存执行的命令",
    ja = "実行したコマンドのみを保存",
  },
  chat_history_commands_only_description = {
    en = "Only successfully executed commands will be saved in the chat history.\n\n" ..
         "WARNING: Changing this setting will erase your chat history.",
    es = "Solo los comandos ejecutados exitosamente serán salvados en el historial.\n\n" ..
         "ATENCIÓN: Cambiar esta preferencia borra el historial del chat.",
    ru = "Только успешно выполненные команды будут сохранены в истории ввода.\n\n" ..
         "ВНИМАНИЕ: изменение этой настройки очистит вашу историю ввода.",
    ["zh-cn"] = "只有成功执行的命令才会保存在聊天历史记录里。\n\n" ..
         "警告：更改此设置会删除所有聊天历史记录。",
    ja = "実行できたコマンドのみをチャット履歴に保存します。\n\n" ..
         "警告：この設定を変更するとチャット履歴が消去されます。",
  },

  chat_command_not_recognized = {
    en = "Command not recognized",
    ["zh-cn"] = "无法识别的命令",
    ru = "Команда не распознана",
    ja = "不明なコマンド",
  },
  clean_chat_history = {
    en = "cleans chat input history",
    es = "Borra el historial de usuario",
    ru = "очищает историю ввода",
    ["zh-cn"] = "清除聊天输入历史记录",
    ja = "チャット入力履歴の消去",
  },
  clean_chat_notifications = {
    en = "cleans chat notification alerts",
    ["zh-cn"] = "清除聊天通知警告",
    ru = "очищает предупреждения об уведомлениях чата",
    ja = "チャット通知警告の消去",
  },
  dev_console_opened = {
    en = "Developer console opened.",
    es = "Abierto la consola de desarrollo.",
    ru = "Консоль разработчика открыта.",
    ["zh-cn"] = "已打开开发者控制台。",
    ja = "開発者コンソールを開きました。",
  },
  dev_console_closed = {
    en = "Developer console closed.",
    es = "Cerrado la consola de desarrollo.",
    ru = "Консоль разработчика закрыта.",
    ["zh-cn"] = "已关闭开发者控制台。",
    ja = "開発者コンソールを閉じました。",
  },
  dev_console_close_warning = {
    en = "The developer console is disabled, but must be closed manually.",
    ["zh-cn"] = "开发者控制台已禁用，但必须手动关闭。",
    ru = "Консоль разработчика отключена, но ее необходимо закрыть вручную.",
    ja = "開発者コンソールが無効になっていますが、手動で閉じる必要があります。",
  },


  -- MUTATORS

  mutator_no_description_provided = {
    en = "No description provided.",
    es = "No se proporcionó una descripción.",
    ["zh-cn"] = "未提供描述。",
    ru = "Описание не предоставлено.",
    ja = "説明がありません。",
  },

  -- Difficulties' names
  lowest = {
    en = "Sedition",
    ["zh-cn"] = "煽动",
    ru = "Мятеж",
    ja = "反乱",
  },
  low = {
    en = "Uprising",
    ["zh-cn"] = "暴乱",
    ru = "Восстание",
    ja = "アップライジング",
  },
  medium = {
    en = "Malice",
    ["zh-cn"] = "憎恶",
    ru = "Злоба",
    ja = "悪意",
  },
  high = {
    en = "Heresy",
    ["zh-cn"] = "异端",
    ru = "Ересь",
    ja = "異端",
  },
  highest = {
    en = "Damnation",
    ["zh-cn"] = "诅咒",
    ru = "Проклятие",
    ja = "破滅",
  },

  -- Chat messages
  broadcast_enabled_mutators = {
    en = "ENABLED MUTATORS",
    es = "MUTACIONES ACTIVADAS",
    ["zh-cn"] = "启用突变器",
    ru = "МУТАТОРЫ ВКЛЮЧЕНЫ",
    ja = "ミューテーターが有効化されました",
  },
  broadcast_all_disabled = {
    en = "ALL MUTATORS DISABLED",
    es = "TODAS LAS MUTACIONES DESACTIVADAS",
    ["zh-cn"] = "禁用所有突变器",
    ru = "ВСЕ МУТАТОРЫ ОТКЛЮЧЕНЫ",
    ja = "すべてのミューテーターが無効化されました",
  },
  broadcast_disabled_mutators = {
    en = "MUTATORS DISABLED",
    es = "MUTACIONES DESACTIVADAS",
    ["zh-cn"] = "禁用突变器",
    ru = "МУТАТОРЫ ОТКЛЮЧЕНЫ",
    ja = "ミューテーターが無効化されました",
  },
  local_disabled_mutators = {
    en = "Mutators disabled",
    es = "Mutaciones desactivadas",
    ["zh-cn"] = "突变器已禁用",
    ru = "Мутаторы отключены",
    ja = "ミューテーターが無効化されました",
  },
  whisper_enabled_mutators = {
    en = "[Automated message] This lobby has the following mutators active",
    es = "[Mensaje automático] Esta partida tiene las siguientes mutaciones",
    ["zh-cn"] = "[自动消息] 此大厅激活了以下突变器",
    ru = "[Автоматическое сообщение] В этом лобби активны следующие мутаторы",
    ja = "[自動メッセージ] このロビーでは以下のミューテーターが有効になっています",
  },

  disabled_reason_not_server = {
    en = "because you're no longer the host",
    es = "porque ya no eres el anfitrión",
    ["zh-cn"] = "因为你不再是主机",
    ru = "потому что вы больше не хост",
    ja = "あなたがホストではなくなったため",
  },
  disabled_reason_difficulty_change = {
    en = "DUE TO CHANGE IN DIFFICULTY",
    es = "DEBIDO A UN CAMBIO DE DIFICULTAD",
    ["zh-cn"] = "由于难度变更",
    ru = "ИЗ-ЗА ИЗМЕНЕНИЯ СЛОЖНОСТИ",
    ja = "難易度が変更されたため",
  },

  -- Interface
  mutators_title = {
    en = "Mutators",
    es = "Mutaciones",
    ["zh-cn"] = "突变器",
    ru = "Мутаторы",
    ja = "ミューテーター",
  },
  mutators_banner_description = {
    en = "Enable and disable mutators",
    es = "Activa y desactiva las mutaciones",
    ["zh-cn"] = "启用和禁用突变器",
    ru = "Включить и отключить мутаторы",
    ja = "ミューテーターのオン/オフ",
  },
  no_mutators = {
    en = "No mutators installed",
    es = "No hay mutaciones instaladas",
    ["zh-cn"] = "未安装突变器",
    ru = "Нет установленных мутаторов",
    ja = "ミューテーターがインストールされていません",
  },
  no_mutators_description = {
    en = "Subscribe to mods and mutators on the workshop",
    es = "Subscribete a mutaciones en el Steam Workshop",
    ["zh-cn"] = "在创意工坊订阅模组和突变器",
    ru = "Подпишитесь на моды и мутаторы в мастерской Steam",
    ja = "ワークショップでModやミューテーターをサブスクライブしてください",
  },

  -- Mutator widgets' tooltips
  tooltip_incompatible_mutators = {
    en = "\n\n-- INCOMPATIBLE WITH MUTATORS --\n",
    es = "\n\n-- INCOMPATIBLE CON LAS MUTACIONES --\n",
    ["zh-cn"] = "\n\n-- 不兼容突变器 --\n",
    ru = "\n\n-- НЕСОВМЕСТИМО С МУТАТОРАМИ --\n",
    ja = "\n\n-- ミューテーターと互換性なし --\n",
  },
  tooltip_compatible_mutators = {
    en = "\n\n-- COMPATIBLE ONLY WITH MUTATORS --\n",
    es = "\n\n-- COMPATIBLE CON LAS MUTACIONES --\n",
    ["zh-cn"] = "\n\n-- 仅兼容突变器 --\n",
    ru = "\n\n-- СОВМЕСТИМО ТОЛЬКО С МУТАТОРАМИ --\n",
    ja = "\n\n-- ミューテーターとのみ互換性あり",
  },
  tooltip_compatible_with_all_mutators = {
    en = "\n\n-- COMPATIBLE WITH ALL MUTATORS --",
    es = "\n\n-- COMPATIBLE CON TODAS LAS MUTACIONES --",
    ["zh-cn"] = "\n\n-- 兼容所有突变器 --\n",
    ru = "\n\n-- СОВМЕСТИМО СО ВСЕМИ МУТАТОРАМИ --\n",
    ja = "\n\n-- すべてのミューテーターと互換性あり --\n",
  },
  tooltip_incompatible_with_all_mutators = {
    en = "\n\n-- INCOMPATIBLE WITH ALL MUTATORS --",
    es = "\n\n-- INCOMPATIBLE CON TODAS LAS MUTACIONES --",
    ["zh-cn"] = "\n\n-- 不兼容所有突变器 --\n",
    ru = "\n\n-- НЕСОВМЕСТИМО СО ВСЕМИ МУТАТОРАМИ --\n",
    ja = "\n\n-- すべてのミューテーターと互換性なし --\n",
  },

  tooltip_incompatible_diffs = {
    en = "\n\n-- INCOMPATIBLE WITH DIFFICULTIES --\n",
    es = "\n\n-- INCOMPATIBLE CON LAS DIFICULTADES --\n",
    ["zh-cn"] = "\n\n-- 不兼容难度 --\n",
    ru = "\n\n-- НЕСОВМЕСТИМО СО СЛОЖНОСТЯМИ --\n",
    ja = "\n\n-- 難易度と互換性なし --\n",
  },
  tooltip_compatible_diffs = {
    en = "\n\n-- COMPATIBLE ONLY WITH DIFFICULTIES --\n",
    es = "\n\n-- COMPATIBLE CON LAS DIFICULTADES --\n",
    ["zh-cn"] = "\n\n-- 仅兼容难度 --\n",
    ru = "\n\n-- СОВМЕСТИМО ТОЛЬКО СО СЛОЖНОСТЯМИ --\n",
    ja = "\n\n-- 難易度とのみ互換性あり --\n",
  },
  tooltip_compatible_with_all_diffs = {
    en = "\n\n-- COMPATIBLE WITH ALL DIFFICULTIES --",
    es = "\n\n-- COMPATIBLE CON TODAS LAS DIFICULTADES --",
    ["zh-cn"] = "\n\n-- 兼容所有难度 --\n",
    ru = "\n\n-- СОВМЕСТИМО СО ВСЕМИ СЛОЖНОСТЯМИ --\n",
    ja = "\n\n-- すべての難易度と互換性あり --\n",
  },

  tooltip_conflicts = {
    en = "\n\n-- CONFLICTS --\n",
    es = "\n\n-- CONFLICTOS --\n",
    ["zh-cn"] = "\n\n-- 冲突 --\n",
    ru = "\n\n-- КОНФЛИКТЫ --\n",
    ja = "\n\n-- 競合 --\n",
  },

  tooltip_append_mutator = {
    en = " (mutator)",
    es = " (mutacion)",
    ["zh-cn"] = "（突变）",
    ru = " (мутатор)",
    ja = " (ミューテーター)",
  },
  tooltip_append_difficulty = {
    en = " (difficulty)",
    es = " (dificultad)",
    ["zh-cn"] = "（难度）",
    ru = " (сложность)",
    ja = " (難易度)",
  },
}
