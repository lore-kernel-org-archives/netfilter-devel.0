From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack
Date: Fri, 14 Jan 2005 13:31:12 +0900 (JST)
Message-ID: <200501140431.j0E4VD1S006210@toshiba.co.jp>
References: <41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, pablo@eurodev.net, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <41E73258.7030002@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 14 Jan 2005 03:45:44 +0100

> Harald Welte wrote:
> 
> >the nf_conntrack approach of having multiple slab caches of differently
> >sized conntrack structures is better from a performance point of view.
> >
> >If you look at the typical applications, people will usually
> >
> >a) either use NAT on most/all of their connections
> >b) or not use NAT on any of their connections
> >
> >Now why don't they (the 'b' users) recompile their kernel? Because they
> >use vendor-kernels, and they compile with everything enabled.
> >
> >So what we end up if we use rusty's scheme for nat private data, is that
> >we have at least one additional allocation, and two disjunct seperate
> >pieces of memory (which will probably also introduce yet another cache
> >miss).   This is acceptable for rare exceptional cases, not for 99.9% of
> >your connections.
> >
> >So even if Rusty's architecture and API is cleaner, I'm very much in
> >favour of the nf_conntrack design and Yasuyuki's current
> >implementation.
> >  
> >
> But unlike ct_extend, the get_features stuff is very unflexible. The
> way it is currently implemented it only works for a single dynamically
> allocated part without leaving holes, and it even it if could handle more,
> they all need to be determined at allocation time, so a worst-case 
> assumption
> has to be made for anything depending on the ruleset. This is especially
> a concern with modules and distribution-kernels, NAT could be loaded at any
> time, so the memory needs to be allocated in advance.

ct_extend is definitely flexible. But at the same time, I agree to use
multiple slab caches if we can improve performance.

I haven't deeply read ct_extend codes, but can we combine it and cache scheme ?

For example, allocate conntrack from cache at first. We can roughly find out
its size by checking l3 protocol, loaded modules, finding helpers which want
to inspect packet, and so on. And if it is not enough, we can allocate more
piecies.

Anyway, I think we have many chance to optimize it later.

So why don't we port ct_extend to nf_conntrack and then optimize it with slab
cache ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
