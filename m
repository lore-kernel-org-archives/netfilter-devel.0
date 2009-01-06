From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 1/6] PostgreSQL: allow local connections
Date: Tue,  6 Jan 2009 23:31:13 +0100
Message-ID: <1231281078-31060-2-git-send-email-chifflier@inl.fr>
References: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52895 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbZAFWaF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:30:05 -0500
In-Reply-To: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to connect to the server using the local (unix) socket,
thus not using a network socket and SSL encryption.
Local connection is used if host parameter is omitted or empty.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 output/pgsql/ulogd_output_PGSQL.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index afab2cc..39ffdb4 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -237,8 +237,9 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	connstr = (char *) malloc(len);
 	if (!connstr) 
 		return -ENOMEM;
+	connstr[0] = '\0';
 
-	if (server) {
+	if (server && strlen(server)>0) {
 		strcpy(connstr, " host=");
 		strcat(connstr, server);
 	}
-- 
1.5.6.5

