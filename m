From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 43/69]: nf_conntrack: reorder struct nf_conntrack_l4proto
Date: Wed, 30 Jan 2008 21:18:00 +0100 (MET)
Message-ID: <20080130201758.29874.83933.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbYA3USC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:02 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: reorder struct nf_conntrack_l4proto

Reorder struct nf_conntrack_l4proto so all members used during packet
processing are in the same cacheline.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7b2624034f45ce13ecfdf13847cbf7ad67bb7137
tree b723a4d976afb8853e3b619922b24004ab2bb6f7
parent 2f75544ea729329074f86020b4524179cc82c219
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100

 include/net/netfilter/nf_conntrack_l4proto.h |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index fb50c21..84892cc 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -23,9 +23,6 @@ struct nf_conntrack_l4proto
 	/* L4 Protocol number. */
 	u_int8_t l4proto;
 
-	/* Protocol name */
-	const char *name;
-
 	/* Try to fill in the third arg: dataoff is offset past network protocol
            hdr.  Return true if possible. */
 	int (*pkt_to_tuple)(const struct sk_buff *skb,
@@ -38,13 +35,6 @@ struct nf_conntrack_l4proto
 	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
 			    const struct nf_conntrack_tuple *orig);
 
-	/* Print out the per-protocol part of the tuple. Return like seq_* */
-	int (*print_tuple)(struct seq_file *s,
-			   const struct nf_conntrack_tuple *);
-
-	/* Print out the private part of the conntrack. */
-	int (*print_conntrack)(struct seq_file *s, const struct nf_conn *);
-
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -65,6 +55,13 @@ struct nf_conntrack_l4proto
 		     enum ip_conntrack_info *ctinfo,
 		     int pf, unsigned int hooknum);
 
+	/* Print out the per-protocol part of the tuple. Return like seq_* */
+	int (*print_tuple)(struct seq_file *s,
+			   const struct nf_conntrack_tuple *);
+
+	/* Print out the private part of the conntrack. */
+	int (*print_conntrack)(struct seq_file *s, const struct nf_conn *);
+
 	/* convert protoinfo to nfnetink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
 			 const struct nf_conn *ct);
@@ -87,6 +84,8 @@ struct nf_conntrack_l4proto
 	struct ctl_table	*ctl_compat_table;
 #endif
 #endif
+	/* Protocol name */
+	const char *name;
 
 	/* Module (if any) which this is connected to. */
 	struct module *me;
