From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 06/11] Fix warning about lack of parenthesis.
Date: Sun, 27 Jul 2008 15:51:21 +0200
Message-ID: <1217166686-28508-7-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43799 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751924AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds parenthesis around an expression to avoid confusion between
order preference of && and || operators.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/pgsql/ulogd_output_PGSQL.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index b04526a..afab2cc 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -288,8 +288,8 @@ static int execute_pgsql(struct ulogd_pluginstance *upi,
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 
 	pi->pgres = PQexec(pi->dbh, stmt);
-	if (!(pi->pgres && (PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)
-		|| (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK))) {
+	if (!(pi->pgres && ((PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)
+		|| (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK)))) {
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
 			  PQerrorMessage(pi->dbh));
 		return -1;
-- 
1.5.4.3

