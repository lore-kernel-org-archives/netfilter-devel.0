From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: conntrack: do not dump other netns's conntrack entries via proc
Date: Mon, 15 Aug 2016 21:50:35 +0800
Message-ID: <1471269035-4436-1-git-send-email-zlpnobody@163.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:49150 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbcHONvk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 09:51:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We should skip the conntracks that belong to a different namespace,
otherwise other unrelated netns's conntrack entries will be dumped via
/proc/net/nf_conntrack.

Fixes: 56d52d4892d0 ("netfilter: conntrack: use a single hashtable for all namespaces")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_conntrack_standalone.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 958a145..9f267c3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -205,6 +205,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(hash);
 	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
+	struct net *net = seq_file_net(s);
 	int ret = 0;
 
 	NF_CT_ASSERT(ct);
@@ -215,6 +216,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (NF_CT_DIRECTION(hash))
 		goto release;
 
+	if (!net_eq(nf_ct_net(ct), net))
+		goto release;
+
 	l3proto = __nf_ct_l3proto_find(nf_ct_l3num(ct));
 	NF_CT_ASSERT(l3proto);
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
-- 
2.5.5


