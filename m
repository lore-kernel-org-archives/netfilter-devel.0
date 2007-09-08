From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: [RFC] High Performance Packet Classification (HPPC) to succeed
	HIPAC
Date: Sat, 8 Sep 2007 18:16:18 +0000
Message-ID: <20070908181618.GA31607@ekonomika.be>
References: <20070907090923.GA31885@ekonomika.be>
	<200709080045.49369.thomasheinz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Heinz <thomasheinz@gmx.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <200709080045.49369.thomasheinz@gmx.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Sep 08, 2007 at 12:45:48AM +0200, Thomas Heinz wrote:
> Hi Steven

Hi Thomas! :)
 
> You wrote:
> > In HIPAC, all rules are stored in a trie indexed by specifier. By
> > walking down such a trie given e.g. an IP address, all rules relevant to
> > that IP address can be found. Repeating this walk for every dimension
> > and intersecting the results (which are lists of rules), a single list
> > is obtained that is relevant for the packet to classify. All that
> > remains to be done then, is go over those rules to classify the packet.
> 
> Well, no. HiPAC is not based on tries but interprets the packet 
> classification problem as a geometric problem where each rule is 
> represented by a d-dimensional orthotope (= rectangular hypercube, for d=2 
> a rectangle) and a packet is a point in the d-dimensional space. Hence, 
> packet classification is equivalent to finding the highest priority 
> orthotope enclosing the point.

the above was actually my interpretation of the thesis you wrote, but
your explanantion is obviously more correct :)

> > The HIPAC authors claim that the complexity of the trie-lookup is O(log
> > log N), where N is the size of the search-space. For IPv4, (and log ==
> > log2), this would be 5.
> 
> With 'this' you mean that log log N = 5, I guess. Well, using van Emde Boas 
> trees also known as stratified trees in order to represent the bounded 
> range location problem (subproblem of the packet classification problem in 
> HiPAC), it is possible to achieve O(d log log N) lookup time for the 
> d-dimensional packet classification problem. 

I see now how vBE trees can achieve O(log log N) (after reading the
wikipedia article). The tree is actually a trie, where each next layer
holds maximum half the entries of the previous layer. Concretely for
IPv4, this means the root of the tree contains 2^16 pointers to nodes of
the next layer (the first 16 bits of the address is used as index in
this array of the rootnode), the next layer has 2^8, then 2^4, 2^2 and
so on.

The way I suggested uses a fixed 8-bit wide key at each level.
(By the way, I'm not saying HiPAC does a bad job, I just never truly
understood it ;) We use HiPAC on our central firewall and are very happy
with its performance).

For IPv4, using fixed 8-bit wide keys takes 4 steps to lookup an IP
address. In HiPAC, it takes 5 steps.

But in IPv6, using HiPAC would take only 7 steps, compared to 16 steps
in using 8-bit indices.

However, a genuine vEB tree would need to store 2^64 pointers at the
first layer, which is more memory than any server I know of, uses.

> However, in practice this is 
> not relevant as for practical range location problem sizes as occuring in 
> the HiPAC data structure, a simpler data structure can be used yielding 
> O(d log n) lookup time where n is the number of rules.

Why is the lookup time dependant on the number of rules ?

> 
> > Just like in HIPAC, I would like to refer to rules from a (radix) tree,
> > indexed by a specifier. Every level in this tree will split up the
> > searchspace in 256 pieces, unless no nodes are stored below it. For IPv4
> > IP addresses, this means an IP can be looked up by splitting it in 4
> > bytes, and using each of the bytes as an index into an array at each
> > level of the tree.
> >
> > The complexity of this is O((log N) / 8), with N being 2^32, and is the
> > fastest and simplest way of looking up an IP address I can imagine
> > without using alot of memory.
> 
> The disadvantage of using tries is that you can only use prefixes for each 
> dimension, e.g. port ranges have to be represented as a set of set of port 
> prefixes. In the worst case you need 2(k-1) prefixes to represent a single 
> range where k is the number of bits (e.g. 32 in case of IPv4 addresses). 
> Hence, if you have a rule with d range matches, you end up with (2(k-1))^d 
> prefix rules in the worst case (assuming that each match has bit width k).

Do you mean 2^(k-1) prefixes as the worst case ?

Suppose I have a trie with 2 levels of 8-bit wide prefixes to represent the 
values 0 to 65535.

If I want to represent a range of 1 to 255, that means I need to store
the rule 255 times in the trie (index 0 at level 0, then 1-255 at level
1)

If I need 1 to 510, I would need to store 510 entries ([0][1] to
[0][255] and [1][0] to [1][254])

But if I need to represent a range that encompases an entire level 1
block, then I can just add the rule at a higher level.

The problem with space is very real here. vEB trees would need less
space, because as the depth increases, the blocksize decreases, so more
of the entries in the range can be grouped.
 
For IPv6, maybe a hybrid approach can be used: a couple fixed-width
prefixes for the first few levels, which then point to vEB trees.

> Moreover, this approach does not scale well to multiple dimensions: either 
> you obtain poor lookup times (hierarchical tries) or poor space complexity 
> (set-pruning tries). See e.g.
> http://tiny-tera.stanford.edu/~nickm/papers/classification_tutorial_01.pdf

This is only if you store multiple dimensions in a single trie, no ?
If you do lookups for each dimension separately, and then intersect the
results, the complexity is just O(d * log n)

kind regards,
-- Steven
