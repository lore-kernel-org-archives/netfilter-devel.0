Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10659C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jan 2022 18:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiACSLp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:11:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57470 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiACSLo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 13:11:44 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E029C62BDB
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jan 2022 19:08:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH ulogd2 1/2] output: JSON: fix possible truncation of socket path
Date:   Mon,  3 Jan 2022 19:11:37 +0100
Message-Id: <20220103181138.101880-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verify that the path is shorter than 108 bytes (maximum unix socket path).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 output/ulogd_output_JSON.c | 48 +++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 913dfb84c8e7..83ad03efa145 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -33,6 +33,10 @@
 #include <ulogd/conffile.h>
 #include <jansson.h>
 
+#ifndef UNIX_PATH_MAX
+#define UNIX_PATH_MAX 108
+#endif
+
 #ifndef ULOGD_JSON_DEFAULT
 #define ULOGD_JSON_DEFAULT	"/var/log/ulogd.json"
 #endif
@@ -146,23 +150,21 @@ static void close_socket(struct json_priv *op) {
 
 static int _connect_socket_unix(struct ulogd_pluginstance *pi)
 {
+	const char *socket_path = file_ce(pi->config_kset).u.string;
 	struct json_priv *op = (struct json_priv *) &pi->private;
-	struct sockaddr_un u_addr;
+	struct sockaddr_un u_addr = { .sun_family = AF_UNIX };
 	int sfd;
 
 	close_socket(op);
 
-	ulogd_log(ULOGD_DEBUG, "connecting to unix:%s\n",
-		  file_ce(pi->config_kset).u.string);
+	ulogd_log(ULOGD_DEBUG, "connecting to unix:%s\n", socket_path);
+	strcpy(u_addr.sun_path, socket_path);
 
 	sfd = socket(AF_UNIX, SOCK_STREAM, 0);
-	if (sfd == -1) {
+	if (sfd == -1)
 		return -1;
-	}
-	u_addr.sun_family = AF_UNIX;
-	strncpy(u_addr.sun_path, file_ce(pi->config_kset).u.string,
-		sizeof(u_addr.sun_path) - 1);
-	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(struct sockaddr_un)) == -1) {
+
+	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(u_addr)) == -1) {
 		close(sfd);
 		return -1;
 	}
@@ -430,9 +432,33 @@ static void reopen_file(struct ulogd_pluginstance *upi)
 	}
 }
 
+static int validate_unix_socket(struct ulogd_pluginstance *upi)
+{
+	const char *socket_path = file_ce(upi->config_kset).u.string;
+
+	if (!socket_path[0]) {
+		ulogd_log(ULOGD_ERROR, "missing unix socket path");
+		return -1;
+	}
+	if (strlen(socket_path) >= UNIX_PATH_MAX) {
+		ulogd_log(ULOGD_ERROR, "unix socket path `%s' is longer than %u\n",
+			  file_ce(upi->config_kset).u.string, UNIX_PATH_MAX);
+		return -1;
+	}
+
+	return 0;
+}
+
 static void reopen_socket(struct ulogd_pluginstance *upi)
 {
+	struct json_priv *op = (struct json_priv *) &upi->private;
+
 	ulogd_log(ULOGD_NOTICE, "JSON: reopening socket\n");
+
+	if (op->mode == JSON_MODE_UNIX &&
+	    validate_unix_socket(upi) < 0)
+		return;
+
 	if (_connect_socket(upi) < 0) {
 		ulogd_log(ULOGD_ERROR, "can't open JSON "
 				       "socket: %s\n",
@@ -510,6 +536,10 @@ static int json_init_socket(struct ulogd_pluginstance *upi)
 	if (port_ce(upi->config_kset).u.string == NULL)
 		return -1;
 
+	if (op->mode == JSON_MODE_UNIX &&
+	    validate_unix_socket(upi) < 0)
+		return -1;
+
 	op->sock = -1;
 	return _connect_socket(upi);
 }
-- 
2.30.2

