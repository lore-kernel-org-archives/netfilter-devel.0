Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357CCCCA47B
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 22:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbiF0Wky (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 18:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242741AbiF0Wkl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 18:40:41 -0400
X-Greylist: delayed 1004 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Jun 2022 15:40:28 PDT
Received: from janet.servers.dxld.at (unknown [5.9.225.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE96620BDB
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 15:40:28 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 28 Jun 2022 00:23:30 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] Allow resetting the include search path
Date:   Tue, 28 Jun 2022 00:23:04 +0200
Message-Id: <20220627222304.93139-1-dxld@darkboxed.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently there is no way to disable searching in DEFAULT_INCLUDE_PATH
first. This is needed when testing nftables configurations spanning
multiple files without overwriting the globally installed ones.
---
 doc/nft.txt | 4 ++--
 src/main.c  | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index f7a53ac9..f04c3e20 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -55,8 +55,8 @@ understanding of their meaning. You can get information about options by running
 
 *-I*::
 *--includepath directory*::
-	Add the directory 'directory' to the list of directories to be searched for included files. This
-	option may be specified multiple times.
+	Append a directory to the end of the search path for the *include* statement. If the empty
+	string is passed the list is reset. This option may be specified multiple times.
 
 *-c*::
 *--check*::
diff --git a/src/main.c b/src/main.c
index 9bd25db8..f5dd3dba 100644
--- a/src/main.c
+++ b/src/main.c
@@ -411,7 +411,9 @@ int main(int argc, char * const *argv)
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-			if (nft_ctx_add_include_path(nft, optarg)) {
+			if (strcmp(optarg, "") == 0) {
+				nft_ctx_clear_include_paths(nft);
+			} else if (nft_ctx_add_include_path(nft, optarg)) {
 				fprintf(stderr,
 					"Failed to add include path '%s'\n",
 					optarg);
-- 
2.30.2

