From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] IP sets
Date: Thu, 19 Feb 2004 23:34:18 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402192309030.5143-100000@filer.marasystems.com>
References: <20040219203113.GI4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040219203113.GI4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Feb 2004, Harald Welte wrote:

> Yes, we could still use a big conntrack lock for the whole tree.  But
> for the current hash table, the direction is heading towards per bucket
> locks.  
> 
> What do you want to do in the tree case? 

For the primitive operations the locking requirements are similar to
per-bucket hash locks, but the rebalancing operation is very tricky wrt
locking. I do not really have the tree experience to dive too deaply into
these complications but I would guess that for a environment like the
conntrack frequent lookups, semifrequent modifications (add/delete) and
low lateny requirements something like the following should work out 
acceptable:

a) A compressed lookup tree with internal and leaf nodes, using a
relatively high fanout and prefix comresed keys in internal nodes

b) A kernel thread for rebalancing and other low-prio maintenance 
operations. Rebalancing builds new internal nodes of the rebalanced part 
of the tree and then atomically replaces that part of the tree.

c) Overflow chains for registering additions/deletes while a rebalance 
operation is rebalancing the relevant parts of the tree, to make sure the 
changes is included in the rebalanced tree before replace. The operation 
is also carried directly in the active tree but limited to the primitive 
add/delete operations with no rebalancing keeping locking etc at a 
trivial level.

> Does somebody know any papers discussing performance comparison between
> hashtables and various different trees in a multithreaded environment?

I am not that much into academics, but my gut feeling is that there should
be quite much written in that area. Trees have a very broad field of
applications.

Regards
Henrik
