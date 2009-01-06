From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 6/6] DBI: lower column name before comparing to key
Date: Tue,  6 Jan 2009 23:31:18 +0100
Message-ID: <1231281078-31060-7-git-send-email-chifflier@inl.fr>
References: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52890 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbZAFWaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:30:04 -0500
In-Reply-To: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some databases (e.g Oracle) return column name in uppercase, while
key name is in lowercase. This patch allows to match keys correctly.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 output/dbi/ulogd_output_DBI.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 7c0f4fa..3f086fc 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -21,6 +21,8 @@
 
 #include <dbi.h>
 
+#include <ctype.h>
+
 #ifdef DEBUG_DBI
 #define DEBUGP(x, args...)	fprintf(stderr, x, ## args)
 #else
@@ -86,6 +88,17 @@ static struct config_keyset dbi_kset = {
 #define schema_ce(x)	(x->ces[DB_CE_NUM+5])
 #define dbtype_ce(x)	(x->ces[DB_CE_NUM+6])
 
+
+/* lower-cases s in place */
+static void str_tolower(char *s)
+{
+	while(*s)
+	{
+		*s=tolower(*s);
+		s++;
+	}
+}
+
 /* find out which columns the table has */
 static int get_columns_dbi(struct ulogd_pluginstance *upi)
 {
@@ -139,6 +152,8 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 		while ((underscore = strchr(buf, '_')))
 			*underscore = '.';
 
+		str_tolower(buf);
+
 		DEBUGP("field '%s' found: ", buf);
 
 		/* add it to list of input keys */
-- 
1.5.6.5

