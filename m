From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: [RFC] High Performance Packet Classification (HPPC) to succeed HIPAC
Date: Fri, 7 Sep 2007 09:09:23 +0000
Message-ID: <20070907090923.GA31885@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I'm a user of nf-HIPAC (http://www.hipac.org) and I've tried to monitor it's
progress into the main kernel tree. Unfortunately, the work on nf-HIPAC seems to
have stopped.  The last update of the website is from November 8th 2005, which
is almost 2 years ago.

Unless there is some work being done on integrating HIPAC with iptables (or
xtables), I would like to give this a go.

The main problem I see with this right now is that the patch is way too big to
analyze and rework (at least for me). So instead, I would like to reimplement
everything from scratch and integrate it with iptables from the very start.

Both these situation sketches are based on my (currently) narrow perception of
how things seem to work:

current situation
-----------------

For every packet traversing a chain, all rules are evaluated untill one reaches
a terminal decision. The worst case scenario is that no rules in the chain
match and all of them need to be traversed.

Each rule has 5 "fixed" specifiers that can be seen as dimensions: source and
destination IP addresses, protocol number and incoming/outgoing interfaces.

Every time a rule needs to be evaluated, these 5 dimensions are checked first.
(ip_packet_match())

The complexity of this is O(n), for n rules.

HIPAC
-----

In HIPAC, all rules are stored in a trie indexed by specifier. By walking down
such a trie given e.g. an IP address, all rules relevant to that IP address can
be found. Repeating this walk for every dimension and intersecting the results
(which are lists of rules), a single list is obtained that is relevant for the
packet to classify. All that remains to be done then, is go over those rules to
classify the packet.

The HIPAC authors claim that the complexity of the trie-lookup is O(log log N),
where N is the size of the search-space. For IPv4, (and log == log2), this would
be 5. The complexity of this way of filtering is not related to the amount of
rules stored in the trie, which makes it very fast for a large ruleset.

I don't understand the (apparently) complicated datastructure used for this in
HIPAC, or how it results in O(log log N) complexity, so I have formulated
another theory which should perform about the same.

HPPC (High Performance Packet Classification)
---------------------------------------------

Just like in HIPAC, I would like to refer to rules from a (radix) tree, indexed
by a specifier. Every level in this tree will split up the searchspace in 256
pieces, unless no nodes are stored below it. For IPv4 IP addresses, this means
an IP can be looked up by splitting it in 4 bytes, and using each of the bytes
as an index into an array at each level of the tree.

The complexity of this is O((log N) / 8), with N being 2^32, and is the fastest
and simplest way of looking up an IP address I can imagine without using alot of
memory.

Just like HIPAC, intersecting the lists of those lookups results in the final
list of rules to consider for that packet.

The same technique can be used to lookup port numbers (2 levels), mac-addresses
(6 levels), IPv6 addresses (16 levels) or pretty much anything else.



My questions:

Is anything like this already in the works ?
Would it be useful ?
Are there any technical reasons why this should not be implemented the way I'd
like to do it ?

kind regards,
-- Steven
