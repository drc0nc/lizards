<?php

// mise en variable des paramètre de connexion
define('DB_HOST' , 'localhost');      // en local
define('DB_NAME' , 'DHT22');          // nom de la BDD
define('DB_USER' , "lizard");           // le login utilisateur de la base de donnée
define('DB_PASS' , "lizard");    // le mot de passe

try {
    // connexion
    $PDO = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME, DB_USER, DB_PASS, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
    $PDO->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING);

    // sélection de toute la table temphumi
    $sql = 'SELECT * FROM temphumi';
    $reponse = $PDO->query($sql);

    // on prépare les tableaux qui vont contenir les datas de chaque champ
    $rows = array();
    $rows['name'] = 'datetime';
    $rows1 = array();
    $rows1['name'] = 'temp';
    $rows2 = array();
    $rows2['name'] = 'humi';

    // on remplie nos tableaux avec les datas
    while ($valeur = $reponse->fetch())
    {
        $rows['data'][] = $valeur['datetime'];
        $rows1['data'][] = $valeur['temp'];
        $rows2['data'][] = $valeur['humi'];
    }

// si échec de connexion
} catch(Exception $e) {
    echo "Impossible de se connecter à la base de données '".DB_NAME."' sur ".DB_HOST." avec le compte utilisateur '".DB_USER."'";
    echo "<br/>Erreur PDO : <i>".$e->getMessage()."</i>";
    die();
}

// on ferme la connexion à la base de donnée.
$reponse->closeCursor();

// on crée un tableau et on y insère les tableaux contenant chaque champ
$result = array();
array_push($result,$rows);
array_push($result,$rows1);
array_push($result,$rows2);

// On affiche les résultats, le tableau complet.
print json_encode($result, JSON_NUMERIC_CHECK);

 ?>
