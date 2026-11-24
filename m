Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531178;
	b=L3xnJ8hh4HvtZa0UrfM3oEZeWBB+H4fBIww874DU/gb9kyc9NbjU/AJxpqLy1O1kRdMB
	 ppOxc+HXfSaZCFrTzRqG6pg5uvrgDgreqj1YzBY0P4mDtFUPH9N49KJiOtpRe+teDhJiG
	 HD980XfE2TgL79rUbvt+mLghexTY1T+thClSCizRveQMjN9iwMBLmzmU9DQvsrSQM6vWL
	 jUBqldyXZRPv8OZ4QKtsZnK/+i++pNpimRGr7Gx9dMDpcOS275YwfkJcUniu5inV6ONMa
	 fg8nVjFdnEu3pn/8x6cWiBaQ41WpN3ViKr0WOGMms+tggoKiSD2CNkPn7ZMr9gTzVpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531178;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=aRAUic9ptpylqLsdksE52M5rgeu/XLppgmfAYKgEwWM=;
	b=ITqIps/0iQPyV9Vo6umyZ/B165K5wh43FcOz0UVBUvmNbIqdll/w3Myt5plumBNJO4eW
	 V+hHg04tNQ3XQjHdbn8m2kojK8WPp9x2yF7vLvr51loMmZPqHKZvR/mZAWJJADrehidjf
	 Y7Jzh5ksQUsPF6VJIQXj+S1Kbw9uFQi5F4PWReXjzLGi5rwpAEqOX8KxlM6O/psFtRqBN
	 RV7s4E543BNSb4jbVW6X65ueHs4/8KjWasKrJk5NGFWbWsNw3nHgRqssy3I59g9EoWain
	 lPkghCqpTsimlr3ogeTcJQH4Gz65qqy1RjfxhELtFigjLWdKTsdlvzVvmcfo0sQIHmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfnpLqLF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99182606A68D;
	Tue, 24 Nov 2026 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfnpLqLF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD0B1F000D0;
	Tue, 24 Nov 2026 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531178;
	bh=aRAUic9ptpylqLsdksE52M5rgeu/XLppgmfAYKgEwWM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SfnpLqLFSKpBCvzEyJTX+htCpBrQ4dquW4v0hXugf6zvGBMRkwJAFm0g9yhp4XfcV
	 x/5yWdi/xD8KVcxV7LchcnOlQzYdI46uWf+yPzgGqEbBTVZ45NfjofC8k7h7Hyn3XG
	 J8XTRVi21r4wWSggAxSd6lSLI3BNMS0IujQ5WklC4gCOCCBHkglgB/4H1fE2MZTjrw
	 ASYOCLmWC6/DhK5UnlbV4P6U4cpe3hn4mJyQ4i/hGC8QHBxQ0nMVwuPCNOYaCk0nCD
	 v9xFF+pjLP4ZgcS3rXYKc39DZouFDNwPBsizejHaHh8lJcMrnT0Lr8wixIdqKY7g8l
	 U5YbHlEhAnVfw==
Subject: Re: [PATCH net-next 07/15] netfilter: nft_ct: validate timeout object
 protocol
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 24 Nov 2026 14:39:37 +0000
Message-ID: <179553117713.3135.14906437423367847166@kernel.org>
In-Reply-To: <20261123135726.3940688-8-pablo@netfilter.org>
References: <20261123135726.3940688-8-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Moving nft_ct_helper_obj_eval() onto nft_ct_get_safe() adds a
  new `l4proto != pkt->tprot` rejection to the conntrack helper object…
- [Low] The changelog credits the original author under a different name
  from the Signed-off-by: the body says "Based on original patch from…

--

netfilter: nft_ct: validate timeout object protocol

This adds nft_ct_get_safe(). It returns the conntrack entry only if the
entry is unconfirmed, is not a template, and both pkt->tprot and the
conntrack tuple protocol match the expected L4 protocol.
nft_ct_timeout_obj_eval() and nft_ct_helper_obj_eval() now use it. A
timeout object therefore can no longer be attached to an entry of a
different protocol.

> Based on original patch from Kyle Zheng, who also authored this commit
> message.
>
> LLM review complains about _ext_add() races with cloned unconfirmed skbs.
> conntrack never supported this; fixing it is hard and out of scope for this
> change.
>
> Fixes: 0434ccdcf883 ("netfilter: nf_tables: rework ct timeout set support")
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

[Severity: Low]
This isn't a bug, but the body credits "Kyle Zheng" and the Signed-off-by:
tag says "Kyle Zeng". Should these match?

The LLM review paragraph mentions a known, unfixed race in
nf_ct_timeout_ext_add() on unconfirmed conntracks reached through cloned
skbs. It doesn't say what the impact is. Could it describe the
consequence, so stable backporters have something to act on?

> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 58846bc405b7e..a19a839a0fc0b 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -839,6 +839,34 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  

[ ... ]

> +static struct nf_conn *nft_ct_get_safe(const struct nft_pktinfo *pkt, u8 l4proto)
> +{
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(pkt->skb, &ctinfo);
> +	if (!ct || l4proto != pkt->tprot)
> +		return NULL;
> +
> +	if (l4proto != nf_ct_protonum(ct))
> +		return NULL;

[ ... ]

> @@ -1115,14 +1141,12 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
>  				   const struct nft_pktinfo *pkt)
>  {
>  	const struct nft_ct_helper_obj *priv = nft_obj_data(obj);
> -	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
>  	struct nf_conntrack_helper *to_assign = NULL;
>  	struct nf_conn_help *help;
> +	struct nf_conn *ct;
>  
> -	if (!ct ||
> -	    nf_ct_is_confirmed(ct) ||
> -	    nf_ct_is_template(ct) ||
> -	    priv->l4proto != nf_ct_protonum(ct))
> +	ct = nft_ct_get_safe(pkt, priv->l4proto);
> +	if (!ct)
>  		return;

[Severity: Medium]
Does this make the helper object path stricter than before?

The old check in nft_ct_helper_obj_eval() only compared priv->l4proto with
nf_ct_protonum(ct). It never looked at packet metadata. Through
nft_ct_get_safe() it now also requires:

	if (!ct || l4proto != pkt->tprot)
		return NULL;

pkt->tprot and the conntrack tuple protocol are not always the same. For
IPv6, nft_set_pktinfo_ipv6() calls ipv6_find_hdr() with IP6_FH_F_AUTH:

	unsigned int flags = IP6_FH_F_AUTH;
	...
	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
	...
	pkt->tprot = protohdr;

This stops at the AH header and reports IPPROTO_AH. Conntrack's
ipv6_get_l4proto() uses ipv6_skip_exthdr() instead, which skips AH and
records the inner transport protocol:

	protoff = ipv6_skip_exthdr(skb, extoff, &nexthdr, &frag_off);

For an IPv6 TCP flow protected by AH, nf_ct_protonum(ct) is IPPROTO_TCP
and pkt->tprot is IPPROTO_AH. No priv->l4proto value passes both checks.

Would "ct helper set" with an ftp or sip helper object then silently stop
attaching the helper for such flows?

The two values can also differ in two other cases. One is when the nft
pktinfo parse fails and nft_set_pktinfo_unspec() leaves tprot at 0. The
other is after a header rewrite.

The commit message says:

    This mirrors validation by named timeout policies and
    nftables conntrack helper objects.

It doesn't mention that the helper object path itself gains the pkt->tprot
check.

The nf_ct_protonum() check alone is enough to prevent the out-of-bounds
read, and the helper path never had that problem. Could the pkt->tprot
comparison stay in nft_ct_timeout_obj_eval() only? The helper object path
would then keep its previous behaviour.

>  
>  	switch (nf_ct_l3num(ct)) {

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135726.3940688-2-pablo%40netfilter.org
