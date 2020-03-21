---
layout: default
title: 유니온파인드 (Union & Find)
description: 개념 설명 및 구현 방법
---

[뒤로가기](../../)

## 들어가기 전에...
> * [***'Fundamentals of data structures in C'***](https://g.co/kgs/41ScV6) 전공서적에서 ***247p - 259p***를 참고하였습니다.
* 해석의 오류가 있을 수 있음을 인정합니다.
* 대부분의 그림과 코드들은 위의 책을 참고하였고, 몇몇 예시는 이 [영상](https://www.youtube.com/watch?v=wU6udHRIkcc)을 참고했습니다.

### 1. Introduction
 ***S1과 S2가 서로 다른 집합이면, 그 안의 어떤 원소도 S1과 S2에 함께 들어있는 원소는 없다***고 가정합니다. 이 때, 우리는 S1과 S2를 ***disjoint set, 서로소 집합***이라 합니다. 예를 들어, 0부터 9까지의 10개 원소를 갖고 있다고 합니다. 이것을 세 개의 서로소 집합으로 나누는데 S1 = {0, 6, 7, 8}, S2 = {1, 4, 9}, S3 = {2, 3, 5}라고 합시다. <그림1>은 이러한 집합들을 보여주는 그림입니다. 
 
 각각의 집합들은 일반적으로 부모에서 자식으로 향하는 연결보다는 자식에서 부모로 향하는 노드들로 연결되어 있습니다. 이러한 연결의 이유는 우리가 집합의 연산을 수행에 대해 이야기할 때 조금 더 명확하게 설명하겠습니다.

 이러한 집합들에 대해 우리가 수행하고자 하는 최소한의 연산은 다음과 같이 정의힙니다.
 > ***Disjoint set union.***  S1과 S2가 서로소 집합이고 그들의 합집합은 S1 ∪ S2 = {모든 원소, x, x는 S1 또는 S2의 원소}이라 하자. 우리는 모든 집합을 서로소 집합이라고 가정했기 때문에 S1과 S2의 합집합에 대하여 S1과 S2가 더 이상 독립적으로 존재하지 않는다고 말할 수 있다. 다시 말해, 우리는 이들을 S1 ∪ S2로 치환할 수 있다.

 > ***Find(i).*** 원소 i를 포함하고 있는 집합을 찾는다.

![1](../../img/Disjointset/picture_1.png)

### 2. Union And Find Operations
 먼저 Union 연산에 대해 생각해 봅시다. 우리는 S1과 S2의 합집합을 구하고 싶습니다. 우리는 자식으로부터 부모로 향하게 노드들을 연결했기 때문에, 우리는 간단하게 다른 하나의 트리를 서브트리로 하는 트리를 만들 수 있습니다. S1 ∪ S2는 <그림2>의 트리 중 하나로 표현할 수 있습니다. 


![2](../../img/Disjointset/picture_2.png)
 ``` c++
    int simpleFind(int i)
    {
        for (; parent[i] >= 0; i = parent[i])   // 인덱스 i의 parent[i]가 -1일 때까지 부모를 찾는다.
            ;
        return i;
    }
    
    void simpleUnion(int i, int j) 
    {
        parent[i] = j;
    }
 ```

***simpleUnion*1과 *simpleFind*1에 관한 분석 :** simpleUnion과 simpleFind가 아무리 구현하기 쉽다고 하더라도, 그들의 성능은 좋지 않습니다. 다음의 순서의 union-find 연산을 수행해 봅시다.

![3](../../img/Disjointset/picture_3.png)

이 순서는 degerated tree, 변질 트리를 만듭니다. union하는 데 걸리는 시간이 constant하기 때문에, 우리는 n-1 유니언을 O(n)에 해결할 수 있습니다. 그러나, find의 경우, 우리는 반드시 0에서 root까지 부모 링크를 따라가야 합니다. 만약 원소가 i-레벨에 있다면, 그것의 루트를 찾는 데 O(i)시간이 걸립니다. 그러므로 n-1을 찾는 프로세스를 처리하는 데 걸리는 ***총 시간은 O(n^2)***입니다. 변질 트리 생성을 피하기 위해 우리는 union과 find 연산에서 조금 더 효율적인 구현을 할 수 있습니다. union(i, j)에 대하여 다음의 **Weighting rule**을 적용하여 이 문제를 해결할 수 있습니다.  


> **정의 :** *union(i, j)에 대한 **weighting rule**.* 만약 트리 i 안의 노드들의 수가 트리 j의 노드들의 수 보다 적을 경우, j를 i의 parent로 만든다. 그렇지 않을 경우, i를 j의 parent로 만든다. 

![4](../../img/Disjointset/picture_4.png)

![5](../../img/Disjointset/picture_6.png)

``` c++
    void weightedUnion(int i, int j)
    {/*root가 i와 j인 두 집합을 union합니다. 이 때, i != j 이면, weighting rule을 적용합니다. 
        parent[i] = -count[i] 이고, parent[j] = -count[j] 입니다.*/
        
        int temp = parent[i] + parent[j];
        if (parent[i] > parent[j]) {
            parent[i] = j;  /* j를 새로운 루트로 만듭니다 */
            parent[j] = temp;
        }
        else {
            parent[j] = i;  /* i를 새로운 루트로 만듭니다 */
            parent[i] = temp;
        }
    }
```


> **정의[*Collapsing rule*]** : 만약 i에서 루트로 향하는 길 위의 노드 j가 parent[i] != root(i)이면, parent[j]를 root(i)로 바꾼다.


***weightedUnion*과 *collapsingFind*에 관한 분석 :** collapsing rule을 사용하는 것은 하나의 find를 수행하는 것보다 2배의 시간이 듭니다. 그러나 연속적인 find를 수행하는 것에 있어서 worst-case 시간을 줄이도록 도와줍니다. weightUnion과 collapsingFind를 이용해서 unions과 finds의 시퀀스를 처리하는 Worst-case 의 복잡도는 애커만 함수를 이용하여 나타낼 수 있습니다. 호출할 때마다 수행시간이 변하므로 매우 까다로운 시간 복잡도를 갖고 있는데 애커만 함수에 의하면 실제 ***시간 복잡도는 O(α(N))***입니다. α는 애커만 함수라고 하는데 N이  2^65536일때 애커만 함수 값이 5가 됩니다. 따라서 그냥 상수라고 봐도 무방합니다.

[시간 복잡도 부분은 crocus님의 블로그 내용을 인용했습니다.](https://www.crocus.co.kr/683)

``` c++
    int collapsingFind(int i)
    {/* 원소 i를 포함하고 있는 트리의 루트를 찾습니다. 
        i부터 루트까지 모든 노드를 무너뜨리기 위해 collapsing rule을 적용합니다. Iterative한 방법으로 구현하였습니다. */

        int root, trail, lead;
        for (root = i; parent[root] >= 0; root = parent[root])
            ;

        for (trail = i; trail != root; trail = lead) {  // Path Compression
            lead = parent[trail];
            parent[trail] = root;
        }

        return root;
    }

    int collapsingFind(int i)
    {/* 원소 i를 포함하고 있는 트리의 루트를 찾습니다. i에서 root로 가는 path위의 모든 vertex를 root에 연결합니다. 
        Recursive한 방법으로 구현하였습니다. */

        if (parent[i] == i) return i;
        else return parent[i] = collapsingFind(parent[i]);
    }
```

 그 밖에도 흔히 트리의 높이를 비교하여 높이가 낮은 서브 트리를 높은 서브 트리에 union하는(heightUnion) 등 다양한 방법으로 union & find를 최적화할 수 있습니다. 결과적으로, union과 find를 최적화하여 다양한 문제에 적용해 볼 수 있을 것 같습니다. 감사합니다.
