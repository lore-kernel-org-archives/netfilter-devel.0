Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E79EDE99C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 09:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbjINJo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbjINJoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 05:44:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632DC44A8
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 02:42:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qgirn-0002Xq-RJ; Thu, 14 Sep 2023 11:42:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] libnftables: refuse to open onput files other than named pipes or regular files
Date:   Thu, 14 Sep 2023 11:42:15 +0200
Message-ID: <20230914094223.1124496-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't start e.g. parsing a block device.
nftables is typically run as privileged user, exit early if we
get unexpected input.

Only exception: Allow character device if input is /dev/stdin.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1664
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftables.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index c5f5729409d1..b143c9b562a7 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -17,6 +17,7 @@
 #include <cmd.h>
 #include <errno.h>
 #include <string.h>
+#include <sys/stat.h>
 
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs)
@@ -673,13 +674,46 @@ retry:
 	return rc;
 }
 
+/* need to use stat() to, fopen() will block for named fifos and
+ * libjansson makes no checks before or after open either.
+ */
+static struct error_record *filename_is_useable(struct nft_ctx *nft, const char *name)
+{
+	unsigned int type;
+	struct stat sb;
+	int err;
+
+	err = stat(name, &sb);
+	if (err)
+		return error(&internal_location, "Could not open file \"%s\": %s\n",
+			     name, strerror(errno));
+
+	type = sb.st_mode & S_IFMT;
+
+	if (type == S_IFREG || type == S_IFIFO)
+		return NULL;
+
+	if (type == S_IFCHR && 0 == strcmp(name, "/dev/stdin"))
+		return NULL;
+
+	return error(&internal_location, "Not a regular file: \"%s\"\n", name);
+}
+
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
+	struct error_record *erec;
 	struct cmd *cmd, *next;
 	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 
+	erec = filename_is_useable(nft, filename);
+	if (erec) {
+		erec_print(&nft->output, erec, nft->debug_mask);
+		erec_destroy(erec);
+		return -1;
+	}
+
 	rc = load_cmdline_vars(nft, &msgs);
 	if (rc < 0)
 		goto err;
-- 
2.41.0

