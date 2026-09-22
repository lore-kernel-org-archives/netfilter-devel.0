Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9C306776;
	Tue, 22 Sep 2026 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089120; cv=none; b=WaAysXuA4Oq/lZU5hC1YXWDy8KOWwz9cjI9Fet45nUn0J+U1x8l4uohYBSNSyMIyApMqWoMbjLIXITsOhGI3C7AVLoektSBqvJogI9JWsxGhCCrfB+e6QBgacbSHnBE77omJcOs2I+FEDDx/YKh4nwtK+ioCNgBYJNLQeCdsRz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089120; c=relaxed/simple;
	bh=Ol76JU8LRz4JpLTP+Ej//f9mF+QqrTKlXYBgOabJTgs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PBHdYnoWb127a+HPgvOa/IGVEUhjshFtavALi6oHezSuYzpxUDv+fJEHnBo1nOeykeUmIvomvudIpeVxKB/2kvsDOtOMvQzzQ932VjlP9GUgelJocw15WSJi1ENqLlP2aEbJD6g+neuKDdTiBuZn8NV+6fxYO6aKEmdVFc93Gok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZJMbjoX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZJMbjoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285571F00898;
	Tue, 22 Sep 2026 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089119;
	bh=mUH7v4Vcp6Jmy4LjSDXVf2p2NbOhZ5t/YVyUr00tUGM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jZJMbjoXnTf8pFSXgz/DECQ8oygoY8bDzoaRak+BedDA34Bjzgg9/yUVq00rsQt3n
	 T1QDxqi+UxzB6DTnOGDS7AkX/MKRLsanhnxL3U5siIoOfQvbm047sd7oT0pOx8DG3g
	 kyCZFX20fe+fq3y+lnYPhBXveHQIqwQX+ObAzMYPaDShD+xJ87jXvfP1jzp9B/+AkA
	 2G4JgiD28GyRVgbWYz6lGGgJVieyIQHF3gv3KdJoydlDstBruvUPk956U3X2Fkxqm1
	 1h95HMrY3ITIoomJv+YUYuFcMgMfI265sLfbGFUDn+n/K6+BIX61VuEW+3LVP/H/G6
	 eW/7QHzkqkIKw==
Subject: Re: [PATCH net 2/6] net: openvswitch: conntrack: remove 'add_helper'
 dead code
From: netdev-bot+sashiko@kernel.org
To: i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
Date: Tue, 22 Sep 2026 14:58:37 +0000
Message-ID: <179008911774.2160803.5007856848467620850@kernel.org>
In-Reply-To: <20260921145655.3167436-3-i.maximets@ovn.org>
References: <20260921145655.3167436-3-i.maximets@ovn.org>
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

- [Low] Concern: after this patch the comment above the helper call reads
  '- nf_conntrack_in() was executed above ("!cached"), or - When…

--

net: openvswitch: conntrack: remove 'add_helper' dead code

This drops the add_helper variable in __ovs_ct_lookup(), since it is only
ever set for unconfirmed connections while it is only read on the
confirmed branch of the helper-call condition.  The helper-call condition
is simplified to nf_ct_is_confirmed(ct) ? !cached : info->commit.

> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index a733029c28dd0..c20f096eef40e 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c

[ ... ]

> @@ -821,13 +818,10 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  		}
>  
>  		/* Call the helper only if:
> -		 * - nf_conntrack_in() was executed above ("!cached") or a
> -		 *   helper was just attached ("add_helper") for a confirmed
> -		 *   connection, or
> +		 * - nf_conntrack_in() was executed above ("!cached"), or
>  		 * - When committing an unconfirmed connection.
>  		 */
> -		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
> -					      info->commit)) {
> +		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {

[Severity: Low]
This isn't a bug, but does the reworded comment still match the condition?

The first bullet now reads as an unqualified statement:

	/* Call the helper only if:
	 * - nf_conntrack_in() was executed above ("!cached"), or
	 * - When committing an unconfirmed connection.
	 */

while the code only honours "!cached" on the confirmed side of the
ternary:

	if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {

For a non-committing ct() action on a new packet in __ovs_ct_lookup(),
cached is false, the entry returned by nf_ct_get() is not yet confirmed
and info->commit is 0, so nf_ct_helper() is not called even though the
first bullet says it should be.

Worth noting that the following patch in the series, "net: openvswitch:
conntrack: fix helper UAF due to extensions realloc", rewrites both the
comment and the condition to:

	/* Call the helper only if nf_conntrack_in() was executed
	 * above ("!cached").
	 *
	 * For unconfirmed connections it will be called later during
	 * commit as we need to have all the other extensions allocated
	 * before the call.
	 */
	if (nf_ct_is_confirmed(ct) && !cached) {

so the mismatch only exists in this intermediate commit.  Could the
deferral note be pulled into this patch to keep each commit
self-consistent, given this one is tagged for stable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921145655.3167436-1-i.maximets%40ovn.org
