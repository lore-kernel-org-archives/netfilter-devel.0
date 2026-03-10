Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5580640B6E9
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773131827; cv=none; b=Nc5cuJO5U94IOS+Fjtk+qlPMfB66Fn+zWyAQ6UhllhJmtxME0vcIipAJ5cJO/Ua7B0ABlbXeMkYX1K5wQwS8BVhRrwUIjkHqWriQw/bm4en2XSRZ1A/kWBKlTsfNfW03eKa0WfAzCqTWNgEoXvhegrbTWDiVT/CinU9OTIUt32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773131827; c=relaxed/simple;
	bh=SkOW0Me5Mei+6+811W8wfI40/OJEsEajTjQbZP2i/9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QFzCKr+YxkHDSWStreFISpmtJtnQm9zuyM31EfsT3mtu3QlFjFfwViL7mCRNIOXvK5hVrxh/Zzw4EWQVNhz6kl5/WeJdI2bocWwp/xmhgHYazmHfCjo6lEUWTJWFuFgxHdhk0LSLgo/ISBh1GcModaYeU/MtNUzGRSBD7j6+acg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0Y3DZZx; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0Y3DZZx"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-662b933f8d1so1564488a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 01:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773131824; x=1773736624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nmp2C2LK1KcB7kS8d+inf4YkPeQ+OioLOT0ROrHIx4Q=;
        b=j0Y3DZZxqWzBx0w0jrGAC3EzKuM0bm64IyMhsaadSYJRSy9gMDrRpUrtORyP7h/yiT
         WdNGTx9e6eAoyHsiLMifexwfVePSkN8amSjtZHsZaUTLZsCbpeBpZipYTx+Wn7E27Bex
         NOFTjlEH+cu3YDMkMfQizQkTJJ0fHuDwcGPMB608+GjpJcyGh3Qe9wFxuDhwoOgLM0Pd
         yCbC7fOecB2xPGK5H+yeAEIl8PqvX6gslzonNhR5qWxwhBGY7Fk3npb2zKe95yaxx+jh
         HTXrKS5pyvAFXWe/7aGPOdz2H3PsMLmC/mpyx+pTdofMl21VsKZSnlP+fkGl1X+0h3zl
         4HGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773131824; x=1773736624;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nmp2C2LK1KcB7kS8d+inf4YkPeQ+OioLOT0ROrHIx4Q=;
        b=O2VUGSm7tcDAhdRx86UcbmWDT2uSE8Dq1xyJbsqYoJw1fOqJokPcdY79fmThftmYBi
         RsOJ1Pk03G4k7TIQZN43hawTPYH9jA28jnuB1v0QPr54vn3uSjSg2YPYf28S5csjfyfE
         xcbhK1BxmwcuLADivxb686IUzO9donpixj9mJYwNYz9zpfimVDm3xZRvg2pVu6/ez/X9
         QwkhqZeZU2xI6otBHLYad7f5iLUIvhB2gJxHh3trMvWrQLhkqVUyk9CJW1oqFr63xGU8
         OsGZ36qI25d9QP6RpqmyUAo7Fi0ADgBuD5aWmCKCnu37RCDuGLo5ICnUqbmeScbZjPBj
         2Cng==
X-Forwarded-Encrypted: i=1; AJvYcCW8PLUftK9IVam9SSkSZKfwL9zOwBsWhsRsWjOZZ4S4g+6GcRwnvgzwj+IaapS+BeflrhLBaDj6xoa8EImPRUI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr+COPkHJ3+6stzrdK6nLzBbq+ovKRdGb2i+wwJcw8I+x54EXS
	YIq2jcnIdPvLYtATWIwAIdJwZLKbt+y69RH8Bn9E7nMsDpZzqmTK9A9W
X-Gm-Gg: ATEYQzwSGsIyKXR96kOMvVda6SoaNHRtlzjpcTikRFA9W9JLAC8hPYWYjbRk+OLdO4j
	9zzBDerufNm8vcb0SieqIQ1kI3HrNHSbSJLK6YtVI+x/sogBVMfE0tkuVD6hC0fOKpYNFuwH6Kc
	0GeMQWqr9B4B20igOfYlvVS9Ye/n0CBBkY/kuhk5qbjr+vYdzwxn9EY35rmQ9gMm78mnGwr9HKQ
	hfgdY7+ch2kObhtefGWFttOwRrCLsigkDyIvJ7rINqb+J8JFbMD+VkHm4qdnkwbFSXvJg/sqz2j
	AWN6dvWRf/fwCOaD9zsL8iWzO9u07dwtnQ+WlIj0zbXaSTXEaw76EDkPIgTWXV3ZAXch8hj6MM0
	85J+2TCFec3GD5uzhYFNCIPvlRyBoVcvCZU7dgISb/RpVFEOT2BVe0s5ijM9uaOvhF1Ex1gU2ju
	yMs5eTLBvaNB3KrQEmJHrIjkYvGZvmPA4rg4w+CrolIExg2UWWjbw19Dc6lkyTfOrjjyET7WezK
	ms/j7802p6Wi5Fea/XjONX72If+I/4RMeqr3EajhBr7elUFeAbUhWQ5RhiyGU9abGcQmhBdvAOt
	mQ6CSribAoxconXnezH4paYPpng+9THD1A==
X-Received: by 2002:a05:6402:13cb:b0:660:ce49:f6d1 with SMTP id 4fb4d7f45d1cf-6619d53ce70mr7697726a12.30.1773131823379;
        Tue, 10 Mar 2026 01:37:03 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a3e61eb6sm4096796a12.8.2026.03.10.01.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 01:37:02 -0700 (PDT)
Message-ID: <76b3546a-37c5-4dab-9074-4df0cbe48524@gmail.com>
Date: Tue, 10 Mar 2026 09:37:00 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 nf-next 5/5] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
 Simon Horman <horms@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Phil Sutter <phil@nwl.cc>, Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>
References: <20260224065307.120768-1-ericwouds@gmail.com>
 <20260224065307.120768-6-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20260224065307.120768-6-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/24/26 7:53 AM, Eric Woudstra wrote:
> In nft_do_chain_bridge() pktinfo is only fully populated for plain packets
> and packets encapsulated in single 802.1q or 802.1ad.
> 
> When implementing the software bridge-fastpath and testing all possible
> encapulations, there can be more encapsulations:
> 
> The packet could (also) be encapsulated in PPPoE, or the packet could be
> encapsulated in an inner 802.1q, combined with an outer 802.1ad or 802.1q
> encapsulation.
> 
> nft_flow_offload_eval() also examines the L4 header, with the L4 protocol
> known from the conntrack-tuplehash. To access the header it uses
> nft_thoff(), but for these packets it returns zero.
> 
> Introduce nft_set_bridge_pktinfo() to help populate pktinfo with the
> offsets.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_chain_filter.c | 55 +++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index d4d5eadaba9c..66ef30c60e56 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -227,21 +227,68 @@ static inline void nft_chain_filter_inet_fini(void) {}
>  #endif /* CONFIG_NF_TABLES_IPV6 */
>  
>  #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
> +static int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt, struct sk_buff *skb,
> +				  const struct nf_hook_state *state,
> +				  __be16 *proto)
> +{
> +	nft_set_pktinfo(pkt, skb, state);
> +
> +	switch (*proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph, _ph;
> +
> +		ph = skb_header_pointer(skb, 0, sizeof(_ph), &_ph);
> +		if (!ph) {
> +			*proto = 0;
> +			return -1;
> +		}
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			*proto = htons(ETH_P_IP);
> +			return PPPOE_SES_HLEN;
> +		case htons(PPP_IPV6):
> +			*proto = htons(ETH_P_IPV6);
> +			return PPPOE_SES_HLEN;
> +		}
> +		break;
> +	}
> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr, _vhdr;
> +
> +		vhdr = skb_header_pointer(skb, 0, sizeof(_vhdr), &_vhdr);
> +		if (!vhdr) {
> +			*proto = 0;
> +			return -1;
> +		}
> +		*proto = vhdr->h_vlan_encapsulated_proto;
> +		return VLAN_HLEN;
> +	}
> +	}
> +	return 0;
> +}
> +
>  static unsigned int
>  nft_do_chain_bridge(void *priv,
>  		    struct sk_buff *skb,
>  		    const struct nf_hook_state *state)
>  {
>  	struct nft_pktinfo pkt;
> +	__be16 proto;
> +	int offset;
>  
> -	nft_set_pktinfo(&pkt, skb, state);
> +	proto = eth_hdr(skb)->h_proto;
> +
> +	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
>  
> -	switch (eth_hdr(skb)->h_proto) {
> +	switch (proto) {
>  	case htons(ETH_P_IP):
> -		nft_set_pktinfo_ipv4_validate(&pkt, 0);
> +		nft_set_pktinfo_ipv4_validate(&pkt, offset);
>  		break;
>  	case htons(ETH_P_IPV6):
> -		nft_set_pktinfo_ipv6_validate(&pkt, 0);
> +		nft_set_pktinfo_ipv6_validate(&pkt, offset);
>  		break;
>  	default:
>  		nft_set_pktinfo_unspec(&pkt);

Just in case, I'm sending a kind and small reminder, before it is too
late in the cycle.

Regards,

Eric

