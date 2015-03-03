From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] netfilter: nf_tables: check for overflow of rule dlen field
Date: Tue,  3 Mar 2015 20:04:19 +0000
Message-ID: <1425413060-6187-3-git-send-email-kaber@trash.net>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44928 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbbCCUE0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:04:26 -0500
In-Reply-To: <1425413060-6187-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check that the space required for the expressions doesn't exceed the
size of the dlen field, which would lead to the iterators crashing.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6fb532b..7baafd5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1968,6 +1968,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			n++;
 		}
 	}
+	/* Check for overflow of dlen field */
+	err = -EFBIG;
+	if (size >= 1 << 12)
+		goto err1;
 
 	if (nla[NFTA_RULE_USERDATA])
 		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
-- 
2.1.0

