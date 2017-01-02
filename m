From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft] scanner: fix search_in_include_path test
Date: Mon,  2 Jan 2017 16:30:01 +0100
Message-ID: <20170102153002.6711-1-anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:47956 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756408AbdABPaW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 10:30:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

clang emits a warning in this function as we're using a boolean as the third
argument to strncmp. Indeed, this function only checks the first byte of the
path as is, so files beginning with . will be incorrectly included from the
current working directory instead of the include directory.

Fixes: f92a1a5c4a8761c39a76b264859f0ff2c8f71179
Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 src/scanner.l | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 625023f..bf88955 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -629,8 +629,8 @@ err:
 
 static bool search_in_include_path(const char *filename)
 {
-	return (strncmp(filename, "./", strlen("./") != 0) &&
-		strncmp(filename, "../", strlen("../") != 0) &&
+	return (strncmp(filename, "./", strlen("./")) != 0 &&
+		strncmp(filename, "../", strlen("../")) != 0 &&
 		filename[0] != '/');
 }
 
-- 
2.11.0

