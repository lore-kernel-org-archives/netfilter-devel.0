From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH netfilter: nf_ct] Fix compilation warning if NF_CONNTRACK_MARK is not set
Date: Fri, 10 Jan 2014 21:43:20 +0100
Message-ID: <1389386600-19012-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33471 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbaAJUna (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:43:30 -0500
Received: by mail-lb0-f177.google.com with SMTP id z5so1408913lbh.36
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 12:43:29 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

net/netfilter/nft_ct.c: In function 'nft_ct_set_eval':
net/netfilter/nft_ct.c:136:6: warning: unused variable 'value' [-Wunused-variable]

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index c7c1285..917052e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -133,7 +133,9 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
+#ifdef CONFIG_NF_CONNTRACK_MARK
 	u32 value = data[priv->sreg].data[0];
+#endif
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
-- 
1.8.3.2

