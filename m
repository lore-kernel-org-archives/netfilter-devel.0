From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/5] netfilter: nfnl_cthelper: don't report error if NFCTH_PRIV_DATA_LEN is empty
Date: Sun, 19 Mar 2017 22:35:58 +0800
Message-ID: <1489934162-7415-2-git-send-email-zlpnobody@163.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:38288 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbdCSOyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 10:54:12 -0400
In-Reply-To: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Currently, when we create cthelper via nfnetlink, -EINVAL will be
returned if the NFCTH_PRIV_DATA_LEN attribute is empty.

But enforcing the user to specify the NFCTH_PRIV_DATA_LEN attr seems
unnecessary, so it's better to set the helper->data_len to zero if
the NFCTH_PRIV_DATA_LEN attribute is empty.

Found by running example program from libnetfilter_cthelper:
  # ./libnetfilter_cthelper/examples/nfct-helper-add test 1
  error: Invalid argument

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 2defe73..9c24301 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -205,7 +205,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 	struct nf_conntrack_helper *helper;
 	int ret;
 
-	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY] || !tb[NFCTH_PRIV_DATA_LEN])
+	if (!tb[NFCTH_TUPLE] || !tb[NFCTH_POLICY])
 		return -EINVAL;
 
 	helper = kzalloc(sizeof(struct nf_conntrack_helper), GFP_KERNEL);
@@ -217,7 +217,8 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		goto err1;
 
 	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
-	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
+	if (tb[NFCTH_PRIV_DATA_LEN])
+		helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
 	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));
 
-- 
2.5.5


