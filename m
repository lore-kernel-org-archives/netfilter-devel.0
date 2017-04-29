From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_ct_ext: invoke destroy even when ext is not attached
Date: Sat, 29 Apr 2017 21:59:49 +0800
Message-ID: <1493474389-9217-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:40807 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166866AbdD2OAt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Apr 2017 10:00:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

For NF_NAT_MANIP_SRC, we will insert the ct to the nat_bysource_table,
then remove it from the nat_bysource_table via nat_extend->destroy.

But now, the nat extension is attached on demand, so if the nat extension
is not attached, we will not be notified when the ct is destroyed, i.e.
we may fail to remove ct from the nat_bysource_table.

So just keep it simple, even if the extension is not attached, we will
still invoke the related ext->destroy. And this will also preserve the
flexibility for the future extension.

Fixes: 9a08ecfe74d7 ("netfilter: don't attach a nat extension by default")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_extend.h | 7 +------
 net/netfilter/nf_conntrack_extend.c         | 8 ++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index b01f73f..4944bc9 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -69,12 +69,7 @@ static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 	((id##_TYPE *)__nf_ct_ext_find((ext), (id)))
 
 /* Destroy all relationships */
-void __nf_ct_ext_destroy(struct nf_conn *ct);
-static inline void nf_ct_ext_destroy(struct nf_conn *ct)
-{
-	if (ct->ext)
-		__nf_ct_ext_destroy(ct);
-}
+void nf_ct_ext_destroy(struct nf_conn *ct);
 
 /* Free operation. If you want to free a object referred from private area,
  * please implement __nf_ct_ext_free() and call it.
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 68ae1be..6c605e8 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -20,16 +20,12 @@ static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
-void __nf_ct_ext_destroy(struct nf_conn *ct)
+void nf_ct_ext_destroy(struct nf_conn *ct)
 {
 	unsigned int i;
 	struct nf_ct_ext_type *t;
-	struct nf_ct_ext *ext = ct->ext;
 
 	for (i = 0; i < NF_CT_EXT_NUM; i++) {
-		if (!__nf_ct_ext_exist(ext, i))
-			continue;
-
 		rcu_read_lock();
 		t = rcu_dereference(nf_ct_ext_types[i]);
 
@@ -42,7 +38,7 @@ void __nf_ct_ext_destroy(struct nf_conn *ct)
 		rcu_read_unlock();
 	}
 }
-EXPORT_SYMBOL(__nf_ct_ext_destroy);
+EXPORT_SYMBOL(nf_ct_ext_destroy);
 
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
-- 
2.5.5


