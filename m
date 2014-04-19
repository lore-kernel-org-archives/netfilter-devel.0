From: Bob Hockney <zeus@ix.netcom.com>
Subject: [PATCH 2/2] Connection parameters other than connstring are ignored
Date: Sat, 19 Apr 2014 12:43:37 -0600
Message-ID: <201404221918.s3MJI0Hl022667@gateway.ford-prefect.net>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [24.49.174.127] ([24.49.174.127]:7235 "EHLO
	smtp.ford-prefect.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDVT0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:26:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Connection parameters other than connstring are ignored,
 forcing its use.  u.string in config_keyset in conffile.h is a character
 array, not a pointer, and is initialized as a zero length string, not a null
 pointer, so the pointer assignment to connstr will always be a valid pointer,
 not NULL, so (! connstr) will always be false.

Signed-off-by: Bob Hockney <zeus@ix.netcom.com>
---
 output/pgsql/ulogd_output_PGSQL.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index fda289e..ac87a64 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -236,7 +236,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	char *schema = NULL;
 	char pgbuf[128];
 
-	if (!connstr) {
+	if (! strlen(connstr)) {
 		char *server = host_ce(upi->config_kset).u.string;
 		unsigned int port = port_ce(upi->config_kset).u.value;
 		char *user = user_ce(upi->config_kset).u.string;
-- 
1.8.3.1

