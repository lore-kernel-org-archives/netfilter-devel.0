From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/32]: Add nf_inet_addr_cmp()
Date: Tue, 25 Mar 2008 15:15:00 +0100 (MET)
Message-ID: <20080325141500.10539.67362.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32905 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYCYOPC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:02 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Add nf_inet_addr_cmp()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 14d510e3026c99ebd8531e8ea0acb574545b5c42
tree aca9464205040aa5daa25a50a0e98443f905eb0b
parent 48bb8ab5591cab986a2850facf33998357db3b10
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:45 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:45 +0100

 include/linux/netfilter.h                  |    9 +++++++++
 include/net/netfilter/nf_conntrack_tuple.h |   15 +++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f0680c2..89e6c72 100644
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
 
