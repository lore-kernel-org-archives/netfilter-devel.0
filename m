From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 libnftnl] examples: nft-chain-add: add chain_add_parse()
Date: Wed, 13 Aug 2014 18:54:57 +0200
Message-ID: <1407948898-8495-2-git-send-email-pablo@netfilter.org>
References: <1407948898-8495-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55353 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaHMQyn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:54:43 -0400
In-Reply-To: <1407948898-8495-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function parses the command line options and it creates the
nft_chain object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-chain-add.c |   73 +++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 3edff86..4d32ddd 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -20,14 +20,52 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/chain.h>
 
+static struct nft_chain *chain_add_parse(int argc, char *argv[])
+{
+	struct nft_chain *t;
+	int hooknum = 0;
+
+	if (argc == 6) {
+		/* This is a base chain, set the hook number */
+		if (strcmp(argv[4], "NF_INET_LOCAL_IN") == 0)
+			hooknum = NF_INET_LOCAL_IN;
+		else if (strcmp(argv[4], "NF_INET_LOCAL_OUT") == 0)
+			hooknum = NF_INET_LOCAL_OUT;
+		else if (strcmp(argv[4], "NF_INET_PRE_ROUTING") == 0)
+			hooknum = NF_INET_PRE_ROUTING;
+		else if (strcmp(argv[4], "NF_INET_POST_ROUTING") == 0)
+			hooknum = NF_INET_POST_ROUTING;
+		else if (strcmp(argv[4], "NF_INET_FORWARD") == 0)
+			hooknum = NF_INET_FORWARD;
+		else {
+			fprintf(stderr, "Unknown hook: %s\n", argv[4]);
+			return NULL;
+		}
+	}
+
+	t = nft_chain_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+	nft_chain_attr_set(t, NFT_CHAIN_ATTR_TABLE, argv[2]);
+	nft_chain_attr_set(t, NFT_CHAIN_ATTR_NAME, argv[3]);
+	if (argc == 6) {
+		nft_chain_attr_set_u32(t, NFT_CHAIN_ATTR_HOOKNUM, hooknum);
+		nft_chain_attr_set_u32(t, NFT_CHAIN_ATTR_PRIO, atoi(argv[5]));
+	}
+
+	return t;
+}
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
-	struct nft_chain *t = NULL;
-	int ret, family, hooknum = 0;
+	int ret, family;
+	struct nft_chain *t;
 
 	if (argc != 4 && argc != 6) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> "
@@ -49,38 +87,13 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (argc == 6) {
-		/* This is a base chain, set the hook number */
-		if (strcmp(argv[4], "NF_INET_LOCAL_IN") == 0)
-			hooknum = NF_INET_LOCAL_IN;
-		else if (strcmp(argv[4], "NF_INET_LOCAL_OUT") == 0)
-			hooknum = NF_INET_LOCAL_OUT;
-		else if (strcmp(argv[4], "NF_INET_PRE_ROUTING") == 0)
-			hooknum = NF_INET_PRE_ROUTING;
-		else if (strcmp(argv[4], "NF_INET_POST_ROUTING") == 0)
-			hooknum = NF_INET_POST_ROUTING;
-		else if (strcmp(argv[4], "NF_INET_FORWARD") == 0)
-			hooknum = NF_INET_FORWARD;
-		else {
-			fprintf(stderr, "Unknown hook: %s\n", argv[4]);
-			exit(EXIT_FAILURE);
-		}
-	}
-
-	t = nft_chain_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	t = chain_add_parse(argc, argv);
+	if (t == NULL)
 		exit(EXIT_FAILURE);
-	}
+
 	seq = time(NULL);
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
 					NLM_F_EXCL|NLM_F_ACK, seq);
-	nft_chain_attr_set(t, NFT_CHAIN_ATTR_TABLE, argv[2]);
-	nft_chain_attr_set(t, NFT_CHAIN_ATTR_NAME, argv[3]);
-	if (argc == 6) {
-		nft_chain_attr_set_u32(t, NFT_CHAIN_ATTR_HOOKNUM, hooknum);
-		nft_chain_attr_set_u32(t, NFT_CHAIN_ATTR_PRIO, atoi(argv[5]));
-	}
 	nft_chain_nlmsg_build_payload(nlh, t);
 	nft_chain_free(t);
 
-- 
1.7.10.4

