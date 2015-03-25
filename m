From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: x_tables: fix cgroup's
 NF_INET_LOCAL_IN sk lookups
Date: Wed, 25 Mar 2015 17:03:00 +0100
Message-ID: <20150325160300.GA3722@salvia>
References: <cover.1427209409.git.daniel@iogearbox.net>
 <20fdc704558880831cbbaa8bba5e4855591cd4ba.1427209409.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41315 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbbCYP7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 11:59:11 -0400
Content-Disposition: inline
In-Reply-To: <20fdc704558880831cbbaa8bba5e4855591cd4ba.1427209409.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 24, 2015 at 04:30:29PM +0100, Daniel Borkmann wrote:
> diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
> index 7198d66..cd2468d 100644
> --- a/net/netfilter/xt_cgroup.c
> +++ b/net/netfilter/xt_cgroup.c
> @@ -16,8 +16,11 @@
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
> @@ -34,38 +37,85 @@ static int cgroup_mt_check(const struct xt_mtchk_param *par)
>  	return 0;
>  }
>  
> -static bool
> -cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +static bool cgroup_mt(const struct sk_buff *skb,
> +		      const struct xt_action_param *par,
> +		      struct sock *(*cgroup_mt_slow)(const struct sk_buff *skb,
> +						     const struct net_device *indev))
>  {
>  	const struct xt_cgroup_info *info = par->matchinfo;
> +	struct sock *sk = skb->sk;
> +	u32 sk_classid;
> +
> +	if (sk) {
> +		sk_classid = sk->sk_classid;
> +	} else {
> +		if (par->in != NULL)
> +			sk = cgroup_mt_slow(skb, par->in);

Is this working with timewait sock?

> +		if (sk == NULL)
> +			return false;
> +
> +		sk_classid = sk->sk_classid;
> +		sock_gen_put(sk);
> +	}
> +
> +	return (info->id == sk_classid) ^ info->invert;
> +}
