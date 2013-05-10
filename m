From: Eric Leblond <eric@regit.org>
Subject: [PATCH 03/11] postgresql: add sanity checking
Date: Fri, 10 May 2013 08:48:50 +0200
Message-ID: <1368168538-29780-4-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51455 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3EJGtY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:24 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Clean postgresql handler at deinit.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/pgsql/ulogd_output_PGSQL.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index f246153..88fb765 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -214,7 +214,9 @@ static int close_db_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 
-	PQfinish(pi->dbh);
+	if (pi->dbh)
+		PQfinish(pi->dbh);
+	pi->dbh = NULL;
 
 	return 0;
 }
-- 
1.7.10.4

