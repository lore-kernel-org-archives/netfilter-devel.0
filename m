From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 9/9] chain: dynamically allocate name
Date: Tue, 14 Jun 2016 15:18:45 +0200
Message-ID: <1465910325-13286-9-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55951 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbcFNNTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:19:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 20795E7DC0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 080079EBA8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F09CC9EBA3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:56 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just in case we ever support chain with larger names in the future,
this will ensure the library doesn't break. Although I don't expect
allocating more bytes for this anytime soon, but let's be conservative
here.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 86ccef6..a7f6742 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -32,7 +32,7 @@
 struct nftnl_chain {
 	struct list_head head;
 
-	char		name[NFT_CHAIN_MAXNAMELEN];
+	const char	*name;
 	const char	*type;
 	const char	*table;
 	const char	*dev;
@@ -95,13 +95,14 @@ EXPORT_SYMBOL(nftnl_chain_alloc);
 
 void nftnl_chain_free(const struct nftnl_chain *c)
 {
+	if (c->flags & (1 << NFTNL_CHAIN_NAME))
+		xfree(c->name);
 	if (c->flags & (1 << NFTNL_CHAIN_TABLE))
 		xfree(c->table);
 	if (c->flags & (1 << NFTNL_CHAIN_TYPE))
 		xfree(c->type);
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
 		xfree(c->dev);
-
 	xfree(c);
 }
 EXPORT_SYMBOL(nftnl_chain_free);
@@ -118,6 +119,9 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 		return;
 
 	switch (attr) {
+	case NFTNL_CHAIN_NAME:
+		xfree(c->name);
+		break;
 	case NFTNL_CHAIN_TABLE:
 		xfree(c->table);
 		break;
@@ -126,7 +130,6 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 	case NFTNL_CHAIN_TYPE:
 		xfree(c->type);
 		break;
-	case NFTNL_CHAIN_NAME:
 	case NFTNL_CHAIN_HOOKNUM:
 	case NFTNL_CHAIN_PRIO:
 	case NFTNL_CHAIN_POLICY:
@@ -164,7 +167,12 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 
 	switch(attr) {
 	case NFTNL_CHAIN_NAME:
-		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
+		if (c->flags & (1 << NFTNL_CHAIN_NAME))
+			xfree(c->name);
+
+		c->name = strdup(data);
+		if (!c->name)
+			return -1;
 		break;
 	case NFTNL_CHAIN_TABLE:
 		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
@@ -528,8 +536,11 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 		return -1;
 
 	if (tb[NFTA_CHAIN_NAME]) {
-		strncpy(c->name, mnl_attr_get_str(tb[NFTA_CHAIN_NAME]),
-			NFT_CHAIN_MAXNAMELEN);
+		if (c->flags & (1 << NFTNL_CHAIN_NAME))
+			xfree(c->name);
+		c->name = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_NAME]));
+		if (!c->name)
+			return -1;
 		c->flags |= (1 << NFTNL_CHAIN_NAME);
 	}
 	if (tb[NFTA_CHAIN_TABLE]) {
-- 
2.1.4

