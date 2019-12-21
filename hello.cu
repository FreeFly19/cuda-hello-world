#include <stdio.h>

const int N = 1 << 29;

__global__ void vector_add(float *a, float *b, float *out, long n) {
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	out[i] = a[i] + b[i];
}

int main(int argc, char **args) {
	float *a, *b, *out;
	float *d_a, *d_b, *d_out;

	a = (float*) malloc(sizeof(float) * N);
	b = (float*) malloc(sizeof(float) * N);
	out = (float*) malloc(sizeof(float) * N);
		
	cudaMalloc((void**) &d_a, sizeof(float) * N);
	cudaMalloc((void**) &d_b, sizeof(float) * N);
	cudaMalloc((void**) &d_out, sizeof(float) * N);

	for(int i = 0; i < N; i++) {
		a[i] = i;
		b[i] = i * 2;
	}

	cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);

	vector_add<<<N/1024, 1024>>>(d_a, d_b, d_out, N);
	
	cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);

	//for(int i = 0; i < N; i++) {
	//	printf("%1.2f\n", out[i]);
	//}
	printf("%d", (int)out[N-1]/3);
}
