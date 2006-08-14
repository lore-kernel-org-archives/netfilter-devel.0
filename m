From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: [PATCH] priv_data 0/2
Date: Mon, 14 Aug 2006 16:17:51 +0200
Message-ID: <20060814141751.GR7194@kriss.csbnet.se>
References: <200606261641.47294.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
Content-Disposition: inline
In-Reply-To: <200606261641.47294.max@nucleus.it>
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

2006-06-26 16:41:46+0200, Massimiliano Hofer <max@nucleus.it> ->
> Hi,
> this is a version of my priv_data patch that updates targets and renames 
> functions as suggested by Patrick.
> 
> Since xt_init_match() and xt_init_target() (formerly xt_check_match() and 
> xt_check_target()) no longer just check and they needed some argument changes 
> anyway, I included some more common code previously replicated in 
> ip_tables.c, ip6_tables.c and arp_tables.c.
> Similarly I introduced xt_destroy_match() and xt_destroy_taget().
> 
> The resulting patches are larger than I anticipated, but most of the space is 
> taken by function ranames and argument adjustments.
> 
> My previous example with xt_condition still applies (just rename checkentry to 
> init in struct xt_match).
> 
> I tested several combination with iptables, ip6tables and arptables. It can't 
> make it fail, but I didn't try it with a real world network load. Right now I 
> don't have a 64 bit machine available for testing (I should be able to use 
> one in a few days), so I didn't test compat at all.
> 
> Testing and comments, as always, are appreciated.
> 
> -- 
> Saluti,
>    Massimiliano Hofer

I'm currently porting some of my modules to use this API with priv_data.
However, I ran into some troubles. For example i'm writing a revision 1 for
the quota module which allows the count to go negative, and in the same time
I'm porting it to use this API (as it's using the same stupid thing as -m
limit with q->master = q;). However, having the quota counter in the
priv_data struct makes it impossible to report the counter to userspace when
the user issues iptables -L.

"Hidden", kernel data only is good with priv_data, but sometimes it will be
too hidden.

Do we have any good solution for this?

--
Joakim Axelsson
