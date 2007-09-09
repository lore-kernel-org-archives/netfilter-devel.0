From: Thomas Heinz <thomasheinz@gmx.net>
Subject: Re: [RFC] High Performance Packet Classification (HPPC) to succeed
	HIPAC
Date: Mon, 10 Sep 2007 00:12:44 +0200
Message-ID: <200709100012.44494.thomasheinz@gmx.net>
References: <20070907090923.GA31885@ekonomika.be>
	<200709080045.49369.thomasheinz@gmx.net>
	<20070908181618.GA31607@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steven Van Acker <deepstar@singularity.be>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070908181618.GA31607@ekonomika.be>
Content-Disposition: inline
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

You wrote:
> I see now how vBE trees can achieve O(log log N) (after reading the
> wikipedia article). The tree is actually a trie, where each next layer
> holds maximum half the entries of the previous layer. Concretely for
> IPv4, this means the root of the tree contains 2^16 pointers to nodes of
> the next layer (the first 16 bits of the address is used as index in
> this array of the rootnode), the next layer has 2^8, then 2^4, 2^2 and
> so on.

Well, an efficient implementation is a little more complicated. You may 
want to read http://citeseer.ist.psu.edu/483355.html

Essentially, a stratified tree consists of a top and a bottom part. The top 
part is again a stratified tree containing the higher N/2 bits of the 
values and the bottom part is a dictionary (hash) which maps each entry i 
in the top tree to a stratified tree containing the lower N/2 bits of all 
values containing i in the higher N/2 bits. This construction continues 
recursively.

> (By the way, I'm not saying HiPAC does a bad job, I just never truly
> understood it ;) We use HiPAC on our central firewall and are very happy
> with its performance).

Nice to hear that :)

> However, a genuine vEB tree would need to store 2^64 pointers at the
> first layer, which is more memory than any server I know of, uses.

No, the paper I mentioned above provides an implementation of stratified 
trees with space complexity O(n) where n is the the number of values 
inserted into the stratified tree.

> > However, in practice this is
> > not relevant as for practical range location problem sizes as occuring
> > in the HiPAC data structure, a simpler data structure can be used
> > yielding O(d log n) lookup time where n is the number of rules.
>
> Why is the lookup time dependant on the number of rules ?

Well, HiPAC does not implement vEB/stratified trees but uses (depending on 
the release) a static B-Tree with implicit layout (no pointers) or simply 
binary search on an array. Since both data structures are not based on a 
bounded universe, the lookup time depends on the number of rules. Hence 
O(d log n) time for the lookup. In practice, they are more efficient. In 
the beginning, we tried a highly tuned stratified tree implementation and 
it lost against our optimized btree variant which to our surprise again 
lost against an efficient binary search implementation.

Actually, the efficiency highly depends on the problem size. Since the 
problem that is solved by these data structures occurs very often in the 
HiPAC data structure, most instances are very small even for huge rule 
sets.

> > The disadvantage of using tries is that you can only use prefixes for
> > each dimension, e.g. port ranges have to be represented as a set of
> > set of port prefixes. In the worst case you need 2(k-1) prefixes to
> > represent a single range where k is the number of bits (e.g. 32 in
> > case of IPv4 addresses). Hence, if you have a rule with d range
> > matches, you end up with (2(k-1))^d prefix rules in the worst case
> > (assuming that each match has bit width k).
>
> Do you mean 2^(k-1) prefixes as the worst case ?

No, any range [a, b] where a, b \in [0, 2^(k-1)] can be expressed by at 
most 2(k-1) prefixes. Just to avoid any confusion. With prefix I mean the 
following. Let k = 4 and our bit prefix be e.g. <01>. Then this prefix 
represents all numbers <0100>...<0111> (4-7).

If you have a rule with d dimensions where each match (dimension) is an 
interval you have to use (2(k-1))^d prefix rules in the worst case to 
represent this rule set (all possible combinations).

> Suppose I have a trie with 2 levels of 8-bit wide prefixes to represent
> the values 0 to 65535.
>
> If I want to represent a range of 1 to 255, that means I need to store
> the rule 255 times in the trie (index 0 at level 0, then 1-255 at level
> 1)
>
> If I need 1 to 510, I would need to store 510 entries ([0][1] to
> [0][255] and [1][0] to [1][254])

You can store prefixes in the trie. Thus, you don't have to store [0..255] 
in the second level under 0 in the first level as the leaf is full. To 
understand this, consider a trie where each node represents a single bit. 
The rest is just optimization.

Note that even with this "trick" tries are highly inefficient for packet 
classification.

The one-dimensional packet classification problem based on intervals is 
actually very simple. You are given n rules of the form [a, b] and a 
unique priority for each rule. Now, these intervals may intersect each 
other but we can easily provide at most 2n + 1 intervals such that none of 
these intervals is intersected by any of our n rules. Check the ascii art 
to see this.

     |-----------------|
             |------------------|
  |-------------------------------------|


|-|--|-------|---------|--------|-------|---------------------------|
0                                                                2^k - 1

Each of the adjacent intervals on the lowest line can be associated with 
the highest priority overlapping interval (rule) and hence the 
one-dimensional packet classification problem boils down to storing the 
right end points in a data structure D which supports the locate operation 
such that
locate(x): returns the smallest y >= x such that y \in D
This problem is also called range location problem.

Efficient data structures are (depending on the problem size): array 
(binary search), btree, vEB (requires bounded universe).

> > Moreover, this approach does not scale well to multiple dimensions:
> > either you obtain poor lookup times (hierarchical tries) or poor space
> > complexity (set-pruning tries). See e.g.
> > http://tiny-tera.stanford.edu/~nickm/papers/classification_tutorial_01
> >.pdf
>
> This is only if you store multiple dimensions in a single trie, no ?
> If you do lookups for each dimension separately, and then intersect the
> results, the complexity is just O(d * log n)

Sorry to disappoint you but no. Each of the d lookups may return O(n) rules 
which you have to intersect and this intersection cannot be done in O(d 
log n) time.


Cheers,

Thomas
