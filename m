From: Josue Alvarez <jalvarez@toulouse.viveris.com>
Subject: Re: [PATCH libnftnl] examples: selective rule dumping
Date: Thu, 21 Jul 2016 16:59:41 +0200
Message-ID: <1469113181-5034-1-git-send-email-jalvarez@toulouse.viveris.com>
References: <20160721133630.GA2050@salvia>
Cc: netfilter-devel@vger.kernel.org,
	Josue Alvarez <jalvarez@toulouse.viveris.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:37958 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbcGUPAH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 11:00:07 -0400
In-Reply-To: <20160721133630.GA2050@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 examples/nft-rule-get.c | 56 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 54bee73..4a491af 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -46,17 +46,50 @@ err:
 	return MNL_CB_OK;
 }
 
+static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
+				   const char *chain, const char *handle)
+{
+	struct nftnl_rule *r = NULL;
+	uint8_t proto;
+	uint16_t dport;
+	uint64_t handle_num;
+
+	r = nftnl_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (table != NULL)
+		nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
+
+	if (chain != NULL)
+		nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+
+	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
+
+	if (handle != NULL) {
+		handle_num = atoll(handle);
+		nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle_num);
+	}
+
+	return r;
+}
+
+
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	const char *table = NULL, *chain = NULL;
 	uint32_t portid, seq, type = NFTNL_OUTPUT_DEFAULT;
-	struct nftnl_rule *t = NULL;
+	struct nftnl_rule *t, *r = NULL;
 	int ret, family;
 
-	if (argc < 2 || argc > 3) {
-		fprintf(stderr, "Usage: %s <family> [xml|json]\n",
+	if (argc < 2 || argc > 5) {
+		fprintf(stderr, "Usage: %s <family> [<table> <chain>] [xml|json]\n",
 			argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -76,13 +109,20 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (argc == 3) {
-		if (strcmp(argv[2], "xml") == 0)
+	/* [xml|json] specified */
+	if (argc == 3 || argc == 5) {
+		if (strcmp(argv[argc - 1], "xml") == 0)
 			type = NFTNL_OUTPUT_XML;
-		else if (strcmp(argv[2], "json") == 0)
+		else if (strcmp(argv[argc - 1], "json") == 0)
 			type = NFTNL_OUTPUT_JSON;
 	}
 
+	/* at least [<table> <chain>] specified */
+	if (argc >= 4) {
+		table = argv[2];
+		chain = argv[3];
+	}
+
 	/* XXX requires table, chain and handle attributes for selective get */
 
 	t = nftnl_rule_alloc();
@@ -95,6 +135,10 @@ int main(int argc, char *argv[])
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 					NLM_F_DUMP, seq);
 
+	r = setup_rule(family, table, chain, NULL);
+	nftnl_rule_nlmsg_build_payload(nlh, r);
+
+
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
 		perror("mnl_socket_open");
-- 
2.7.4

