From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] add support to related connections via ctnetlink
Date: Thu, 13 Sep 2007 17:47:12 +0200
Message-ID: <46E95B80.3020307@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010007040202050007090605"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010007040202050007090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

This patch adds support to relate a connection to an existing master
connection. This patch is used by conntrackd to correctly replicate
related connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Será preciso viajar por los ojos de los idiotas" -- Poeta en Nueva York
-- Federico García Lorca.

--------------010007040202050007090605
Content-Type: text/x-patch;
 name="master.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="master.patch"

[PATCH] add support to related connections via ctnetlink

This patch adds support to relate a connection to an existing master
connection. This patch is used by conntrackd to correctly replicate related
connections.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2007-06-11 02:37:41.000000000 +0200
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2007-09-12 14:20:28.000000000 +0200
@@ -36,6 +36,7 @@ enum ctattr_type {
 	CTA_USE,
 	CTA_ID,
 	CTA_NAT_DST,
+	CTA_TUPLE_MASTER,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-07-26 15:05:48.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-09-12 14:24:59.000000000 +0200
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
+ * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -945,7 +945,8 @@ ctnetlink_change_conntrack(struct nf_con
 static int
 ctnetlink_create_conntrack(struct nfattr *cda[],
 			   struct nf_conntrack_tuple *otuple,
-			   struct nf_conntrack_tuple *rtuple)
+			   struct nf_conntrack_tuple *rtuple,
+			   struct nf_conn *master_ct)
 {
 	struct nf_conn *ct;
 	int err = -EINVAL;
@@ -983,6 +984,10 @@ ctnetlink_create_conntrack(struct nfattr
 	if (help)
 		help->helper = nf_ct_helper_find_get(rtuple);
 
+	/* setup master conntrack: this is a confirmed expectation */
+	if (master_ct)
+		ct->master = master_ct;
+
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
 
@@ -1028,10 +1033,37 @@ ctnetlink_new_conntrack(struct sock *ctn
 		h = __nf_conntrack_find(&rtuple, NULL);
 
 	if (h == NULL) {
+		struct nf_conntrack_tuple master;
+		struct nf_conntrack_tuple_hash *master_h = NULL;
+		struct nf_conn *master_ct = NULL;
+
+		if (cda[CTA_TUPLE_MASTER-1]) {
+			err = ctnetlink_parse_tuple(cda, 
+						    &master, 
+						    CTA_TUPLE_MASTER, 
+						    u3);
+			if (err < 0)
+				return err;
+
+			master_h = __nf_conntrack_find(&master, NULL);
+			if (master_h == NULL) {
+        			err = -ENOENT;
+				goto out_unlock;
+			}
+			master_ct = nf_ct_tuplehash_to_ctrack(master_h);
+			atomic_inc(&master_ct->ct_general.use);
+		}
+
 		write_unlock_bh(&nf_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+			err = ctnetlink_create_conntrack(cda,
+							 &otuple,
+							 &rtuple,
+							 master_ct);
+		if (err < 0 && master_ct)
+			nf_ct_put(master_ct);
+
 		return err;
 	}
 	/* implicit 'else' */
@@ -1045,6 +1077,11 @@ ctnetlink_new_conntrack(struct sock *ctn
 			err = -EINVAL;
 			goto out_unlock;
 		}
+		/* can't link an existing conntrack to a master */
+		if (cda[CTA_TUPLE_MASTER-1]) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
 		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
 						 cda);
 	}

--------------010007040202050007090605--
