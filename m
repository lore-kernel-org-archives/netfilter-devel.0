From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's
 NF_INET_LOCAL_IN sk lookups
Date: Fri, 27 Mar 2015 01:14:08 +0100
Message-ID: <20150327001408.GD3545@salvia>
References: <cover.1427394874.git.daniel@iogearbox.net>
 <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbbC0AKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 20:10:10 -0400
Content-Disposition: inline
In-Reply-To: <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 08:14:48PM +0100, Daniel Borkmann wrote:
[...]
> However, that as-is only partially works, i.e. it works for the case
> of established TCP and connected UDP sockets when early demux is
> enabled, but not for various other ingress scenarios: i) early demux
> disabled (sysctl), ii) udp on unconnected sockets, iii) tcp and udp
> (any kind) on localhost communications.

This extension has been around since Dec 2013, I'd rather see a new
revision that includes an option --lookup-sock.

More comments below.

>  net/netfilter/Kconfig     |  5 +++
>  net/netfilter/xt_cgroup.c | 92 +++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 79 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 971cd75..044bd22 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -960,8 +960,13 @@ config NETFILTER_XT_MATCH_BPF
>  
>  config NETFILTER_XT_MATCH_CGROUP
>  	tristate '"control group" match support'
> +	depends on NETFILTER_XTABLES

why this? I think NETFILTER_ADVANCED is sufficient.

>  	depends on NETFILTER_ADVANCED
> +	depends on !NF_CONNTRACK || NF_CONNTRACK

why conntrack?

> +	depends on (IPV6 || IPV6=n)

Do we depend on any ipv6 symbol?

>  	depends on CGROUPS
> +	select NF_DEFRAG_IPV4
> +	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES

No need for defrag either.

Please, revisit the Kconfig trickery.

>  	select CGROUP_NET_CLASSID
>  	---help---
>  	Socket/process control group matching allows you to match locally
> diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
> index 7198d66..17f5a98 100644
> --- a/net/netfilter/xt_cgroup.c
> +++ b/net/netfilter/xt_cgroup.c
> @@ -16,14 +16,20 @@
>  #include <linux/module.h>
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/xt_cgroup.h>
> +
>  #include <net/sock.h>
>  
> +#include "xt_sk_helper.h"
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Daniel Borkmann <dborkman@redhat.com>");
>  MODULE_DESCRIPTION("Xtables: process control group matching");
>  MODULE_ALIAS("ipt_cgroup");
>  MODULE_ALIAS("ip6t_cgroup");
>  
> +typedef struct sock *(*cgroup_lookup_t)(const struct sk_buff *skb,
> +				        const struct net_device *indev);
> +
>  static int cgroup_mt_check(const struct xt_mtchk_param *par)
>  {
>  	struct xt_cgroup_info *info = par->matchinfo;
> @@ -34,38 +40,88 @@ static int cgroup_mt_check(const struct xt_mtchk_param *par)
>  	return 0;
>  }
>  
> -static bool
> -cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +static bool cgroup_mt(const struct sk_buff *skb,
> +		      const struct xt_action_param *par,
> +		      cgroup_lookup_t cgroup_mt_slow)
>  {
>  	const struct xt_cgroup_info *info = par->matchinfo;
> +	struct sock *sk = skb->sk;
> +	u32 sk_classid;
>  
> -	if (skb->sk == NULL)
> -		return false;
> +	if (sk) {
> +		sk_classid = sk->sk_classid;
> +	} else {
> +		if (par->in != NULL)
> +			sk = cgroup_mt_slow(skb, par->in);
> +		if (sk == NULL)
> +			return false;
> +		if (!sk_fullsock(sk)) {
> +			sock_gen_put(sk);
> +			return false;
> +		}
> +
> +		sk_classid = sk->sk_classid;
> +		sock_gen_put(sk);
> +	}
> +
> +	return (info->id == sk_classid) ^ info->invert;
> +}
>  
> -	return (info->id == skb->sk->sk_classid) ^ info->invert;
> +static bool
> +cgroup_mt_v4(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +	return cgroup_mt(skb, par, xt_sk_lookup);
> +}
> +
> +#ifdef XT_HAVE_IPV6

Please, kill this custom XT_HAVE_IPV6 and now use IS_ENABLED(NF_SOCK_IPV6)

> +static bool
> +cgroup_mt_v6(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +	return cgroup_mt(skb, par, xt_sk_lookup6);
>  }
> +#endif
>  
> -static struct xt_match cgroup_mt_reg __read_mostly = {
> -	.name       = "cgroup",
> -	.revision   = 0,
> -	.family     = NFPROTO_UNSPEC,
> -	.checkentry = cgroup_mt_check,
> -	.match      = cgroup_mt,
> -	.matchsize  = sizeof(struct xt_cgroup_info),
> -	.me         = THIS_MODULE,
> -	.hooks      = (1 << NF_INET_LOCAL_OUT) |
> -		      (1 << NF_INET_POST_ROUTING) |
> -		      (1 << NF_INET_LOCAL_IN),
> +static struct xt_match cgroup_mt_reg[] __read_mostly = {
> +	{
> +		.name       = "cgroup",
> +		.revision   = 0,
> +		.family     = NFPROTO_IPV4,
> +		.checkentry = cgroup_mt_check,
> +		.match      = cgroup_mt_v4,
> +		.matchsize  = sizeof(struct xt_cgroup_info),
> +		.me         = THIS_MODULE,
> +		.hooks      = (1 << NF_INET_LOCAL_OUT) |
> +			      (1 << NF_INET_POST_ROUTING) |
> +			      (1 << NF_INET_LOCAL_IN),
> +	},
> +#ifdef XT_HAVE_IPV6
> +	{
> +		.name       = "cgroup",
> +		.revision   = 0,
> +		.family     = NFPROTO_IPV6,
> +		.checkentry = cgroup_mt_check,
> +		.match      = cgroup_mt_v6,
> +		.matchsize  = sizeof(struct xt_cgroup_info),
> +		.me         = THIS_MODULE,
> +		.hooks      = (1 << NF_INET_LOCAL_OUT) |
> +			      (1 << NF_INET_POST_ROUTING) |
> +			      (1 << NF_INET_LOCAL_IN),
> +	}
> +#endif
>  };
>  
>  static int __init cgroup_mt_init(void)
>  {
> -	return xt_register_match(&cgroup_mt_reg);
> +	nf_defrag_ipv4_enable();

Why did you add this?

> +#ifdef XT_HAVE_IPV6
> +	nf_defrag_ipv6_enable();
> +#endif
> +	return xt_register_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
>  }
>  
>  static void __exit cgroup_mt_exit(void)
>  {
> -	xt_unregister_match(&cgroup_mt_reg);
> +	xt_unregister_matches(cgroup_mt_reg, ARRAY_SIZE(cgroup_mt_reg));
>  }
>  
>  module_init(cgroup_mt_init);
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
