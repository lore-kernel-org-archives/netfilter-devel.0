Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiATMHW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiATMHW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 07:07:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003AAC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 04:07:21 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nAWDo-0002kv-FK; Thu, 20 Jan 2022 13:07:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] netfilter: conntrack: hande ->destroy hook via nat_ops instead
Date:   Thu, 20 Jan 2022 13:07:01 +0100
Message-Id: <20220120120702.15939-4-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220120120702.15939-1-fw@strlen.de>
References: <20220120120702.15939-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nat module already exposes a few functions to the conntrack core.
Move the nat extension destroy hook to it.

After this, no conntrack extension needs a destroy hook.
'struct nf_ct_ext_type' and the register/unregister api can be removed
in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h                   |  1 +
 include/net/netfilter/nf_conntrack_extend.h |  3 ---
 net/netfilter/nf_conntrack_core.c           | 14 ++++++++++++--
 net/netfilter/nf_conntrack_extend.c         | 21 ---------------------
 net/netfilter/nf_nat_core.c                 | 13 +++----------
 5 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 15e71bfff726..c2c6f332fb90 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -379,6 +379,7 @@ struct nf_nat_hook {
 	unsigned int (*manip_pkt)(struct sk_buff *skb, struct nf_conn *ct,
 				  enum nf_nat_manip_type mtype,
 				  enum ip_conntrack_dir dir);
+	void (*remove_nat_bysrc)(struct nf_conn *ct);
 };
 
 extern const struct nf_nat_hook __rcu *nf_nat_hook;
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 87d818414092..343f9194423a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -79,9 +79,6 @@ void nf_ct_ext_destroy(struct nf_conn *ct);
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
 struct nf_ct_ext_type {
-	/* Destroys relationships (can be NULL). */
-	void (*destroy)(struct nf_conn *ct);
-
 	enum nf_ct_ext_id id;
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e301227eabcb..e7530aba5680 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -593,7 +593,7 @@ EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
 
 void nf_ct_tmpl_free(struct nf_conn *tmpl)
 {
-	nf_ct_ext_destroy(tmpl);
+	kfree(tmpl->ext);
 
 	if (ARCH_KMALLOC_MINALIGN <= NFCT_INFOMASK)
 		kfree((char *)tmpl - tmpl->proto.tmpl_padto);
@@ -1596,7 +1596,17 @@ void nf_conntrack_free(struct nf_conn *ct)
 	 */
 	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
-	nf_ct_ext_destroy(ct);
+	if (ct->status & IPS_SRC_NAT_DONE) {
+		const struct nf_nat_hook *nat_hook;
+
+		rcu_read_lock();
+		nat_hook = rcu_dereference(nf_nat_hook);
+		if (nat_hook)
+			nat_hook->remove_nat_bysrc(ct);
+		rcu_read_unlock();
+	}
+
+	kfree(ct->ext);
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	cnet = nf_ct_pernet(net);
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 69a6cafcb045..6b772b804ee2 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -89,27 +89,6 @@ static __always_inline unsigned int total_extension_size(void)
 	;
 }
 
-void nf_ct_ext_destroy(struct nf_conn *ct)
-{
-	unsigned int i;
-	struct nf_ct_ext_type *t;
-
-	for (i = 0; i < NF_CT_EXT_NUM; i++) {
-		rcu_read_lock();
-		t = rcu_dereference(nf_ct_ext_types[i]);
-
-		/* Here the nf_ct_ext_type might have been unregisterd.
-		 * I.e., it has responsible to cleanup private
-		 * area in all conntracks when it is unregisterd.
-		 */
-		if (t && t->destroy)
-			t->destroy(ct);
-		rcu_read_unlock();
-	}
-
-	kfree(ct->ext);
-}
-
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2ff20d6a5afb..8cc31d695e36 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -838,7 +838,7 @@ static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
-static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
+static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
 	unsigned int h;
 
@@ -860,7 +860,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	 * will delete entry from already-freed table.
 	 */
 	if (test_and_clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status))
-		__nf_nat_cleanup_conntrack(ct);
+		nf_nat_cleanup_conntrack(ct);
 
 	/* don't delete conntrack.  Although that would make things a lot
 	 * simpler, we'd end up flushing all conntracks on nat rmmod.
@@ -868,15 +868,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	return 0;
 }
 
-/* No one using conntrack by the time this called. */
-static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
-{
-	if (ct->status & IPS_SRC_NAT_DONE)
-		__nf_nat_cleanup_conntrack(ct);
-}
-
 static struct nf_ct_ext_type nat_extend __read_mostly = {
-	.destroy	= nf_nat_cleanup_conntrack,
 	.id		= NF_CT_EXT_NAT,
 };
 
@@ -1171,6 +1163,7 @@ static const struct nf_nat_hook nat_hook = {
 	.decode_session		= __nf_nat_decode_session,
 #endif
 	.manip_pkt		= nf_nat_manip_pkt,
+	.remove_nat_bysrc	= nf_nat_cleanup_conntrack,
 };
 
 static int __init nf_nat_init(void)
-- 
2.34.1

