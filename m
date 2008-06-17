From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: nf_nat: fix RCU races
Date: Tue, 17 Jun 2008 16:03:53 +0200 (MEST)
Message-ID: <20080617140352.1355.52788.sendpatchset@localhost.localdomain>
References: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYFQODy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:03:54 -0400
In-Reply-To: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_nat: fix RCU races

Fix three ct_extend/NAT extension related races:

- When cleaning up the extension area and removing it from the bysource hash,
  the nat->ct pointer must not be set to NULL since it may still be used in
  a RCU read side

- When replacing a NAT extension area in the bysource hash, the nat->ct
  pointer must be assigned before performing the replacement

- When reallocating extension storage in ct_extend, the old memory must
  not be freed immediately since it may still be used by a RCU read side

Possibly fixes https://bugzilla.redhat.com/show_bug.cgi?id=449315
and/or http://bugzilla.kernel.org/show_bug.cgi?id=10875

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6a5696d1b52e24202682359b54775260fb4cbb54
tree 039e10ad0931c24be83cb3a7fc95fedde0d46825
parent 68be802cd5ad040fe8cfa33ce3031405df2d9117
author Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:36 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:36 +0200

 include/net/netfilter/nf_conntrack_extend.h |    1 +
 net/ipv4/netfilter/nf_nat_core.c            |    3 +--
 net/netfilter/nf_conntrack_extend.c         |    9 ++++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index f736e84..f80c0ed 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -15,6 +15,7 @@ enum nf_ct_ext_id
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
+	struct rcu_head rcu;
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
 	char data[0];
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0457859..d2a887f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -556,7 +556,6 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 
 	spin_lock_bh(&nf_nat_lock);
 	hlist_del_rcu(&nat->bysource);
-	nat->ct = NULL;
 	spin_unlock_bh(&nf_nat_lock);
 }
 
@@ -570,8 +569,8 @@ static void nf_nat_move_storage(void *new, void *old)
 		return;
 
 	spin_lock_bh(&nf_nat_lock);
-	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;
+	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	spin_unlock_bh(&nf_nat_lock);
 }
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index bcc19fa..8a3f8b3 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -59,12 +59,19 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!*ext)
 		return NULL;
 
+	INIT_RCU_HEAD(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
 	return (void *)(*ext) + off;
 }
 
+static void __nf_ct_ext_free_rcu(struct rcu_head *head)
+{
+	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
+	kfree(ext);
+}
+
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *new;
@@ -106,7 +113,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)ct->ext + ct->ext->offset[i]);
 			rcu_read_unlock();
 		}
-		kfree(ct->ext);
+		call_rcu(&ct->ext->rcu, __nf_ct_ext_free_rcu);
 		ct->ext = new;
 	}
 
