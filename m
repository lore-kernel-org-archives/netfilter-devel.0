Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8A2298CA5;
	Mon, 20 Apr 2026 11:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776684972; cv=none; b=AnGvlG9LlKXMpM1JMxjC7ISuv4V1ebRNSXl1WM44iI18ge2YwFA0osql70OPWt/SEIvmsx79dN2VW0po2GE8rlxUg2+HZfZlrY3YoABCw2k3MC7xSTzJb4KaZ/ACBwDSfBGFwD2fCrmTcLWpsJ2v4GxEZPYx5zjGIwdNSxjMiLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776684972; c=relaxed/simple;
	bh=HGpoCHM50rdfgpFlGuZ3vT4pQo6a/gxkLdwuP4MT6rE=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=hrL4lnuEkwG3JY6zIeHsDqaoaC4HFK7NsFx7KhDGNjysmeXMbWEHVLgeMIYdbl9lCI4EsLtu/S0zdQv0eNKh0Je+OOw3sBNu/nKonqxyDc7AfqgT515h1wykCpJBo5UoTOBjypU6kseuIuDq63bgPfe7Iq2Ssjk1l0vmmMEsC0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uem6msaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uem6msaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDC3C19425;
	Mon, 20 Apr 2026 11:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776684972;
	bh=HGpoCHM50rdfgpFlGuZ3vT4pQo6a/gxkLdwuP4MT6rE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=uem6msaOVXuc+4VK5IUxlhY6ptFIr2JR/P5SmK2b+uAv0ZyaYY9U5y3C+e6NwFFuQ
	 9KuNUdJ08eFbCsP7M8umrFw6VYXL/SSlh5z+ceJuvJW3JLldkXnU0CmqEpPMUC5EkU
	 sInQCCfXqiVbZyWg9vEcv7sAgfZ3W+7dLjDEbe9/EQeBCkZObY6rhuU5Vadd0e/EcK
	 U50IZp2tw2oGvZr1tHi4J0hlEPoWDMpL8p3ovRWX/ChnnuthDR5pKDufGNrT5S51kd
	 M0l/+wUxiODh5ea99Yl8j7E1qQjad7B18+yRMy8xFklFjVngz8/JlAQVFrvJzj65Lz
	 ircMEUv4ovwUg==
Content-Type: multipart/mixed; boundary="===============0537590972006115725=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c0aa7f264055f44ac4c93aa4718473e89ed13b8bb11de3179ed40d2f88a99257@mail.kernel.org>
In-Reply-To: <20260420105816.72168-2-mahe.tardy@gmail.com>
References: <20260420105816.72168-2-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v4 1/6] net: move netfilter nf_reject_fill_skb_dst to core ipv4
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,mahe.tardy@gmail.com
Cc: alexei.starovoitov@gmail.com,andrii@kernel.org,ast@kernel.org,bpf@vger.kernel.org,coreteam@netfilter.org,daniel@iogearbox.net,fw@strlen.de,john.fastabend@gmail.com,lkp@intel.com,martin.lau@linux.dev,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,oe-kbuild-all@lists.linux.dev,pablo@netfilter.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 20 Apr 2026 11:36:12 +0000 (UTC)

--===============0537590972006115725==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/net/route.h b/include/net/route.h
> index f90106f383c5..ec2466fd0bec 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
>  				    const struct sock *sk);
>  struct dst_entry *ipv4_blackhole_route(struct net *net,
>  				       struct dst_entry *dst_orig);
> +int ip_route_reply_fetch_dst(struct sk_buff *skb);
>
>  static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
>  {

[ ... ]

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index bc1296f0ea69..7091ef936073 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
>  }
>  EXPORT_SYMBOL_GPL(ip_route_output_flow);
>
> +int ip_route_reply_fetch_dst(struct sk_buff *skb)
> +{
> +	struct rtable *rt;
> +	struct flowi4 fl4 = {
> +		.daddr = ip_hdr(skb)->saddr
> +	};
> +
> +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +	skb_dst_set(skb, &rt->dst);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_route_reply_fetch_dst);

Is ip_route_reply_fetch_dst() actually needed before calling icmp_send()?

Martin KaFai Lau raised this question in v3 of the patch series and
noted that icmpv6_send() does its own route lookup and doesn't use
skb_dst() of the original skb. He also pointed out that at
cgroup/egress, skb->_skb_refdst should already be set.

Looking at icmpv6_send(), the fl6.{daddr,saddr} are filled and passed
to icmpv6_route_lookup, which performs the reverse/invert route lookup.
The function doesn't appear to use skb_dst() of the original skb.

Since this patch moves ip_route_reply_fetch_dst() from netfilter to
core specifically for the BPF kfunc, can you clarify why this routing
step is necessary? Does the kfunc not work without
ip[6]_route_reply_fetch_dst()?

Reference: https://lore.kernel.org/bpf/df4b0996-3e88-4ea4-983b-82866455a6fc@linux.dev/


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/24663313503
--===============0537590972006115725==--
