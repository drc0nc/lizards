<!doctype html>     
<html lang="en">   
<head>              
  <meta charset="utf-8">                                
  <title>Lizard probe</title>                            
  <link rel="stylesheet" href="index.css">              
  <script src="jquery.js"></script>                    
  <script src="highcharts.js"></script>                 
  <script src="gray.js"></script>                       
  <script src="RGraph.common.core.js"></script>         
  <script src="RGraph.common.csv.js"></script>          
  <script src="RGraph.gauge.js"></script>               
  <script src="graph.js"></script>                    

  <script type="text/javascript">  
var auto_refresh = setInterval(
  function ()
  {
    $('#gauge').load('gauge.html').fadeIn("slow");
  }, 30000);
 </script> 
  <script type="text/javascript">  
var auto_refresh = setInterval(
  function ()
  {
    $('#gauge').load('gauge17.html').fadeIn("slow");
  }, 30000);
 </script> 
 <script type="text/javascript">  
var auto_refresh = setInterval(
  function ()
  {
    $('#gauge').load('gauge27.html').fadeIn("slow");
  }, 30000);
 </script> 
</head>             

<body>             
    
<div id="gauge">    
    
<?php require "gauge.html"; ?>
<?php require "gauge17.html"; ?>
<?php require "gauge27.html"; ?>

</div>


    
<h1>Graphe Highcharts</h1>    

<div id="graph">           

the graph will be put here

</div>




</body>             
</html>            
