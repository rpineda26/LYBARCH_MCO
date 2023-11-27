#include <stdio.h>
int average(int x, int y, int sample, int* input, int row){
	int i, j, sum=0, n;
	n= sample * sample;
	sample /=2;
	for( i=x-sample;i<x+sample+1;i ++){
		for(j = y-sample;j<y+sample+1; j++){
			sum += input[i*row+j];
			printf("%d + ", input[i*row+j]);
		}
		printf("\n");
	}
	printf("\nsum: %d\n", sum);
	return sum / n;
}
int checkBorder(int x_index, int y_index, int sample, int x_size, int y_size){
	int  result;
	sample /=2;
	if(x_index - sample <0)
		result = 0;
	else if(x_index + sample >= x_size)
		result = 0;
	else if(y_index + sample >= y_size)
		result = 0;
	else if (y_index-sample<0)
		result =0;
	else
		result = 1;
	return result;
}
void imgAvgFilter(int*input_image, int* filtered_image, int sampling_window_size, int image_size_x, int image_size_y){
	int i, j, isBorder;
	for(i=0;i<image_size_x;i++){
		for(j=0;j<image_size_y;j++){
			isBorder = checkBorder(i,j,sampling_window_size, image_size_x, image_size_y);
			if(isBorder){
				filtered_image[i*image_size_x +j] = average(i, j, sampling_window_size, input_image, image_size_x);
			}else{
				filtered_image[i*image_size_x+j] = input_image[i*image_size_x+ j];
			}
		}
	}
}
int main(){
	int i, j, x, y, sample, n;
	scanf("%d", &x);
	scanf("%d", &y);
	scanf("%d", &sample);
	n = x * y;
	int input[n];
	int filter[n];
	for(i=0;i<x;i++){
		for(j=0;j<y;j++){
			scanf("%d", &input[i*x + j]);
		}
	}
	imgAvgFilter(input,filter,sample,x,y);
	for(i=0;i<x;i++){
		for(j=0;j<y;j++){
			printf("%d  ", filter[i*x + j]);
		}
		printf("\n");
	}
	return 0;
}

