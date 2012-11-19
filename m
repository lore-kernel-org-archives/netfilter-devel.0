From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ipset: Increase the number of maximal sets
 automatically as needed
Date: Mon, 19 Nov 2012 09:29:11 -0800
Message-ID: <1353346151.10798.74.camel@edumazet-glaptop>
References: <alpine.DEB.2.00.1211191742240.22835@blackhole.kfki.hu>
	 <1353344480.10798.70.camel@edumazet-glaptop>
	 <alpine.DEB.2.00.1211191820430.23128@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38270 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2KSR3N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:29:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so598681pad.19
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Nov 2012 09:29:13 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1211191820430.23128@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2012-11-19 at 18:21 +0100, Jozsef Kadlecsik wrote:
> On Mon, 19 Nov 2012, Eric Dumazet wrote:
> > 
> > This rcu_dereference() is probably wrong, looking at the context.
> > (GFP_KERNEL allocations, or synchronize_net() a bit later.
> > 
> > LOCKDEP will probably issue a splat here.
> > 
> > Maybe you meant rtnl_dereference() instead, assuming RTNL is held here ?
> 
> Yes, that is so. Do you spot any other RCU-related issue in the patch?

Yes, please add __rcu qualifier in 

static struct ip_set __rcu **ip_set_list;  /* all individual sets */

You should try :

CONFIG_SPARSE_RCU_POINTER=y

make C=2 net/netfilter/ipset/ip_set_core.o

And spot all the places you access ip_set_list without proper rcu
annotation.

(some of them need the rcu_read_lock(), others need the
rtnl_dereference()



