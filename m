Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698695540B6;
	Tue, 22 Sep 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089126; cv=none; b=DLA0jHx+Cpob3uaRS+anZln9WFZ75F7/ACDjJNw4gujw8UZkREweiC5W3cZZnNl3wOsRBWNKuBidOxS2aEky/I8pHgQCInzfHSucrBqHe+eH7USRaB1peQHm3jHFVELr2GMe5mSs68K/6HqN8txc9ugxjPYlhAA4GEANQluRNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089126; c=relaxed/simple;
	bh=AJ946u0VRgEUWbBg+HmIl/K8Mj8X7onJfsKkgLlIAzE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=efUQjllhN6pOJJBmVAAhms8W2IukvbuJ7T6HKx796Dos3/ZDN56zS4HU1XVMnL0FGpG/3dSMDvfqnKupv6NGeYP5ZQetuXN+kjPjMs8hXzsRoTdCGg+0bRM5gjZFPa9lUGwOXKoNowKcneHXTI6oXrh7ibw0544D8f731ZG/B24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4lzPYSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4lzPYSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313A41F00898;
	Tue, 22 Sep 2026 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089124;
	bh=fcNFSQpGPmAHmvVhqh7UJlj6p8NNW5sqxG2eromIL3g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=F4lzPYSUhcyhpSJzcbXpFZhE0tV3HBRa6s4GewfLoTsUBggSPLPpnqN9Em2kCxIkV
	 qc+TBi8aLsovTvHiskeBqAYwpYNH2e2/JZmCHUKvdq+2m0XHYNHf3bF8nT5RV/jCUS
	 wfz0erap0pPCZwxGQJ0vm1eR6F/fUkJq388YMbh2HKuCKH7GlIbsR4h/l8BNWyTYuk
	 6KpthiKF/MzWja+2jLMP7UyPlsHuWRjEpMq0pSJSjDPFXLeGBl9OZjm+B7nabAGhHN
	 TULorbzFbsjvZM+wQwbnitrfEhzBZhxaZPhPv4K43zK/S5jc3iYXg73kDt5W774Ygy
	 jY2ODarXxGJrg==
Subject: Re: [PATCH net 6/6] net/sched: act_ct: fix helper UAF due to
 extensions realloc
From: netdev-bot+sashiko@kernel.org
To: i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:58:42 +0000
Message-ID: <179008912273.2160803.18168154192973334378@kernel.org>
In-Reply-To: <20260921145655.3167436-7-i.maximets@ovn.org>
References: <20260921145655.3167436-7-i.maximets@ovn.org>
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

- [Low] Comment vs. code mismatch introduced by this patch in
  tcf_ct_act() (net/sched/act_ct.c:1113-1117).

--

net/sched: act_ct: fix helper UAF due to extensions realloc

This moves the nf_ct_helper() call in tcf_ct_act() to after the mark,
labels and act_ct extension updates, so that no further extension
reallocation can happen once a helper has wired a raw pointer to the
extension area into the expectations list.  The executable condition
guarding the helper call is unchanged, only relocated.

> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f62051ec9d57d..411e3dd92d072 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1102,19 +1102,25 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		}
>  	}
>  
> -	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
> -		err = nf_ct_helper(skb, ct, ctinfo, family);
> -		if (err != NF_ACCEPT)
> -			goto nf_error;
> -	}
> -
>  	if (commit) {
>  		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
>  		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
>  
>  		if (!nf_ct_is_confirmed(ct))
>  			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
> +	}
>  
> +	/* Run helpers for the connection if nf_conntrack_in() was executed
> +	 * or if we're about to commit.  This has to be done after all the
> +	 * extensions are already added.
> +	 */
> +	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {

[Severity: Low]
Does the new comment match the condition it annotates?  The prose reads as
an unconditional "or", but the ternary below it skips the helper in both of
those cases in some configurations.

First packet through a non-committing ct action: tcf_ct_skb_nfct_cached()
misses so cached is false, nf_conntrack_in() runs and creates an
unconfirmed ct, and then:

	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {

takes the commit branch, which is false here, so the helper is not called
even though nf_conntrack_in() was executed.

Recirculation case: a previous ct action already confirmed the entry, and a
later committing ct action in the same zone hits the cached path, so
nf_ct_is_confirmed(ct) is true and !cached is false.  The helper is not
called even though we are about to commit.

The peer call site of the same nf_ct_helper() API words it in a way that
matches the code, in __ovs_ct_lookup() in net/openvswitch/conntrack.c:

	/* Call the helper only if nf_conntrack_in() was executed
	 * above ("!cached").
	 *
	 * For unconfirmed connections it will be called later during
	 * commit as we need to have all the other extensions allocated
	 * before the call.
	 */
	if (nf_ct_is_confirmed(ct) && !cached) {

Since this patch is about the ordering contract between nf_ct_helper() and
the extension allocations, could the comment be reworded along the same
lines, so the two in-tree descriptions of the same contract agree?

> +		err = nf_ct_helper(skb, ct, ctinfo, family);
> +		if (err != NF_ACCEPT)
> +			goto nf_error;
> +	}
> +
> +	if (commit) {
>  		/* This will take care of sending queued events
>  		 * even if the connection is already confirmed.
>  		 */

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921145655.3167436-1-i.maximets%40ovn.org
