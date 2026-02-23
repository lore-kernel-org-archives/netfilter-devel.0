Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B86630C606;
	Mon, 23 Feb 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862483; cv=none; b=So9Zn2qJIiqv3OogA3VOIdUkbTUYd5YmDRJpA4BsV9Z/TECRIWC8zoK5U9r8/3bWjOviCccju+uW5qIntLMcZ1Z/JopizaL9W1myBYmixKyCjpPKSUncw3msQk3A0zKHSOivIxx4Tpkj3G9nQ7iuMsX1J5XZ1xvd42Zb2az+iUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862483; c=relaxed/simple;
	bh=wu2jEMSeASBK/6J7P4JboN7dhpfcXah/GbCIlIXFqt8=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhXQDVoQehtjf21EaQD7KyoSa+xXzXtNYXEB92cjQ6oqQMY+hHedYvTxCDS2mdr3T0mKVUNBMHp4KCXxX0g7mGgUai4d4uppF9y5G899ioAfqF/WXnbD8cPQXWoTFEQaBKeG+hFTVnGY3BNoLTdmydLBPNuD52Ty239Er1hhdTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 507286033B; Mon, 23 Feb 2026 17:01:15 +0100 (CET)
Date: Mon, 23 Feb 2026 17:01:15 +0100
From: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v18 nf-next 4/4] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aZx5y6c6gIzELiHq@strlen.de>
References: <20260222195845.77880-1-ericwouds@gmail.com>
 <20260222195845.77880-5-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222195845.77880-5-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:

This an AI-generated review, with no edits.
I added my own 2 cents at the end.

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

[ ... ]

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

The commit message states support for "inner 802.1q, combined with an
outer 802.1ad or 802.1q encapsulation", but the code only handles
ETH_P_8021Q (0x8100). Should there be a case for ETH_P_8021AD (0x88A8)?

When a packet has an 802.1ad outer VLAN tag, proto will be ETH_P_8021AD
but won't match any case in the switch statement. The function returns 0
with proto unchanged, then nft_do_chain_bridge() calls
nft_set_pktinfo_unspec(), setting thoff to 0.

Other netfilter code handles both protocols, for example:

net/netfilter/nf_flow_table_ip.c:
    switch (tuple->encap[i].proto) {
    case htons(ETH_P_8021Q):
    case htons(ETH_P_8021AD):
        if (skb_vlan_push(...))

For double VLAN scenarios like outer 802.1q + inner 802.1q, the function
strips the outer tag and sets proto to ETH_P_8021Q (from the inner VLAN).
When nft_do_chain_bridge() switches on this proto value, it doesn't match
ETH_P_IP or ETH_P_IPV6, so it falls through to the default case and calls
nft_set_pktinfo_unspec().

This means for a packet with two 802.1q tags followed by IPv4, the offset
returned is 4 (one VLAN header), but nft_set_pktinfo_unspec() is called
and thoff becomes 0 instead of 8.

Should nft_set_bridge_pktinfo() handle nested encapsulations recursively,
or should nft_do_chain_bridge() check if the updated proto is still a
VLAN type and call nft_set_bridge_pktinfo() again?

[ fw: I oppose auto-following nested headers an would prefer to add
  any vlan-vlan-vlan-vlan-vlan-pppoe or whatever incrementally after
  someone explains why thats sane.

Wrt. the rest, I suspect the LLM gets confused due to vlan offloading,
the code is fine if vlan offloading is on, we have outer vlan tag in
the skb and eth_hdr(skb)->h_proto will be ETH_P_8021Q.

Neverthelss: should this support configurations where vlan tag offload
is off?  If it should, then ETH_P_8021AD / ETH_P_8021Q combo has to be
handled.  That could be done in a followup change, of course.

So, *I* don't see a need to send another iteration of the patch.

Eric, whats your take?  Supersede?  Ignore LLM?  Follwup patch?
