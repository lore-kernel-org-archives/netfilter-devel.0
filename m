From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/32]: nf_conntrack_expect: support inactive expectations
Date: Thu, 28 Feb 2008 13:00:03 +0100 (MET)
Message-ID: <20080228115954.29267.91593.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49974 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbYB1MAE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:04 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: support inactive expectations

This is useful for the SIP helper and signalling expectations.
We don't want to create a full-blown expectation with a wildcard
as source based on a single UDP packet, but need to know the
final port anyways. With inactive expectations we can register
the expectation and reserve the tuple, but wait for confirmation
from the registrar before activating it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 322ac7d38f97af880a7df6f39336b1918ccaf7d6
tree d6592355237559f9c940dd1ff49e0c4721591eb2
parent 80c19a28e05a8855425f7f8cc62384b700b208c1
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:10 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:10 +0100

 include/net/netfilter/nf_conntrack_expect.h |    3 ++-
 net/netfilter/nf_conntrack_expect.c         |   25 +++++++++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index f1bdcb4..47c28dd 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -53,7 +53,8 @@ struct nf_conntrack_expect
 	struct rcu_head rcu;
 };
 
-#define NF_CT_EXPECT_PERMANENT 0x1
+#define NF_CT_EXPECT_PERMANENT	0x1
+#define NF_CT_EXPECT_INACTIVE	0x2
 
 int nf_conntrack_expect_init(void);
 void nf_conntrack_expect_fini(void);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index bc4c8e0..4bd694d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -126,9 +126,21 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_find_get);
 struct nf_conntrack_expect *
 nf_ct_find_expectation(const struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_expect *exp;
+	struct nf_conntrack_expect *i, *exp = NULL;
+	struct hlist_node *n;
+	unsigned int h;
+
+	if (!nf_ct_expect_count)
+		return NULL;
 
-	exp = __nf_ct_expect_find(tuple);
+	h = nf_ct_expect_dst_hash(tuple);
+	hlist_for_each_entry(i, n, &nf_ct_expect_hash[h], hnode) {
+		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
+		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)) {
+			exp = i;
+			break;
+		}
+	}
 	if (!exp)
 		return NULL;
 
@@ -460,6 +472,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
 	struct hlist_node *n = v;
+	char *delim = "";
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
@@ -476,8 +489,12 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
 				       expect->tuple.dst.protonum));
 
-	if (expect->flags & NF_CT_EXPECT_PERMANENT)
-		seq_printf(s, "PERMANENT ");
+	if (expect->flags & NF_CT_EXPECT_PERMANENT) {
+		seq_printf(s, "PERMANENT");
+		delim = ",";
+	}
+	if (expect->flags & NF_CT_EXPECT_INACTIVE)
+		seq_printf(s, "%sINACTIVE", delim);
 
 	return seq_putc(s, '\n');
 }
