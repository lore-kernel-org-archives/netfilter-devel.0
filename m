From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: early_drop() possible issue?
Date: Sun, 1 Nov 2009 23:58:32 +0100
Message-ID: <873dce860911011458v7a4f1fe8l93c11c1ecb9af8be@mail.gmail.com>
References: <0016e6d64c234ca84604775639a4@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34902 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKAW62 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:58:28 -0500
Received: by bwz27 with SMTP id 27so5687120bwz.21
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2009 14:58:32 -0800 (PST)
In-Reply-To: <0016e6d64c234ca84604775639a4@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, I re-worked the patch, because it was buggy (ct_general.use was
incremented, not tested).
Here is the (hopefully) correct one:


--- nf_conntrack_core.c	2009-10-23 00:57:56.000000000 +0200
+++ nf_conntrack_core_modded.c	2009-11-01 23:56:23.000000000 +0100
@@ -506,14 +506,12 @@
 		hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[hash],
 					 hnnode) {
 			tmp = nf_ct_tuplehash_to_ctrack(h);
-			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
+			if (!test_bit(IPS_ASSURED_BIT, &tmp->status) &&
likely(!nf_ct_is_dying(ct) &&
+				   atomic_read(&ct->ct_general.use)!=0))
 				ct = tmp;
 			cnt++;
 		}

-		if (ct && unlikely(nf_ct_is_dying(ct) ||
-				   !atomic_inc_not_zero(&ct->ct_general.use)))
-			ct = NULL;
 		if (ct || cnt >= NF_CT_EVICTION_RANGE)
 			break;
 		hash = (hash + 1) % nf_conntrack_htable_size;
@@ -523,6 +521,7 @@
 	if (!ct)
 		return dropped;

+	atomic_inc(&ct->ct_general.use);
 	if (del_timer(&ct->timeout)) {
 		death_by_timeout((unsigned long)ct);
 		dropped = 1;


On Sun, Nov 1, 2009 at 10:48 PM,  <pesce.luca@gmail.com> wrote:
> I noticed that early_drop(), before killing a conntrack, checks if it is
> already dying or
> if its usage count is zero: if one of these two conditions is true, the
> conntrack
> is not killed, which is obviously fine. However, these checks are performed
> outside
> the per-chain loop: if I correctly understand the code, this could lead to
> skip a killable conntrack
> that was before (so more recently used) the least recently used one that is
> already dying.
> For example, consider the case of a hash chain with 10 entries:
>
> - entry number 1 is NOT ASSURED, is not already dying and has ct_general.use
>>=1, so it
> is a good candidate
> - entries from 2 to 9 are ASSURED - not candidates for destroying
> - entry 10 is NOT ASSURED, but is already dying by itself (or has
> ct_general.use==0)
>
> The conntrack examined are only those inside this chain (since 10 >
> NF_CT_EVICTION_RANGE),
> so the chain loop will end with ct pointing to entry number 10, which cannot
> be
> killed. In this way, early_drop() fails to free a hastable entry, while
> entry 1
> was a good candidate.
> This is just one case, but not the only, I think...
> If this analysis is correct, maybe the code should check the dying status
> and the
> usage count together with the assured bit.
> I am attaching the diff coming from this idea.
>
> If I did not correctly understood the code, I am sorry, I apologize for
> that!
>
>
> --- nf_conntrack_core.c 2009-10-23 00:57:56.000000000 +0200
> +++ nf_conntrack_core_modded.c 2009-11-01 22:22:33.000000000 +0100
> @@ -506,14 +506,12 @@
> hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[hash],
> hnnode) {
> tmp = nf_ct_tuplehash_to_ctrack(h);
> - if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
> + if (!test_bit(IPS_ASSURED_BIT, &tmp->status) &&
> unlikely(!nf_ct_is_dying(ct) &&
> + atomic_inc_not_zero(&ct->ct_general.use)))
> ct = tmp;
> cnt++;
> }
>
> - if (ct && unlikely(nf_ct_is_dying(ct) ||
> - !atomic_inc_not_zero(&ct->ct_general.use)))
> - ct = NULL;
> if (ct || cnt >= NF_CT_EVICTION_RANGE)
> break;
> hash = (hash + 1) % nf_conntrack_htable_size;
