Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FB24ACC94
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822845; cv=none; b=fIb9rpSGQfiGZ//EOs3TpBeLx0TolNol72YcwE4nK3dFcLz8aLrTEqaArcpbmcidgrA0Q2bxEnznrhD3NcEm1PnNnycBJxQJ16NsFbIMGlWoEdm9uOMXfhKknfGJ/15TI3Ux022dkvCqhOLIkxiRMafCjc/dLMF6MwMnBIToZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822845; c=relaxed/simple;
	bh=x1uaBw5wT1DlCiJN3TUvm+ZpFcYJZW69lfwQPrMaZik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bHs0C0DGct/3xCf2CtmVlk91wliir6R0lNpZfuMA/7F0LJ5sJoe+J8vUdi6KMn9VN/zKayDgrCO+ohSAJrDcEl8K9LfCpXQeGjHLiomu9c/T+K5jtNVMwgpEbUnFMH1ukr708nlASfAUXvimW0b0GRo+65QVx6OgLJJjFi/yaTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ktab8bdo; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ktab8bdo"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1c9879395so593210a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2026 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791822843; x=1792427643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7zZQz09e2z7LLltXs9Z13zt+x6jsBC1fIjhxWSY3rxM=;
        b=Ktab8bdo/0Xpu28k2F5UBQ9yxwTtyjPjBz30iLIHGZJN3vhLIpHUix8qw++05s9ZQs
         59HDNUW2DeZG/aG/b0RLPVxFFxf96e+hnFE2gfzKX4F5WN2PE6cmyABgfPoRvEpvsx1W
         UbTKn8o7Ze5o+cYqF+deKfeh2ry4RmbwGKEGjXyKc1s1G4ufky/XuYLQxVeTlrpBrUkP
         wUTIM8NXef2z/B/cvCtJ5ZOfS43v2sGIb78OgCiYJURGgnNbkgWCVPEiIS02DyyxblBa
         l4iq7BUPhjK4Tt9v3eHpPc7JlPazTpzIOVxCD+4GCGbbTzB+kTmoZ/J68gA6zhsWpOBi
         /zCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822843; x=1792427643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zZQz09e2z7LLltXs9Z13zt+x6jsBC1fIjhxWSY3rxM=;
        b=cDXhCchbPc6KA3HlQTL255maiQ1ASXkdQJDP89hc/EzNI7GZPcPBkqJ590xK5Md6nH
         nyz9JH22g4lYPz/OpmO7q4Ba/jUKf3ftzjljmTVfVu23X15+BoVZso4ZQK0J8Cdk0ugt
         4lAUW3JxnbyIEEWS7UfhI54ql+IbUcjAKujxNmtISuLxdxAu1SIEy1O3TZ5Y6Kf2kXVz
         CTABWcMSM/AQzJna4nZA1Gr2e+eV9BujeRjX5PjysMn+MuvM7xZQ0omSNyVrZ917LgyT
         m237TyzkI43ESX5HHXfvq/UatOusmiLQ67DUwwLXlag4mOraad6Y88i6zltALXUKhNsz
         EZsw==
X-Gm-Message-State: AFq9FYKlauGMT0AJuTfIv7VX5WplAJSqMfwlEL02l7WjhdL8uXcVFFFA
	8GOV4RdSEfeAaLKb/f3Nl5m8O9xl25a/kpXP3f4qPF9R7NMD72ihBfLSbd1v0nWoE6noOw==
X-Gm-Gg: AYBFou1cbBctXUYwHdqpNif7TxIrfNszVwZZk6Z3ehMlg6djIZqKI/AjXT76x7jyztm
	osqlfvTg2R+i8uICL/1p49j33v2FKKJLcyRxFBGRKenHbzuTmfFLQaAj2aXDo2BFsmn0QEIM5En
	A8FJvD5TF/a7kPOnHovixqiDBer/RHs+vYFikKsKo6sNvhpcTcr07MOvZj5GHpnDLHyeEBS8K0V
	utpFPLcyszx7gpyyDniCQy2VDto9nX9rNGuOoeUWux9d9OfpzrHYCXWHfDY8OVJkSn2/AwZRSSV
	azDibuvMEMJ0m5Sm9g9sf3tr7SqNEd/PHRhiFnjTIlXfzugioZyU5d1yvyWpFqTd2yGttmdky9/
	XnvePND1TKB1ZCPJCUYX/EjVlX0baa17nohVvnlofLCBpHEmfW7EJ5SLxp/B9B4LQOPsmOz6n/7
	smyWuqJ+Il1NMeZb7qhf44NOy2CrkzmiRA3zScbilBIv4kWSFxOKp2cfT3A9fXwoEh3hmxLmg=
X-Received: by 2002:a05:6a21:7d0b:b0:3d1:c99f:efbf with SMTP id adf61e73a8af0-3e16be892f4mr8693216637.14.1791822843291;
        Mon, 12 Oct 2026 09:34:03 -0700 (PDT)
Received: from gmail.com ([116.162.234.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e0816csm4857340a12.7.2026.10.12.09.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:34:01 -0700 (PDT)
From: Xue Boyang <fuchen.dust@gmail.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf] netfilter: ipset: fix double free on kernel-side delete during resize
Date: Mon, 12 Oct 2026 11:33:53 -0500
Message-ID: <20261012163353.4093-1-fuchen.dust@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
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

Deferred deletes of a failed resize are replayed against the original
table, which stays the live table, instead of being dropped.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: Xue Boyang <fuchen.dust@gmail.com>
Assisted-by: LLM DeepSeek-V4.1-Flash
---

The reproducer (SET --del-set rule plus a userspace add triggering the
resize) was run against v7.3-rc5 (mainline tree at 6d25ffca055a):
before the patch the double free shows up as the warning quoted in the
commit message and as duplicate objects in the SLUB RCU sheaves; with
the patch applied it no longer reproduces in repeated runs. The
reproducer is not attached; it is available and can be shared privately
upon request. Note: the replay of deferred deletes on a resize abort
(allocation failure in the copy loop) is covered by review only.

Found with AI assistance (DeepSeek V4.1 Flash, see Assisted-by); the
patch was reviewed, reproduced and tested by hand.

 net/netfilter/ipset/ip_set_hash_gen.h | 48 +++++++++++++++++----------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..d94db604ed6b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -764,6 +764,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct hbucket *n, *m;
 	struct list_head *l, *lt;
 	struct mtype_resize_ad *x;
+	LIST_HEAD(backlog);
 	u32 i, j, r, nr, key;
 	int ret;
 
@@ -934,13 +935,21 @@ mtype_resize(struct ip_set *set, bool retried)
 	if (ret == -EAGAIN)
 		goto retry;
 
-	/* Cleanup the backlog of ADD/DEL elements */
+	/* Cleanup the backlog of ADD/DEL elements: kernel-side adds were
+	 * applied to the original table, which is still the live table,
+	 * so they are simply dropped. Kernel-side deletes were deferred,
+	 * replay them against the original table.
+	 */
 	spin_lock_bh(&set->lock);
-	list_for_each_safe(l, lt, &orig->ad) {
+	list_splice_init(&orig->ad, &backlog);
+	spin_unlock_bh(&set->lock);
+	list_for_each_safe(l, lt, &backlog) {
+		x = list_entry(l, struct mtype_resize_ad, list);
 		list_del(l);
-		kfree(l);
+		if (x->ad == IPSET_DEL)
+			mtype_del(set, &x->d, NULL, NULL, 0);
+		kfree(x);
 	}
-	spin_unlock_bh(&set->lock);
 	goto out;
 
 hbwarn:
@@ -1217,6 +1226,24 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
+			if (!x)
+				/* Don't bother, deleting the element here
+				 * could free the shared extensions twice.
+				 */
+				goto out;
+			x->ad = IPSET_DEL;
+			memcpy(&x->d, value, sizeof(struct mtype_elem));
+			x->flags = flags;
+			goto out;
+		}
 		clear_bit(i, n->used);
 		smp_mb__after_atomic();
 		if (i + 1 == pos)
@@ -1224,19 +1251,6 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
-- 
2.53.0

