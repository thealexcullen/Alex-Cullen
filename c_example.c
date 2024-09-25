#include <stdio.h>

int main() {
    printf("\n------------Challenge 1------------\n");
    int num = 1;
    for (int i = 1; i <= 10; i++) {
        printf("%d ", num);
        num *= 3;
    }

    int choice;
    int attempts = 0;
    char answer;
    int correct = 0;
    printf("\n------------Challenge 2------------\n");

    do{
        printf("\nChoose a riddle to solve: 1, 2, or 3.\n");
        printf("1. What has keys but can't open locks?\n");
        printf("2 I speak without a mouth and hear without ears. What am I?\n");
        printf("3. The more of this there is, the less you see. What is it?\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch(choice){
            case 1:
                printf("Riddle: What has keys but can't open locks?\n");
                printf("(a) A Piano\n(b) A Map\n(c) A Computer\nYour answer: ");
                scanf(" %c", &answer);
                if (answer == 'a' || answer == 'A') {
                    correct = 1;
                    printf("Correct!\n");
                } else {
                    printf("Incorrect answer. Try again.\n");
                }
                break;

            case 2:
                printf("Riddle 2: I speak without a mouth and hear without ears. What am I?\n");
                printf("(a) a voice\n(b) a piano\n(c) an echo\nYour answer: ");
                scanf(" %c", &answer);
                if(answer == 'c' || answer =='C'){
                    correct = 1;
                    printf("Correct!\n");
                }else{
                    printf("Incorrect, try again\n");
                }
                break;

            case 3:
                printf("Riddle 3: The more of this there is, the less you see. What is it?\n");
                printf("(a) sunlight\n(b) darkness\n(c) silence\nYour answer: ");
                scanf(" %c", &answer);
                if(answer == 'b' || answer =='B'){
                    correct = 1;
                    printf("Correct!\n");
                }else{
                    printf("Incorrect, try again\n");
                }
                break;

            default:
                printf("Invalid choice, please select a riddle from 1 to 3.\n");
                break;
        }
        attempts++;

    } while (attempts < 3 && !correct);

    printf("\n------------Challenge 3------------\n");
    int given;
    int result;

    printf("Enter the given number: ");
    scanf("%d", &given);

    result = (given % 2 == 0) ? (given + 50) : (given - 25);

    printf("\nThe result is: %d\n", result);
    return 0;
}