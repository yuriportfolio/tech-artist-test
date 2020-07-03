﻿using UnityEngine;

[RequireComponent(typeof(PlayerMotor))]
public class PlayerController : MonoBehaviour
{
    public LayerMask movementMask;                                                              //Declare a layerMask called movementMask.  This represents the ground

    Camera cam;                                                                                 //Declare a camera called cam
    PlayerMotor motor;                                                                          //Declare a playerMotor called motor
    Animator anim;                                                                              //Declare an Animtor called anim
    Rigidbody rb;

    // Use this for initialization
    void Start()
    {
        cam = Camera.main;                                                                      //Assing the main camera to the variable cam
        motor = GetComponent<PlayerMotor>();                                                    //Get a playerMotor and assign it to motor
        anim = GetComponent<Animator>();                                                        //Get animator component and asign to the variable anim
        rb = GetComponent<Rigidbody>();
    }

    void Update()//Is called once per frame.  Asks if the mouse has been clicked
    {
        //Move the player
        if (Input.GetMouseButtonDown(0))                                                        //If the left mouse button is clicked...
        {
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);                                //Declare a ray called ray which points to the mouse positon
            RaycastHit hit;                                                                     //Declare a raycastHit called hit

            if (Physics.Raycast(ray, out hit, 100, movementMask))                               //If the ray hits the ground...
            {
                motor.MoveToPoint(hit.point);                                                   //Call the method MoveToPoint in playerMotor
            }
        }
        if (transform.hasChanged)
        {
            anim.SetBool("isWalking", true);
            transform.hasChanged = false;
        }
        else
        {
            anim.SetBool("isWalking", false);                                                   //If not walking than play Idle animation

        }

    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("PowerUp"))
        {
            anim.SetTrigger("PickUpTrigger");
        }
        if (other.CompareTag("Damage"))
        {
           anim.SetTrigger("HitTrigger");
        }
    }

}