Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A78D4E8E15;
	Wed, 14 Oct 2026 12:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982626; cv=none; b=Q1gO+C09nsiIpqoELH0Fl0cLjogSWsZICbvVR7bczXwWHLFiJx1jY9ywwa/oLMVFasyZ0H/UJzmQo5lFJTfTimr9OUQlC5FsgjSBxCo839sfSqCUwmWB49cmU8tRg0hdaHcCWp4Atj8Hmw6/7GTv2QzdDAvrA1BwzUlxPHRpCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982626; c=relaxed/simple;
	bh=ZlqUrwnlMOYpNHBfdwldXhW+FC3EtFNfIIu/l6ZnSiE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pk7cNenxdwlZ7QCYY5ceZS2QDWOPqJVLw1YJmjDEVcOZMtF+Jybx2ggKuYzxwOOHYO2YURB2GPAI9c+CiuXGJKbtWLX2ar/wUj/eczWoF4ae3r3Se5Q+mZVtvM2UiMVs4JNCCjS3j/aBIFuhMnUp4Qu20poUUlkKK0G48at35lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=SJSBUiLq; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="SJSBUiLq"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4j4WJk3jjNzGFDCt;
	Wed, 14 Oct 2026 14:50:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1791982228; x=1793796629; bh=Bka3a+5gc9
	LmGmyiRJ/S4p4dH9HwrSoei/gNKkl35rg=; b=SJSBUiLqCAiAd44FhldgqaTgQs
	5nLBHqrKVlG+9xvB5nkfyxG+t2V/ATGt1LstYYCa1uFRjxA4aTABZRp0KkHhmL1f
	QC3RgdYRrl/Ewy4MdblvRY7GHzW7ATl0dlvfI4y9mQCUlseOaf7BUyVlzayo97kn
	kIO/IVd4jwP2IDDdE=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id N5TZgdhswmsj; Wed, 14 Oct 2026 14:50:28 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4j4WJg4sNSzGFDCf;
	Wed, 14 Oct 2026 14:50:27 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 9857F340D0D; Wed, 14 Oct 2026 14:50:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 967EB340CFB;
	Wed, 14 Oct 2026 14:50:27 +0200 (CEST)
Date: Wed, 14 Oct 2026 14:50:27 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Xue Boyang <fuchen.dust@gmail.com>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: ipset: fix double free on kernel-side
 delete during resize
In-Reply-To: <20261012163353.4093-1-fuchen.dust@gmail.com>
Message-ID: <8b1c4c41-d371-1901-0f85-f3d0a1dfd033@blackhole.kfki.hu>
References: <20261012163353.4093-1-fuchen.dust@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Mon, 12 Oct 2026, Xue Boyang wrote:

> A kernel-side delete, i.e. a delete triggered by the SET target while
> the set is being resized, is applied to the current table and saved in
> the resize backlog, to be replayed against the new table when the
> resize finished. Both tables share the element extensions: the resize
> copies the element to the new table, keeping the pointer to the
> extension data, e.g. to the comment. Deleting the element in the
> current table calls ip_set_ext_destroy() and releases the shared
> extension. The replay then deletes the copy from the new table and
> releases the same extension again, i.e. the same rcu_head is queued
> twice. With CONFIG_DEBUG_OBJECTS_RCU_HEAD (and slub_debug=F, which
> keeps kfree_rcu() off the sheaf fast path):
>
>  ODEBUG: activate active (active state 1) object type: rcu_head
>  WARNING: lib/debugobjects.c:629 at debug_print_object+0x7b/0x100
>  kvfree_call_rcu(): Double-freed call. rcu_head ffff88810474ce40
>  WARNING: mm/slab_common.c:2041 at kvfree_call_rcu+0x10b/0x140
>  Call Trace:
>   <TASK>
>   debug_object_activate (lib/debugobjects.c:905)
>   kvfree_call_rcu (mm/slab_common.c:2039)
>   hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1226)
>   hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
>   ip_set_del (net/netfilter/ipset/ip_set_core.c:820)
>   set_target_v3 (net/netfilter/xt_set.c:411)
>   ipt_do_table (net/ipv4/netfilter/ip_tables.c:345)
>   nf_hook_slow (net/netfilter/core.c:619)
>   raw_sendmsg (net/ipv4/raw.c:652)
>   __sys_sendto (net/socket.c:2281)
>
> The double free is reachable from an unprivileged user namespace and
> permits local privilege escalation.
>
> Fix this by deferring the delete when a resize is in progress: the
> element is not deleted in the current table, only saved in the backlog,
> like it is done for kernel-side adds. The resize copies the element
> including its extension pointers, and the replayed delete releases the
> extension exactly once. This also avoids updating the cidr counters
> twice for the same element.
>
> Deferred deletes of a failed resize are replayed against the original
> table, which stays the live table, instead of being dropped.

Thank you for your patch! Could you address the issues sashiko raised at 
https://sashiko.dev/#/patchset/20261012163353.4093-1-fuchen.dust%40gmail.com 
about it?

Best regards,
Jozsef

> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xue Boyang <fuchen.dust@gmail.com>
> Assisted-by: LLM DeepSeek-V4.1-Flash
> ---
>
> The reproducer (SET --del-set rule plus a userspace add triggering the
> resize) was run against v7.3-rc5 (mainline tree at 6d25ffca055a):
> before the patch the double free shows up as the warning quoted in the
> commit message and as duplicate objects in the SLUB RCU sheaves; with
> the patch applied it no longer reproduces in repeated runs. The
> reproducer is not attached; it is available and can be shared privately
> upon request. Note: the replay of deferred deletes on a resize abort
> (allocation failure in the copy loop) is covered by review only.
>
> Found with AI assistance (DeepSeek V4.1 Flash, see Assisted-by); the
> patch was reviewed, reproduced and tested by hand.
>
> net/netfilter/ipset/ip_set_hash_gen.h | 48 +++++++++++++++++----------
> 1 file changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 80ca523f304b..d94db604ed6b 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -764,6 +764,7 @@ mtype_resize(struct ip_set *set, bool retried)
> 	struct hbucket *n, *m;
> 	struct list_head *l, *lt;
> 	struct mtype_resize_ad *x;
> +	LIST_HEAD(backlog);
> 	u32 i, j, r, nr, key;
> 	int ret;
>
> @@ -934,13 +935,21 @@ mtype_resize(struct ip_set *set, bool retried)
> 	if (ret == -EAGAIN)
> 		goto retry;
>
> -	/* Cleanup the backlog of ADD/DEL elements */
> +	/* Cleanup the backlog of ADD/DEL elements: kernel-side adds were
> +	 * applied to the original table, which is still the live table,
> +	 * so they are simply dropped. Kernel-side deletes were deferred,
> +	 * replay them against the original table.
> +	 */
> 	spin_lock_bh(&set->lock);
> -	list_for_each_safe(l, lt, &orig->ad) {
> +	list_splice_init(&orig->ad, &backlog);
> +	spin_unlock_bh(&set->lock);
> +	list_for_each_safe(l, lt, &backlog) {
> +		x = list_entry(l, struct mtype_resize_ad, list);
> 		list_del(l);
> -		kfree(l);
> +		if (x->ad == IPSET_DEL)
> +			mtype_del(set, &x->d, NULL, NULL, 0);
> +		kfree(x);
> 	}
> -	spin_unlock_bh(&set->lock);
> 	goto out;
>
> hbwarn:
> @@ -1217,6 +1226,24 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 			goto out;
>
> 		ret = 0;
> +		if (t->resizing && ext && ext->target) {
> +			/* Resize is in process and kernel side del: do not
> +			 * delete the element and free its extensions here,
> +			 * the extensions may be shared with the copy in
> +			 * the new table. Save the values, the resize replays
> +			 * the delete against the new table.
> +			 */
> +			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
> +			if (!x)
> +				/* Don't bother, deleting the element here
> +				 * could free the shared extensions twice.
> +				 */
> +				goto out;
> +			x->ad = IPSET_DEL;
> +			memcpy(&x->d, value, sizeof(struct mtype_elem));
> +			x->flags = flags;
> +			goto out;
> +		}
> 		clear_bit(i, n->used);
> 		smp_mb__after_atomic();
> 		if (i + 1 == pos)
> @@ -1224,19 +1251,6 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 		t->hregion[r].elements--;
> 		mtype_del_cidr_all(set, h, d);
> 		ip_set_ext_destroy(set, data);
> -
> -		if (t->resizing && ext && ext->target) {
> -			/* Resize is in process and kernel side del,
> -			 * save values
> -			 */
> -			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
> -			if (x) {
> -				x->ad = IPSET_DEL;
> -				memcpy(&x->d, value,
> -				       sizeof(struct mtype_elem));
> -				x->flags = flags;
> -			}
> -		}
> 		for (; i < pos; i++) {
> 			if (!test_bit(i, n->used))
> 				k++;
> -- 
> 2.53.0
>
>
