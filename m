From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v4 1/2] nfacct: check cmd line argument for singleness
Date: Fri, 12 Sep 2014 14:56:57 +0400
Message-ID: <1410519418-8671-2-git-send-email-a.perevalov@samsung.com>
References: <1410519418-8671-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34857 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaILK5F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:57:05 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBS00IMABVU0MA0@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Fri, 12 Sep 2014 11:59:54 +0100 (BST)
In-reply-to: <1410519418-8671-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was possible to specify several equal options for list operation.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 src/nfacct.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/nfacct.c b/src/nfacct.c
index 091a5c9..e58b9af 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -63,6 +63,13 @@ static void nfacct_perror(const char *msg)
 	}
 }
 
+static void duparg(const char *key)
+{
+	fprintf(stderr, "Error: duplicate \"%s\" or collision with another "
+		"option \n", key);
+	exit(EXIT_FAILURE);
+}
+
 int main(int argc, char *argv[])
 {
 	int cmd = NFACCT_CMD_NONE, ret = 0;
@@ -177,8 +184,12 @@ static int nfacct_cmd_list(int argc, char *argv[])
 
 	for (i=2; i<argc; i++) {
 		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
+			if (zeroctr)
+				duparg(argv[i]);
 			zeroctr = true;
 		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+			if (xml)
+				duparg(argv[i]);
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
-- 
1.7.9.5

