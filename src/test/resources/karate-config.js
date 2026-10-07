function fn() {
    var env = karate.env || 'dev';
    karate.log('Ambiente:', env);

    var config = {
        baseUrl: 'https://api.escuelajs.co/api/v1'
    };

    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 20000);

    return config;
}