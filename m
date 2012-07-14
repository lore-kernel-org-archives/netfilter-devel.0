From: Eric Leblond <eric@regit.org>
Subject: [PATCH] Fix typo in loop.
Date: Sat, 14 Jul 2012 23:40:32 +0200
Message-ID: <1342302032-9108-2-git-send-email-eric@regit.org>
References: <1342302032-9108-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37668 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2GNVld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 17:41:33 -0400
In-Reply-To: <1342302032-9108-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a small typo in the command line parsing.
---
 src/nfacct.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index a59366e..8407670 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -159,9 +159,9 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	int ret, i;
 
 	for (i=2; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[2])) == 0) {
+		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[2])) == 0) {
+		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
@@ -357,9 +357,9 @@ static int nfacct_cmd_get(int argc, char *argv[])
 		return -1;
 	}
 	for (i=3; i<argc; i++) {
-		if (strncmp(argv[i], "reset", strlen(argv[2])) == 0) {
+		if (strncmp(argv[i], "reset", strlen(argv[i])) == 0) {
 			zeroctr = true;
-		} else if (strncmp(argv[i], "xml", strlen(argv[2])) == 0) {
+		} else if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
 			xml = true;
 		} else {
 			nfacct_perror("unknown argument");
-- 
1.7.10.4

