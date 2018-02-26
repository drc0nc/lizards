// la fonction qui crée le graphe

$(function () {
    $.getJSON('data.php', function (data) {  // on récupère les datas fourni par data.php.

        $('#graph').highcharts({            //on dessinera le graphe dans la div graphe
            chart: {
                zoomType: 'x'                // le type de graphe
            },
            title: {
                text: 'probe DHT22'          // le titre du graphe
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                        'Clic et sélectionne une zone pour zoomer' : 'select a zone to zoom in'
            },
            tooltip: {                          // légende flottante partagé
                shared: true
            },

                // l'axe X
            xAxis: {
                categories: data[0]['data']   // correspond au champ 0 des données du json crée par data.php (dateetheure)
                },

                // Premier axe Y
            yAxis: [{

            title: {
                text: 'temperature',           // titre du 1er axe  Y
                style: {
                    color: Highcharts.getOptions().colors[0]   // sa couleur
                }
            },
                // y min, max, ne rien mettre -> ajustement auto, sinon dé-commenter ces 2 lignes :
            //min : 50,
            //max : 100,

            labels: {
                format: '{value} °F',  // la légende 1er axe Y
                style: {
                    color: Highcharts.getOptions().colors[0]   // sa couleur
                }
            }

            }, { // Deuxième axe Y

            title: {
                text: 'humidity',           // titre du 2eme axe  Y
                style: {
                    color: Highcharts.getOptions().colors[1]   // sa couleur
                }
            },
                // y min, max, ne rien mettre -> ajustement auto, sinon dé-commenter ces 2 lignes :
            //min : 0,
            //max : 100,

            opposite: true,        // à l'opposé du 1er axe Y

            labels: {
                format: '{value} %',      // la légende 2eme axe Y
                style: {
                    color: Highcharts.getOptions().colors[1]  // sa couleur
                }
            }

            }],

            legend: {                            // la légende en haut à droite du graphe
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -100,
                y: 0,
                floating: true,
                borderWidth: 0
            },

            plotOptions: {                         // la fonction séléction pour le zoom
                area: {
                    fillColor: {
                        linearGradient: {
                            x1: 0,
                            y1: 0,
                            x2: 0,
                            y2: 1
                        },
                        stops: [
                            [0, Highcharts.getOptions().colors[0]],
                            [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                        ]
                    },

                    marker: {                   // la taille des points
                        radius: 2
                    },

                    lineWidth: 1,               // la taille de la ligne

                    states: {
                        hover: {
                            lineWidth: 1       // la taille de la ligne si on passe la souris
                        }
                    },
                }
            },
                // les séries des axes Y
            series: [{
                type: 'spline',             // type de graphe
                name: 'temperature',        // nom de la série
                yAxis: 0,
                tooltip: {                   // sur le 1er axe Y
                valueSuffix: ' °F'         // suffixe de la légende flottante
            },
                data: data[1].data     // correspond au champ 1 des données du json crée par data.php (temp)
            }, {
                type: 'spline',         // type de graphe
                name: 'humidity',       // nom de la série
                yAxis: 1,               // sur le 2eme axe Y
                tooltip: {
                valueSuffix: ' %'       // suffixe de la légende flottante
            },
                data: data[2].data     // correspond au champ 2 des données du json crée par data.php (humi)
            }]
        });
    });
});
