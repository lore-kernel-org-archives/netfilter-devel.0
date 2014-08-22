From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 5/6] examples: nft-table-del: add table_del_parse()
Date: Fri, 22 Aug 2014 11:39:51 +0200
Message-ID: <20140822093951.1524.4682.stgit@nfdev.cica.es>
References: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:45533 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaHVJj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:39:59 -0400
In-Reply-To: <20140822093929.1524.32948.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new function parses the input arguments and generates the nft_table.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-table-del.c |   55 +++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index ed1140d..ae7db27 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -20,13 +20,43 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/table.h>
 
+static struct nft_table *table_del_parse(int argc, char *argv[])
+{
+	struct nft_table *t;
+	uint16_t family;
+
+	if (strcmp(argv[1], "ip") == 0)
+		family = NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") == 0)
+		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") == 0)
+		family = NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") == 0)
+		family = NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		return NULL;
+	}
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_table_attr_set_str(t, NFT_TABLE_ATTR_NAME, argv[2]);
+	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FAMILY, family);
+
+	return t;
+}
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, family;
-	struct nft_table *t = NULL;
+	struct nft_table *t;
 	int ret;
 
 	if (argc != 3) {
@@ -34,30 +64,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	t = nft_table_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	t = table_del_parse(argc, argv);
+	if (t == NULL)
 		exit(EXIT_FAILURE);
-	}
 
-	seq = time(NULL);
-	if (strcmp(argv[1], "ip") == 0)
-		family = NFPROTO_IPV4;
-	else if (strcmp(argv[1], "ip6") == 0)
-		family = NFPROTO_IPV6;
-	else if (strcmp(argv[1], "bridge") == 0)
-		family = NFPROTO_BRIDGE;
-	else if (strcmp(argv[1], "arp") == 0)
-		family = NFPROTO_ARP;
-	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
-		exit(EXIT_FAILURE);
-	}
 
+	seq = time(NULL);
+	family = nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE, family,
 					NLM_F_ACK, seq);
-	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
-
 	nft_table_nlmsg_build_payload(nlh, t);
 	nft_table_free(t);
 

