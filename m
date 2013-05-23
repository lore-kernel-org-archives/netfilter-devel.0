From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] netfilter: don't panic on error while walking through
 the init path
Date: Thu, 23 May 2013 16:50:48 +0800
Message-ID: <519DD868.1070809@cn.fujitsu.com>
References: <1369298557-5351-1-git-send-email-pablo@netfilter.org> <1369298557-5351-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab3EWItC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 04:49:02 -0400
In-Reply-To: <1369298557-5351-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/23/2013 04:42 PM, Pablo Neira Ayuso wrote:
> Don't panic if we hit an error while adding the nf_log or pernet
> netfilter support, just bail out.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

>  net/netfilter/core.c   |   19 ++++++++++++++-----
>  net/netfilter/nf_log.c |    5 +----
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 07c865a..3905104 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -304,15 +304,24 @@ static struct pernet_operations netfilter_net_ops = {
>  
>  void __init netfilter_init(void)
>  {
> -	int i, h;
> +	int i, h, ret;
> +
>  	for (i = 0; i < ARRAY_SIZE(nf_hooks); i++) {
>  		for (h = 0; h < NF_MAX_HOOKS; h++)
>  			INIT_LIST_HEAD(&nf_hooks[i][h]);
>  	}
>  
> -	if (register_pernet_subsys(&netfilter_net_ops) < 0)
> -		panic("cannot create netfilter proc entry");
> +	ret = register_pernet_subsys(&netfilter_net_ops);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = netfilter_log_init();
> +	if (ret < 0)
> +		goto err_pernet;
>  
> -	if (netfilter_log_init() < 0)
> -		panic("cannot initialize nf_log");
> +	return 0;
> +err_pernet:
> +	unregister_pernet_subsys(&netfilter_net_ops);
> +err:
> +	return ret;
>  }
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 388656d..bd5474a 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -368,10 +368,7 @@ static int __net_init nf_log_net_init(struct net *net)
>  	return 0;
>  
>  out_sysctl:
> -	/* For init_net: errors will trigger panic, don't unroll on error. */
> -	if (!net_eq(net, &init_net))
> -		remove_proc_entry("nf_log", net->nf.proc_netfilter);
> -
> +	remove_proc_entry("nf_log", net->nf.proc_netfilter);
>  	return ret;
>  }
>  
> 

