From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/32]: Add nf_inet_addr_cmp()
Date: Thu, 28 Feb 2008 13:00:06 +0100 (MET)
Message-ID: <20080228115957.29267.35707.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbYB1MAH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:07 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Add nf_inet_addr_cmp()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 21eb86674a1b26ff842b7d449c34c747c897fe90
tree 1357433c0e059b26aa42526a20d5e67cc6fcd9f3
parent 52e02723b365a29b1694a8d157d42aa5f6c72895
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:13 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:13 +0100

 include/linux/netfilter.h                  |    9 +++++++++
 include/net/netfilter/nf_conntrack_tuple.h |   15 +++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b74b615..9d00a3f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -61,6 +61,15 @@ union nf_inet_addr {
 #ifdef __KERNEL__
 #ifdef CONFIG_NETFILTER
 
+static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
+				   const union nf_inet_addr *a2)
+{
+	return a1->all[0] == a2->all[0] &&
+	       a1->all[1] == a2->all[1] &&
+	       a1->all[2] == a2->all[2] &&
+	       a1->all[3] == a2->all[3];
+}
+
 extern void netfilter_init(void);
 
 /* Largest hook number + 1 */
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index d9b53dd..168c917 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -163,10 +163,7 @@ struct nf_conntrack_tuple_hash
 static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					  const struct nf_conntrack_tuple *t2)
 { 
-	return (t1->src.u3.all[0] == t2->src.u3.all[0] &&
-		t1->src.u3.all[1] == t2->src.u3.all[1] &&
-		t1->src.u3.all[2] == t2->src.u3.all[2] &&
-		t1->src.u3.all[3] == t2->src.u3.all[3] &&
+	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
 		t1->src.u.all == t2->src.u.all &&
 		t1->src.l3num == t2->src.l3num);
 }
@@ -174,10 +171,7 @@ static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 static inline int __nf_ct_tuple_dst_equal(const struct nf_conntrack_tuple *t1,
 					  const struct nf_conntrack_tuple *t2)
 {
-	return (t1->dst.u3.all[0] == t2->dst.u3.all[0] &&
-		t1->dst.u3.all[1] == t2->dst.u3.all[1] &&
-		t1->dst.u3.all[2] == t2->dst.u3.all[2] &&
-		t1->dst.u3.all[3] == t2->dst.u3.all[3] &&
+	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
 		t1->dst.u.all == t2->dst.u.all &&
 		t1->dst.protonum == t2->dst.protonum);
 }
@@ -192,10 +186,7 @@ static inline int nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,
 static inline int nf_ct_tuple_mask_equal(const struct nf_conntrack_tuple_mask *m1,
 					 const struct nf_conntrack_tuple_mask *m2)
 {
-	return (m1->src.u3.all[0] == m2->src.u3.all[0] &&
-		m1->src.u3.all[1] == m2->src.u3.all[1] &&
-		m1->src.u3.all[2] == m2->src.u3.all[2] &&
-		m1->src.u3.all[3] == m2->src.u3.all[3] &&
+	return (nf_inet_addr_cmp(&m1->src.u3, &m2->src.u3) &&
 		m1->src.u.all == m2->src.u.all);
 }
 
