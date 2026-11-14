Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622544;
	b=OAY6oz2u/+otcom3hH7op5UcuEZOZX2yoSXpOFFOM0Lo7AQ6ZtlmYlIJFslSccVyyQtw
	 WGScQzcYRoLlmXSjMqWhqxyTpbAk/+RSz5JDkhmGvVjQk/Az4ZMECkx1hzvFZlQ7eh2FJ
	 S19KyllpjJYQH+KxrL83Q6XrTf27Y0RTx4deGszSqu7jPAe05wPaRyUuD/KzxrPkR5CPM
	 ouqQffceJERLxpJneQ1OxEM65zMowHdb4+tAcRhnolS8sB7eyBtbIYn9BuushawNSJF8Q
	 fD/U0vsTnA38OPiUgLicCV/ehNJyFjK0DzUX4kdW6JIqWYBBw+t22shGf2+bwjLR/gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622544;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=q32++NpuSBVXrZq1yEkuGL5U2LuT40oHUIbLOJp8kTQ=;
	b=oe/2gbQsn4T9dBlb/+te6poMPyx3Tx9w3yiz+KxN/yvmMGTiuiQX8xXRMFu/kvFmgjEQ
	 OLOljG5EW5vo9O2FGJJBH8fbm3YThUQTWvE66/8XgNjoTu71UtX2FmXNLFTrdRordbZr7
	 SiLFYqu+w0kSqD5fa3l6m8De3fAsuOl/L9Ms5Kb+JMuH7H2RKKb3SGCIzqrH7Gz71FuCV
	 IBRrZzqArcq7UUBXfQn9LRGtaACIyqwutm603afUm8fvgBHs6qJS9yqvxLsCSLSdObPYc
	 Ul9NKQkQIgtmFgfXz8gc8UiMj2r1FDbULTcd2o/cn/MJTJvPHv154DdEybRORtWdXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5HuSM05;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03ED606A89E;
	Sat, 14 Nov 2026 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5HuSM05
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3251F000C4;
	Sat, 14 Nov 2026 02:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622544;
	bh=q32++NpuSBVXrZq1yEkuGL5U2LuT40oHUIbLOJp8kTQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=b5HuSM05eHq/yPW/eax2d8ltu4SvwSaM24GXEzsPhAbjEzpCQ4nXLFXDdjUV2Jg5s
	 /hcN1XZBrdyFJFQU2/u10oQfcj/wDDLH5mCmwJ5njt9QCx8vxjV1MUPNAQjESeOEm3
	 FggVW66uIPtQpuuUbDZQ8UnD9V7jxxz2wI8KUqebXtFYTsQCT7uHw61voBKR9jSJPw
	 yanMxbdBELg5QbWzoTCM1fxJgsuxq+kWFNmKQrtl1TdeAmEYLLYVMb9AsiHSP2Nyju
	 qPNRafGl7GCyL1HE0hlcetFazz54mXEH0GowSqGox+OLMc1AF7n6a0eY9VhnwS5n//
	 jbrCKXnm/uFtg==
Subject: Re: [PATCH net 07/15] ipvs: ftp: add seqadj extension before linking
 the expectation
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:43 +0000
Message-ID: <179462254370.2199510.3740508632458892922@kernel.org>
In-Reply-To: <20261113011447.2357709-8-pablo@netfilter.org>
References: <20261113011447.2357709-8-pablo@netfilter.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.

--

ipvs: ftp: add seqadj extension before linking the expectation

This patch adds the seqadj extension to an unconfirmed conntrack in
ip_vs_ftp_out() before the payload is mangled and before the expectation
is linked. The goal is to keep ip_vs_update_conntrack() from reallocating
ct->ext while the helper's expectation list still points into it.

> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index 44de99f4d187f..81c3a2fd27b39 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c

[ ... ]

> @@ -384,19 +385,25 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
>
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (ct && !nf_ct_is_template(ct)) {
> -		bool mangled;
> +		bool mangled = false;
>
>  		/* If mangling fails this function will return 0
>  		 * which will cause the packet to be dropped.
>  		 * Mangling can only fail under memory pressure,
>  		 * hopefully it will succeed on the retransmitted
>  		 * packet.
> +		 *
> +		 * Add the seqadj extension before the expectation is
> +		 * linked into the helper extension: adding it later
> +		 * reallocates ct->ext under the expectation list.
>  		 */
> -		mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
> -						   ipvsh->len,
> -						   start - data,
> -						   end - start,
> -						   buf, buf_len);
> +		if (nf_ct_is_confirmed(ct) || nfct_seqadj(ct) ||
> +		    nfct_seqadj_ext_add(ct))
> +			mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
> +							   ipvsh->len,
> +							   start - data,
> +							   end - start,
> +							   buf, buf_len);
>  		if (mangled) {
>  			ip_vs_nfct_expect_related(skb, ct, n_cp,
>  						  ipvsh->protocol, 0, 0);

[Severity: High]
Does this fully close the use-after-free? The expectation is still linked
into nfct_help(ct)->expectations while ct is unconfirmed, and that list
head lives inside ct->ext. Pre-adding seqadj only stops one later
extension add from moving ct->ext.

nf_ct_expect_insert() does:

    hlist_add_head_rcu(&exp->lnode, &master_help->expectations);

so exp->lnode.pprev now points into the current ct->ext block.

Later hooks on the same packet can still grow ct->ext. One example is a
MASQUERADE rule in POSTROUTING, which runs for this IP_CT_NEW conntrack
after the IPVS out hook:

  nf_nat_inet_fn()
    nf_nat_masquerade_ipv4()
      nf_ct_nat_ext_add()
        nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC)
          krealloc(ct->ext, alloc, gfp)

Here is one layout where this moves the block. With
CONFIG_NF_CONNTRACK_TIMESTAMP=y and an ecache extension present
(nf_conntrack_events=1), the extensions are header 16, ecache 32, help
56 and seqadj 24. That adds up to exactly 128 bytes, which is the
NF_CT_EXT_PREALLOC object size. Adding NAT gives a newlen of 132-136.
__do_krealloc() then goes to alloc_new and the old block is freed.
nf_conntrack_acct=1 gives the same arithmetic.

After that, ext->help.expectations.first in the new block points to
exp->lnode. But exp->lnode.pprev still points into the freed block. When
the expectation or conntrack is removed, nf_ct_unlink_expect_report()
calls:

    hlist_del_rcu(&exp->lnode);

This writes through the stale pprev, which looks like the same KASAN
report quoted in the commit message. In this layout the seqadj add would
not have moved the block even before the patch, so the patch does not
help in this case.

Other extension adds on an unconfirmed ct are also reachable later in
the same traversal:

  nft_ct_set_eval() with NFT_CT_EVENTMASK -> nf_ct_ecache_ext_add()
  nft_ct_timeout_obj_eval() -> nf_ct_timeout_ext_add()

The commit message says this is reachable with CAP_NET_ADMIN in a user
namespace. That context can configure MASQUERADE, nft ct rules, the acct
sysctl and ctnetlink listeners.

Would it be better to not link the expectation while the conntrack's ext
can still grow? Two options are deferring the link until confirmation,
or making ct->ext stable first. Pre-adding one more extension does not
seem to cover these other paths.

None of the later patches in the series appear to touch ip_vs_ftp.c,
ip_vs_nfct.c, nf_conntrack_extend.c, nf_nat_core.c, nf_nat_masquerade.c
or nf_conntrack_expect.c.

>  			if (skb->ip_summed == CHECKSUM_COMPLETE)
>  				skb->ip_summed = CHECKSUM_UNNECESSARY;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
