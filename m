From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft-sync PATCH 3/3] client: parse ruleset before printing
Date: Fri, 26 Dec 2014 13:51:33 +0100
Message-ID: <20141226125133.16382.87197.stgit@nfdev.cica.es>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41864 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbaLZMvm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:51:42 -0500
In-Reply-To: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of printing directly the payload to stdout, let's parse it with
libnftnl, so we make sure we fetch a ruleset that we actually understand.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/client.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/src/client.c b/src/client.c
index d509a52..c979392 100644
--- a/src/client.c
+++ b/src/client.c
@@ -21,12 +21,55 @@
 #include "msg_buff.h"
 #include "proto.h"
 #include "config.h"
+#include "utils.h"
+
+#include <libnftnl/ruleset.h>
+#include <libnftnl/common.h>
+
+static struct nft_ruleset *payload2ruleset(struct msg_buff *msgb)
+{
+	struct nft_ruleset *rs;
+	struct nft_parse_err *err;
+	char *data = (char *)(msgb_data(msgb) + sizeof(struct nft_sync_hdr));
+
+	rs = nft_ruleset_alloc();
+	if (rs == NULL)
+		memory_allocation_error();
+
+	err = nft_parse_err_alloc();
+	if (err == NULL)
+		memory_allocation_error();
+
+	if (nft_ruleset_parse(rs, NFT_PARSE_XML, data, err) < 0) {
+		nft_parse_perror("unable to parse remote ruleset", err);
+		nft_parse_err_free(err);
+		nft_ruleset_free(rs);
+		return NULL;
+	}
+
+	nft_parse_err_free(err);
+	return rs;
+}
 
 static void print_payload(struct msg_buff *msgb)
 {
-	write(1, msgb_data(msgb) + sizeof(struct nft_sync_hdr),
-	      msgb_len(msgb) - sizeof(struct nft_sync_hdr));
-	write(1, "\n", 1);
+	struct nft_ruleset *rs = payload2ruleset(msgb);
+
+	if (rs == NULL) {
+		nfts_log(NFTS_LOG_ERROR,
+			 "unable to parse remote ruleset\n");
+		return;
+	}
+
+	if (nft_ruleset_fprintf(stdout, rs, NFT_OUTPUT_XML, 0) < 0) {
+		nfts_log(NFTS_LOG_ERROR,
+			 "unable to print remote ruleset to stdout\n");
+		nft_ruleset_free(rs);
+		return;
+	}
+
+	nft_ruleset_free(rs);
+	fprintf(stdout, "\n");
 }
 
 static int process_response(struct msg_buff *msgb, int len)

