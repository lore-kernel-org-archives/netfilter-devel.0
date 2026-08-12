Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281D81E5B70;
	Wed, 12 Aug 2026 01:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498484; cv=none; b=rGq107yvEcvt84i1+uZ+KeFJ0bdhmIjoZbRVqgKA4gD/uU7vfg7uCyxlWQOXQ42kUkI1aHlXk316ZxdIua1ZTl4xaAX0BIUi3zpkFE9wHtPmf/ggE+NurjbBX976yFpJr6L/t8DEKvUemcN1x8PyXfys80+4t7n+ws4o2CeHv0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498484; c=relaxed/simple;
	bh=+WuVLE8XlBwxiZXnm3wRd/oyRUQxHSpx7DesQbCx6ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVAqeOoVWLSILahRv94ORKYi+tifW70iuPNixVnht25U+g9rpaQ1n14HL3I3RBpKnkPga1YCZ1Meh0XFPQcNAJMELqg7HF3uAf9YN+DMnCZKV74zVQBWc+FuP64oTOIQuQRV5gT01W6wqZXBfRhJh1UoYefG90bb5KY/5G1JqHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYPhNELs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYPhNELs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC71F00A3A;
	Wed, 12 Aug 2026 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786498483;
	bh=+UN3hw2Py8vkOT6kz6KqudeU1QTOD0kTavExJEhAu7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYPhNELs5nybGobFPtzSjX3xdRUys94PMcVJwpwaN8K3WcqtIQofSpCCis3G+L5xt
	 Ukl3hjTtwLjIJz3tHqMmLLkDbP0VJTXdg69C0O1KFzN8C/X2hYWZmgH199h6jhGvfn
	 ZOL7ketOX6IbbtEEABhW1xVy9NGax78qdVh/y/rhrh9hv1YOkwcbdGhjdg9dsNG/pJ
	 xMO3jELPYOIu0uBDqQVbg+O2jzoD4/O/QY+WoAWSEmF2TEj8MhRr+xOwGQABs/UWSN
	 EaZ0O8T/STlUd7d3SxSw1hm5e+EeuicfuW2R8abUcQt9YmuCiA1vlDwy0ub8D1R++g
	 hcG+XTcFBKVDw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net-next 01/12] netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
Date: Tue, 11 Aug 2026 18:34:41 -0700
Message-ID: <20260812013441.1673114-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810194015.932627-2-pablo@netfilter.org>
References: <20260810194015.932627-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()

This adds a DEBUG_NET_WARN_ON_ONCE() to skb_set_nfct() that fires when
skb->_nfct already holds a conntrack pointer, so that nf_ct_set() calls
overwriting a live ct object are caught.  Several existing nf_ct_set()
callers in ipvs, conntrack clash resolution, openvswitch and act_ct are
converted to call nf_reset_ct() first.

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 22eda1d54a0e8..95184183180f6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -5004,6 +5004,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
>  static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
>  {
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	DEBUG_NET_WARN_ON_ONCE(skb->_nfct & NFCT_PTRMASK);
>  	skb->slow_gro |= !!nfct;
>  	skb->_nfct = nfct;
>  #endif

[Severity: High]
Was nf_ct_bridge_pre() in net/bridge/netfilter/nf_conntrack_bridge.c meant
to be converted too?

That hook deliberately lets an skb carrying a conntrack template through its
entry check:

net/bridge/netfilter/nf_conntrack_bridge.c:nf_ct_bridge_pre() {
	ct = nf_ct_get(skb, &ctinfo);
	if ((ct && !nf_ct_is_template(ct)) ||
	    ctinfo == IP_CT_UNTRACKED)
		return NF_ACCEPT;

The ETH_P_IP and ETH_P_IPV6 arms then hand the template to
nf_conntrack_in(), which zeroes skb->_nfct and drops the template reference
with nf_ct_put(tmpl) at its out: label, so those paths satisfy the new
precondition.  The default: arm does not:

	default:
		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
		return NF_ACCEPT;
	}

Since the new warning tests the old value of skb->_nfct regardless of the
new value, does nf_ct_set(skb, NULL, IP_CT_UNTRACKED) here trip
DEBUG_NET_WARN_ON_ONCE() whenever a template is still attached?

Can a template be attached before this hook runs?  An nft bridge base chain
in NF_BR_PRE_ROUTING at a priority below NF_IP_PRI_CONNTRACK (-200) appears
to be accepted, as nf_tables_api.c only restricts priorities at or below
NF_IP_PRI_CONNTRACK for NAT-type chains.  A rule with ct zone set in such a
chain reaches nft_ct_set_zone_eval():

net/netfilter/nft_ct.c:nft_ct_set_zone_eval() {
	...
	nf_ct_set(skb, ct, IP_CT_NEW);

which takes a reference on the per-CPU template (or allocates a fresh one
via nf_ct_tmpl_alloc() when that one is busy).  nft_do_chain_bridge()
evaluates rules for every ethertype, including ARP, PPPoE and LLDP frames,
which then land in the default: arm above.

With CONFIG_DEBUG_NET=y, does this turn any received non-IPv4/IPv6 frame on
such a bridge into a warning splat, and a panic when panic_on_warn=1?

Separately, the reference drop at that site is not new: the overwrite has
always discarded the template reference without nf_conntrack_put().  Does
that pin the per-CPU template refcount above 1 permanently, so
nft_ct_set_zone_eval() takes the nf_ct_tmpl_alloc() path for every later
frame, and each of those allocations is leaked by the same
nf_ct_set(skb, NULL, IP_CT_UNTRACKED)?

For reference, the same shape was converted in this patch:

> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index b3bb228ad75cb..3dca7d387dd08 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -2121,7 +2121,7 @@ static inline void ip_vs_notrack(struct sk_buff *skb)
>  	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
>  
>  	if (ct) {
> -		nf_conntrack_put(&ct->ct_general);
> +		nf_reset_ct(skb);
>  		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>  	}
>  #endif

[ ... ]

Would adding nf_reset_ct(skb) before the nf_ct_set() in the default: arm of
nf_ct_bridge_pre() be the right fix?  If it is intentionally left for a
separate change, could the commit message mention it so that a new warning
in bridge plus conntrack zone setups is not a surprise?

Checking the tip of the series (839e6caf13c7332db9b40817696bb7a326b810d5),
nf_ct_bridge_pre() is still unchanged and the warning in skb_set_nfct() is
still present.

Two nearby nf_ct_set() users also set a ct on an skb without clearing a
possible pre-existing one: nf_conntrack_attach() in
net/netfilter/nf_conntrack_core.c and tcf_ct_flow_table_restore_skb() in
include/net/tc_act/tc_ct.h.  Both rely on the caller supplying a fresh skb.
Is that assumption worth documenting alongside the new invariant?
