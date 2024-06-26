# О диагностической информации
:::info[Обратите внимание!]
На данной странице описана информация, передаваемая **Legacy Launcher** как диагностическая. Страница является актуальной с момента релиза версии **1.159.2**.
:::

## Откуда берётся диагностическая информация? {#collecting}
Диагностическая информация целиком и полностью копирует **Журнал событий** (далее – Журнал). Всё, что Вы можете увидеть в Журнале будет в точности передано на сервер.

## Что пишется в Журнале? {#logging}
В Журнал записывается разнообразная информация для диагностики ошибок: текущее время, путь запуска, имя пользователя в системе, текущие настройки лаунчера и игры, конфигурация компьютера, вывод запущенных лаунчером приложений и так далее.

## Как посмотреть содержимое Журнала? {#viewing-logger}
1. Откройте Legacy Launcher
2. Откройте меню настроек лаунчера ("Дополнительно" => "Настройки лаунчера и игры" => вкладка "Лаунчер")
3. Установите параметр "Журнал событий" на "Включён всегда"
4. Сохраните изменения
5. Готово! У вас откроется окно Журнала со всем его содержимым
:::note[Примечание]
Содержимое Журнала в окне может быть неполным. Вы можете открыть файл, в котором хранятся логи полностью, кликнув на иконку диска.
:::

## Куда именно передаётся диагностическая информация? {#submitting}
Она передаётся на приватный сервис под названием «[Pasta](https://pasta.llaun.ch)». Никто, кроме команды технической поддержки, не может прочитать диагностические данные, которые вы нам присылаете.

## Как мы используем диагностическую информацию? {#usage}
Чтобы помочь вам, когда вы с нами свяжетесь. По умолчанию эти данные хранятся всего 30 дней с момента загрузки, но, по желанию администратора, это время может быть продлено. Вы всегда можете попросить нас удалить ваши данные, если пожелаете.
:::note[Примечание]
Мы не можем идентифицировать пользователя по присланным данным. Если вы хотите удалить свои данные, пожалуйста, пришлите нам соответствующие адреса "паст"
:::
