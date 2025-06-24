    # Используем готовый образ Nginx как основу
    FROM nginx:1.25-alpine

    # Удаляем стандартную приветственную страницу Nginx
    RUN rm /usr/share/nginx/html/index.html

    # Копируем наш файл index.html в папку, откуда Nginx отдает контент
    COPY ./index.html /usr/share/nginx/html/
