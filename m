From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RESEND v2 1/1] netfilter: xtables: add quota support to
 nfacct
Date: Mon, 27 Jan 2014 00:02:31 +0100
Message-ID: <20140126230231.GA29022@breakpoint.cc>
References: <1390766673-21444-1-git-send-email-mathieu.poirier@linaro.org>
 <1390766673-21444-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbaAZXCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:02:37 -0500
Content-Disposition: inline
In-Reply-To: <1390766673-21444-2-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> wrote:

[ removed netfilter@ from CC ]

> Adding packet and byte quota support.  Once a quota has been
> reached a noticifaction is sent to user space that includes
> the name of the accounting object along with the current byte
> and packet count.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
> index 3e19c8a..d38104f 100644
> --- a/include/uapi/linux/netfilter/xt_nfacct.h
> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
> @@ -3,11 +3,25 @@
>  
> +struct xt_nfacct_match_info_v1 {
> +	char		name[NFACCT_NAME_MAX];
> +	struct nf_acct	*nfacct;
> +
> +	__u32 flags;
> +	__aligned_u64 quota;
> +	struct nf_acct_quota	*priv;
> +};

I think that pointers should be aligned to 8-byte boundary, else
this can cause issues with 32-bit-userspace-on-64-bit-kernel.

It also should be flagged as "kernel only", e.g. via comment.

> index b3be0ef..ff66792 100644
> --- a/net/netfilter/xt_nfacct.c
> +++ b/net/netfilter/xt_nfacct.c
> @@ -8,10 +8,14 @@
>  #include <linux/netfilter/xt_nfacct.h>
> +#include <linux/netfilter_ipv4/ipt_ULOG.h>

ULOG is the ipv4-only predecessor of NFLOG target, why this include?

> +	nfacct = nfnl_acct_find_get(info->name);
> +	if (nfacct == NULL) {
> +		pr_info("xt_nfacct: invalid accounting object `%s'\n",
> +		       info->name);
> +		return -ENOENT;
> +	}
> +
> +	info->nfacct = nfacct;
> +
> +	if ((info->flags & XT_NFACCT_QUOTA) && !info->priv) {
> +		info->priv =  kmalloc(sizeof(struct nf_acct_quota), GFP_KERNEL);
> +		if (info->priv == NULL)
> +			return -ENOMEM;

I think this misses a _put of nfacct object.

Thanks for your patience.
