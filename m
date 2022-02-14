Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFA1C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Feb 2022 12:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352819AbiBNMQa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 07:16:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352797AbiBNMQ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 07:16:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A520C62
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 04:16:19 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C514F601BB
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 13:15:48 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] examples: add libnftables example program
Date:   Mon, 14 Feb 2022 13:16:12 +0100
Message-Id: <20220214121613.311530-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214121613.311530-1-pablo@netfilter.org>
References: <20220214121613.311530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create an example folder to add example source code files to show how to
use libnftables. Add first example program using the buffer API.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac          |  1 +
 examples/Makefile.am  |  3 +++
 examples/nft-buffer.c | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)
 create mode 100644 examples/Makefile.am
 create mode 100644 examples/nft-buffer.c

diff --git a/configure.ac b/configure.ac
index 503883f28c66..d321c960562b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -145,6 +145,7 @@ AC_CONFIG_FILES([					\
 		files/osf/Makefile			\
 		doc/Makefile				\
 		py/Makefile				\
+		examples/Makefile			\
 		])
 AC_OUTPUT
 
diff --git a/examples/Makefile.am b/examples/Makefile.am
new file mode 100644
index 000000000000..dd637fe31340
--- /dev/null
+++ b/examples/Makefile.am
@@ -0,0 +1,3 @@
+noinst_PROGRAMS	= nft-buffer
+
+LDADD = $(top_builddir)/src/libnftables.la
diff --git a/examples/nft-buffer.c b/examples/nft-buffer.c
new file mode 100644
index 000000000000..1c4b1e041d75
--- /dev/null
+++ b/examples/nft-buffer.c
@@ -0,0 +1,34 @@
+/* gcc nft-buffer.c -o nft-buffer -lnftables */
+#include <stdlib.h>
+#include <nftables/libnftables.h>
+
+const char ruleset[] =
+	"flush ruleset;"
+	"add table x;"
+	"add chain x y { type filter hook input priority 0; };"
+	"add rule x y counter;";
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
+	/* create ruleset: all commands in the buffer are atomically applied */
+	err = nft_run_cmd_from_buffer(ctx, ruleset);
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

