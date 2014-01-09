From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 10/13] netfilter: nf_tables: take AF module reference when creating a table
Date: Thu,  9 Jan 2014 18:42:40 +0000
Message-ID: <1389292963-4089-11-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51693 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaAISnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:24 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The table refers to data of the AF module, so we need to make sure the
module isn't unloaded while the table exists.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 88f9c94..c352614 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -430,9 +430,14 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 			return -EINVAL;
 	}
 
+	if (!try_module_get(afi->owner))
+		return -EAFNOSUPPORT;
+
 	table = kzalloc(sizeof(*table) + nla_len(name), GFP_KERNEL);
-	if (table == NULL)
+	if (table == NULL) {
+		module_put(afi->owner);
 		return -ENOMEM;
+	}
 
 	nla_strlcpy(table->name, name, nla_len(name));
 	INIT_LIST_HEAD(&table->chains);
@@ -468,6 +473,7 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	list_del(&table->list);
 	nf_tables_table_notify(skb, nlh, table, NFT_MSG_DELTABLE, family);
 	kfree(table);
+	module_put(afi->owner);
 	return 0;
 }
 
-- 
1.8.4.2

