From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] examples: nft-events: add option how to format the printed events
Date: Sat, 26 Apr 2014 14:03:43 +0200
Message-ID: <1398513823-23222-1-git-send-email-pablo@netfilter.org>
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaDZMEJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Apr 2014 08:04:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # ./nft-events xml
 <event><type>new</type><chain><name>xxx</name><handle>9</handle><bytes>0</bytes><packets>0</packets><table>test</table><family>ip</family></chain></event>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-events.c |   60 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/examples/nft-events.c b/examples/nft-events.c
index fc63650..fb18e55 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -44,7 +44,7 @@ static uint32_t event2flag(uint32_t event)
 	return 0;
 }
 
-static int table_cb(const struct nlmsghdr *nlh, int type)
+static int table_cb(const struct nlmsghdr *nlh, int event, int type)
 {
 	struct nft_table *t;
 
@@ -59,7 +59,7 @@ static int table_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_table_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	nft_table_fprintf(stdout, t, type, event2flag(event));
 	fprintf(stdout, "\n");
 
 err_free:
@@ -68,7 +68,7 @@ err:
 	return MNL_CB_OK;
 }
 
-static int rule_cb(const struct nlmsghdr *nlh, int type)
+static int rule_cb(const struct nlmsghdr *nlh, int event, int type)
 {
 	struct nft_rule *t;
 
@@ -83,7 +83,7 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_rule_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	nft_rule_fprintf(stdout, t, type, event2flag(event));
 	fprintf(stdout, "\n");
 
 err_free:
@@ -92,7 +92,7 @@ err:
 	return MNL_CB_OK;
 }
 
-static int chain_cb(const struct nlmsghdr *nlh, int type)
+static int chain_cb(const struct nlmsghdr *nlh, int event, int type)
 {
 	struct nft_chain *t;
 
@@ -107,7 +107,7 @@ static int chain_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_chain_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	nft_chain_fprintf(stdout, t, type, event2flag(event));
 	fprintf(stdout, "\n");
 
 err_free:
@@ -116,7 +116,7 @@ err:
 	return MNL_CB_OK;
 }
 
-static int set_cb(const struct nlmsghdr *nlh, int type)
+static int set_cb(const struct nlmsghdr *nlh, int event, int type)
 {
 	struct nft_set *t;
 
@@ -131,7 +131,7 @@ static int set_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_set_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	nft_set_fprintf(stdout, t, type, event2flag(event));
 	fprintf(stdout, "\n");
 
 err_free:
@@ -140,7 +140,7 @@ err:
 	return MNL_CB_OK;
 }
 
-static int setelem_cb(const struct nlmsghdr *nlh, int type)
+static int setelem_cb(const struct nlmsghdr *nlh, int event, int type)
 {
 
 	struct nft_set *s;
@@ -156,7 +156,7 @@ static int setelem_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_set_fprintf(stdout, s, NFT_OUTPUT_DEFAULT, event2flag(type));
+	nft_set_fprintf(stdout, s, type, event2flag(event));
 	fprintf(stdout, "\n");
 
 err_free:
@@ -168,28 +168,29 @@ err:
 static int events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
-	int type = nlh->nlmsg_type & 0xFF;
+	int event = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	int type = *((int *)data);
 
-	switch(type) {
+	switch(event) {
 	case NFT_MSG_NEWTABLE:
 	case NFT_MSG_DELTABLE:
-		ret = table_cb(nlh, type);
+		ret = table_cb(nlh, event, type);
 		break;
 	case NFT_MSG_NEWCHAIN:
 	case NFT_MSG_DELCHAIN:
-		ret = chain_cb(nlh, type);
+		ret = chain_cb(nlh, event, type);
 		break;
 	case NFT_MSG_NEWRULE:
 	case NFT_MSG_DELRULE:
-		ret = rule_cb(nlh, type);
+		ret = rule_cb(nlh, event, type);
 		break;
 	case NFT_MSG_NEWSET:
 	case NFT_MSG_DELSET:
-		ret = set_cb(nlh, type);
+		ret = set_cb(nlh, event, type);
 		break;
 	case NFT_MSG_NEWSETELEM:
 	case NFT_MSG_DELSETELEM:
-		ret = setelem_cb(nlh, type);
+		ret = setelem_cb(nlh, event, type);
 		break;
 	}
 
@@ -200,7 +201,28 @@ int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	int ret;
+	int ret, type;
+
+	switch (argc) {
+	case 1:
+		type = NFT_OUTPUT_DEFAULT;
+		break;
+	case 2:
+		if (strcmp(argv[1], "xml") == 0) {
+			type = NFT_OUTPUT_XML;
+		} else if (strcmp(argv[1], "json") == 0) {
+			type = NFT_OUTPUT_JSON;
+		} else if (strcmp(argv[1], "default") == 0) {
+			type = NFT_OUTPUT_DEFAULT;
+		} else {
+			fprintf(stderr, "unknown format type `%s'\n", argv[1]);
+			return EXIT_FAILURE;
+		}
+		break;
+	default:
+		fprintf(stderr, "%s [<default|xml|json>]\n", argv[0]);
+		return EXIT_FAILURE;
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -215,7 +237,7 @@ int main(int argc, char *argv[])
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, 0, 0, events_cb, NULL);
+		ret = mnl_cb_run(buf, ret, 0, 0, events_cb, &type);
 		if (ret <= 0)
 			break;
 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-- 
1.7.10.4

