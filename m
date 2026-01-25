Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5A1A704B
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Jan 2026 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769358347; cv=none; b=QlI387N0nMNhxlmk1l8xysm4gPbVoiuH48iHjfOyivnZHsPen5d/HrMsrRCz8tIhPyIgmLsXC5QLpCbeTawa4RVZlxTMg33g43CeGblk+ixqN47LmxbEQx9NGXNipq71aB4VYncaTkTl/wBwOtP6rnR02zwrfR560SRROxZGNDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769358347; c=relaxed/simple;
	bh=QVtSTX/XLp16X/oXKfhKEuxOzQqk8ZSe4U/GC/FHDBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1nLoieXZAEBiz/za0eL0Ig3V4GhoOOgTVT5TmR4+3SMbvA7KW9LUih0Hvp1iENbhOyDORm5XyyS1PUNFQON7/XquqEN5D3sE/PPDxXN6/4gYhQ5WO0WamNSzsULBercniHFZzaMqA04WWhccEucyajvrGCjYwjbnKZP3cxlb5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqIiRvkH; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqIiRvkH"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so6703963a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jan 2026 08:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769358344; x=1769963144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3v57Iy+bDz50Wo3pEiRxYhkqRNwfCJZJ1CeX2JqnHG4=;
        b=OqIiRvkHIpky35Lm795JQYFph/tL3/iuFylaZYybbVRwn+8215c9wtABw9xo6gVQ4/
         5e0GLgehdPAAFygx6Ex6BKeaF6kA0pIbLKhh/FKKwhWdeH9725z69K3yEk5Ck5Lcto4w
         S5V1iJ97a3ui8njQfItB51mZZFocwwJKEBLufKZOCDori1d7AevkyiAV3RjHPh7qncZw
         MGo9mdstytYyLSdg76MigFFOJfYVnPARNxxfkKHVS4V2V+QFJ6F9ruHd62u7NJEsErl9
         UHka3u5ZwO+ww9ABrz6M5WG/FavLEVT4S3Ebd9mSC2MpsptY/b57HZprJqWhsMaSkOj9
         mp6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769358344; x=1769963144;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3v57Iy+bDz50Wo3pEiRxYhkqRNwfCJZJ1CeX2JqnHG4=;
        b=QCPqW05f77c+8Iy5Heakml87iwjWRtIEPD8ROM0MPrIgw5DYmcI/NGyu4lk5Z9Rv2Z
         uVVtinK7ouV3292bTXW9xURa/uc/Zi15hWtLatAhLtHkCuKXMDTiFgfVKXa2L1f3VzsR
         CoB2zNAj+ouDqxM6H7ozE3CsGrRNF1Ek9ZOKJzC5d7hHRlltTfS6hri7SmSx8q1LVPuN
         Ar3KAawaehVnAduNBAwI4zPzLo3CSyXq8Ls+VghVvD0Mtaw4MvlwCy+H/CItbHPzaDOa
         YnqU5vwyPdl/sAZc9/9LKdq49a9DvpmOYxwEZjTfhau5TtePmd0udpZx1jcUZj1pwrc/
         coKQ==
X-Gm-Message-State: AOJu0YxGDEwNgeZZz9IEUmMtDvi/Y9OjR61+VMwz+f16dZdmTAKgiU+4
	0CvydrTmajuDcNvINjQV53bUZ4OyYLX3n262ZsgXWLqmfiFCl0+0HSMP
X-Gm-Gg: AZuq6aIvML2zpKglq0dsxgyOnNBYAu/IswudssZ8RyB/IpMx7Z1Zz+0jVL4xgbjTyq+
	IH3sYcccsfnj5qAljZGYD1t+YxJPQ+Bzx+9PDBabvhiipKj1dTtenNYZ4JVSD6K3LopUiDWBXpR
	1q2CqT8AD7/U1pZbuXiXti4CWPaqeoY51q0ExlQ7m85y7uKpBW+bXyUlrXSTQ4sMUxMj3Zuu/Qs
	iFWgU7g4BvCJt1hAQpocQ7/ZrS6oRnGJALUru+3dqm4N5o4QmSCWs4BU+LajId+BuB02+oTn/7f
	ji5/TqNDih3GYwZeN6+sbAy9F4nk/M0Uk4DCojF6ZOA98/Ogq+EgIPy0GVNyNuxAXUfYj6ouUvG
	E+sd1ZwOH2VBfJ83ojKoR4eyQo1N/UxadGW/jbWHLZa0SrBlh0pkU36tz5GtdwWhlvm2qX0O+rN
	lcg712QwPueG/Jc7YSkuRrzYapGNPuFXOgMtuKotgTcP6/JLpTvwHJzZRrFr8DKrQKr404Fflaa
	dh4QSPkQvE41IqsaqlTm+groqNhrB/xisuggnVePyUUxSuHmQbZxcIx8hVBybd7qg==
X-Received: by 2002:a05:6402:f23:b0:658:7a1:fbe7 with SMTP id 4fb4d7f45d1cf-658706ecd1amr811921a12.23.1769358343678;
        Sun, 25 Jan 2026 08:25:43 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6584b3e07cbsm3860622a12.1.2026.01.25.08.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 08:25:43 -0800 (PST)
Message-ID: <e9c7fa63-6c9b-48c2-97c9-2d73e1029f20@gmail.com>
Date: Sun, 25 Jan 2026 17:25:41 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 nf-next 4/4] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 bridge@lists.linux.dev
References: <20251109192427.617142-1-ericwouds@gmail.com>
 <20251109192427.617142-5-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20251109192427.617142-5-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/9/25 8:24 PM, Eric Woudstra wrote:
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
> index d4d5eadaba9c..082b10e9e853 100644
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
> +		} *ph;
> +
> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN)) {
> +			*proto = 0;
> +			return -1;
> +		}
> +		ph = (struct ppp_hdr *)(skb->data);
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
> +		struct vlan_hdr *vhdr;
> +
> +		if (!pskb_may_pull(skb, VLAN_HLEN)) {
> +			*proto = 0;
> +			return -1;
> +		}
> +		vhdr = (struct vlan_hdr *)(skb->data);
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

I've also tried asking on the cover letter 0/4, but no response.

Can I ask what is the status of this patchset? Quite some time has
passed by now...

