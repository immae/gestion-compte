<?php

namespace AppBundle\Controller;


use AppBundle\Entity\Service;
use AppBundle\Entity\Task;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;
use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\Validator\Constraints\DateTime;


/**
 * Task controller.
 *
 * @Route("services")
 */
class ServiceController extends Controller
{

    /**
     * Lists all services.
     *
     * @Route("/", name="admin_services")
     * @Method("GET")
     * @Security("has_role('ROLE_SUPER_ADMIN')")
     */
    public function listAction(Request $request){
        $em = $this->getDoctrine()->getManager();
        $services = $em->getRepository('AppBundle:Service')->findAll();
        return $this->render('admin/service/list.html.twig', array(
            'services' => $services
        ));

    }

    /**
     * add new services.
     *
     * @Route("/new", name="service_new")
     * @Method({"GET","POST"})
     * @Security("has_role('ROLE_SUPER_ADMIN')")
     */
    public function newAction(Request $request){
        $session = new Session();

        $service = new Service();

        $em = $this->getDoctrine()->getManager();

        $form = $this->createForm('AppBundle\Form\ServiceType', $service);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {

            $em->persist($service);
            $em->flush();

            $session->getFlashBag()->add('success', 'Le nouveau service a bien été créée !');

            return $this->redirectToRoute('admin_services');

        }elseif ($form->isSubmitted()){
            foreach ($this->getErrorMessages($form) as $key => $errors){
                foreach ($errors as $error)
                    $session->getFlashBag()->add('error', $key." : ".$error);
            }
        }
        return $this->render('admin/service/new.html.twig', array(
            'form' => $form->createView()
        ));

    }

    /**
     * edit service.
     *
     * @Route("/edit/{id}", name="service_edit")
     * @Method({"GET","POST"})
     * @Security("has_role('ROLE_SUPER_ADMIN')")
     */
    public function editAction(Request $request,Service $service){
        $session = new Session();

        $em = $this->getDoctrine()->getManager();
        $form = $this->createForm('AppBundle\Form\ServiceType', $service);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {

            $em->persist($service);
            $em->flush();

            $session->getFlashBag()->add('success', 'Le service a bien été édité !');

            return $this->redirectToRoute('admin_services');

        }elseif ($form->isSubmitted()){
            foreach ($this->getErrorMessages($form) as $key => $errors){
                foreach ($errors as $error)
                    $session->getFlashBag()->add('error', $key." : ".$error);
            }
        }
        return $this->render('admin/service/edit.html.twig', array(
            'form' => $form->createView()
        ));


    }

}
