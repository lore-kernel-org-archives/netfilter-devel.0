From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: IPtables performance (fwd)
Date: Sat, 3 May 2003 19:39:46 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305031750040.8241-100000@fantomas.insite.com.br>
References: <Pine.LNX.4.44.0305031129230.8273-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0305031129230.8273-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 3 May 2003, Chris Wilson wrote:

> Hi Andre,
> 
> > 	I also may be making a fool of myself (not a first), but my take
> > is this:
> 
> It looks like you have found some very efficient algorithms (not to 
> mention a nice visual metaphor). Would you mind if I try to reimplement 
> mark_source_chains using these algorithms?

	Unfortunately, I cannot claim to be that smart, since not even the
colors are my idea... 

	Be my guest to implement it. I thought of doing it myself, but I'm
still looking around and trying to understand all those structures and
pointers and I am still trying to find my way around.

	Anyway, I was wondering, there is a variation that I think would
be more efficient, and would avoid traversing the trees again for every
hook.

	What is new is a stack of chains, initially empty, and you change
the traversal slightly to put chains on the stack.

	Here is the pseudo-code for the algorithm:

-------------------------------------------------
	for every chain:
		paint it white 
		set chain->comefrom to 0 

	for every hook:
		if dfs(chain pointed to by hook) returns LOOP
			return LOOP

	// here we know there are no loops and our stack have the chains 
	// in a nice order. Let's mark comefroms

	for every hook:
		hook->chain->comefrom |= (1<<HOOK_NUM)

	while there are chains on stack:
		get chain from top of stack
		for every rule in chain:
			comefrom of rule's target |= chain->comefrom

	dfs(chain) is:
		if color of chain is gray (that is, undecided)
			return LOOP
		if color of chain is black (that is, loop-free)
			return NO_LOOP
		paint chain gray
		for every rule:
			if (dfs(target of rule == LOOP)
				return LOOP
		paint chain black
		push chain
		return NO_LOOP
--------------------------------------------

	The explanation of it all is this: 

	First, to detect a loop, you paint vertices according to its
current state and you traverse the graph depth-first. Each vertex may be:
	
	- white: not yet seen
	- black: the graphs leaving from it are known not to have loops
	- gray: still being considered. 

	If you visit a chain and it is gray, then there is a loop, since
the chain being visited is a predecessor of the previous one. If you
visited every arc coming out of a vertex (rules coming out of a chain) and
you didn't detect a loop, then you paint this vertex black.

	Ok, now about marking the comefrom field: I was thinking that you
had to visit the vertices of the tree more than once because I was
thinking that you can't know what shade you use to paint a vertex at the
first time you visit it, since there may be more than one source for a
given vertex, and those sources may belong to different hooks. If you
visit a vertex from hook OUTPUT, for instance, and find out that it was
already marked as coming from hook INPUT, you still have to visit every
chain below it to mark them as coming from OUTPUT (if you use the
coloring, you visit them only once for every hook, but it is still once
*for every hook*).

	But there is a better way: what if you only visited a chain after
every chain that could be a source to it was already visited and had the
right comefrom field? 

	The way to do this is to visit every chain, starting from the 
hooks and put them on a stack after each of its children were visited. 
Since we have already done that to find loops, we can use that first 
traversal to make that stack.

	Here is an example:

-----------------------
Chains:
	INPUT -> A, G
	OUTPUT -> B 
	FORWARD -> D, C
	A -> B, F, G
	B -> C
	C -> G, H
	D -> E, H
	E -> F
	F -> nothing
	G -> nothing
	H -> nothing

Order of traversal:
	dfs(INPUT)
		dfs(A)
			dfs(B)
				dfs (C)
					dfs(G)
					dfs(H)
			dfs(F)
			dfs(G) returns immediately since G is black.
		dfs(G). G is black.
	dfs(OUTPUT)
		dfs(B). B is black.
	dfs(FORWARD)
		dfs(D)
			dfs(E)
			dfs(H). H is black
		dfs(C). C is black
		

	Order on stack:
	G H C B F A INPUT OUTPUT E D FORWARD


Now you begin popping:
	
	FORWARD: you set D and C as coming from FORWARD
	D: you mark E and H as coming from FORWARD
	E: you mark F as coming from FORWARD
	OUTPUT: you mark B as coming from OUTPUT
	INPUT: you mark A and G as coming from INPUT
	A: you mark B, F, G as coming from INPUT
		-- notice that B is OUTPUT + INPUT, and 
		-- F is FORWARD + INPUT
	F: no children to mark
	B: you mark C as OUTPUT + INPUT
		- now C is OUTPUT + INPUT + FORWARD
	C: you mark G and H as OUTPUT + INPUT + FORWARD
	H: no children to mark
	G: no children to mark

	A: INPUT
	B: INPUT OUTPUT
	C: INPUT OUTPUT FORWARD
	D: FORWARD
	E: FORWARD
	F: INPUT FORWARD
	G: INPUT OUTPUT FORWARD
	H: INPUT OUTPUT FORWARD
	
> I'm also wondering if the two steps, loop-detection and colouring, should 
> be combined as they currently are for brevity and performance, or 
> separated for simplicity and intuitive correctness?

	I don't think there is a way to have them really combined. I think
you have to visit the tree at least twice (discounting the first one in
which you paint the chains white), because of the problem mentioned above.  
I think that the method above will give you the theoretical minimum number
of operations possible. I may be wrong, of course.

	BTW, one thing to look at is how deep the recursion will be. If
someone decides to make a very deep tree, we may exhaust the system stack. 
We may have to use a recursion depth counter or change from recursion to 
iteration.

	Regards,
	Andre
