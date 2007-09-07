From: Thomas Heinz <thomasheinz@gmx.net>
Subject: Re: [RFC] High Performance Packet Classification (HPPC) to succeed
	HIPAC
Date: Sat, 8 Sep 2007 00:45:48 +0200
Message-ID: <200709080045.49369.thomasheinz@gmx.net>
References: <20070907090923.GA31885@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070907090923.GA31885@ekonomika.be>
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

Hi Steven

You wrote:
> In HIPAC, all rules are stored in a trie indexed by specifier. By
> walking down such a trie given e.g. an IP address, all rules relevant to
> that IP address can be found. Repeating this walk for every dimension
> and intersecting the results (which are lists of rules), a single list
> is obtained that is relevant for the packet to classify. All that
> remains to be done then, is go over those rules to classify the packet.

Well, no. HiPAC is not based on tries but interprets the packet 
classification problem as a geometric problem where each rule is 
represented by a d-dimensional orthotope (= rectangular hypercube, for d=2 
a rectangle) and a packet is a point in the d-dimensional space. Hence, 
packet classification is equivalent to finding the highest priority 
orthotope enclosing the point.

> The HIPAC authors claim that the complexity of the trie-lookup is O(log
> log N), where N is the size of the search-space. For IPv4, (and log ==
> log2), this would be 5.

With 'this' you mean that log log N = 5, I guess. Well, using van Emde Boas 
trees also known as stratified trees in order to represent the bounded 
range location problem (subproblem of the packet classification problem in 
HiPAC), it is possible to achieve O(d log log N) lookup time for the 
d-dimensional packet classification problem. However, in practice this is 
not relevant as for practical range location problem sizes as occuring in 
the HiPAC data structure, a simpler data structure can be used yielding 
O(d log n) lookup time where n is the number of rules.

> Just like in HIPAC, I would like to refer to rules from a (radix) tree,
> indexed by a specifier. Every level in this tree will split up the
> searchspace in 256 pieces, unless no nodes are stored below it. For IPv4
> IP addresses, this means an IP can be looked up by splitting it in 4
> bytes, and using each of the bytes as an index into an array at each
> level of the tree.
>
> The complexity of this is O((log N) / 8), with N being 2^32, and is the
> fastest and simplest way of looking up an IP address I can imagine
> without using alot of memory.

The disadvantage of using tries is that you can only use prefixes for each 
dimension, e.g. port ranges have to be represented as a set of set of port 
prefixes. In the worst case you need 2(k-1) prefixes to represent a single 
range where k is the number of bits (e.g. 32 in case of IPv4 addresses). 
Hence, if you have a rule with d range matches, you end up with (2(k-1))^d 
prefix rules in the worst case (assuming that each match has bit width k).

Moreover, this approach does not scale well to multiple dimensions: either 
you obtain poor lookup times (hierarchical tries) or poor space complexity 
(set-pruning tries). See e.g.
http://tiny-tera.stanford.edu/~nickm/papers/classification_tutorial_01.pdf


Cheers,

Thomas
