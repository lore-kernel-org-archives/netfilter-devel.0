From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 10/10] netfilter: remove useless variable
 proc_net_netfilter
Date: Fri, 5 Apr 2013 20:45:11 +0200
Message-ID: <20130405184511.GC10039@localhost>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1364205048-32632-10-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53962 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162464Ab3DESp0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:45:26 -0400
Content-Disposition: inline
In-Reply-To: <1364205048-32632-10-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 05:50:48PM +0800, Gao feng wrote:
> After we add net namespace support for nflog and nfqueue,
> the var proc_net_netfilter has no use,just remove it.

Applied a different patch based on yours.

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  include/linux/netfilter.h | 1 -
>  net/netfilter/core.c      | 7 -------
>  2 files changed, 8 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index ee14284..b9d401c 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -291,7 +291,6 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
>  
>  #ifdef CONFIG_PROC_FS
>  #include <linux/proc_fs.h>

Removed also these two lines above.

> -extern struct proc_dir_entry *proc_net_netfilter;
>  #endif
>  
>  #else /* !CONFIG_NETFILTER */
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index e054799..3117ce8 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -276,11 +276,6 @@ void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
>  EXPORT_SYMBOL(nf_nat_decode_session_hook);
>  #endif
>  
> -#ifdef CONFIG_PROC_FS
> -struct proc_dir_entry *proc_net_netfilter;
> -EXPORT_SYMBOL(proc_net_netfilter);
> -#endif
> -
>  static int __net_init netfilter_net_init(struct net *net)
>  {
>  #ifdef CONFIG_PROC_FS
> @@ -290,8 +285,6 @@ static int __net_init netfilter_net_init(struct net *net)
>  	if (net_eq(net, &init_net)) {
>  		if (!net->nf.proc_netfilter)
>  			panic("cannot create netfilter proc entry");
> -		else
> -			proc_net_netfilter = net->nf.proc_netfilter;
>  	} else if (!net->nf.proc_netfilter) {
>  		pr_err("cannot create netfilter proc entry");
>  		return -ENOMEM;

Refactors this code to handle error path like:

       if (!net->nf.proc_netfilter) {
               if (!net_eq(net, &init_net))
                       pr_err("cannot create netfilter proc entry");

                return -ENOMEM;
       }

So this spots an error only if netns fails. This still panics for the
init_net case.
