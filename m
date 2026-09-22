Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F95505D0;
	Tue, 22 Sep 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089123; cv=none; b=E1r/DJUcmvzWO0Gnyom7j/atg/dK9fEOMLyhSeRA0EfNpW840V1D82RKDGZiM/Lb287Ne2jU4gE83VdIWmr5QJgxcPz2Bh2uhN7yAu4bXND2BVoPkAB1hh9OZILw9Cmiy3cSJMSx+8kgRdFLICQ6qf8UCdQ3555T+kE6nFuQkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089123; c=relaxed/simple;
	bh=fzHqs63NGI8o75Sd6Odr55ABBX3tXxeFz/gUuJwz35g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QC0lxF+7V4Z7LhNBz4cq+6MiNmMIK61PZZ3+Ym7pbzW6VJFZrOTVymj7RaXHaIY6l3q1w/8rjCHRG3jhasDBjPT8Id8d9dtJhOnDB8Cn3jjV3AVYHpkSrDbUKNJxPv4ljryecxwrcbcEXYUQp8OTap5TKDUlravuaJdw5poYw0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3d8rZPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3d8rZPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF8B1F000FF;
	Tue, 22 Sep 2026 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089120;
	bh=u6KTYkbQclAPbM4tLLukEDyue3dV0gr5VT5nbT0ra3I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=m3d8rZPqdyvxkFdW+wjZy8k384TJAFlMH6W+uWBedptDVpjhbzpkCkrLHj00rzNU4
	 ubIDZGnM1alzIzWyfij/5Wem33NT4kykopjzyEv6NEpZmGKTyoVhP78bgKqnPstpBQ
	 AtXGWL4l11kGv63TO03v6Skz1EkUA2K9mP54I7l69uW91M+lmhfKssddeY+83orUYp
	 n+t30dG2X73pn4vtZA5dQX42u1agvAUAqHxM3cBishEUDiohNIOuRrCfq3h6lS7TIg
	 TjNKmNNoXc+tNeMvYuP6s2WidPokiF8++d/BaU6xki7Z1bwBcktjH+DTs8SzNmtrVr
	 WjRVZbdO/URRg==
Subject: Re: [PATCH net 3/6] net: openvswitch: conntrack: fix helper UAF due
 to extensions realloc
From: netdev-bot+sashiko@kernel.org
To: i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:58:39 +0000
Message-ID: <179008911935.2160803.14933035266780079917@kernel.org>
In-Reply-To: <20260921145655.3167436-4-i.maximets@ovn.org>
References: <20260921145655.3167436-4-i.maximets@ovn.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Inaccurate newly added comment in __ovs_ct_lookup()
  (net/openvswitch/conntrack.c:820-826).

Pre-existing issues:
- [Low] Concern (INVALIDATED by later patch in the same series): the
  identical helper/expectation use-after-free was claimed to remain…

--

net: openvswitch: conntrack: fix helper UAF due to extensions realloc

This moves the nf_ct_helper() call for unconfirmed connections out of
__ovs_ct_lookup() and into ovs_ct_commit(), after the mark, labels and
act_ct extensions have been added, so that a later extension realloc
cannot invalidate the expectation list pointer wired up by the helper.

No Link: tags are present in the commit header.

> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c20f096eef40e..d3326edcabf76 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -817,11 +817,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  			}
>  		}
>  
> -		/* Call the helper only if:
> -		 * - nf_conntrack_in() was executed above ("!cached"), or
> -		 * - When committing an unconfirmed connection.
> +		/* Call the helper only if nf_conntrack_in() was executed
> +		 * above ("!cached").
> +		 *
> +		 * For unconfirmed connections it will be called later during
> +		 * commit as we need to have all the other extensions allocated
> +		 * before the call.
>  		 */
> -		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
> +		if (nf_ct_is_confirmed(ct) && !cached) {

[Severity: Low]
Could this comment be made to match the condition below it?  The text says
the helper is called only if nf_conntrack_in() ran above ("!cached"), but
the guard is:

	if (nf_ct_is_confirmed(ct) && !cached) {

The nf_ct_is_confirmed() term isn't mentioned, which can read as if the
confirmed check were redundant.

The second half of the comment also promises that for unconfirmed
connections the helper "will be called later during commit".  Isn't that
only true for the committing path?  __ovs_ct_lookup() is also reached from
ovs_ct_lookup(), where info->commit is 0 and there is no nf_ct_helper()
call anywhere in that action:

net/openvswitch/conntrack.c:ovs_ct_lookup() {
	...
	err = __ovs_ct_lookup(net, key, info, skb);
	...
}

So for an unconfirmed entry created by nf_conntrack_in() during a plain
ct() lookup action, the helper is simply never run and there is no later
commit to run it.  Behaviour here is the same as before the patch (the old
nf_ct_is_confirmed(ct) ? !cached : info->commit guard skipped it too), so
this is only about the wording of the new comment.

>  			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
>  
>  			err = verdict_to_errno(err);
> @@ -1025,6 +1028,14 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
>  			return err;
>  
>  		nf_conn_act_ct_ext_add(skb, ct, ctinfo);
> +
> +		/* Call the helpers now.  We couldn't do this before as
> +		 * all the extensions must be allocated before the call.
> +		 */
> +		err = nf_ct_helper(skb, ct, ctinfo, info->family);
> +		err = verdict_to_errno(err);
> +		if (err)
> +			return err;

[Severity: Low]
This isn't a bug introduced by this patch, but the same ordering problem
exists in the other in-tree caller of nf_ct_helper(), tcf_ct_act() in
net/sched/act_ct.c, which at this commit runs the helper before the
extension add for unconfirmed entries:

net/sched/act_ct.c:tcf_ct_act() {
	...
	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
		err = nf_ct_helper(skb, ct, ctinfo, family);
	...
	if (commit) {
		tcf_ct_act_set_mark(...);
		tcf_ct_act_set_labels(...);
		if (!nf_ct_is_confirmed(ct))
			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
	...
}

nf_conn_act_ct_ext_add() -> nf_ct_ext_add() -> krealloc() can move ct->ext,
leaving exp->lnode.pprev (which points into nf_conn_help inside the old
ext blob, stored by nf_ct_expect_insert() via
hlist_add_head_rcu(&exp->lnode, &master_help->expectations)) dangling.

Note this is already handled by the later patch in the same series,
"net/sched: act_ct: fix helper UAF due to extensions realloc", which moves
the tcf_ct_act() helper call below the nf_conn_act_ct_ext_add() block, so
no extension-adding call remains after the helper in either caller by the
end of the series.  Mentioned here only for completeness.

>  	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
>  		   labels_nonzero(&info->labels.mask)) {
>  		err = ovs_ct_set_labels(ct, key, &info->labels.value,

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921145655.3167436-1-i.maximets%40ovn.org
