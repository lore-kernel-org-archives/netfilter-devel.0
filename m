From: Eric Leblond <eric@regit.org>
Subject: [Ulogd PATCH 1/4] postgresql: add sanity checking
Date: Mon, 18 Mar 2013 01:01:21 +0100
Message-ID: <1363564884-5957-2-git-send-email-eric@regit.org>
References: <1363564884-5957-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44632 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab3CRABt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:01:49 -0400
In-Reply-To: <1363564884-5957-1-git-send-email-eric@regit.org>
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

