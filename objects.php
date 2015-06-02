<?php
pre_r(__FILE__);

function pre_r(){
	echo '<pre>';
	foreach (func_get_args() as $key => $value) {
		print_r($value);
	}
	echo '</pre>';
}

require_once('rb.php');

R::setup(
    'mysql:host=localhost;dbname=keys',
    'root',
    'root'
);

	
