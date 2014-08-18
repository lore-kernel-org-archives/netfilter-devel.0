From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] examples: nft-chain-del: add chain_del_parse()
Date: Mon, 18 Aug 2014 11:19:47 +0200
Message-ID: <20140818091947.11948.79838.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:43030 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975AbaHRJT4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:19:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function parses the command line options and creates the nft_chain
object.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-chain-del.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index c87ab92..833bce0 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -20,6 +20,22 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/chain.h>
 
+static struct nft_chain *chain_del_parse(int argc, char *argv[])
+{
+	struct nft_chain *t;
+
+	t = nft_chain_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	nft_chain_attr_set(t, NFT_CHAIN_ATTR_TABLE, argv[2]);
+	nft_chain_attr_set(t, NFT_CHAIN_ATTR_NAME, argv[3]);
+
+	return t;
+}
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -48,16 +64,13 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	t = nft_chain_alloc();
-	if (t == NULL) {
-		perror("OOM");
+	t = chain_del_parse(argc, argv);
+	if (t == NULL)
 		exit(EXIT_FAILURE);
-	}
+
 	seq = time(NULL);
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN, family,
 					NLM_F_ACK, seq);
-	nft_chain_attr_set(t, NFT_CHAIN_ATTR_TABLE, argv[2]);
-	nft_chain_attr_set(t, NFT_CHAIN_ATTR_NAME, argv[3]);
 	nft_chain_nlmsg_build_payload(nlh, t);
 	nft_chain_free(t);
 

