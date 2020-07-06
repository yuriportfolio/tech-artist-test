using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Player : MonoBehaviour
{

	public int maxHealth = 100;
	public int currentHealth;
    public int score = 0;
    public Text TextScore;


	public HealthBar healthBar;

    // Start is called before the first frame update
    void Start()
    {
		currentHealth = maxHealth;
		healthBar.SetMaxHealth(maxHealth);
    }

    // Update is called once per frame
    
    void ISCORE()
    {
        score+=1;
        TextScore.text = score.ToString(); 
    }
	void TakeDamage(int damage)
	{
		currentHealth -= damage;

		healthBar.SetHealth(currentHealth);
	}
    void UpHealth(int lifepoint)
    {
        currentHealth += lifepoint;

        healthBar.SetHealth(currentHealth);
    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("PowerUp"))
        {
            UpHealth(20);
            ISCORE();
            
        }
        if (other.CompareTag("Damage"))
        {
            TakeDamage(20);
        }
    }
}
