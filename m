Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B8FECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E4B721848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 13:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfJONPi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 09:15:38 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43596 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729551AbfJONPh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 09:15:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iKMfn-0003l7-P3; Tue, 15 Oct 2019 15:15:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: conntrack: free extension area immediately
Date:   Tue, 15 Oct 2019 15:19:15 +0200
Message-Id: <20191015131915.28385-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191015131915.28385-1-fw@strlen.de>
References: <20191015131915.28385-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of waiting for rcu grace period just free it directly.

This is safe because conntrack lookup doesn't consider extensions.

Other accesses happen while ct->ext can't be free'd, either because
a ct refcount was taken or because the conntrack hash bucket lock or
the dying list spinlock have been taken.

This allows to remove __krealloc in a followup patch, netfilter was the
only user.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h | 10 ----------
 net/netfilter/nf_conntrack_core.c           |  2 --
 net/netfilter/nf_conntrack_extend.c         | 21 ++++++++++-----------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 112a6f40dfaf..5ae5295aa46d 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -43,7 +43,6 @@ enum nf_ct_ext_id {
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
-	struct rcu_head rcu;
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
 	char data[0];
@@ -72,15 +71,6 @@ static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 /* Destroy all relationships */
 void nf_ct_ext_destroy(struct nf_conn *ct);
 
-/* Free operation. If you want to free a object referred from private area,
- * please implement __nf_ct_ext_free() and call it.
- */
-static inline void nf_ct_ext_free(struct nf_conn *ct)
-{
-	if (ct->ext)
-		kfree_rcu(ct->ext, rcu);
-}
-
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120b2db2..bcccaa7ec34c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -573,7 +573,6 @@ EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
 void nf_ct_tmpl_free(struct nf_conn *tmpl)
 {
 	nf_ct_ext_destroy(tmpl);
-	nf_ct_ext_free(tmpl);
 
 	if (ARCH_KMALLOC_MINALIGN <= NFCT_INFOMASK)
 		kfree((char *)tmpl - tmpl->proto.tmpl_padto);
@@ -1417,7 +1416,6 @@ void nf_conntrack_free(struct nf_conn *ct)
 	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
-	nf_ct_ext_free(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index d4ed1e197921..c24e5b64b00c 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -34,21 +34,24 @@ void nf_ct_ext_destroy(struct nf_conn *ct)
 			t->destroy(ct);
 		rcu_read_unlock();
 	}
+
+	kfree(ct->ext);
 }
 EXPORT_SYMBOL(nf_ct_ext_destroy);
 
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
-	struct nf_ct_ext *old, *new;
 	struct nf_ct_ext_type *t;
+	struct nf_ct_ext *new;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
 	WARN_ON(nf_ct_is_confirmed(ct));
 
-	old = ct->ext;
 
-	if (old) {
+	if (ct->ext) {
+		const struct nf_ct_ext *old = ct->ext;
+
 		if (__nf_ct_ext_exist(old, id))
 			return NULL;
 		oldlen = old->len;
@@ -68,22 +71,18 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	rcu_read_unlock();
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
-	kmemleak_not_leak(old);
-	new = __krealloc(old, alloc, gfp);
+	new = krealloc(ct->ext, alloc, gfp);
 	if (!new)
 		return NULL;
 
-	if (!old) {
+	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
-		ct->ext = new;
-	} else if (new != old) {
-		kfree_rcu(old, rcu);
-		rcu_assign_pointer(ct->ext, new);
-	}
 
 	new->offset[id] = newoff;
 	new->len = newlen;
 	memset((void *)new + newoff, 0, newlen - newoff);
+
+	ct->ext = new;
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-- 
2.21.0

