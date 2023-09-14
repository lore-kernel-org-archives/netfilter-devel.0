Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B209EDE99E
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 09:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbjINJoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237465AbjINJoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 05:44:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3744B1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 02:42:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qgirs-0002Xz-88; Thu, 14 Sep 2023 11:42:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] scanner: restrict include directive to regular files
Date:   Thu, 14 Sep 2023 11:42:16 +0200
Message-ID: <20230914094223.1124496-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230914094223.1124496-1-fw@strlen.de>
References: <20230914094223.1124496-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to previous change, also check all

include "foo"

and reject those if they refer to named fifos, block devices etc.

Directories are still skipped, I don't think we can change this
anymore.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1664
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/scanner.l                                 | 69 ++++++++++++++++++-
 .../testcases/bogons/nft-f/include-device     |  1 +
 2 files changed, 67 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/include-device

diff --git a/src/scanner.l b/src/scanner.l
index 1aae1ecb09ef..15b272ab1e9e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -18,6 +18,7 @@
 #include <arpa/inet.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
+#include <sys/stat.h>
 
 #include <nftables.h>
 #include <erec.h>
@@ -972,9 +973,59 @@ static void scanner_push_file(struct nft_ctx *nft, void *scanner,
 	scanner_push_indesc(state, indesc);
 }
 
+enum nft_include_type {
+	NFT_INCLUDE,
+	NFT_CMDLINE,
+};
+
+static bool __is_useable(unsigned int type, enum nft_include_type t)
+{
+	type &= S_IFMT;
+	switch (type) {
+	case S_IFREG: return true;
+	case S_IFIFO:
+		 return t == NFT_CMDLINE; /* disallow include /path/to/fifo */
+	default:
+		break;
+	}
+
+	return false;
+}
+
+/* need to use stat() to, fopen() will block for named fifos */
+static bool filename_is_useable(const char *name)
+{
+	struct stat sb;
+	int err;
+
+	err = stat(name, &sb);
+	if (err)
+		return false;
+
+	return __is_useable(sb.st_mode, NFT_INCLUDE);
+}
+
+static bool fp_is_useable(FILE *fp, enum nft_include_type t)
+{
+	int fd = fileno(fp);
+	struct stat sb;
+	int err;
+
+	if (fd < 0)
+		return false;
+
+	err = fstat(fd, &sb);
+	if (err < 0)
+		return false;
+
+	return __is_useable(sb.st_mode, t);
+}
+
 static int include_file(struct nft_ctx *nft, void *scanner,
 			const char *filename, const struct location *loc,
-			const struct input_descriptor *parent_indesc)
+			const struct input_descriptor *parent_indesc,
+			enum nft_include_type includetype)
+
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -986,12 +1037,24 @@ static int include_file(struct nft_ctx *nft, void *scanner,
 		goto err;
 	}
 
+	if (includetype == NFT_INCLUDE && !filename_is_useable(filename)) {
+		erec = error(loc, "Not a regular file: \"%s\"\n", filename);
+		goto err;
+	}
+
 	f = fopen(filename, "r");
 	if (f == NULL) {
 		erec = error(loc, "Could not open file \"%s\": %s\n",
 			     filename, strerror(errno));
 		goto err;
 	}
+
+	if (!fp_is_useable(f, includetype)) {
+		fclose(f);
+		erec = error(loc, "Not a regular file: \"%s\"\n", filename);
+		goto err;
+	}
+
 	scanner_push_file(nft, scanner, f, filename, loc, parent_indesc);
 	return 0;
 err:
@@ -1064,7 +1127,7 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 			if (len == 0 || path[len - 1] == '/')
 				continue;
 
-			ret = include_file(nft, scanner, path, loc, indesc);
+			ret = include_file(nft, scanner, path, loc, indesc, NFT_INCLUDE);
 			if (ret != 0)
 				goto err;
 		}
@@ -1101,7 +1164,7 @@ err:
 int scanner_read_file(struct nft_ctx *nft, const char *filename,
 		      const struct location *loc)
 {
-	return include_file(nft, nft->scanner, filename, loc, NULL);
+	return include_file(nft, nft->scanner, filename, loc, NULL, NFT_CMDLINE);
 }
 
 static bool search_in_include_path(const char *filename)
diff --git a/tests/shell/testcases/bogons/nft-f/include-device b/tests/shell/testcases/bogons/nft-f/include-device
new file mode 100644
index 000000000000..1eb797735481
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/include-device
@@ -0,0 +1 @@
+include "/dev/null"
-- 
2.41.0

