From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack
Date: Tue, 02 Mar 2004 11:26:41 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403020227.LAA16842@toshiba.co.jp>
References: <20040224092137.GU13386@sunbeam.de.gnumonks.org>
	<200402251247.VAA25777@toshiba.co.jp>
	<20040225150554.GC13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
        kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20040225150554.GC13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Wed, 25 Feb 2004 16:05:54 +0100

> > 1 chunk includes static part of nf_conntrack and 2 tuples.
> > But memory spaces for helper, nat are statically allocated.
> > Because I wanted to see the impact of dynamic allocating memory space
> > for tuple, at first.
> 
> I think this is fine.  The 'extension structures' would be a further
> optimization that are totally unrelated to ipv4/ipv6 generalization and
> don't really fit this discussion then.

I see.

> > BTW, unfortunately, I can't spend time for this work this 2 months.
> 
> No problem, we're all busy with other stuff anyway.  But I think we
> should finish the mising parts (I've read some FIXME's with regard to
> helpers, are they still valid?) at about the time that 2.7.x forks off. 
> 
> Could you write a small TODO list containing the Items that will yet

ok.
	1. change to allocate nf_conntrack with various size depended
	   on features.
	2. implement the code handling fragmented packets
	3. support for various helper. At least, helpers in current main
	   kernel.
	4. apply fixes and changes for latest ip_conntrack.
	5. wrapper for current ip_conntrack and ip_nat, if I have any time.
	   (or is it more efficient to change all nat and helper modules ?)

> btw: I will put your current patch into patch-o-matic-ng. This means it
> will probably get some more users.

Thank you. Please notice that I'll implement 1 in TODO list based on
"static size of nf_conntrack" version. So I'll change many codes.

> > I think processing speed is more important for connection tracking than
> > saving memory space. But you got a point that unused memory space should
> > not be allocated.
> 
> The issue is mostly about wasting cache lines.  Memory is cheap, but
> cache is very limited... ip_conntrack is currently 304 bytes of size.
> If we could somehow get this down to 256 bytes, we would save a whole 
> cache line per connection, that's quite a lot.

Oh, sorry about missunderstading. I got it.

> it's actually not that difficult.  When we allocate a conntrack, we
> already know the tuple.  And from the tuple, we already know if there is
> a conntrack helper.  So let's just assume if iptable_nat is loaded and
> we have a conntrack helper responsible for this tuple, we will later
> need the nat helper union.  There are few protocols that only have a nat
> helper but no conntrack helper.  In that case one would have to either
> re-allocate, or force them to have a dummy conntrack helper.

I agree.

> >    On the other hand, there is no problem about "nat union" (= ip_nat_info).
> >    Because if nat module is loaded, all conntrack certainly have
> >    "null-binding" or "binding" which specified by user. So conntrack
> >    core module always need to allocate memory space for "nat union" in
> >    this case.
> 
> Yes, but what happens in cases where you alrady have entries in the
> conntrack table at the time of loading iptable_nat ?  Then the old
> conntracks don't have the nat union, ... - but I think these are minor
> issues that could be resolved.

I imagine that bit flags is checked and conntrack is reallocated if needed.
The cost is small because reallocating is needed only once per conntrack
processed by nat helper.

In the case that nat module is unloaded, cache isn't destroyed until
all nat enabled conntrack is free.

Thank you for your help and suggestions.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
