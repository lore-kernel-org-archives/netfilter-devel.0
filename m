From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/6] Allow plain INSERT instead of procedure
Date: Tue,  6 Jan 2009 23:31:14 +0100
Message-ID: <1231281078-31060-3-git-send-email-chifflier@inl.fr>
References: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52891 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZAFWaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:30:04 -0500
In-Reply-To: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the procedure name specified in configuration is INSERT, than use
a regular insertion instead of a stored procedure.
This should be used when performance is needed, with a flat SQL schema,
to reduce the cost of SQL procedure calls.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 util/db.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/util/db.c b/util/db.c
index 61c31a3..077d8be 100644
--- a/util/db.c
+++ b/util/db.c
@@ -91,8 +91,33 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		return -ENOMEM;
 	}
 
-	sprintf(mi->stmt, "SELECT %s(", procedure);
+	if (strcasecmp(procedure,"INSERT")==0) {
+		char buf[ULOGD_MAX_KEYLEN];
+		char *underscore;
+
+		if (mi->schema)
+			sprintf(mi->stmt, "insert into %s.%s (", mi->schema, table);
+		else
+			sprintf(mi->stmt, "insert into %s (", table);
+		mi->stmt_val = mi->stmt + strlen(mi->stmt);
+
+		for (i = 0; i < upi->input.num_keys; i++) {
+			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
+				continue;
+
+			strncpy(buf, upi->input.keys[i].name, ULOGD_MAX_KEYLEN);	
+			while ((underscore = strchr(buf, '.')))
+				*underscore = '_';
+			sprintf(mi->stmt_val, "%s,", buf);
+			mi->stmt_val = mi->stmt + strlen(mi->stmt);
+		}
+		*(mi->stmt_val - 1) = ')';
+
+		sprintf(mi->stmt_val, " values (");
+	} else {
+		sprintf(mi->stmt, "SELECT %s(", procedure);
 
+	}
 	mi->stmt_val = mi->stmt + strlen(mi->stmt);
 
 	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", mi->stmt);
-- 
1.5.6.5

