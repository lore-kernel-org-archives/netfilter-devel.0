Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1673BFE47;
	Tue,  6 Oct 2026 07:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791273481; cv=none; b=qafO18rl6n9t3nYZsA+CKAMVHJDbOHh5KCsfRwziD6KXycPQpnS0rZKG7Q+h0ARJthxxY+zx3bguyQNTj0e/d9qsMgHT7sNqkRAgwtMusalhVHX5adhKTVaKRnwE5+bvkTXUeJ+Mwr+9AYv7uFffN4SIL6M2QlAm9ZZXyBJBuVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791273481; c=relaxed/simple;
	bh=z83cvtVI/OZvnKWBWCmnpyHuPaDOYziAgjZjwqno7tQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kr5Nop8xDPnbunotT0jZNsFmvgNV0VhbZW5xVVsPIFJ1fY0i7DNn5VVOiGE/ivV6UciKFtjafgnzUFMh9tt6vBxE6F1p0xd30cLKyerx9IZixy+d7pFqS/shGd1Sc6guM5caifCKgn2JO0+yK/dMkSyEcT3lco7pVTWamgS7vIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yo5KNjs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yo5KNjs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101501F000FF;
	Tue,  6 Oct 2026 07:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791273479;
	bh=96AbM7wmILCi/FUwWn4BbH1/d/V3wqMQSKn7tm4Vo1E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Yo5KNjs/qZJnkYXKoMoh2+afx3BBnWuhPjNLXtBqxXvKmQrM+uRcwTqlclM04+QaO
	 tcIz1w1zB7Px50yiGFBtx+9YnZYdWHURW3Gi/Jeo62VETP+zRNiIrZJ6rRhhscyp9h
	 EF7Qy78+TMqZdl79raymOzdhERC0R9zPWAL1zKotnrdtKj1BMa93VbGuPfS3rDhtMj
	 NPrF3bUenBya9e5Yhwb1gc96WeXJi+LRNL+E1szWVDpQRuc/wjdQIjPsiZknXuKDJW
	 4ulB04F9cTT094kEd70ThPDjA+uSWxcudnySjDObHySlOeqvH4UBXkwtlxkD1Ad7r2
	 fUF3E3ESchAow==
Subject: Re: [PATCH v2 net] netfilter: conntrack: reject nested ctnetlink
 master chains
From: netdev-bot+sashiko@kernel.org
To: 4ncienth@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Tue, 06 Oct 2026 07:57:58 +0000
Message-ID: <179127347858.434549.11821822167265441355@kernel.org>
In-Reply-To: <20261002165601.1754467-1-4ncienth@gmail.com>
References: <20261002165601.1754467-1-4ncienth@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix does not stop userspace from building an unbounded
  ct->master chain.
- [High] The commit keeps "kernel helper expectations unchanged", but the
  H.323 Q.931 helper nests itself without limit.
- [Medium] The new check in ctnetlink_create_conntrack()
  (nf_conntrack_netlink.c:2362) makes IPCTNL_MSG_CT_NEW fail with…

--

netfilter: conntrack: reject nested ctnetlink master chains

The patch rejects ctnetlink conntrack creation when the CTA_TUPLE_MASTER
conntrack already has a master. It also rejects NFQUEUE-attached
expectations (NFQA_EXP) for conntracks that have a master. The aim is to
stop userspace from building unbounded master chains, whose recursive
release in nf_ct_destroy() exhausts the kernel stack.

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 4e5d7c7014368..c68e79d1ac87b 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2359,6 +2359,11 @@ ctnetlink_create_conntrack(struct net *net,
>  			goto err2;
>  		}
>  		master_ct = nf_ct_tuplehash_to_ctrack(master_h);
> +		if (master_ct->master) {
> +			nf_ct_put(master_ct);
> +			err = -EOPNOTSUPP;
> +			goto err2;
> +		}

[Severity: Medium]
Does this check reject state that the kernel itself creates? In H.323, a
RAS expectation creates the Q.931 conntrack. That Q.931 conntrack then
sets up the H.245 expectation:

net/netfilter/nf_conntrack_h323_main.c:expect_h245() {
    ...
	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_h245_ptr);
    ...
}

So the resulting H.245 and RTP conntracks have a master that itself has
a master.

A state-sync daemon such as conntrackd may recreate those flows with
IPCTNL_MSG_CT_NEW and a CTA_TUPLE_MASTER that points at the related Q.931
conntrack. That request used to be accepted and now gets -EOPNOTSUPP, so
these flows would not be replicated after a failover.

Since this is tagged for stable, could the commit message mention this
change in what CT_NEW accepts?

>  		__set_bit(IPS_EXPECTED_BIT, &ct->status);
>  		ct->master = master_ct;
>  	}
> @@ -2864,6 +2869,9 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
>  	struct nf_conntrack_expect *exp;
>  	int err;
>  
> +	if (ct->master)
> +		return -EOPNOTSUPP;
> +

[Severity: High]
Can nf_tables still reach the same stack exhaustion? The commit message
says "Stop the repeatable userspace paths", but the patch only covers
CTA_TUPLE_MASTER and NFQA_EXP.

The first path uses an nft ct expectation object alone.
nft_ct_expect_obj_eval() only skips conntracks that are confirmed,
templates, or that already have a help extension:

net/netfilter/nft_ct.c:nft_ct_expect_obj_eval() {
    ...
	ct = nf_ct_get(pkt->skb, &ctinfo);
	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
		regs->verdict.code = NFT_BREAK;
		return;
	}

	help = nfct_help(ct);
	if (help) {
    ...
}

A RELATED child created from an expectation with a NULL assign_helper has
no help extension, so it also gets the ct_expect_help helper.

ct_expect_help() then calls nf_ct_expect_related() with the child as
exp->master, and it never checks ct->master. Over loopback, each new flow
from a fresh source port consumes the previous expectation and arms the
next one, so every flow adds a level.

The second path combines an nft ct helper with ctnetlink.
IPCTNL_MSG_EXP_NEW only stops the chain because ctnetlink_alloc_expect()
requires help->helper.

nft_ct_helper_obj_eval() assigns a helper to any unconfirmed conntrack,
related ones included. After that, ctnetlink_create_expect() succeeds
with the child as master.

A kernel helper attached this way, such as FTP, could also extend the
chain from traffic alone.

In every case init_conntrack() sets ct->master = exp->master with no
depth limit. Freeing the leaf then recurses once per level:

nf_ct_put()
  nf_ct_destroy()
    nf_ct_put(ct->master)
      nf_ct_destroy()
        ...

Both nft paths need only CAP_NET_ADMIN in a user/net namespace, the same
privilege ctnetlink needs.

Would a central bound in nf_ct_expect_related() or init_conntrack() be
needed to close this, or an iterative release of the master chain in
nf_ct_destroy()? Gating each entry point separately leaves these paths
open.

[Severity: High]
The commit message says "Keep regular ctnetlink and kernel helper
expectations unchanged". Can the H.323 Q.931 helper build an unbounded
chain on its own?

For a Facility message with reason callForwarded, process_facility()
calls expect_callforwarding(). That function gives the expected child the
Q.931 helper again:

net/netfilter/nf_conntrack_h323_main.c:expect_callforwarding() {
    ...
	rcu_assign_pointer(exp->assign_helper, nf_conntrack_helper_q931_ptr[0]);
    ...
}

Neither function checks IPS_EXPECTED or ct->master. Each new expected
Q.931 connection can therefore send another Facility(callForwarded) and
create the next level.

The default callforward_filter does not seem to prevent this.
callforward_do_filter() only filters when the nexthop and device are the
same, and two distinct local addresses have different nexthops.

This works over loopback from an unprivileged user namespace once the
helper is attached. It also works for remote peers wherever the Q.931
helper is enabled. Either way, the same recursion in nf_ct_destroy()
exhausts the stack.

SIP REGISTER does not seem to have this problem, because
process_register_request() returns early when IPS_EXPECTED is set.

>  	err = nla_parse_nested_deprecated(cda, CTA_EXPECT_MAX, attr,
>  					  exp_nla_policy, NULL);
>  	if (err < 0)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002165601.1754467-1-4ncienth%40gmail.com
