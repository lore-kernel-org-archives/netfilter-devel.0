From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/3] sqlite: resolve compiler warnings
Date: Tue,  5 Jun 2012 10:41:01 +0200
Message-ID: <1338885663-30131-2-git-send-email-jengelh@inai.de>
References: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54612 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507Ab2FEIlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:41:08 -0400
In-Reply-To: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In file included from /usr/include/string.h:642:0,
                 from ulogd_output_SQLITE3.c:34:
In function 'strncat',
    inlined from 'db_count_cols' at ulogd_output_SQLITE3.c:306:9,
    inlined from 'sqlite3_init_db' at ulogd_output_SQLITE3.c:328:11:
/usr/include/bits/string3.h:152:3: warning: call to __builtin___strncat_chk might overflow destination buffer [enabled by default]

I: Statement might be overflowing a buffer in strncat. Common mistake:
   BAD: strncat(buffer,charptr,sizeof(buffer)) is wrong, it takes the left over size as 3rd argument
   GOOD: strncat(buffer,charptr,sizeof(buffer)-strlen(buffer)-1)
E: ulogd2 bufferoverflowstrncat ulogd_output_SQLITE3.c:328:11

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 output/sqlite3/ulogd_output_SQLITE3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 3cd2106..dffdda3 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -303,7 +303,7 @@ db_count_cols(struct ulogd_pluginstance *pi, sqlite3_stmt **stmt)
 	struct sqlite3_priv *priv = (void *)pi->private;
 	char query[SELECT_ALL_LEN + CONFIG_VAL_STRING_LEN] = SELECT_ALL_STR;
 
-	strncat(query, table_ce(pi), LINE_LEN);
+	strncat(query, table_ce(pi), sizeof(query) - strlen(query) - 1);
 
 	if (sqlite3_prepare(priv->dbh, query, -1, stmt, 0) != SQLITE_OK)
 		return -1;
-- 
1.7.7

