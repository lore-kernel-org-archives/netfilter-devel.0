Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792937259;
	b=POd+ItlFS7VzqRfdyWeA5jT2C69V4+7giGbTF3F8B2TeJLZpT2WdAQYduRycEjBHDTq2
	 MYOVSMdnexqlb6vVO2E0E3h35PeiEtXbySMxQxQUXygzGIPUrLE8C4pmRYmdvNr6q+PCW
	 3q3jUPOePnQ2WiRGrwZnRYoGiCoqLi/F2z9CxOaAZHT9k1gsnovhNlqAUdmnkKFcSN6gb
	 KI+Nt1uQ8jny7j39bG+dMT1QKfx8b05JE4yiMSk1jHqk9J3xjfm6EwSO1gxWeSQjJKwGf
	 gBGtH8fnIprgpV88gKdzNDM08LSX26iqaErPhXZjJxmAXRexXYg8PDsMa29DCrM3qXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792937259;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nwo3NYlls8cyar7A+KG0JtYLr0c2wn1Lw0JyofWgGxI=;
	b=xg3XxHw5AQl4cylYBtfMeUYQjPCvL3rLCZpH68Cen7fZVpUOSRi4kzm01kAFr/SrHnPw
	 +G0uznCKsepMWPhApBpZfaiBei32LcwNz5gaHqwiHVLULB344QSwm3MyC4SonX07FjEEp
	 tX7pcuHFO3n+X+5hSuXaJUK5A3gK+rLnfqCjBqJS7rGMBoJhK4p9S+qDRlshBI+Mq2Aac
	 0UlXLq6zx3Pz3D7UG8CGRGxngONFMWTEP6pzQt9X8L0o13BaDiScyDyk9cIaZ8xlIiwLq
	 crRU6SgJG1n7j79b3G0950hVOvpti0BGhJS3McNI6GUL6Q7nocjb4jur1pCU9wdI5Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SlUUBPTN;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787E4606A31B
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 14:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 787E4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SlUUBPTN
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-398b3c37877so1249366a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 07:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792937259; x=1793542059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwo3NYlls8cyar7A+KG0JtYLr0c2wn1Lw0JyofWgGxI=;
        b=SlUUBPTNj/UpNQiL1vlrRsgD7o7sPLtC66LWqGxP3q5zpSmtns3oLq/5tLtKxqlrsP
         zx9nwz6OqL4RBTnzp9Z1ZQYFXoukssrfoUVgJwA4wY3s2Usu7wkfLv9pIYKTt7Vh4eDh
         3J3rixsKv+qllsJXnhbYZWrIMaySOBMf15t+9e/bP5jA427RQkckQGt4kPMOZYidt0Is
         vGftN0CRjIty26pnwzwQwfKbbe+977UHFHXMCRbRQ8lN9Ae3NlY/wrfGkPJFviov/D9A
         LckF40meGnel6o7bI19tuwCxaFxPPbU8/Rtk5Yifbi5HaQFuI/eJguGJi5lIU5gqU1VA
         eKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792937259; x=1793542059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwo3NYlls8cyar7A+KG0JtYLr0c2wn1Lw0JyofWgGxI=;
        b=vYZSOmQ/kKdTB41DyG8j5MZQeScT3HFI49QmUM1aIrJ5bIJ6nXGVpnEShvK66egh36
         h+qjy+xJjkDaail+3La62FQAl5AFC6gQ7oQaj8bxXlbKHLA3hOTOt93mlpT7HxBv92Q7
         7QIaygjBtIedQU7b9exIBqqRgVTzkiuikcT4kQouyxRET0Pda9t2u30VbL2vmRVEjs7f
         v9yX+S1hZ9JkMTbWGh7lttX3/qI9lEWr7OoatHPIYC7z9L8H3V9mzlKNctyy8tU49KIQ
         7l3nT7Eme5IMBRLfToMYN5rYfZcLc6wR7JIvjDW9so9PHDAA3cWnES+FBCVgQePC7s7b
         fuhg==
X-Gm-Message-State: AFq9FYItnRlW6WYyDJaB3OUUO9rkE/7iCv9wnGpmo8Ub170yxy0tx5//
	5vrvot0E7iz1ISa/HSbSpwhdGs6fB4HtOJ5TsITRHGYHMXLNEiZUZqRY1AMmYfDQQGk=
X-Gm-Gg: AYBFou3JJdCi/hCAIM25qVSCRCv6HQjpXq5t3oJ7frjY1igCHvn7gg6rZqV/IptWkUc
	ZCx9XcbNEwJES/eTRGLvl+xZKrULFEtn9+HgfTdGeuwkROSFjU9E6N4dF4bxkcZQaZhg7ey45R5
	IQo6hpg5x7lSFIaVkFiUJN1B0/6PT6LJyMCvlZZsCY8Qyfg2sRasNZhFACJxz3cth+TRvI9aUaM
	2rdnbP5WT2iORx4eyg9qHFU1OfBkdXc6v6R4pu7A9zChQqHRSHW7/0fC1d7tltPmJdKSFdTvZn5
	eGQLMLtTWAn0V+sgv1e0Ho87HRa765GpBrLwPiiNBkjYimEGSuiaERzaPTS3pVcXRVCYOk0ilwG
	tZPowSdlzh98npqIIZRGHRyubYoduD0mRB+npZff7tdDa5L+bp1krL8cZ4i81C1qW4ffbdBmiU0
	EET3Zw04eirmV0OR/RUeAFfkcGh4QGmg/swJsfLkpRaUe9ouEiSBfx348z+b9I8WHYv9xFUy+2n
	m6dW3CJ3tCHunaslwc3Nt5hCsWgWwCa9CjEJCi/RUdKxvsuZpILA6lk
X-Received: by 2002:a17:90b:4cd1:b0:3a8:1943:cb7a with SMTP id 98e67ed59e1d1-3adead44808mr3477817a91.18.1792937258609;
        Sun, 25 Oct 2026 07:07:38 -0700 (PDT)
Received: from gmail.com ([240e:469:849:35a9:20c:29ff:feb3:e631])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe9078asm5038210a91.10.2026.10.25.07.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 07:07:37 -0700 (PDT)
From: Xue Boyang <fuchen.dust@gmail.com>
To: kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phil@nwl.cc,
	Xue Boyang <fuchen.dust@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v2] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Sun, 25 Oct 2026 09:07:29 -0500
Message-ID: <20261025140729.5152-1-fuchen.dust@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025090609.v2reply.4093.fuchen.dust@gmail.com>
References: <20261025090609.v2reply.4093.fuchen.dust@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A kernel-side delete, i.e. a delete triggered by the SET target while
the set is being resized, is applied to the current table and saved in
the resize backlog, to be replayed against the new table when the
resize finished. Both tables share the element extensions: the resize
copies the element to the new table, keeping the pointer to the
extension data, e.g. to the comment. Deleting the element in the
current table calls ip_set_ext_destroy() and releases the shared
extension. The replay then deletes the copy from the new table and
releases the same extension again, i.e. the same rcu_head is queued
twice. With CONFIG_DEBUG_OBJECTS_RCU_HEAD (and slub_debug=F, which
keeps kfree_rcu() off the sheaf fast path):

  ODEBUG: activate active (active state 1) object type: rcu_head
  WARNING: lib/debugobjects.c:629 at debug_print_object+0x7b/0x100
  kvfree_call_rcu(): Double-freed call. rcu_head ffff88810474ce40
  WARNING: mm/slab_common.c:2041 at kvfree_call_rcu+0x10b/0x140
  Call Trace:
   <TASK>
   debug_object_activate (lib/debugobjects.c:905)
   kvfree_call_rcu (mm/slab_common.c:2039)
   hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1226)
   hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
   ip_set_del (net/netfilter/ipset/ip_set_core.c:820)
   set_target_v3 (net/netfilter/xt_set.c:411)
   ipt_do_table (net/ipv4/netfilter/ip_tables.c:345)
   nf_hook_slow (net/netfilter/core.c:619)
   raw_sendmsg (net/ipv4/raw.c:652)
   __sys_sendto (net/socket.c:2281)

The double free is reachable from an unprivileged user namespace and
permits local privilege escalation.

Fix this by deferring the delete when a resize is in progress: the
element is not deleted in the current table, only saved in the backlog,
like it is done for kernel-side adds. The resize copies the element
including its extension pointers, and the replayed delete releases the
extension exactly once. This also avoids updating the cidr counters
twice for the same element.

Clearing the used bit of the deferred delete instead is not an option:
the extension of an element the resize copy loop has not reached yet
would never be freed, the old table is destroyed with ext_destroy=false
to protect the extensions shared with the copied elements. The element
thus stays in the current table until the resize completes, so

- a kernel-side add of such an element must be deferred too, otherwise
  it is rejected with -EEXIST and lost, and the replayed delete removes
  the element for good, leaving the set without an element the last
  packet-path operation added;

- the backlog must keep the arrival order of the operations: deferred
  deletes are queued with list_add_tail() like the deferred adds, so an
  add followed by a delete of the same element is not replayed the
  other way around, resurrecting the element.

A resize which is aborted before the new table is in place replays the
backlog against the original table, which stays the live table, instead
of dropping it. This covers the allocation failure in the copy loop and
the early exits of a retry after -EAGAIN, which inherits the backlog of
the previous attempt: the deferred deletes are the only record of the
delete there, dropping them would leave elements in the set which the
packet path believes deleted, and the backlog entries would leak.

The deferred delete reports -ENOMEM when the backlog entry cannot be
allocated, instead of returning success without deleting anything.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: Xue Boyang <fuchen.dust@gmail.com>
Assisted-by: LLM DeepSeek-V4.1-Flash
---

Changes in v2, addressing the review of v1 linked in
https://sashiko.dev/#/patchset/20261012163353.4093-1-fuchen.dust%40gmail.com :

- Defer the kernel-side add of an element still present in the current
  table during the resize ("missing clear_bit() breaks operation
  ordering during resize"). The add was rejected with -EEXIST without
  being queued, so an add following a deferred delete was lost and the
  replayed delete removed the element.

- Replay the backlog on all resize failure exits, not only on the
  allocation failure in the copy loop ("memory leak of deferred
  operations on resize failure"). The exact path claimed there, an
  allocation failure of the first attempt, exits before the table is
  marked resizing and the backlog is empty; the leak is real however
  for the early exits of a retry after -EAGAIN, which inherits a
  non-empty backlog from the previous attempt.

- Queue the deferred deletes with list_add_tail() ("backlog replay
  ordering during resize resurrects deleted elements"). The prepend
  predates this patch, but the fix relies on the backlog preserving
  the arrival order, so all deferred operations are now queued FIFO
  and the failure path replays the full backlog in order instead of
  dropping the deferred adds.

- Report -ENOMEM when the deferred delete cannot allocate its backlog
  entry.

The "memory leak of extensions for expired elements" concern is
preexisting (the resize copy loop skips expired elements and the table
destroy keeps ext_destroy=false) and is not addressed here.

The reproducer (SET --del-set rule plus a userspace add triggering the
resize) was run against v7.3-rc5 (mainline tree at 6d25ffca055a):
before the patch the double free shows up as the warning quoted in the
commit message and as duplicate objects in the SLUB RCU sheaves; with
the patch applied it no longer reproduces in repeated runs. The
reproducer is not attached; it is available and can be shared privately
upon request. The ordering of the deferred operations and the replay of
the backlog were verified with a packet-path del+add / add+del
regression test racing continuous resizes: v1 shows the lost add and
the resurrected element, v2 shows neither in repeated runs.

Found with AI assistance (DeepSeek V4.1 Flash, see Assisted-by); the
patch was reviewed, reproduced and tested by hand.
---
 net/netfilter/ipset/ip_set_hash_gen.h | 77 +++++++++++++++++++--------
 1 file changed, 56 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..f24c51d489e2 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -764,6 +764,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct hbucket *n, *m;
 	struct list_head *l, *lt;
 	struct mtype_resize_ad *x;
+	LIST_HEAD(backlog);
 	u32 i, j, r, nr, key;
 	int ret;
 
@@ -786,13 +787,13 @@ mtype_resize(struct ip_set *set, bool retried)
 	t = ip_set_alloc(hsize);
 	if (!t) {
 		ret = -ENOMEM;
-		goto out;
+		goto drain;
 	}
 	t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
 	if (!t->hregion) {
 		ip_set_free(t);
 		ret = -ENOMEM;
-		goto out;
+		goto drain;
 	}
 	t->htable_bits = htable_bits;
 	t->maxelem = h->maxelem / ahash_numof_locks(htable_bits);
@@ -934,20 +935,34 @@ mtype_resize(struct ip_set *set, bool retried)
 	if (ret == -EAGAIN)
 		goto retry;
 
-	/* Cleanup the backlog of ADD/DEL elements */
+drain:
+	/* Cleanup the backlog of ADD/DEL elements: replay them in arrival
+	 * order against the original table, which is still the live table.
+	 * Kernel-side adds of elements still present are no-ops, the
+	 * deferred deletes remove the elements. This is also reached when
+	 * the resize fails early, e.g. on allocation failure in a retry
+	 * after -EAGAIN: the backlog may still hold deferred operations
+	 * from the previous attempt.
+	 */
 	spin_lock_bh(&set->lock);
-	list_for_each_safe(l, lt, &orig->ad) {
+	list_splice_init(&orig->ad, &backlog);
+	spin_unlock_bh(&set->lock);
+	list_for_each_safe(l, lt, &backlog) {
+		x = list_entry(l, struct mtype_resize_ad, list);
 		list_del(l);
-		kfree(l);
+		if (x->ad == IPSET_ADD)
+			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
+		else
+			mtype_del(set, &x->d, NULL, NULL, 0);
+		kfree(x);
 	}
-	spin_unlock_bh(&set->lock);
 	goto out;
 
 hbwarn:
 	/* In case we have plenty of memory :-) */
 	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
 	ret = -IPSET_ERR_HASH_FULL;
-	goto out;
+	goto drain;
 }
 
 /* Get the current number of elements and ext_size in the set  */
@@ -1053,6 +1068,19 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				j = i;
 				goto overwrite_extensions;
 			}
+			if (t->resizing && ext && ext->target) {
+				/* Resize is in progress and kernel side add
+				 * of an existing element: the element may
+				 * have a deferred delete pending in the
+				 * backlog and it is going to be copied to
+				 * the new table, sharing the extensions.
+				 * Defer the add too, so that the replay of
+				 * the backlog after resize keeps the order
+				 * of the operations.
+				 */
+				ret = 0;
+				goto resize;
+			}
 			ret = -IPSET_ERR_EXIST;
 			goto unlock;
 		}
@@ -1217,6 +1245,26 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			goto out;
 
 		ret = 0;
+		if (t->resizing && ext && ext->target) {
+			/* Resize is in process and kernel side del: do not
+			 * delete the element and free its extensions here,
+			 * the extensions may be shared with the copy in
+			 * the new table. Save the values, the resize replays
+			 * the delete against the new table.
+			 */
+			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
+			if (!x) {
+				/* Don't bother, deleting the element here
+				 * could free the shared extensions twice.
+				 */
+				ret = -ENOMEM;
+				goto out;
+			}
+			x->ad = IPSET_DEL;
+			memcpy(&x->d, value, sizeof(struct mtype_elem));
+			x->flags = flags;
+			goto out;
+		}
 		clear_bit(i, n->used);
 		smp_mb__after_atomic();
 		if (i + 1 == pos)
@@ -1224,19 +1272,6 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		t->hregion[r].elements--;
 		mtype_del_cidr_all(set, h, d);
 		ip_set_ext_destroy(set, data);
-
-		if (t->resizing && ext && ext->target) {
-			/* Resize is in process and kernel side del,
-			 * save values
-			 */
-			x = kzalloc_obj(struct mtype_resize_ad, GFP_ATOMIC);
-			if (x) {
-				x->ad = IPSET_DEL;
-				memcpy(&x->d, value,
-				       sizeof(struct mtype_elem));
-				x->flags = flags;
-			}
-		}
 		for (; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				k++;
@@ -1273,7 +1308,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	spin_unlock_bh(&t->hregion[r].lock);
 	if (x) {
 		spin_lock_bh(&set->lock);
-		list_add(&x->list, &t->ad);
+		list_add_tail(&x->list, &t->ad);
 		spin_unlock_bh(&set->lock);
 	}
 	if (atomic_dec_and_test(&t->uref) && t->resizing) {
-- 
2.53.0

