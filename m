From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_recent BUG() in kernel 3.2/3.4  & patch
Date: Tue, 11 Dec 2012 02:20:17 +0100
Message-ID: <20121211012017.GA15044@1984>
References: <50C4730D.2080401@guap.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Cc: netfilter-devel@vger.kernel.org
To: "Vitaly E. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32838 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2LKBUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:20:25 -0500
Content-Disposition: inline
In-Reply-To: <50C4730D.2080401@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 09, 2012 at 03:16:29PM +0400, Vitaly E. Lavrov wrote:
> Appears when stopping container without emptying tables (iptables
> -F/iptables -t mangle -F)
> 
> Problem: recent_mt_destroy called after __net_exit recent_net_exit() !
> 
> xt_hashlimit contains a BUG () and should be corrected similarly

I'll be really happy if we find a way to reverse the order of those
calls, so we don't need to hack xt_recent and xt_hashlimit.

Could you test this patch?

Thanks.

> Possible patch for xt_recent is below
> =============
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index d2ff15a..0fc5c32 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -75,6 +75,9 @@ struct recent_entry {
>  struct recent_table {
>         struct list_head        list;
>         char                    name[XT_RECENT_NAME_LEN];
> +#ifdef CONFIG_PROC_FS
> +       struct proc_dir_entry   *pe;
> +#endif
>         unsigned int            refcnt;
>         unsigned int            entries;
>         struct list_head        lru_list;
> @@ -375,6 +378,7 @@ static int recent_mt_check(const struct
> xt_mtchk_param *par)
>         }
>         pde->uid = ip_list_uid;
>         pde->gid = ip_list_gid;
> +       t->pe = pde;
>  #endif
>         spin_lock_bh(&recent_lock);
>         list_add_tail(&t->list, &recent_net->tables);
> @@ -398,7 +402,8 @@ static void recent_mt_destroy(const struct
> xt_mtdtor_param *par)
>                 list_del(&t->list);
>                 spin_unlock_bh(&recent_lock);
>  #ifdef CONFIG_PROC_FS
> -               remove_proc_entry(t->name, recent_net->xt_recent);
> +               if(t->pe)
> +                       remove_proc_entry(t->name, recent_net->xt_recent);
>  #endif
>                 recent_table_flush(t);
>                 kfree(t);
> @@ -607,7 +612,19 @@ static void __net_exit recent_net_exit(struct net *net)
>  {
>         struct recent_net *recent_net = recent_pernet(net);
> 
> -       BUG_ON(!list_empty(&recent_net->tables));
> +       if(!list_empty(&recent_net->tables)) {
> +#ifdef CONFIG_PROC_FS
> +               struct recent_table *t;
> +               spin_lock_bh(&recent_lock);
> +               list_for_each_entry(t, &recent_net->tables, list) {
> +                       t->pe = NULL;
> +                       remove_proc_entry(t->name, recent_net->xt_recent);
> +               }
> +               spin_unlock_bh(&recent_lock);
> +#endif
> +               printk(KERN_INFO "%s net %x: Warning! Tables not empty!\n",
> +                               __func__,(u32)net);
> +       }
>         recent_proc_net_exit(net);
>  }
> ==================
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 17c5e06..532ae92 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2266,5 +2266,5 @@ static void __exit ip_tables_fini(void)
 EXPORT_SYMBOL(ipt_register_table);
 EXPORT_SYMBOL(ipt_unregister_table);
 EXPORT_SYMBOL(ipt_do_table);
-module_init(ip_tables_init);
+core_initcall(ip_tables_init);
 module_exit(ip_tables_fini);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 125a90d..5dc3c7e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2275,5 +2275,5 @@ EXPORT_SYMBOL(ip6t_register_table);
 EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_do_table);
 
-module_init(ip6_tables_init);
+core_initcall(ip6_tables_init);
 module_exit(ip6_tables_fini);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8d987c3..afcea11 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1390,6 +1390,6 @@ static void __exit xt_fini(void)
 	kfree(xt);
 }
 
-module_init(xt_init);
+core_initcall(xt_init);
 module_exit(xt_fini);
 

--HcAYCG3uE/tztfnV--
