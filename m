From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 3/8] nf_conntrack: sparse warnings
Date: Thu, 24 Jan 2008 10:15:39 -0800
Message-ID: <20080124181628.162252995@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48254 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbYAXSYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:20 -0500
Content-Disposition: inline; filename=nf-hashtable.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The hashtable size is really unsigned so sparse complains when you pass
a signed integer.  Change all uses to make it consistent.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/include/net/netfilter/nf_conntrack.h	2008-01-23 10:24:42.000000000 -0800
+++ b/include/net/netfilter/nf_conntrack.h	2008-01-23 10:25:05.000000000 -0800
@@ -171,9 +171,9 @@ static inline void nf_ct_put(struct nf_c
 extern int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 extern void nf_ct_l3proto_module_put(unsigned short l3proto);
 
-extern struct hlist_head *nf_ct_alloc_hashtable(int *sizep, int *vmalloced);
+extern struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced);
 extern void nf_ct_free_hashtable(struct hlist_head *hash, int vmalloced,
-				 int size);
+				 unsigned int size);
 
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
--- a/net/netfilter/nf_conntrack_core.c	2008-01-23 10:23:37.000000000 -0800
+++ b/net/netfilter/nf_conntrack_core.c	2008-01-23 10:26:48.000000000 -0800
@@ -939,7 +939,7 @@ static int kill_all(struct nf_conn *i, v
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
@@ -1015,8 +1015,8 @@ EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable)
 
 int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 {
-	int i, bucket, hashsize, vmalloced;
-	int old_vmalloced, old_size;
+	int i, bucket, vmalloced, old_vmalloced;
+	unsigned int hashsize, old_size;
 	int rnd;
 	struct hlist_head *hash, *old_hash;
 	struct nf_conntrack_tuple_hash *h;
@@ -1025,7 +1025,7 @@ int nf_conntrack_set_hashsize(const char
 	if (!nf_conntrack_htable_size)
 		return param_set_uint(val, kp);
 
-	hashsize = simple_strtol(val, NULL, 0);
+	hashsize = simple_strtoul(val, NULL, 0);
 	if (!hashsize)
 		return -EINVAL;
 

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

