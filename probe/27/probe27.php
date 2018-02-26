<!doctype html>     <!-- html5 -->
<html lang="en">    <!-- la langue -->  
<head>              <!-- début du head -->
  <meta charset="utf-8">                                <!-- type de codage -->
  <title>Lizard probe</title>                            <!-- titre de la page -->
  <link rel="stylesheet" href="index.css">              <!-- lien vers le fichier CSS (la déco) -->
  <script src="../jquery.js"></script>                     <!-- appel de la librairie jquery -->
  <script src="../highcharts.js"></script>                 <!-- appel de la librairie highcharts -->
  <script src="../gray.js"></script>                       <!-- appel du thème highcharts -->
  <script src="../RGraph.common.core.js"></script>         <!-- appel de la librairie Rgraph --> 
  <script src="../RGraph.common.csv.js"></script>          <!-- appel de la librairie Rgraph -->  
  <script src="../RGraph.gauge.js"></script>               <!-- appel de la librairie Rgraph -->         
  <script src="graph27.js"></script>                     <!-- appel de notre graphe -->  

  <!-- fonction qui rafraîchi les gauges toute les 30 secondes    -->  
  <script type="text/javascript">  
var auto_refresh = setInterval(
  function ()
  {
    $('#gauge').load('gauge27.html').fadeIn("slow");
  }, 30000); // rafraîchis toutes les 30s (30000 millisecondes) la div gauge  
 </script> 
  
</head>             <!-- fin du head -->

<body>              <!-- début du body -->
    
    
<!------------------ la partie pour les gauges ----------------->
<div id="gauge">    
    
<?php require "gauge27.html"; ?>

</div>

<!------------------ la partie pour le graphe ----------------->
    
<h1>Gauge 27</h1>      <!-- titre -->

<div id="graph">           <!-- la div qui contiendra le graphe -->     

the graph will be put here

</div>




</body>             <!-- fin du body -->
</html>             <!-- fin du html5 -->
