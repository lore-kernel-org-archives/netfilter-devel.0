Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0235BC43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Feb 2022 12:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352797AbiBNMQf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 07:16:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352854AbiBNMQe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 07:16:34 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F309488A9
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 04:16:26 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C61EB601C1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 13:15:56 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] examples: load ruleset from JSON
Date:   Mon, 14 Feb 2022 13:16:13 +0100
Message-Id: <20220214121613.311530-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214121613.311530-1-pablo@netfilter.org>
References: <20220214121613.311530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add an example to load a ruleset file expressed in JSON.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/Makefile.am      |  3 ++-
 examples/json-ruleset.nft | 43 +++++++++++++++++++++++++++++++++++++++
 examples/nft-json-file.c  | 30 +++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 examples/json-ruleset.nft
 create mode 100644 examples/nft-json-file.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index dd637fe31340..c972170d3fdc 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -1,3 +1,4 @@
-noinst_PROGRAMS	= nft-buffer
+noinst_PROGRAMS	= nft-buffer		\
+		  nft-json-file
 
 LDADD = $(top_builddir)/src/libnftables.la
diff --git a/examples/json-ruleset.nft b/examples/json-ruleset.nft
new file mode 100644
index 000000000000..acea1786649a
--- /dev/null
+++ b/examples/json-ruleset.nft
@@ -0,0 +1,43 @@
+{
+  "nftables": [
+    {
+      "flush": {
+        "ruleset": {
+          "family": "ip"
+        }
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "x"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "y",
+        "expr": [
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/examples/nft-json-file.c b/examples/nft-json-file.c
new file mode 100644
index 000000000000..0c832f22e206
--- /dev/null
+++ b/examples/nft-json-file.c
@@ -0,0 +1,30 @@
+/* gcc nft-json-file.c -o nft-json-file -lnftables */
+#include <stdlib.h>
+#include <nftables/libnftables.h>
+
+int main(void)
+{
+	struct nft_ctx *ctx;
+	int err;
+
+	ctx = nft_ctx_new(0);
+	if (!ctx) {
+		perror("cannot allocate nft context");
+		return EXIT_FAILURE;
+	}
+
+	nft_ctx_output_set_flags(ctx, NFT_CTX_OUTPUT_JSON);
+
+	/* create ruleset: all commands in the buffer are atomically applied */
+	err = nft_run_cmd_from_filename(ctx, "json-ruleset.nft");
+	if (err < 0)
+		fprintf(stderr, "failed to run nftables command\n");
+
+	err = nft_run_cmd_from_buffer(ctx, "list ruleset");
+	if (err < 0)
+		fprintf(stderr, "failed to run nftables command\n");
+
+	nft_ctx_free(ctx);
+
+	return EXIT_SUCCESS;
+}
-- 
2.30.2

