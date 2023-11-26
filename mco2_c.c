#include <stdio.h>
#include <stdlib.h>
extern void vecadd(int n, int* arr1, int* arr2, int*arr3);
extern void imgAvgFilter(int* input_image, int* filtered_image, int sampling_window_size, int image_size_x,int image_size_y);
int main(){
	int i, j,N, sampling_window_size, image_size_x, image_size_y;;
	int* input_image;
	int* filtered_image;
	input_image = (int*)malloc(N*sizeof(*input_image));
//get input for size of array
	printf("Enter x number of rows: ");
	scanf("%d", &image_size_x);
	printf("Enter y number of columns: ");
	scanf("%d", &image_size_y);
	printf("Enter sampling window size: ");
	scanf("%d", &sampling_window_size);
	
	N = image_size_x * image_size_y;
	int input_image[N]= {0};
	int filtered_image[N]= {0};
//get image input
	printf("Enter the pixel values for the input image: \n");	
	for(i=0;i<image_size_x;i++){
		for(j = 0; j< image_size_y; j++){
			printf("pixel[%d][%d]: ",i,j);
			scanf("%d", &input_image[i*image_size_x +j]);
		}
	}

	imgAvgFilter(input_image,filtered_image,sampling_window_size,image_size_x, image_size_y);

//display filtered image
	for(i=0; i< image_size_x;i++){
		for(j=0;j<image_size_y; j++){
			printf("%d  ", filtered_image[i*image_size_x+image_size_y]);
		}
		printf("\n");
	}
	return 0;
}
