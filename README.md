# MILIS
Multiple Instance Learning with Instance Selection

### Implementation of the Algorithm MILIS from scratch. You can find the original paper MILIS [here](https://ieeexplore.ieee.org/document/5557878?arnumber=5557878)

* This paper proposes an efficient instance selection technique to speed up the training process of a multiple instance learning problem without compromising the performance.
* MILIS is based on a bag level feature representation. It uses linear SVM for classification in the bag level feature space. The feature vectors are constructed using IPs. The IP is every instance that is used to form the bag-level feature mapping and treated as a potential target concept carrying category information. For each bag, the idea is to detect the instance that represents most that bag. For positive bags, the goal is to detect the true positive instance in each bag. The idea behind this method is that if instance x is a true positive instance, then a positive bag should have high similarity to instance x. A negative bag, on the other hand, has a low similarity since all instances in the negative bag are far apart from x. 
* All instances contained in the negative bags are modeled by Gaussian-kernel-based kernel density estimator (KDE). For the efficient density estimation for each positive instance, we pick its K-nearest negative instances and evaluate the probability of the positive instance being generated from the negative population. The least negative instance, from each positive bag is selected as the IP.
For each negative bag, we pick the single instance with the highest likelihood value, so the most negative instance, as the IP.
Number of IPs= number of bags << number of all the training instance (MILES)
* After obtaining the SVM classifier for bag-level features, we can validate the selected IPs and update them accordingly. 
* The MILIS method updates the feature map and the classifier output simultaneously and stop the update process early on if the new feature map yields solutions that depart from the current optimum.


