From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 53/53] netfilter: nf_ct_ext: invoke destroy even when ext is not attached
Date: Mon,  1 May 2017 12:47:20 +0200
Message-ID: <1493635640-24325-54-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166399AbdEAKtR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:49:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19E82210590
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B6E1FF2C1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED75DDA870
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:09 +0200 (CEST)
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_extend.h | 7 +------
 net/netfilter/nf_conntrack_extend.c         | 8 ++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index b01f73fb4dcb..4944bc9153cf 100644
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
index 68ae1be08ed8..6c605e88ebae 100644
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
2.1.4

