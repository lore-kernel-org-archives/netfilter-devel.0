From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 6/29] bugfix: prevent 0-sized nfacct name being accepted
Date: Wed, 10 Jul 2013 19:25:04 +0100
Message-ID: <1373480727-11254-7-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52697 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:50 -0400
Received: by mail-lb0-f177.google.com with SMTP id 10so5942083lbf.36
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:49 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add additional checks in nfacct_cmd_add, nfacct_cmd_delete and
nfacct_cmd_get functions to prevent zero-sized string being accepted as a
command line parameter for nfacct object name;

* add a separate check for the number of command-line arguments in
nfacct_cmd_restore, preventing arbitrary parameters being specified;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 1324da7..bf50f50 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -298,7 +298,7 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 
 static int nfacct_cmd_add(int argc, char *argv[])
 {
-	if (argc < 3) {
+	if (argc < 3 || strlen(argv[2]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
 	} else if (argc > 3) {
@@ -318,7 +318,7 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 	struct nfacct *nfacct;
 	int ret;
 
-	if (argc < 3) {
+	if (argc < 3 || strlen(argv[2]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
 	} else if (argc > 3) {
@@ -385,7 +385,7 @@ static int nfacct_cmd_get(int argc, char *argv[])
 	struct nfacct *nfacct;
 	int ret, i;
 
-	if (argc < 3) {
+	if (argc < 3 || strlen(argv[2]) == 0) {
 		nfacct_perror("missing object name");
 		return -1;
 	}
@@ -546,6 +546,11 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 	char buffer[512];
 	int ret;
 
+	if (argc > 2) {
+		nfacct_perror("too many arguments");
+		return -1;
+	}
+
 	while (fgets(buffer, sizeof(buffer), stdin)) {
 		char *semicolon = strchr(buffer, ';');
 		if (semicolon == NULL) {
-- 
1.8.3.1

