datatype 'a AVLTree = Nil | Br of ((int*('a))*('a AVLTree)*('a AVLTree));
datatype Balance = RR | LR | LL | RL;
exception NotFound;

fun size Nil = 0
	| size (Br (v, t1, t2)) = 1 + size t1 + size t2;


local
	val compare = Int.compare;
	fun cmp (k1,_) (k2,_) = compare (k1,k2);
	fun height (Br(_,Nil,Nil)) = 0
		| height (Br(_,Nil,rt)) = 1 + (height rt)
		| height (Br(_,lt,Nil)) = 1 + (height lt)
		| height (Br(_,lt,rt)) = 1 + Int.max((height lt), (height rt))
		| height Nil = ~1;

	fun rotateRR (Br(fNode, fLTree, Br(sNode, sLTree, sRTree))) = Br(sNode,Br(fNode,fLTree,sLTree),sRTree)
		| rotateRR _ = raise NotFound; 
	fun rotateLL (Br(fNode, Br(sNode, sLTree, sRTree),fRTree)) = Br(sNode,sLTree,Br(fNode,sRTree,fRTree))
		| rotateLL _ = raise NotFound;
	fun rotateLR (Br(gfNode,Br(fNode, fLTree, Br(sNode, sLTree, sRTree)),gfRTree)) = 
		Br(sNode, Br(fNode, fLTree, sLTree), Br(gfNode, sRTree, gfRTree))
		| rotateLR _ = raise NotFound;
	fun rotateRL (Br(gfNode,gfLTree, Br(fNode, Br(sNode, sLTree, sRTree),fRTree))) = 
		Br(sNode, Br(gfNode,gfLTree,sLTree),Br(fNode,sRTree,fRTree))
		| rotateRL _ = raise NotFound;

	fun  checkRotateL (Br(_,lTree, rTree)) = 
			if ((height lTree - height rTree) >= 0 )  
			then LL 
			else LR
		| checkRotateL _ = raise NotFound
	fun checkRotateR (Br(_,lTree, rTree)) = 
			if ((height rTree - height lTree) >= 0 )  
			then RR 
			else RL
		| checkRotateR _ = raise NotFound
in
	fun insert (Nil, item) = Br(item, Nil, Nil)
		| insert ((Br (node,left,right)), item) = 
			case (cmp item node) of
				EQUAL => Br (item, left, right)
			  | GREATER => let
								val newRightTree = (insert(right, item));
								val newFatherNode = Br(node, left, newRightTree);
							in
								if (((1 + (height newRightTree)) - (1+(height left))) = 2) 
								then  
									if (checkRotateR newRightTree) = RR 
									then rotateRR newFatherNode
									else rotateRL newFatherNode
								else newFatherNode
							end
			  | LESS => let
							val newleftTree = (insert(left, item));
							val newFatherNode = Br(node, newleftTree, right);
						in
							if (((1 + (height newleftTree)) - (1 + (height right))) = 2) 
							then  
								if (checkRotateL newleftTree) = LL 
								then rotateLL newFatherNode
								else rotateLR newFatherNode
							else newFatherNode
						end;
end;

local
	val cmp = Int.compare;
	fun height (Br(_,Nil,Nil)) = 0
		| height (Br(_,Nil,rt)) = 1 + (height rt)
		| height (Br(_,lt,Nil)) = 1 + (height lt)
		| height (Br(_,lt,rt)) = 1 + Int.max((height lt), (height rt))
		| height Nil = ~1;
		

	fun rotateRR (Br(fNode, fLTree, Br(sNode, sLTree, sRTree))) = Br(sNode,Br(fNode,fLTree,sLTree),sRTree)
		| rotateRR _ = raise NotFound; 
	fun rotateLL (Br(fNode, Br(sNode, sLTree, sRTree),fRTree)) = Br(sNode,sLTree,Br(fNode,sRTree,fRTree))
		| rotateLL _ = raise NotFound;
	fun rotateLR (Br(gfNode,Br(fNode, fLTree, Br(sNode, sLTree, sRTree)),gfRTree)) = 
		Br(sNode, Br(fNode, fLTree, sLTree), Br(gfNode, sRTree, gfRTree))
		| rotateLR _ = raise NotFound;
	fun rotateRL (Br(gfNode,gfLTree, Br(fNode, Br(sNode, sLTree, sRTree),fRTree))) = 
		Br(sNode, Br(gfNode,gfLTree,sLTree),Br(fNode,sRTree,fRTree))
		| rotateRL _ = raise NotFound;

	fun  checkRotateL (Br(_,lTree, rTree)) = 
			if ((height lTree - height rTree) >= 0 )  
			then LL 
			else LR
		| checkRotateL _ = raise NotFound
	fun checkRotateR (Br(_,lTree, rTree)) = 
			if ((height rTree - height lTree) >= 0 )  
			then RR 
			else RL
		| checkRotateR _ = raise NotFound

	fun getMax (Br(node,Nil,Nil)) = node
		| getMax (Br(node,left,Nil)) = node
		| getMax (Br(node,_,right)) = getMax(right)
		| getMax (_) = raise NotFound

	fun getMin (Br(node,Nil,Nil)) = node
		| getMin (Br(node,Nil,right)) = node
		| getMin (Br(node,left,_)) = getMin(left)
		| getMin (_) = raise NotFound

in
	fun remove (Nil, key) = raise NotFound 
		| remove ((Br ((kNode,node),left,right)), key) = 
			case (cmp(key,kNode)) of
				EQUAL => (case (left,right) of
							(Nil,Nil) => Nil
							| (Nil,right) => let 
												val (minKey,minNode) = (getMin(right));
											  in
											  	Br((minKey,minNode),Nil,remove(right,minKey))
											  end
							| (left,Nil) =>  let 
												val (maxKey,maxNode) = (getMax(left));
											  in
											  	Br((maxKey,maxNode),remove(left,maxKey),Nil)
											  end
							| (left,right) => if ((height left) < (height right))
												then
													let 
														val (minKey,minNode) = (getMin(right));
													  in
													  	Br((minKey,minNode),left,remove(right,minKey))
													 end
												else
													let 
														val (maxKey,maxNode) = (getMax(left));
													  in
													  	Br((maxKey,maxNode),remove(left,maxKey),right)
													  end													 
						)
			  | GREATER => let
								val newRightTree = (remove(right, key));
								val newFatherNode = Br((kNode,node), left, newRightTree);
							in
								if (((1+(height newRightTree)) - (1+(height left))) = 2) 
								then  
									if (checkRotateR newRightTree) = RR 
									then rotateRR newFatherNode
									else rotateRL newFatherNode
								else newFatherNode
							end
			  | LESS => let
							val newleftTree = (remove(left, key));
							val newFatherNode = Br((kNode,node), newleftTree, right);
						in
							if (((1+(height newleftTree)) - (1+(height right))) = 2) 
							then  
								if (checkRotateL newleftTree) = LL 
								then rotateLL newFatherNode
								else rotateLR newFatherNode
							else newFatherNode
						end;

end;


fun  get(Nil, _) = raise NotFound
	| get((Br((node_k, v), left, right)),k) = 
		case Int.compare (k,node_k) of
			EQUAL   => v
			| GREATER => get(right, k)
			| LESS    => get(left, k);


fun inorder(Nil) = []
	| inorder(Br((k,v),Nil,Nil))  = [v]
	| inorder(Br((k,v),left,right))  = (inorder(left))@[v]@(inorder(right));


