From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: nf_tables: check for overflow of rule dlen field
Date: Sat, 16 May 2015 20:50:47 +0200
Message-ID: <1431802251-4781-3-git-send-email-pablo@netfilter.org>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43084 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbbEPSqL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 14:46:11 -0400
In-Reply-To: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

[ upstream commit 9889840f5988ecfd43b00c9abb83c1804e21406b ]

Check that the space required for the expressions doesn't exceed the
size of the dlen field, which would lead to the iterators crashing.

Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 3.19.x
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    4 ++++
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
1.7.10.4

