---
layout: default
title: 유니온파인드 (Union & Find)
description: 개념 설명 및 구현 방법
---



## 들어가기 전에...
> * [***'Fundamentals of data structures in C'***](https://g.co/kgs/41ScV6) 전공서적에서 ***247p - 259p***를 참고하였습니다.
* 해석의 오류가 있을 수 있음을 인정합니다.
* 모든 그림과 코드들은 책에서 가져왔습니다. 

### 1. Introduction
 이 장에서는 우리는 set으로 표현되는 트리의 사용법에 대해 공부할 것입니다. 간단히 하기 위해, 우리는 집합의 원소를 0, 1, ..., n-1의 정수라고 합니다. 이 예제에서는 이 숫자들이 원소들의 실제 이름을 저장하고 있는 테이블의 인덱스들이라고 정합니다. 또한, 표현되어진 집합은 pairwise disjoint입니다. 다시 말해, S1과 S2가 서로 다른 집합이면, 그 안의 어떤 원소도 S1과 S2에 함께 들어있는 원소는 없다고 가정합니다. 예를 들어, 우리는 0부터 9까지의 10개의 원소를 갖고 있다고 합니다. 이것을 세 개의 disjoint set으로 나누는데 S1 = {0, 6, 7, 8}, S2 = {1, 4, 9}, S3 = {2, 3, 5}라고 합시다. <그림1>은 이러한 집합들을 보여주는 그림입니다. 
 
 우리가 가진 각각의 집합들은 일반적으로 부모에서 자식으로 향하는 연결보다는 자식에서 부모로 향하는 노드들로 연결되어 있습니다. 이러한 연결의 이유는 우리가 집합의 연산을 수행에 대해 이야기할 때 조금 더 명확하게 설명하겠습니다.

 이러한 집합들에 대해 우리가 수행하고자 하는 최소한의 연산은 다음과 같습니다.
 > **Disjoint set union.** 만약 S1과 S2가 서로 분리집합이고 그리고 그들의 union은 S1 ∪ S2 = {모든 원소, x, x는 S1 또는 S2의 원소}이다. 우리는 모든 집합을 서로 분리집합이라고 가정했기 때문에 S1과 S2의 union에 대하여 S1과 S2가 더 이상 독립적으로 존재하지 않는다고 말할 수 있다. 다시 말해, 우리는 이들을 S1 ∪ S2로 치환할 수 있다.

 > **Find(i).** 원소 i를 포함하고 있는 집합을 찾는다. 예를 들어, 3은 S3 집합 안에 존재하고, 8은 S1 집합에 포함된다. 


### 2. Union And Find Operations
 먼저 Uion 연산에 대해 생각해 봅시다. 우리는 S1과 S2의 합집합을 구하고 싶습니다. 우리는 자식으로부터 부모로 향하게 노드들을 연결했기 때문에, 우리는 간단하게 다른 하나의 트리를 서브트리로 하는 트리를 만들 수 있습니다. S1 ∪ S2는 <그림2>의 트리 중 하나로 표현할 수 있습니다. 

 ``` c
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

***simpleUnion*1과 *simpleFind*1에 관한 분석 :** simpleUnion과 simpleFind가 아무리 구현하기 쉽다고 하더라도, 그들의 퍼포먼스는 좋지 않습니다. 예를 들어, 우리가 p 원소에서 시작했을 때, 그것 자체를 하나의 원소로 가지는 집합, 즉, Si = {i}, 0 <= i <= p이다. 이제 다음의 순서의 union-find 연산을 수행하여 보자.



``` c
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

***weightedUnion*과 *collapsingFind*에 관한 분석 :** collapsing rule을 사용하는 것은 하나의 find를 수행하는 것보다 2배의 시간이 듭니다. 그러나 연속적인 find를 수행하는 것에 있어서 worst-case 시간을 줄이도록 도와줍니다. 여기서 중요!



``` c
    int collapsingFind(int i)
    {/* 원소 i를 포함하고 있는 트리의 루트를 찾습니다. 
        i부터 루트까지 모든 노드를 무너뜨리기 위해 collapsing rule을 적용합니다. */

        int root, trail, lead;
        for (root = i; parent[root] >= 0; root = parent[root])
            ;

        for (trail = i; trail != root; trail = lead) {
            lead = parent[trail];
            parent[trail] = root;
        }

        return root;
    }
```

### 알고리즘





### 자료구조