Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273894;
	b=xyV3eRSuHvG+WMHpRq5Zwuq2berKpCJ6m2gaTYcdAcrQndlfhfWNqi4rc3veWO3O67Hn
	 3srhdi9JJmRCjnp/ise7eUTIdZgOOqoN9LKQa5PT+Pb/aWbW+tyaXBD22+wToA0eyTF8U
	 j64Q/mK20hJTyEkQJE95N+kTAorIgZSqymAQs0kMnODGKlPalyluh2YjghmM1T/Tl7fuB
	 doEtnPWdAk1N4nM1s93HxWwpRlXX8aLKnyuDrQVyrWcia4m2Z3ZlDFW7BMOSugFjrb9nI
	 EeRwQQIXqvkaywh5UsTaNSwaIX9MFws8miku2GEJdPaSPhDrUULBvgi016AQTmd61Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273894;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=cabK4srU/G66Ei8Wu76IfA6Yj6V4c/V/svODtFbiw4E=;
	b=ZiOFSTCOGqkHvqHiRTmArxQDQNGGDriCCwK7t/9sKCcE2J0jK7WlFLi6iZ8w506JDTJX
	 Jmh2We5jjVQ0BEDrgZo85BEe1a3zVt8JXuS5ODVt37am9UHXzskAWPLVPzeBQX1YwGeA0
	 SkTaYoLaQ8marVpYeqSgamRHseeiikDQumny9qQHTe9pcDm/iC6nAmpTFKQBU6VCIbI53
	 sqFOGBgFzc8m4jcM4euHKVFyO3bJ5q+BX2LiuHIrXKNhnodtAdCACxfVu0RHSshT35tMN
	 zr6JP7yweKs7Nb9WBMDgcwlPWqJQy/HZNidxljHrH3YKpua874TTogV4afQjmPFyb/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Fv3G7Lam;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B74D8606A31A;
	Thu, 29 Oct 2026 11:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B74D8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Fv3G7Lam
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793273891;
	bh=cabK4srU/G66Ei8Wu76IfA6Yj6V4c/V/svODtFbiw4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fv3G7Lam7o3OKJHPSDWdNyHvoNQeVpwMhyXaEdBYSlshEJjbWPkM9YfYJ3XZK3DmL
	 Io2dhZcdeKhBSBG8tIeLRAEhfSZW2kHPNVtEiOWo5fhvMFVXMGcmwzfahfs3zh6Ybe
	 27d7Kada/Vxs0eSyYXjX7LUM2quGpdSjNhCZkpxslgIIzKPPccPKjDkdAVaZy+Gizj
	 5oFTdEEKuoeVMQ+0wyTCl+3rBMITcqRqeqse/XVT2JRgpP9RabqrIpm+6hHbztNEe+
	 2hgNDwQTt7kQyUfnxDO78DL9457Uma50AwIfPpKM0ionPyBEmTZfEhs+Foh3jtcVa8
	 SI3VH0AUuaXug==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3679D60077;
	Thu, 29 Oct 2026 12:38:11 +0100 (CET)
Date: Thu, 29 Oct 2026 12:38:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Koral Ilgun <koralilgun@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Koral Ilgun <koral.ilgun@adtran.com>
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: do not offload multicast
Message-ID: <auMwIMerV-LQ-aNL@chamomile>
References: <20261028205938.662312-1-koralilgun@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261028205938.662312-1-koralilgun@gmail.com>

On Wed, Oct 28, 2026 at 01:59:38PM -0700, Koral Ilgun wrote:
> From: Koral Ilgun <koral.ilgun@adtran.com>
> 
> A flow holds one output per direction, which it resolves when it is
> added. The outputs of a multicast route change when listeners join
> or leave. So a multicast flow in the flowtable continues to send to
> the output that it resolved, also after the last listener left, and
> the counters of the multicast routing stop.
> 
> IPv4 multicast stays out of the flowtable only because the reverse
> route lookup in nft_flow_route() refuses a multicast source address.
> The IPv6 route lookup has no such check, so IPv6 multicast that
> ip6mr forwards goes into the flowtable.
> 
> Skip a multicast destination for both families, so that the result
> no longer depends on the route lookup.

Please, target nf-next for this patch.

I agree this is convenient, but you can still restrict to unicast
traffic via ruleset, so I don't think this qualify as a fix.

> Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
> Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
> ---
> Tested on an arm64 router with Linux 6.18.54, with an inet flowtable
> that offloads forwarded flows, and IPv4 and IPv6 multicast routed from
> the WAN to one VLAN. Without this change, the IPv6 flow went into the
> flowtable after its first packets: the ip6mr vif counters showed 25 of
> 1,500 packets, and the receiver still got all 400 packets after its
> leave. With it, the vif counters showed 1,500 of 1,500, the flow stayed
> out of the flowtable, and the stream stopped about 2.5 s after the
> leave. IPv4 multicast stayed out of the flowtable before and after.
> Unicast IPv4 and IPv6 flows still went into the flowtable.
> 
>  net/netfilter/nft_flow_offload.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index d3c5651dd699..1fc755e594b0 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -10,6 +10,7 @@
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/ip.h>
> +#include <net/ipv6.h>
>  #include <net/flow.h>
>  #include <net/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables_core.h>
> @@ -35,6 +36,16 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
>  			return true;
>  	}
>  
> +	/* A flow keeps the output it resolved at offload time, but the
> +	 * outputs of a multicast route change when listeners join or leave.
> +	 */
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +		return ipv4_is_multicast(ip_hdr(skb)->daddr);
> +	case NFPROTO_IPV6:
> +		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
> +	}
> +
>  	return false;
>  }
>  
> 
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> -- 
> 2.43.0
> 
