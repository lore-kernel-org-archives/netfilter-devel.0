Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D05369D55;
	Wed, 12 Aug 2026 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498490; cv=none; b=FuYvVyG79ZHcmnZNbk+FXMKVuMY5D+VLCap5e7n+NFTgVd37CFYpf9+xLwNmHH9/FmIjoX3PWPoPLQpibqHdQAiMgDyClntNPTj9Buoj3k59aUMSQHV1Bsp6KwobrNa0St9Lgmox2SEgXaa282HWEArkzbkYPDDm7G9k4yfIc48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498490; c=relaxed/simple;
	bh=n5MteN7NuHLdIf39gHaaYz2OmteUVnv8QJWxynhb+0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjzfPR2i3+dwa5Xsqy6tUNrwHDVOi33kxhKU9lYvGYH+mkG3aBYmnNQJpU840GK4sJtC5AG84ajQLSBeyAKIR8O4QIDvK1OlTzX3nWh9saUP0Rb+XoC8DF1RG60mC0v+Yqd9IXp8tTtzJbPPt0zAs5CGJxEo4ENwe0SdcT8+9n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrJro6lA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrJro6lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0351F00A3D;
	Wed, 12 Aug 2026 01:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786498488;
	bh=rNHgyiJtyIEXvqtnLESwYFU0SJwNyKhO04LHA2Ah6Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrJro6lAAIVPbOBtTesPZwmst4TJizQrQ3hpRnv2mcfbE6NJd5MPesfaJmRDDZr+B
	 l9RSdQtflh35IqfZQyByth4ktNArH0f+ZFwmcSKV9rCSljKSMSTI82Q0H3qTKxK2jM
	 tAWgFAF420wAhkPDI47JDr/oCPilWRHnQvIAbTb0hfKsm8PJAOXYhA5d6BBpcEm0Yb
	 3MqfsIS6QJuBZJ4S4NovtML5KIYHMxL7cdr07UWnN5SxmIKHFXwz7Mfl9L2BGCzLen
	 ACtjMQr0J0HGcAjaEf/12ajXDgoJgWf4XttEpHHGbaohmNU+fH+YCyHogfO55958PV
	 F53f6dYD8iyFA==
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
Subject: Re: [PATCH net-next 11/12] netfilter: nf_conntrack_expect: bail out on insert dead expectations
Date: Tue, 11 Aug 2026 18:34:47 -0700
Message-ID: <20260812013447.1676073-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810194015.932627-12-pablo@netfilter.org>
References: <20260810194015.932627-12-pablo@netfilter.org>
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
netfilter: nf_conntrack_expect: bail out on insert dead expectations

This adds a check in nf_ct_expect_related_report() that refuses insertion
of an expectation carrying NF_CT_EXPECT_DEAD, returning -EINVAL and
triggering DEBUG_NET_WARN_ON_ONCE(). It is described as hardening for
b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap
expectations").

A couple of questions about the placement of the new check and about the
DEAD flag itself.

> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 10b130a7b230b..f1f0c582db5df 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -528,6 +528,12 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
>  	int ret;
>  
>  	spin_lock_bh(&nf_conntrack_expect_lock);
> +	if (expect->flags & NF_CT_EXPECT_DEAD) {
> +		DEBUG_NET_WARN_ON_ONCE(1);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +

[Severity: Low]
Would it make sense to put this check in __nf_ct_expect_check() instead?

The other exported insertion entry point, nf_ct_expect_related_pair(),
goes straight from the lock to __nf_ct_expect_check() and
nf_ct_expect_insert() with no NF_CT_EXPECT_DEAD test:

net/netfilter/nf_conntrack_expect.c:nf_ct_expect_related_pair() {
	spin_lock_bh(&nf_conntrack_expect_lock);
	master_help = nfct_help(expect[0]->master);
	if (!master_help || master_help != nfct_help(expect[1]->master)) {
		ret = -EINVAL;
		goto out;
	}

	for (i = 0; i < 2; i++) {
		ret = __nf_ct_expect_check(expect[i], master_help, flags);
	...
}

Since nf_ct_unexpect_related() now only sets the bit and leaves the
expectation linked on hnode/lnode until GC runs:

net/netfilter/nf_conntrack_expect.c:nf_ct_unexpect_related() {
	spin_lock_bh(&nf_conntrack_expect_lock);
	WRITE_ONCE(exp->flags, exp->flags | NF_CT_EXPECT_DEAD);
	spin_unlock_bh(&nf_conntrack_expect_lock);
}

a resubmission of a DEAD-but-still-linked expectation on the pair path
would reach nf_ct_expect_insert() and call hlist_add_head_rcu() on
already-linked nodes, plus double-count cnet->expect_count and
master_help->expecting[class].

The gap in the pair path is pre-existing and not introduced by this patch,
and I could not find any in-tree caller that actually reaches it. The two
pair callers, nf_nat_sdp_media() in net/netfilter/nf_nat_sip.c and
nat_rtp_rtcp() in net/ipv4/netfilter/nf_nat_h323.c, allocate the
expectations per packet with flags cleared, retry only on -EBUSY (before
anything is published), and call nf_ct_unexpect_related() only on the
terminal error exits that return immediately. When the tuple hash is
unchanged, __nf_ct_expect_check()'s own expired-entry loop would also
unlink the stale entry first.

Would it still be worth making the invariant symmetric, given the commit
message says this should not ever happen?

Separately, on the DEAD flag itself:

[Severity: Medium]
This is a pre-existing issue rather than something introduced here, but
since this patch is tightening the semantics of the same flag: is the
kernel-private NF_CT_EXPECT_DEAD bit supposed to be visible over ctnetlink?

The uAPI header keeps it out of the userspace-visible mask:

include/uapi/linux/netfilter/nf_conntrack_common.h {
#ifdef __KERNEL__
#define NF_CT_EXPECT_DEAD		0x8
#define NF_CT_EXPECT_MASK	(NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE | \
				 NF_CT_EXPECT_USERSPACE)
#endif
}

and the input policy enforces that mask, so a request carrying 0x8 is
rejected with -EINVAL:

net/netfilter/nf_conntrack_netlink.c:exp_nla_policy {
	[CTA_EXPECT_FLAGS]	= NLA_POLICY_MASK(NLA_BE32, NF_CT_EXPECT_MASK),
}

But the dump path exports the raw value:

net/netfilter/nf_conntrack_netlink.c:ctnetlink_exp_dump_expect() {
	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
}

Because the expectation now stays linked after nf_ct_unexpect_related()
sets the bit, the value can be observed with 0x8 set through the
IPEXP_DESTROY event from nf_ct_unlink_expect_report(), and through
ctnetlink_exp_ct_dump_table(), which walks help->expectations without the
nf_ct_exp_is_expired() filter that ctnetlink_exp_dump_table() and
__nf_ct_expect_find() apply:

net/netfilter/nf_conntrack_netlink.c:ctnetlink_exp_ct_dump_table() {
	hlist_for_each_entry_rcu(exp, &help->expectations, lnode) {
		if (l3proto && exp->tuple.src.l3num != l3proto)
			continue;
	...
}

A tool that reads CTA_EXPECT_FLAGS and replays it gets a value the same
kernel refuses on input. Would masking with NF_CT_EXPECT_MASK in
ctnetlink_exp_dump_expect() be appropriate here?

This behaviour dates back to b8b09dc2bf35 and is unchanged through the end
of the series.
