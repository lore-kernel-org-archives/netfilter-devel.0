Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883EB13AA31;
	Thu,  6 Jun 2024 09:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665988; cv=none; b=Kqz93KnyuaVgPp/QNzE9XLojnBS1t4UwkSgRo+1MhD3FW7q5Oi9bLvoDb9WgdLgmPhlfg8E2vCLHYgGtPZo7B/08ZKxxFi2+QqV32YP0oKXRYvvojBZLsqryxFoT2vD/In+HXeJ5fuhO+eWoL/+mL+llbZEzZ5Bbvk9jsXphe3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665988; c=relaxed/simple;
	bh=5XpcrG+TOKYFI4ePBqmfAJ/d5uRfaHB11848HdHFc9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aS1SmE6S/kh3B5VPT3CcVCvAWNLeYJ0/JsRv9LDZTBBiMxL10+T50JyZk+45U8hIAOelUtUfx5Ceh27EaQw4kxiPpwW78Xks6P+Xg+qkpV7BVDvrwmJct4sMZ/W039QcaKZDrOINmm3y9K+axInsFOXix56u+Xfjk5x0eLqnpvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sF9O0-0001n0-VU; Thu, 06 Jun 2024 11:26:20 +0200
Date: Thu, 6 Jun 2024 11:26:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606092620.GC4688@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605190833.GB7176@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> When this was added (handle dissection from bpf prog, per netns), the correct
> solution would have been to pass 'struct net' explicitly via skb_get_hash()
> and all variants.  As that was likely deemed to be too much code churn it
> tries to infer struct net via skb->{dev,sk}.
> 
> So there are several options here:
> 1. remove the WARN_ON_ONCE and be done with it
> 2. remove the WARN_ON_ONCE and pretend net was init_net
> 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
>    or 2)
> 4. stop using skb_get_hash() from netfilter (but there are likely other
>    callers that might hit this).

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -303,6 +303,30 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
        kfree_skb(skb);
 }
 
+static u32 __nf_skb_get_hash(const struct net *net, struct sk_buff *skb)
+{
+       struct flow_keys keys;
+       u32 hash;
+
+       memset(&keys, 0, sizeof(keys));
+
+       __skb_flow_dissect(net, skb, &flow_keys_dissector,
+                          &keys, NULL, 0, 0, 0,
+                          FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+
+       hash = flow_hash_from_keys(&keys);
+       __skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
+       return hash;
+}
+
+static u32 nf_skb_get_hash(const struct net *net, struct sk_buff *skb)
+{
+       if (!skb->l4_hash && !skb->sw_hash)
+               return __nf_skb_get_hash(net, skb);
+
+       return skb->hash;
+}
+
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
                    const struct nft_chain *chain)
 {
@@ -317,7 +341,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
        net_get_random_once(&trace_key, sizeof(trace_key));
 
        info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
-                                       skb_get_hash(skb),
+                                       nf_skb_get_hash(nft_net(pkt), skb),
                                        skb->skb_iif,
                                        &trace_key);
 }


... doesn't solve the nft_hash.c issue (which calls _symmetric version, and
that uses flow_key definiton that isn't exported outside flow_dissector.o.
