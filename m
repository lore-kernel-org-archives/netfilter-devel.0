From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libnl-nft PATCH] Fix file descriptor leak on error
Date: Tue, 25 Dec 2012 15:21:10 +0100
Message-ID: <50D9B656.6040809@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:36981 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2LYOVN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:21:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Detected by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 lib/utils.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/utils.c b/lib/utils.c
index 4007bee..50ca6d9 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -60,24 +60,32 @@ int __nl_read_num_str_file(const char *path, int (*cb)(long, const char *))
 			continue;
 
 		num = strtol(buf, &end, 0);
-		if (end == buf)
+		if (end == buf) {
+			fclose(fd);
 			return -NLE_INVAL;
+		}
 
-		if (num == LONG_MIN || num == LONG_MAX)
+		if (num == LONG_MIN || num == LONG_MAX) {
+			fclose(fd);
 			return -NLE_RANGE;
+		}
 
 		while (*end == ' ' || *end == '\t')
 			end++;
 
 		goodlen = strcspn(end, "#\r\n\t ");
-		if (goodlen == 0)
+		if (goodlen == 0) {
+			fclose(fd);
 			return -NLE_INVAL;
+		}
 
 		end[goodlen] = '\0';
 
 		err = cb(num, end);
-		if (err < 0)
+		if (err < 0) {
+			fclose(fd);
 			return err;
+		}
 	}
 
 	fclose(fd);
-- 
1.7.11.7

