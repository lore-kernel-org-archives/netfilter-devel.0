Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637251FE45D;
	Wed, 25 Feb 2026 01:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984376; cv=none; b=fWFp7zZSfCrV9CTZBOqHZ1/OLpfWQOCOFohcxTc7JEaBekIrHmbIViAeWbNnL/HDy+Nd6ksC8h2d+Bt/Z2Lw49KayrfklKWMkNKEoWOKNIobGkVJWchYFL9855VklCyc7z2dIH4eTWCwQiLsN8IAAwMUJgFbPnV/C05qVdc6ru4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984376; c=relaxed/simple;
	bh=IACWKJ8NQgW46rPKrUtEAAc4l8/vFQANiaDAzWwriC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh7roptEoIeGFWjHMSFpxcfqneYTSY/XQDRn1/NjLHPfMNSFqsck+HIjNw0nV4erPWM62Oek6+hMaVKDdwVagzaCvJoftgP7GvQexuZkjoztEek8ToZOJ5koJEFLApJeqzI6LxNDqYmcAcpKw6kivSF1RKWkK5lR1TaO5KrJVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sE3eh2qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sE3eh2qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B853C116D0;
	Wed, 25 Feb 2026 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771984376;
	bh=IACWKJ8NQgW46rPKrUtEAAc4l8/vFQANiaDAzWwriC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE3eh2qGh/nnkQbTd+X72/iZvN1yzhv17OkQvM9ecrDumsaxfENW+5sXy7MW4tAVK
	 dJtat05Gv2CzX3Z0Jb1GVCO6yNL+bFFzyNm0RauW4PWiqz4klO6JMpAmLO0RbPTyZ+
	 edWOCDIU2FQq2lJ5CmXgid2KZHYWv8aN0L1onXMHTIiV0Sb7SFnZ8b7lXa5w1P+n4r
	 RVfQVaGOuZuveg7BWfRFK9L23iBl2mYGHJ7LediLTor5f5fljd/sOeALtg2xlIlkpX
	 Pm/+4ELgc1+snHSStbq7EJ2M+/fhCotamHYoXFakUFScdRdKHFn6ss11drPgSMKpeR
	 NMV9vF76Mmhxg==
From: Jakub Kicinski <kuba@kernel.org>
To: ericwouds@gmail.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	mostrows@earthlink.net,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	kees@kernel.org,
	edumazet@google.com,
	razor@blackwall.org,
	horms@kernel.org,
	fw@strlen.de,
	pablo@netfilter.org,
	andrew+netdev@lunn.ch,
	idosch@nvidia.com,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	bridge@lists.linux.dev,
	phil@nwl.cc
Subject: Re: [v19,nf-next,3/5] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 24 Feb 2026 17:52:35 -0800
Message-ID: <20260225015235.967500-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-4-ericwouds@gmail.com>
References: <20260224065307.120768-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "The tracking of feedback in the AI bot is often wrong,
but FWIW this is what it has to say about the submission"

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
netfilter: bridge: Add conntrack double vlan and pppoe

This patch adds connection tracking capabilities for PPPoE encapsulated
packets and for inner 802.1q combined with outer 802.1ad or 802.1q
encapsulation in bridge netfilter.

> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 58a33d0380b0..49e01083278c 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -16,6 +16,7 @@
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <net/netfilter/nf_conntrack_bridge.h>
>
> +#include <linux/ppp_defs.h>
>  #include <linux/netfilter_ipv4.h>
>
>  #include "../br_private.h"
> @@ -236,58 +237,116 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
>  	return 0;
>  }
>
> +static int nf_ct_bridge_pre_inner(struct sk_buff *skb, __be16 *proto, u32 *len)
> +{
> +	switch (*proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;
> +
> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
> +			return -1;
> +		ph = (struct ppp_hdr *)(skb->data);
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			*proto = htons(ETH_P_IP);
> +			*len = ntohs(ph->hdr.length) - 2;
> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
> +			return PPPOE_SES_HLEN;
> +		case htons(PPP_IPV6):
> +			*proto = htons(ETH_P_IPV6);
> +			*len = ntohs(ph->hdr.length) - 2;
> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
> +			return PPPOE_SES_HLEN;
> +		}
> +		break;
> +	}

Is there validation on the PPPoE length field before using it? Florian
Westphal raised this concern during v14 review:

https://lore.kernel.org/netfilter-devel/aG2VDyHfVsp5L2zR@strlen.de/

The code reads ph->hdr.length and uses it directly to compute *len without
checking if the value is reasonable. While pskb_may_pull and pskb_trim_rcsum
provide bounds checking later in the code path, garbage or malicious
ph->hdr.length values could cause issues before those checks occur.

Should there be explicit validation of the PPPoE length field here to ensure
it's within acceptable bounds?

[ ... ]

> @@ -236,58 +237,116 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
>
[ ... ]

>  static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  				     const struct nf_hook_state *state)
>  {
>  	struct nf_hook_state bridge_state = *state;
> +	int ret = NF_ACCEPT, offset = 0;
>  	enum ip_conntrack_info ctinfo;
> +	u32 len, pppoe_len = 0;
>  	struct nf_conn *ct;
> -	u32 len;
> -	int ret;
> +	__be16 proto;
>
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if ((ct && !nf_ct_is_template(ct)) ||
>  	    ctinfo == IP_CT_UNTRACKED)
>  		return NF_ACCEPT;
>
> -	switch (skb->protocol) {
> -	case htons(ETH_P_IP):
> -		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> +	proto = skb->protocol;
> +
> +	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
> +			NF_CT_DEFAULT_ZONE_ID) {
> +		offset = nf_ct_bridge_pre_inner(skb, &proto, &pppoe_len);
> +		if (offset < 0)
>  			return NF_ACCEPT;
> +	}
> +
> +	switch (proto) {
> +	case htons(ETH_P_IP):
> +		if (!pskb_may_pull(skb, offset + sizeof(struct iphdr)))
> +			goto do_not_track;
>
>  		len = skb_ip_totlen(skb);
> -		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +		if (pppoe_len && pppoe_len != len)
> +			goto do_not_track;
> +		if (pskb_trim_rcsum(skb, offset + len))
> +			goto do_not_track;
>
>  		if (nf_ct_br_ip_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		bridge_state.pf = NFPROTO_IPV4;
>  		ret = nf_ct_br_defrag4(skb, &bridge_state);
>  		break;
>  	case htons(ETH_P_IPV6):
> -		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> -			return NF_ACCEPT;
> +		if (!pskb_may_pull(skb, offset + sizeof(struct ipv6hdr)))
> +			goto do_not_track;
>
>  		len = sizeof(struct ipv6hdr) + skb_ipv6_payload_len(skb);
> -		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +		if (pppoe_len && pppoe_len != len)
> +			goto do_not_track;
> +		if (pskb_trim_rcsum(skb, offset + len))
> +			goto do_not_track;
>
>  		if (nf_ct_br_ipv6_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>
>  		bridge_state.pf = NFPROTO_IPV6;
>  		ret = nf_ct_br_defrag6(skb, &bridge_state);
>  		break;
>  	default:
>  		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> -		return NF_ACCEPT;
> +		goto do_not_track;
>  	}
>
> -	if (ret != NF_ACCEPT)
> -		return ret;
> +	if (ret == NF_ACCEPT)
> +		ret = nf_conntrack_in(skb, &bridge_state);
> +
> +do_not_track:
> +	if (offset && ret == NF_ACCEPT)
> +		skb_reset_network_header(skb);
>
> -	return nf_conntrack_in(skb, &bridge_state);
> +	return ret;
>  }

This patch introduces PPPoE and inner VLAN encapsulated packet processing,
but skb->protocol is never modified. When a PPPoE or VLAN-encapsulated
fragmented IP packet is reassembled by ip_defrag via nf_ct_br_defrag4 (or
nf_ct_br_defrag6 for IPv6), the br_skb_cb_restore call sets
BR_INPUT_SKB_CB(skb)->frag_max_size to a non-zero value.

Later in the packet path, nf_ct_bridge_post calls nf_ct_bridge_refrag:

net/bridge/netfilter/nf_conntrack_bridge.c:nf_ct_bridge_refrag() {
    ...
    if (BR_INPUT_SKB_CB(skb)->frag_max_size) {
        switch (skb->protocol) {
        case htons(ETH_P_IP):
            nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
            break;
        case htons(ETH_P_IPV6):
            nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
            break;
        default:
            WARN_ON_ONCE(1);
            return NF_DROP;
        }
    }
}

Since skb->protocol is still ETH_P_PPP_SES or ETH_P_8021Q (not ETH_P_IP or
ETH_P_IPV6), nf_ct_bridge_refrag hits the default case for reassembled
packets. This triggers WARN_ON_ONCE(1) and returns NF_DROP, dropping the
packet and emitting a kernel warning.

Should skb->protocol be updated to reflect the inner protocol, or should
nf_ct_bridge_refrag be extended to handle these encapsulation types?
-- 
pw-bot: awaiting-upstream
