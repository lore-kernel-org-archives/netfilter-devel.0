From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/50]: Netfilter 2.6.23 update
Date: Sat, 07 Jul 2007 22:53:54 -0700 (PDT)
Message-ID: <20070707.225354.97294389.davem@davemloft.net>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat,  7 Jul 2007 14:23:00 +0200 (MEST)

> following is a large netfilter update for 2.6.23, featuring
> 
> - rework of the conntrack allocator by Yasuyuki. We're now using
>   dynamically sized extension areas for things like helper data,
>   expectations, NAT. This fixes a number of problems resulting
>   from the old allocator scheme, most importantly we don't need
>   to search the helper and expectation lists twice anymore.
> 
> - conversion of the conntrack and NAT hash tables to hlists
> 
> - patches to reduce the ability to mask tuples in expectations
>   and helpers, which allows to keep them in a hash table. This
>   fixes an easy DoS against conntrack and should also improve
>   performance.
> 
> - improvement of conntrack eviction under pressure
> 
> - new xt_TRACE target that allows to trace packets through the
>   netfilter hooks (unfortunately needs 1 bit in the skb)
> 
> - new xt_u32 match, which is the iptables equivalent to cls_u32
> 
> - some cleanup work by Jan Engelhardt to use bools where possible
> 
> - lots of minor cleanups: conversion from self-made debugging
>   macros to pr_debug, __read_mostly annotations, ...
> 
> Please apply, thanks.

Excellent work, all applied and pushed out.

Thanks!
