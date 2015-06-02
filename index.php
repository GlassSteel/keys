<?php
namespace glasteel\SPH\StudentAwards;

use \R as R;

require_once('rb.php');

R::setup(
    'mysql:host=localhost;dbname=keys',
    'root',
    'root'
);

echo '<pre>';

class Nomination
{
    protected $base_bean;

    public function __construct($id=false)
    {
        //TODO if $id !== false and no base found, raise exception
        $this->base_bean = R::load('nomination',$id);
    }//__construct()

    public function getSerial()
    {
        return $this->getFromBase('id');
    }//getSerial()

    protected function getFromBase($key)
    {
        return $this->base_bean->$key;
    }//getFromBase()
}//class Nomination

abstract class NominationSubtype extends Nomination
{
    protected $nomtype_specific_bean;

    public function __construct($id=false){
        //TODO if $id !== false and no nomtype_specific found, raise exception
        parent::__construct($id);
        $this->nomtype_specific_bean = R::load($this->subtype_table, $this->getSerial());

        if ( $id !== false && $this->nomtype_specific_bean->id === 0 ){
            //TODO custom message for table not found vs. id not found
            throw new \Exception('Subtable record not found.');
        }

        //print_r($this->base_bean->export());
        //print_r($this->nomtype_specific_bean->export());
    }
}//class NominationSubtype

class Selfnom extends NominationSubtype
{
    protected $subtype_table = 'selfnom';

}//class Selfnom

if ( isset($_POST['upload']) && $_FILES['myfile']['size'] > 0 ){
    
    $name = $_FILES['myfile']['name'];
    $tmp_name  = $_FILES['myfile']['tmp_name'];
    $size = $_FILES['myfile']['size'];
    $type = $_FILES['myfile']['type'];
    
    $handle = fopen($tmp_name, 'r');
    $content = fread($handle, filesize($tmp_name));
    fclose($handle);

    $upload = R::dispense('upload');
    $upload->name = $name;
    $upload->type = $type;
    $upload->size = $size;
    $upload->content = $content;

    try {
        R::store($upload);
    } catch (Exception $e) {
        print_r('<h2>Message = </h2>');
        print_r($e->getMessage());
    }
    

}elseif(isset($_GET['file']) ){

    $upload = R::load('upload',$_GET['file']);
    header("Content-length: $upload->size");
    header("Content-type: $upload->type");
    header("Content-Disposition: upload; filename=$upload->name");
    echo $upload->content;
    exit;
}
?>
</pre>
<form action="" method="post" enctype="multipart/form-data">
    <input type="file" name="myfile" />
    <input type="submit" value="Go" name="upload" />
</form>
<?php

$uploads = R::findAll('upload');
echo '<p>Available Files:</p><ul>';
foreach ($uploads as $idx => $upload) {
    echo '<li><a href="?file=' . $upload->id . '">'. $upload->name .'</a></li>';
}
echo '</ul>';

//$nomination = new nomination(1);

$selfnom = new Selfnom(1);

// class Model_Nomination extends RedBean_SimpleModel
// {
//  public function open() {
//      print_r(__METHOD__ . '<br />');
//      print_r($this->nominationtype->slug . '<br />');
//      $this->bean->setMeta('subtable_record', R::findOne(
//          'nomination' . $this->nominationtype->slug,
//          'nomination_id = :nomination_id',
//          [
//              ':nomination_id' => $this->id,
//          ]
//      ));
//  }
// }

// $nom = R::load('nomination',1);

// print_r($nom->export());
// print_r($nom->getMeta('subtable_record')->export());


// R::store($nom);



// $ac = R::findOrCreate('awardcycle',['name'=>'Academic Year 2015-16']);
// print_r($ac->export());

// $nt = R::findOrCreate('nominationtype',['name'=>'Student Self-Nominated']);
// print_r($nt->export());

// $ap = R::findOrCreate('awardprofile',['name'=>'ABC Award']);
// //print_r($ap->export());

// $ac->sharedNominationtypeList[] = $nt;
// R::store($ac);

// $ao = R::load('awardoffer',10);
// //$ao->awardcycle = $ac;
// //$ao->nominationtype = $nt;
// //$ao->awardprofile = $ap;

// //R::store($ao);
// echo '$ao = <br />';
// print_r($ao->export());

// $u = R::findOrCreate('user',['first_name' =>'Paul']);
// //$u->last_name = 'Glass-Steel';
// //R::store($u);
// //print_r($u->export());

// $nom = R::load('nomination',3);
// // $nom->nominee = $u;
// // $nom->awardcycle = $ac;
// // $nom->nominationtype = $nt;

// print_r( R::store($nom) );

// echo '<br />$nom after store= <br />';
// print_r($nom->export());

// $nom->link('nomination_awardoffer',[
//  'awardcycle' => $ac,
//  'nominationtype_id' => 3,
//  'nominee_id' => $nom->nominee_id,
//  'awardprofile_id' => 2,
// ])->awardoffer = $ao;

//echo '<br />$nom after link set= <br />';
//print_r($nom->export());


// $nom = R::load('nomination',2);
// $nom->fetchAs('user')->nominee;

// $ao = R::load('awardoffer',11);

// $nom->link('nomination_awardoffer',[
//  'awardcycle' => $nom->awardcycle,
//  'nominationtype' => $nom->nominationtype,
//  'nominee' => $nom->nominee,
//  'awardprofile' => $ao->awardprofile,
// ])->awardoffer = $ao;

// try {
//  R::store($nom); //adding nao
// } catch (Exception $e) {
//  if ( strripos($e->getMessage(), 'nao_one_profile_per_nominee_per_cycle') !== false ){
//      $nom->fetchAs('user')->nominee;
//      echo 'Error: Nominee ' . $nom->nominee->first_name . ' ' . $nom->nominee->last_name . ' already has a ' . $ao->awardprofile->name . ' nomination for the ' . $nom->awardcycle->name . ' Award Cycle';
//  }else{
//      print_r('message = ');
//      print_r($e->getMessage());
//  }
// }

// echo '<p>END</p>';

