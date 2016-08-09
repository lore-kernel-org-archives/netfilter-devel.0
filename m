From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] scanner: honor absolute and relative paths via include file
Date: Tue,  9 Aug 2016 11:29:40 +0200
Message-ID: <1470734982-10298-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbcHIJaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 05:30:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 06FDFE9761
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA5CA9663B
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5D6C7FF2FE
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2016 11:30:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the path refers to an absolute or relative path, do not check for the
default include paths, eg. /etc/nftables/.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1040
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 88669d0..6f1a551 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -611,6 +611,13 @@ err:
 	return -1;
 }
 
+static bool search_in_include_path(const char *filename)
+{
+	return (strncmp(filename, "./", strlen("./") != 0) &&
+		strncmp(filename, "../", strlen("../") != 0) &&
+		filename[0] != '/');
+}
+
 int scanner_include_file(void *scanner, const char *filename,
 			 const struct location *loc)
 {
@@ -622,13 +629,16 @@ int scanner_include_file(void *scanner, const char *filename,
 	FILE *f;
 
 	f = NULL;
-	for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
-		if (include_paths[i] == NULL)
-			break;
-		snprintf(buf, sizeof(buf), "%s/%s", include_paths[i], filename);
-		f = fopen(buf, "r");
-		if (f != NULL)
-			break;
+	if (search_in_include_path(filename)) {
+		for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
+			if (include_paths[i] == NULL)
+				break;
+			snprintf(buf, sizeof(buf), "%s/%s",
+				 include_paths[i], filename);
+			f = fopen(buf, "r");
+			if (f != NULL)
+				break;
+		}
 	}
 	if (f == NULL) {
 		f = fopen(filename, "r");
-- 
2.1.4

