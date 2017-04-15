From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/6] netfilter: nfnetlink_cthelper: reject too large userspace allocation requests
Date: Sun, 16 Apr 2017 01:29:16 +0200
Message-ID: <20170415232919.13671-4-fw@strlen.de>
References: <20170415232919.13671-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754704AbdDOX3N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 19:29:13 -0400
In-Reply-To: <20170415232919.13671-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace should not abuse the kernel to store large amounts of data,
reject requests larger than the private area can accommodate.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cthelper.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 9a50bf93dd16..eef7120e1f74 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -104,7 +104,7 @@ nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	if (help->helper->data_len == 0)
 		return -EINVAL;
 
-	memcpy(help->data, nla_data(attr), help->helper->data_len);
+	nla_memcpy(help->data, nla_data(attr), sizeof(help->data));
 	return 0;
 }
 
@@ -216,6 +216,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 {
 	struct nf_conntrack_helper *helper;
 	struct nfnl_cthelper *nfcth;
+	unsigned int size;
 	int ret;
 
 	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
@@ -231,7 +232,12 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		goto err1;
 
 	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
-	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
+	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
+	if (size > FIELD_SIZEOF(struct nf_conn_help, data)) {
+		ret = -ENOMEM;
+		goto err2;
+	}
+
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
 	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));
 
-- 
2.10.2

