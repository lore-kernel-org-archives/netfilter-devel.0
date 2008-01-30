From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/69]: nf_conntrack: sparse warnings
Date: Wed, 30 Jan 2008 21:17:32 +0100 (MET)
Message-ID: <20080130201730.29874.12718.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbYA3URe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:34 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: sparse warnings

The hashtable size is really unsigned so sparse complains when you pass
a signed integer.  Change all uses to make it consistent.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 70d4a3d143164c03c11ad8d14a646e46453f4c76
tree f2d2e1053d51c51dfdc934d0713a6bbec711b4c1
parent 1ba99fa44b76ee7a7dddffc965a296d46c70fd40
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:05 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:18 +0100

 include/net/netfilter/nf_conntrack.h |    4 ++--
 net/netfilter/nf_conntrack_core.c    |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 857d899..dada041 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -171,9 +171,9 @@ static inline void nf_ct_put(struct nf_conn *ct)
 extern int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 extern void nf_ct_l3proto_module_put(unsigned short l3proto);
 
-extern struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced);
+extern struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced);
 extern void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced,
-				 int size);
+				 unsigned int size);
 
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 078fff0..7b1f7e8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -939,7 +939,7 @@ static int kill_all(struct nf_conn *i, void *data)
 	return 1;
 }
 
-void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced, int size)
+void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced, unsigned int size)
 {
 	if (vmalloced)
 		vfree(hash);
@@ -988,7 +988,7 @@ void nf_conntrack_cleanup(void)
 	nf_conntrack_expect_fini();
 }
 
-struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced)
+struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced)
 {
 	struct hlist_head *hash;
 	unsigned int size, i;
@@ -1015,8 +1015,8 @@ EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable);
 
 int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 {
-	int i, bucket, hashsize, vmalloced;
-	int old_vmalloced, old_size;
+	int i, bucket, vmalloced, old_vmalloced;
+	unsigned int hashsize, old_size;
 	int rnd;
 	struct hlist_head *hash, *old_hash;
 	struct nf_conntrack_tuple_hash *h;
@@ -1025,7 +1025,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 	if (!nf_conntrack_htable_size)
 		return param_set_uint(val, kp);
 
-	hashsize = simple_strtol(val, NULL, 0);
+	hashsize = simple_strtoul(val, NULL, 0);
 	if (!hashsize)
 		return -EINVAL;
 
