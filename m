From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 3/6] examples: nft-table-add: add table_add_parse()
Date: Fri, 22 Aug 2014 11:39:40 +0200
Message-ID: <20140822093940.1524.13689.stgit@nfdev.cica.es>
References: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:45516 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752737AbaHVJjt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:39:49 -0400
In-Reply-To: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fucntion parses the command line options and creates the nft_table object.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-add.c |   55 +++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 3b7572f..9c3ae6f 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -20,27 +20,11 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/table.h>
 
-int main(int argc, char *argv[])
+static struct nft_table *table_add_parse(int argc, char *argv[])
 {
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq, family;
-	struct nft_table *t = NULL;
-	int ret;
-
-	if (argc != 3) {
-		fprintf(stderr, "%s <family> <name>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
+	struct nft_table *t;
+	uint16_t family;
 
-	t = nft_table_alloc();
-	if (t == NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
-	seq = time(NULL);
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
@@ -51,11 +35,42 @@ int main(int argc, char *argv[])
 		family = NFPROTO_ARP;
 	else {
 		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		return NULL;
+	}
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
+	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, argv[2]);
+
+	return t;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq, family;
+	struct nft_table *t;
+	int ret;
+
+	if (argc != 3) {
+		fprintf(stderr, "%s <family> <name>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
 
-	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
+	t = table_add_parse(argc, argv);
+	if (t == NULL)
+		exit(EXIT_FAILURE);
 
+
+	seq = time(NULL);
+	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
 					NLM_F_ACK, seq);
 	nft_table_nlmsg_build_payload(nlh, t);

