Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D7F42AA9
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504671; cv=none; b=N9F81ojoCI1EnUvBtD83Vw01ZOLW8ebS8+d05DToTGDRJtHQ60MOpHbxSoQZYWbCqUxqocmRSv9aRGczG+mEz+graTWhBp/fDVddVHNTUU7Un3Q9+w1xpcySF1Wfz6DdsuyEYEcZ0XrYcSlCP6dnf50woMrywESF288NGnV83dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504671; c=relaxed/simple;
	bh=9Efgtpcc0zXwvXFYQrXIhw4ZC7q5CEasosP6k84vcW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYHNVShm43rhYPZOzRQJ9Emx/O/PNTyPyASUTrwXJSiIWA5xnKcL3/W/KHYJdfIM5ZAltpOza2gQ65W0mtp5SR8/+nEsxDBcixKLXs8PsjmSSUt5eHodu1C/XrNVPssCN5YJPv1HLwhdvp0vvC5xUQbsB8W0rHejp1jQIfrrz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WqwTwUHd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WqwTwUHd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791504665;
	bh=BChrV0L9WIkNkhgiIqxwCM87NZ9LIWdfbiSl9QnUlNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WqwTwUHdix0JjRIOGBnn1Zr+Qkgll80GmA7uQr5gRhf42clLIjlKysqx1+YsEGGIx
	 2JK5hMtFzjPJxEXrTbxmei1GIjnC3MKXxvQ14h3J5oflIL4wLuU7q8MdcjXfGj/6Iz
	 yOhdBvOKOq1OzH4xEXAc9IwiBKJO1GsNtX85aB0O5EnructtsoYv9qpEcDlRL3DlZv
	 ZH62kB6pY+XUNzgwY/DGWbe+uminky11v6gE43DoX49/0/O4NMmKjtw0w3TZkm4VL3
	 p/SPtIYLrZpis+oTitovKXCjOv9Iiu/3wGnG70DMgbbMAHIwF6+73X7fJMlRMQccun
	 od+qftWzWnH5g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7304660091;
	Fri,  9 Oct 2026 02:11:05 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:11:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, jengelh@medozas.de,
	vega@nebusec.ai, root@tr0jan.top
Subject: Re: [PATCH nf v6 1/1] netfilter: nf_dup: reject TEE and
 IPv4/IPv6/netdev nft dup in userns
Message-ID: <asgxFmPajqm8ze-N@chamomile>
References: <cover.1791429178.git.zihanx@nebusec.ai>
 <82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai>

On Thu, Oct 08, 2026 at 07:08:16AM +0000, Zihan Xi wrote:
> The packet-duplication frontends can permit repeated packet duplication and
> resource consumption when configured in a network namespace owned by a
> non-initial user namespace. Users with CAP_NET_ADMIN in that namespace can
> configure the affected rules.
> 
> No use case for TEE or nft dup in such namespaces has been identified.
> Reject TEE and IPv4/IPv6/netdev nft dup rule or expression setup with
> -EPERM there, without adding checks to packet-processing fast paths.
> 
> This is a namespace policy restriction, not a general fix for asynchronous
> duplication behavior. Rules remain installable in init_user_ns-owned
> network namespaces, and their existing packet-processing behavior is
> unchanged.

This patch does not refer to NFQUEUE anymore, which allows to trigger
the OOM sequence that is described. I think it is relevant to
understand why this is being proposed to be disable in userns.

I read Florian proposed this approach, but I have to admit I get a bit
nervous when it comes to restricting features in this way
(sledgehammer!).

Why saving current->in_nf_duplicate in the struct nf_queue_entry is
not an option? So restoring current->in_nf_duplicate on packet
reinjection can be done? Are there concerns about this can be abused
in more way via async/escape paths similar to NFQUEUE?

Thanks.

> Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
> Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to the netdev family")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Co-developed-by: Luxing Yin <root@tr0jan.top>
> Signed-off-by: Luxing Yin <root@tr0jan.top>
> Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
> ---
> changes in v6:
>   - reroll the unchanged four-file setup-time restriction on nf.git main at
>     ab699d296e06
>   - do not present v5 build or runtime results as v6 validation
>   - v5 Link:
>     https://lore.kernel.org/all/20260929125832.25316-1-zihanx@nebusec.ai/
> changes in v5:
>   - describe the patch as a non-initial-userns setup restriction, not a
>     general recursion fix; state that init_user_ns behavior is unchanged
>   - remove path-specific trigger details and run-specific metrics from the
>     public commit and cover prose
>   - drop d877f07112f1 from Fixes: because it added a later frontend, not the
>     shared duplication behavior addressed by this restriction
>   - record the v5 build and setup-time validation, distinguishing them from
>     earlier unpatched-baseline and root-OOM runs
>   - v4 Link:
>     https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
> changes in v4:
>   - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup
>     frontends
>   - clarify that fcd53c51d037 only added a synchronous guard
>   - clarify that this restricts non-initial user namespaces and does not
>     fix asynchronous recursion in init_user_ns-owned network namespaces
>   - state explicitly that the netdev loop was not runtime-reproduced
>   - v3 Link:
>     https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
> changes in v3:
>   - reroll the fix against the latest nf.git main after no follow-up on v2
>   - add the Co-developed-by trailer and matching Signed-off-by
>   - v2 Link:
>     https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
> changes in v2:
>   - drop the persistent struct sk_buff::nf_duplicated field and nf_copy()
>     change from v1
>   - disable IPv4/IPv6 duplication in non-initial user namespaces
>   - v1 Link:
>     https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/
> ---
>  net/ipv4/netfilter/nft_dup_ipv4.c | 4 ++++
>  net/ipv6/netfilter/nft_dup_ipv6.c | 4 ++++
>  net/netfilter/nft_dup_netdev.c    | 4 ++++
>  net/netfilter/xt_TEE.c            | 4 ++++
>  4 files changed, 16 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
> index d53a65ddbd7b..db62e30456e4 100644
> --- a/net/ipv4/netfilter/nft_dup_ipv4.c
> +++ b/net/ipv4/netfilter/nft_dup_ipv4.c
> @@ -7,6 +7,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/netlink.h>
> +#include <linux/user_namespace.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables.h>
> @@ -37,6 +38,9 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
>  	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
>  	int err;
>  
> +	if (ctx->net->user_ns != &init_user_ns)
> +		return -EPERM;
> +
>  	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
>  		return -EINVAL;
>  
> diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
> index 95ec27b3971c..6219ef57633e 100644
> --- a/net/ipv6/netfilter/nft_dup_ipv6.c
> +++ b/net/ipv6/netfilter/nft_dup_ipv6.c
> @@ -7,6 +7,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/netlink.h>
> +#include <linux/user_namespace.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables.h>
> @@ -35,6 +36,9 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
>  	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
>  	int err;
>  
> +	if (ctx->net->user_ns != &init_user_ns)
> +		return -EPERM;
> +
>  	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
>  		return -EINVAL;
>  
> diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
> index 06866799e946..8d9dfd18475c 100644
> --- a/net/netfilter/nft_dup_netdev.c
> +++ b/net/netfilter/nft_dup_netdev.c
> @@ -7,6 +7,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/netlink.h>
> +#include <linux/user_namespace.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables.h>
> @@ -37,6 +38,9 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
>  {
>  	struct nft_dup_netdev *priv = nft_expr_priv(expr);
>  
> +	if (ctx->net->user_ns != &init_user_ns)
> +		return -EPERM;
> +
>  	if (tb[NFTA_DUP_SREG_DEV] == NULL)
>  		return -EINVAL;
>  
> diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
> index 5d34ceb893ed..51c643987526 100644
> --- a/net/netfilter/xt_TEE.c
> +++ b/net/netfilter/xt_TEE.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
>  #include <linux/route.h>
> +#include <linux/user_namespace.h>
>  #include <linux/netfilter/x_tables.h>
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
> @@ -95,6 +96,9 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
>  	struct xt_tee_tginfo *info = par->targinfo;
>  	struct xt_tee_priv *priv;
>  
> +	if (par->net->user_ns != &init_user_ns)
> +		return -EPERM;
> +
>  	/* 0.0.0.0 and :: not allowed */
>  	if (memcmp(&info->gw, &tee_zero_address,
>  		   sizeof(tee_zero_address)) == 0)
> -- 
> 2.43.0
> 
