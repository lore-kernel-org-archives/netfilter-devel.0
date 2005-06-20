From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 20 Jun 2005 11:07:33 +0200
Message-ID: <42B68755.8020805@tac.ch>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42B67BEC.1090105@tac.ch>
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

> and Pablo's debug code (which I believe is not triggered yet):
> 
> --- linux-2.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-15
> 23:16:43.000000000 +0200
> +++ linux-2.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-17
> 20:44:18.000000000 +0200
> @@ -1391,6 +1391,8 @@
>  		schedule();
>  		goto i_see_dead_people;
>  	}
> +	while (atomic_read(&ip_conntrack_untracked.ct_general.use) != 1)
> +		schedule();
> 
>  	kmem_cache_destroy(ip_conntrack_cachep);
>  	vfree(ip_conntrack_hash);

This results in an endless loop when calling rmmod ip_conntrack. lsmod shows
(deleted) but the process is in D state. No oops of course and now hang.

> Trace; c02b9f51 <nf_hook_slow+141/1c4>

(gdb) list *nf_hook_slow+141
0xc02ba0bd is in nf_hook_slow (netfilter.c:492).
487                             skb_checksum_help(*pskb);
488                     }
489             }
490
491             /* We may already have this, but read-locks nest anyway */
492             br_read_lock_bh(BR_NETPROTO_LOCK);
493
494     #ifdef CONFIG_NETFILTER_DEBUG
495             if (unlikely((*pskb)->nf_debug & (1 << hook))) {
496                     printk("nf_hook: hook %i already set.\n", hook);

... hmmm, weird.

> If you have other ideas, let me know. I could also need some help regarding
> debugging the stack trace. It doesn't make much sense to me right now. To
> reproduce I roughly use following procedure (not always successful):
> 
> 1. load a lot of modules (I don't know them by heart but certainly all
>    ip_conntrack* related ones)

These were the loaded modules before the oops:

# lsmod
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_tables              12352  10  [ipt_NOTRACK ipt_state ipt_LOG ipt_limit
iptable_raw iptable_mangle iptable_filter iptable_nat]
ip_conntrack_ftp        3904   1
ip_conntrack           28832   1  [ipt_NOTRACK ipt_state ip_nat_ftp
iptable_natip_conntrack_ftp]

-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
