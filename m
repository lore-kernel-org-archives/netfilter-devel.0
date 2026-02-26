Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C73876AD;
	Thu, 26 Feb 2026 03:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077286; cv=none; b=X2nCyZVwKwGkKvMHw/Lk9YvT0GOPBOR35KGCz7R4ow8tBF91zLCmSLFiDrVyGxAc/3wmCjABh23xRimT8f6NjFt77ZezHUMxifqB6Wn+Fj8wOEqZvE2O7iBRz45Oj9r0C6fgbJ77I+H3sKi+X0Jk1f+Z9c1VhkOE8OTCY5aLTt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077286; c=relaxed/simple;
	bh=mohWYbY9wLh1D3mgX6qgP294pIHbEtzES+tjlmn1e7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF5+uS62D4sR3kYZFaJM1X/71vAXbx1ltPioWx+/tsYnnMF3DFyRV4rTqLVzLRg56cIYAYGkc3RCmTqTyM1ADhBJBwE3FaLzwBukMXKbACfjtULOUZaJRXGP2e8Ox4Ki7RvuCNfryrXP0/SrzbqjYA/cd/jwocQuQHpc5arTWqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1xtqEgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1xtqEgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43A6C19424;
	Thu, 26 Feb 2026 03:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772077286;
	bh=mohWYbY9wLh1D3mgX6qgP294pIHbEtzES+tjlmn1e7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1xtqEgg0a0z1Enu4uADTeCj6h8GfpVfjrE3dVcEPYapfJoIz9+zkukXCUJBi+mq6
	 oBW8/8zZiL+epqNnXtlrU1VjHoIGz9pQi2aXqIqajp+2G6duzud/sJNByel5HyZ/HW
	 bV5GmmU4u7VT8yEo8h2xqipZ2cSVRAgwvTh7Irh81ODeMDFHoMA4fvhZroiVUiAPdu
	 m11BTnJyFWxaA584Cqakp3KlDo3NMaz5CEwRPCdfa4AJuZ6V+fmYVxtLrOM2a1q2Ea
	 zqgnPUFrL4WdRzllh75zxKuMSamNKPmd4hRzFYQzUhTL+1/K/tB2c2+S+aZ1TzptVd
	 tx74aFMYS1L8Q==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [net-next,4/9] ipvs: do not keep dest_dst after dest is removed
Date: Wed, 25 Feb 2026 19:41:24 -0800
Message-ID: <20260226034124.1806970-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224205048.4718-5-fw@strlen.de>
References: <20260224205048.4718-5-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "FYI"

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
ipvs: do not keep dest_dst after dest is removed

Before now dest->dest_dst is not released when server is moved into
dest_trash list after removal. As result, we can keep dst/dev
references for long time without actively using them. It is better to
avoid walking the dest_trash list when ip_vs_dst_event() receives dev
events. So, make sure we do not hold dev references in dest_trash
list. As packets can be flying while server is being removed, check
the IP_VS_DEST_F_AVAILABLE flag in slow path to ensure we do not save
new dev references to removed servers.

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 2ef1f99dada6..7c0e2d9b5b98 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 4389bfe3050d..394b5b5f2ccd 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -336,9 +336,11 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  				goto err_unreach;
>  			}
>  			/* It is forbidden to attach dest->dest_dst if
> -			 * device is going down.
> +			 * device is going down or if server is removed and
> +			 * stored in dest_trash.
>  			 */
> -			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
> +			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
> +			    dest->flags & IP_VS_DEST_F_AVAILABLE)
>  				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);

Should this be wrapped in parentheses?

In C operator precedence, the logical AND (&&) binds more tightly than
the bitwise AND (&). The expression here parses as:

    (!rt_dev_is_down(...) && dest->flags) & IP_VS_DEST_F_AVAILABLE

This works correctly only because IP_VS_DEST_F_AVAILABLE is 0x0001, and
the logical AND produces 0 or 1, so the bitwise AND with 0x0001 still
produces the expected result.

Every other check of IP_VS_DEST_F_AVAILABLE in the IPVS codebase wraps
the bitwise operation in parentheses. For example:

net/netfilter/ipvs/ip_vs_core.c:ip_vs_out():
    if (likely(dest && (dest->flags & IP_VS_DEST_F_AVAILABLE))) {
        ...
    }

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_conn_fill_param_sync():
    if (unlikely(dest && !(dest->flags & IP_VS_DEST_F_AVAILABLE))) {
        ...
    }

Would it be clearer to write this as:

    if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
        (dest->flags & IP_VS_DEST_F_AVAILABLE))

>  			else
>  				noref = 0;

[ ... ]

> @@ -513,9 +515,11 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
>  			rt = dst_rt6_info(dst);
>  			cookie = rt6_get_cookie(rt);
>  			/* It is forbidden to attach dest->dest_dst if
> -			 * device is going down.
> +			 * device is going down or if server is removed and
> +			 * stored in dest_trash.
>  			 */
> -			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
> +			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
> +			    dest->flags & IP_VS_DEST_F_AVAILABLE)
>  				__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);

Same question here in __ip_vs_get_out_rt_v6().
