From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 02/14] Suppress ip_as_string configuration variable.
Date: Sun, 23 Mar 2008 17:25:10 +0100
Message-ID: <12062895222096-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55043 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752637AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch suppress a now unused option. Each database module
have now to be used with a defined IP storage type.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/db.h |   11 +++--------
 util/db.c          |   11 -----------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 62819f2..b0b7295 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -37,10 +37,6 @@ struct db_instance {
 			.u.value = RECONNECT_DEFAULT,		\
 		},						\
 		{						\
-			.key = "ip_as_string",			\
-			.type = CONFIG_TYPE_INT,		\
-		},						\
-		{						\
 			.key = "connect_timeout",		\
 			.type = CONFIG_TYPE_INT,		\
 		},						\
@@ -50,12 +46,11 @@ struct db_instance {
 			.options = CONFIG_OPT_MANDATORY,	\
 		}
 
-#define DB_CE_NUM	5
+#define DB_CE_NUM	4
 #define table_ce(x)	(x->ces[0])
 #define reconnect_ce(x)	(x->ces[1])
-#define asstring_ce(x)	(x->ces[2])
-#define timeout_ce(x)	(x->ces[3])
-#define procedure_ce(x)	(x->ces[4])
+#define timeout_ce(x)	(x->ces[2])
+#define procedure_ce(x)	(x->ces[3])
 
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal);
 int ulogd_db_start(struct ulogd_pluginstance *upi);
diff --git a/util/db.c b/util/db.c
index b9ca8db..3cfe057 100644
--- a/util/db.c
+++ b/util/db.c
@@ -265,17 +265,6 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			sprintf(di->stmt_ins, "%u,", res->u.value.ui16);
 			break;
 		case ULOGD_RET_IPADDR:
-			if (asstring_ce(upi->config_kset).u.value) {
-				memset(&addr, 0, sizeof(addr));
-				addr.s_addr = ntohl(res->u.value.ui32);
-				*(di->stmt_ins++) = '\'';
-				tmpstr = inet_ntoa(addr);
-				di->driver->escape_string(upi, di->stmt_ins,
-							  tmpstr, strlen(tmpstr));
-				di->stmt_ins = di->stmt + strlen(di->stmt);
-				sprintf(di->stmt_ins, "',");
-				break;
-			}
 			/* fallthrough when logging IP as u_int32_t */
 		case ULOGD_RET_UINT32:
 			sprintf(di->stmt_ins, "%u,", res->u.value.ui32);
-- 
1.5.2.5

