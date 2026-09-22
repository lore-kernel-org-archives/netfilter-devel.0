Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88514552954;
	Tue, 22 Sep 2026 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089125; cv=none; b=Xo7Gax3LdMpR1cDR/D1tsbtDqwP/AHqiK0IVQURwXbBfOrpZ6r7B5/XueWI5QuHYLzudp7MeGmD71a6YaRZTPCGoA0GAwpCZ/MIfTMBUUgTq1ran9I0iKwLkfxRB+nVOas0YmkEW/7bnXamrp+Oh9ylEeFrnnaRdapOzDTjzoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089125; c=relaxed/simple;
	bh=h4m9Hef1/FCV5jrzyN6ugFtkqKYyEkyoBQ2zmIPShDA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AeutXnhfIOzchWUl+ESFHh0prO6TAYUaZc7lqdyDrgrFqZpItkc5yMr81jIgiXwYUvE/WHkl4es1dpRueVZgQMuV6RKFvu6gud11VtLkdvR+kf9s10go0Muh0rAwNwvlKoMDz+b2jUhzBwxAcMUE54B4fURcoOLTvUJOpNwr7ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1bSddWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1bSddWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692E11F00893;
	Tue, 22 Sep 2026 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089122;
	bh=GSJ/mGqSW5RuTirkz901iOf8hAWbkhO8pkCL+J/UXlU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=H1bSddWo+VxeUIPwxFCRZTAOkZ3ya0qXoxsHw/nNbM5e9D1XGOlkixtni3Y0mHCgO
	 V1z1sRPPAMrtj4PZGgAb2x8vSW/CZ9pZi4mLDK1GrmJduXiWcEuyiIJGE7/H/ATEgF
	 ugAWPw/e7Ibvi4qE9wfvgRt2DUrxIc8G8mihMCLcCAleqGieiIiRPWHxG7Fx/W5R0M
	 HMCoNKvrJqfTB/QxwFRMRrLxSDWTFLgxAry6p0gHdaI7a3J9QVf+d4OHR8cEwrVvBz
	 TRBKQbPKHVTgCKsAnldm5KGZTsWeQv+53qmf2/Zcv6r3axkrxhZ1WnwGRxHrcFtYwa
	 Wa6qT9cvCapGA==
Subject: Re: [PATCH net 4/6] net/sched: act_ct: avoid modifying shared
 unconfirmed ct entry
From: netdev-bot+sashiko@kernel.org
To: i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:58:40 +0000
Message-ID: <179008912095.2160803.9187949237353089190@kernel.org>
In-Reply-To: <20260921145655.3167436-5-i.maximets@ovn.org>
References: <20260921145655.3167436-5-i.maximets@ovn.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] tcf_ct_act() now discards an unconfirmed conntrack entry
  purely because its refcount is >1, without checking whether the…

Pre-existing issues:
- [Medium] At this commit, tcf_ct_act() still calls nf_ct_helper()
  (net/sched/act_ct.c:1106) before the commit block that grows the…

--

net/sched: act_ct: avoid modifying shared unconfirmed ct entry

tcf_ct_act() now resets the skb conntrack association when the cached entry
is unconfirmed and its refcount shows it is shared with another skb, so that
a commit or nat pass cannot grow the extension area of an entry another
clone still points into.  The nat flag is also hoisted into a local
variable.

> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 55f3521edb4c9..e72143d36b119 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c

[ ... ]

> @@ -998,6 +998,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	retval = p->action;
>  	commit = p->ct_action & TCA_CT_ACT_COMMIT;
>  	clear = p->ct_action & TCA_CT_ACT_CLEAR;
> +	nat = p->ct_action & TCA_CT_ACT_NAT;
>  	tmpl = p->tmpl;
>  
>  	tcf_lastuse_update(&c->tcf_tm);
> @@ -1046,6 +1047,19 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	 * different zone.
>  	 */
>  	cached = tcf_ct_skb_nfct_cached(net, skb, p);
> +
> +	/* If the ct entry is not confirmed and shared with some other skb,
> +	 * e.g., a cloned one, we can't just modify it with a commit or nat
> +	 * as we must not modify the extension set.  Reset.
> +	 */
> +	if (cached && (commit || nat)) {
> +		ct = nf_ct_get(skb, &ctinfo);
> +		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
> +			nf_reset_ct(skb);
> +			cached = false;
> +		}
> +	}
> +

[Severity: Medium]
Can this drop NAT state that was already applied to the packet?

The condition keys off nf_ct_shared(ct), i.e. refcount > 1, and not off
whether the sharing skb will ever be re-processed by conntrack.  act_ct
permits nat without commit, and in that case
tcf_ct_act_nat()->nf_ct_nat() (net/netfilter/nf_nat_ovs.c) already
installs the binding and translates the headers on the unconfirmed entry:

net/netfilter/nf_nat_ovs.c:nf_ct_nat() {
	...
	/* Add NAT extension if not confirmed yet. */
	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
		return NF_DROP;   /* Can't NAT. */
	...
	err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
}

If the skb is then cloned by a path that keeps the nfct reference, and a
later filter runs "action ct zone N commit" on the original, the new block
sees cached && commit with an unconfirmed, shared entry, calls
nf_reset_ct(skb) and sets cached = false.  nf_conntrack_in() then re-tracks
the already translated packet, so the entry that gets committed carries the
post-NAT tuple as its ORIGINAL tuple and no matching binding, and reply
traffic is no longer reverse translated.  Before this change the cached,
NAT'ed unconfirmed entry was simply committed.

One note on the trigger: act_mirred and AF_PACKET taps do not produce this
sharing, since both clear the association on the clone:

net/sched/act_mirred.c:tcf_mirred_to_dev() {
	/* All mirred/redirected skbs should clear previous ct info */
	nf_reset_ct(skb_to_send);
}

net/packet/af_packet.c:packet_rcv() {
	/* drop conntrack reference */
	nf_reset_ct(skb);
}

Bridge flood/multicast delivery does keep it, though -
net/bridge/br_forward.c:deliver_clone() calls skb_clone() with no
nf_reset_ct(), so __nf_copy() raises ct_general.use on the clone.

Would it be worth mentioning in the changelog that the reset also fires
when the second pass does commit?  The changelog currently only argues
about the "without commit" case:

    This, however, doesn't really change the picture for sensible
    networking cases as there should be no need to run the same packet
    twice (before and after the clone) through conntrack without packet
    header or zone changes and without commit.

[Severity: Medium]
This is a pre-existing ordering problem and is not introduced by this
patch, but it is worth flagging for backports since the new guard does not
cover it.

At this commit tcf_ct_act() still runs the helper before the commit block
grows the extension area of an unconfirmed entry:

net/sched/act_ct.c:tcf_ct_act() {
	...
	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
		err = nf_ct_helper(skb, ct, ctinfo, family);
		if (err != NF_ACCEPT)
			goto nf_error;
	}

	if (commit) {
		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);

		if (!nf_ct_is_confirmed(ct))
			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
	...
}

A helper that inserts an expectation links exp->lnode into a list head that
lives inside ct->ext:

net/netfilter/nf_conntrack_expect.c:nf_ct_expect_insert() {
	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
}

and the following nf_ct_ext_add(NF_CT_EXT_ACT_CT) relocates that memory:

net/netfilter/nf_conntrack_extend.c:nf_ct_ext_add() {
	new = krealloc(old, alloc, gfp);
}

leaving exp->lnode.pprev pointing into the freed block, which is written
through when the expectation is unlinked via nf_ct_remove_expectations().

The new reset only fires for cached entries with refcount > 1, so an entry
that was just tracked (cached == false), or the replacement entry created
after the reset, still follows the helper-then-realloc sequence with a
single skb reference.

The later patch in this series ("net/sched: act_ct: fix helper UAF due to
extensions realloc") moves nf_ct_helper() after the
nf_conn_act_ct_ext_add() block with the comment "This has to be done after
all the extensions are already added.", so the ordering is resolved within
the series.  Given the stable tag here, should the two patches be marked so
that backporters take the reordering change together with this one?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921145655.3167436-1-i.maximets%40ovn.org
