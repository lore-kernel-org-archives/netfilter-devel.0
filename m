Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626C3905F9;
	Tue, 22 Sep 2026 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089119; cv=none; b=Q8tBUBhVL5kH8UJY51vCfZCrBjeqq1oK8+NA8cdyTYLKa24Gi+GrUBl8UNaBvq+gD7MTOA3aNrBWyvrfiTlcTCb0YXw1yVP3IUOh+vNcGv9dt9/wBSUKdPEi+pLmthWA1mJKSAIOJDyTMrU/kgUkwbz/y0SAcXf2d48qqmiZBMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089119; c=relaxed/simple;
	bh=8CS6daGo9V3Xjsk0EcXTXCP47j5eXnWaKZTS+PoOOMs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zts4omc0ER+frYI5XXos62N0pXR+BZTkso1O2QHbwgtSC3EGwMf81A5t9uCQ4ctg3rJWTwksTh5YS/gsWCQTPbA51uJJz7mQKBpBbNuD4Ey7K9Yg7a4fJ2d0HpiJNDp+ojoSa6qSjqpp8NsIfNElAosg0BiPGN0doc8BrkttTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bM+Q9jgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bM+Q9jgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726671F000FF;
	Tue, 22 Sep 2026 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089117;
	bh=M6nTIIB1x5FwMgcT5MFxWk/QvQSD8W0tvgq+XELplsk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bM+Q9jgHIGa/MYbVHS7TGYGi66VwgcudpUrKNVNG45LO8XYCInWzznFub6WHleTcg
	 JBJzhAuaQe0wrVEQcze2aAiujYMky5TMg2RulP9Dy0uDDLhlPF0GaOs3aJGF1due/Y
	 ikLQxhBoZhxl8W8G9ZFCQi5IQFKsqtP+TSST56rCIgvlWv2xzP7KNrWOV6jyvSB4X/
	 GMghnd3KF78fH4RMgiPwFmgiLuZYXtbAT1XPJPJY37vwxAQnXI+UYK4kNOzlAc2o9P
	 S/2dTU5L4HGNhJzVmFcIhG2VhnoEDfjSAKH2Z+N1jlKRoXcDxfCyj62mN6HpvvhK+Z
	 vFWXCrDyKZlYQ==
Subject: Re: [PATCH net 1/6] net: openvswitch: conntrack: avoid modifying
 shared unconfirmed ct entry
From: netdev-bot+sashiko@kernel.org
To: i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:58:35 +0000
Message-ID: <179008911592.2160803.15817354196701627708@kernel.org>
In-Reply-To: <20260921145655.3167436-2-i.maximets@ovn.org>
References: <20260921145655.3167436-2-i.maximets@ovn.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] New behaviour change introduced by the guard in
  __ovs_ct_lookup() (net/openvswitch/conntrack.c:741-747): when two skbs…
- [Low] nf_ct_shared() is added as an undocumented generic predicate in
  include/net/netfilter/nf_conntrack.h:188-191 returning…

Pre-existing issues:
- [Low] Peer call site net/sched/act_ct.c (tcf_ct_act()) performs the
  same 'cached, unconfirmed ct + commit modifies the extension set'…

--

net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry

This adds a new nf_ct_shared() helper to the conntrack header and uses it in
__ovs_ct_lookup() to reset the cached conntrack entry when an skb arrives at
a committing ct action with an unconfirmed entry that is shared with another
skb.  The goal is to avoid two clones committing the same unconfirmed entry
with different extension sets, which can lead to a use-after-free.

A few questions below.

> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index bc42dd0e10e65..c39425e54d87d 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -185,6 +185,11 @@ static inline void nf_ct_put(struct nf_conn *ct)
>  		nf_ct_destroy(&ct->ct_general);
>  }
>  
> +static inline bool nf_ct_shared(const struct nf_conn *ct)
> +{
> +	return refcount_read(&ct->ct_general.use) > 1;
> +}
> +

[Severity: Low]
Would it be worth documenting that this predicate is only meaningful for
unconfirmed, non-template entries?

The reference accounting comment on struct nf_conn in this same header says
the count is "1 for hash table, 1 per skb, plus 1 for any connection(s) we
are `master' for".  With that, every confirmed entry owned by a single skb
already has use == 2, since __nf_conntrack_confirm() does:

	/* The caller holds a reference to this object */
	refcount_set(&ct->ct_general.use, 2);

The same is true for a template in use: nf_ct_tmpl_alloc() sets use = 1 and
nf_ct_set(skb, tmpl, ...) adds another.  So nf_ct_shared() returns true for
an ordinary single-owner confirmed entry and for an in-use template, while
the name reads as "more than one skb owns this ct".

Both consumers at the end of the series check !nf_ct_is_confirmed(ct) first,
so there is no misbehaviour today, but a future caller without that check
would get a surprising answer.

There is also already an open-coded twin of this test in
nf_ct_drop_unconfirmed() in net/netfilter/nfnetlink_queue.c, which states the
precondition ("conntrack assumes exclusive skb->_nfct ownership for
unconfirmed entries") and applies it only after:

	if (!ct || nf_ct_is_confirmed(ct))
		return false;

Should that one be converted to the new helper so there is a single
definition of "shared"?

[Severity: Low]
This isn't a bug introduced by this patch, but the helper lands in the
shared netfilter header while the equivalent call site in net/sched/act_ct.c
is left alone here.

tcf_ct_act() runs the same sequence on a cached unconfirmed entry, adding
extensions and running helpers:

	err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
	...
	if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
		if (!nfct_seqadj_ext_add(ct))
			goto drop;

tcf_ct_skb_nfct_cached() has no exclusivity test either.

For what it is worth, the follow-up patch in this series, "net/sched:
act_ct: avoid modifying shared unconfirmed ct entry", adds the same guard to
tcf_ct_act() and extends it to the NAT-without-commit case, so the gap is
closed by the end of the series.  Mentioning that ordering in this changelog
might help backporters.

> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 0f433688e17b9..a733029c28dd0 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -734,6 +734,18 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  	enum ip_conntrack_info ctinfo;
>  	struct nf_conn *ct;
>  
> +	/* If the ct entry is not confirmed and shared with some other skb,
> +	 * e.g., a cloned one, we can't just modify it with the commit as we
> +	 * must not modify the extension set.  Reset.
> +	 */
> +	if (cached && info->commit) {
> +		ct = nf_ct_get(skb, &ctinfo);
> +		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
> +			nf_reset_ct(skb);
> +			cached = false;
> +		}
> +	}
> +

[Severity: Medium]
Since the test is a point-in-time refcount snapshot, does it exempt the last
remaining holder?

With two skbs sharing one unconfirmed entry and both executing ct(commit) in
the same zone:

  - the first one to reach the check sees use == 2, so nf_reset_ct() drops
    its reference (2 -> 1), nf_conntrack_in() runs again and it commits a
    brand new entry with the same tuple.

  - the second holder now sees use == 1, so nf_ct_shared() is false, it
    keeps the stale unconfirmed entry and commits that.

__nf_conntrack_confirm() then finds the equal tuple already in
nf_conntrack_hash and falls into nf_ct_resolve_clash(), where:

	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
	if (!l4proto->allow_clash)
		goto drop;

For TCP, SCTP and DCCP that returns NF_DROP, and verdict_to_errno(NF_DROP)
== -EINVAL propagates through ovs_ct_commit() and ovs_ct_execute(), so that
packet is dropped with OVS_DROP_CONNTRACK.  Before the patch both clones
were accepted, as the second nf_conntrack_confirm() was a no-op on the
already confirmed shared entry.

For UDP and ICMP the clash resolution succeeds, but __nf_ct_resolve_clash()
discards the losing entry, so the mark and labels the second clone just
wrote are silently lost.

The changelog says the reset "doesn't affect any known use cases".  Should
the drop and the mark/label loss be spelled out there, given both are
visible consequences for a pipeline that commits two clones into the same
zone?

The clone precondition itself comes from __nf_copy() in
include/linux/skbuff.h, which unconditionally takes a ct reference:

	dst->_nfct = src->_nfct;
	nf_conntrack_get(skb_nfct(src));

and skb_nfct_cached() returns true for the surviving clone since it only
checks netns, zone, helper, timeout and force.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921145655.3167436-1-i.maximets%40ovn.org
