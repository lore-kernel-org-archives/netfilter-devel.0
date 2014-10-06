From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] netlink: use switch whenever possible in the monitor code
Date: Mon,  6 Oct 2014 19:53:34 +0200
Message-ID: <1412618014-3895-2-git-send-email-pablo@netfilter.org>
References: <1412618014-3895-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56069 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaJFRwW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:52:22 -0400
In-Reply-To: <1412618014-3895-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is more robust than the current 'else' fallback. If we run a
newer kernel with old nft binaries, unknown messages will be
misinterpreted as deletions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |   87 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 29 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 64960ad..0797174 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1632,7 +1632,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 	uint32_t family;
 	struct nft_table *nlt = netlink_table_alloc(nlh);
 
-	if (monh->format == NFT_OUTPUT_DEFAULT) {
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
 		if (type == NFT_MSG_NEWTABLE) {
 			if (nlh->nlmsg_flags & NLM_F_EXCL)
 				printf("update table ");
@@ -1646,10 +1647,13 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 
 		printf("%s %s\n", family2str(family),
 		       nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
-	} else {
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
 		nft_table_fprintf(stdout, nlt, monh->format,
 				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		break;
 	}
 
 	nft_table_free(nlt);
@@ -1663,8 +1667,10 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 	uint32_t family;
 	struct nft_chain *nlc = netlink_chain_alloc(nlh);
 
-	if (monh->format == NFT_OUTPUT_DEFAULT) {
-		if (type == NFT_MSG_NEWCHAIN) {
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
+		switch (type) {
+		case NFT_MSG_NEWCHAIN:
 			if (nlh->nlmsg_flags & NLM_F_EXCL)
 				printf("update ");
 			else
@@ -1673,7 +1679,8 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			c = netlink_delinearize_chain(monh->ctx, nlc);
 			chain_print_plain(c);
 			chain_free(c);
-		} else {
+			break;
+		case NFT_MSG_DELCHAIN:
 			family = nft_chain_attr_get_u32(nlc,
 							NFT_CHAIN_ATTR_FAMILY);
 			printf("delete chain %s %s %s\n", family2str(family),
@@ -1681,11 +1688,15 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 						      NFT_CHAIN_ATTR_TABLE),
 			       nft_chain_attr_get_str(nlc,
 						      NFT_CHAIN_ATTR_NAME));
+			break;
 		}
-	} else {
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
 		nft_chain_fprintf(stdout, nlc, monh->format,
 				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		break;
 	}
 
 	nft_chain_free(nlc);
@@ -1703,31 +1714,35 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 	if (flags & SET_F_ANONYMOUS)
 		goto out;
 
-	if (monh->format == NFT_OUTPUT_DEFAULT) {
-		if (type == NFT_MSG_NEWSET) {
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
+		switch (type) {
+		case NFT_MSG_NEWSET:
 			printf("add ");
 			set = netlink_delinearize_set(monh->ctx, nls);
 			if (set == NULL)
 				return MNL_CB_ERROR;
 			set_print_plain(set);
 			set_free(set);
-		} else {
+			printf("\n");
+			break;
+		case NFT_MSG_DELSET:
 			family = nft_set_attr_get_u32(nls,
 						      NFT_SET_ATTR_FAMILY);
-			printf("delete set %s %s %s",
+			printf("delete set %s %s %s\n",
 			       family2str(family),
 			       nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE),
 			       nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+			break;
 		}
-
-		printf("\n");
-
-	} else {
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
 		nft_set_fprintf(stdout, nls, monh->format,
 				netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		break;
 	}
-
 out:
 	nft_set_free(nls);
 	return MNL_CB_OK;
@@ -1754,7 +1769,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		goto out;
 	}
 
-	if (monh->format == NFT_OUTPUT_DEFAULT) {
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
 		if (set->flags & SET_F_ANONYMOUS)
 			goto out;
 
@@ -1782,22 +1798,30 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		}
 		nft_set_elems_iter_destroy(nlsei);
 
-		if (type == NFT_MSG_NEWSETELEM)
+		switch (type) {
+		case NFT_MSG_NEWSETELEM:
 			printf("add ");
-		else
+			break;
+		case NFT_MSG_DELSETELEM:
 			printf("delete ");
-
+			break;
+		default:
+			set_free(dummyset);
+			goto out;
+		}
 		printf("element %s %s %s ", family2str(family), table, setname);
 		expr_print(dummyset->init);
 		printf("\n");
 
 		set_free(dummyset);
-	} else {
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
 		nft_set_fprintf(stdout, nls, monh->format,
 				netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		break;
 	}
-
 out:
 	nft_set_free(nls);
 	return MNL_CB_OK;
@@ -1820,14 +1844,16 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 	uint64_t handle;
 	struct nft_rule *nlr = netlink_rule_alloc(nlh);
 
-	if (monh->format == NFT_OUTPUT_DEFAULT) {
+	switch (monh->format) {
+	case NFT_OUTPUT_DEFAULT:
 		fam = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
 		family = family2str(fam);
 		table = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
 		chain = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN);
 		handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
 
-		if (type == NFT_MSG_NEWRULE) {
+		switch (type) {
+		case NFT_MSG_NEWRULE:
 			r = netlink_delinearize_rule(monh->ctx, nlr);
 			nlr_for_each_set(nlr, rule_map_decompose_cb, NULL);
 
@@ -1836,18 +1862,21 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			printf("\n");
 
 			rule_free(r);
-			goto out;
+			break;
+		case NFT_MSG_DELRULE:
+			printf("delete rule %s %s %s handle %u\n",
+			       family, table, chain, (unsigned int)handle);
+			break;
 		}
-
-		printf("delete rule %s %s %s handle %u\n",
-		       family, table, chain, (unsigned int)handle);
-	} else {
+		break;
+	case NFT_OUTPUT_XML:
+	case NFT_OUTPUT_JSON:
 		nft_rule_fprintf(stdout, nlr, monh->format,
 				 netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
+		break;
 	}
 
-out:
 	nft_rule_free(nlr);
 	return MNL_CB_OK;
 }
-- 
1.7.10.4

