From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 01/11] Fix some simple warnings.
Date: Sun, 27 Jul 2008 15:51:16 +0200
Message-ID: <1217166686-28508-2-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43797 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes some gcc warnings:
 * Unused variables
 * Functions with wrong return (or without return)

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    3 ---
 filter/ulogd_filter_IFINDEX.c             |    2 +-
 filter/ulogd_filter_IP2BIN.c              |    4 ++--
 filter/ulogd_filter_PWSNIFF.c             |    1 -
 output/mysql/ulogd_output_MYSQL.c         |    2 --
 output/pgsql/ulogd_output_PGSQL.c         |    1 -
 src/ulogd.c                               |    3 +--
 util/db.c                                 |    5 +----
 util/printpkt.c                           |    2 --
 9 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index dde1cf3..7c6fd26 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -920,9 +920,6 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 
 static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)
 {
-	struct ulogd_key *ret = pi->output.keys;
-	const struct sk_buff *skb =
-		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
 	const u_int16_t proto =
 		GET_VALUE(pi->input.keys, INKEY_OOB_PROTOCOL).ui16;
 
diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index 6491127..f7571bd 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -84,7 +84,7 @@ static int nlif_read_cb(int fd, unsigned int what, void *param)
 	if (!(what & ULOGD_FD_READ))
 		return 0;
 
-	nlif_catch(nlif_inst);
+	return nlif_catch(nlif_inst);
 }
 
 static int ifindex_start(struct ulogd_pluginstance *upi)
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index c4b44fa..2d9fc16 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -147,7 +147,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 		default:
 			/* TODO handle error */
 			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
-			return;
+			return NULL;
 	}
 
 	buffer = tmp;
@@ -161,7 +161,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 				addr8[0], addr8[1], addr8[2], addr8[3]);
 		if (written != 2 * 4) {
 			buffer[0] = 0;
-			return;
+			return NULL;
 		}
 		buffer += written;
 		addr8 += 4;
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 95d92b5..290e4cb 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -60,7 +60,6 @@ static unsigned char *_get_next_blank(unsigned char* begp, unsigned char *endp)
 
 static int interp_pwsniff(struct ulogd_pluginstance *pi)
 {
-	struct ulogd_key *inp = pi->input.keys;
 	struct ulogd_key *ret = pi->output.keys;
 	struct iphdr *iph;
 	void *protoh;
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index fd650bf..562424b 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -102,7 +102,6 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
 	MYSQL_RES *result;
 	MYSQL_FIELD *field;
-	struct ulogd_key *f, *f2;
 	int i;
 
 	if (!mi->dbh) {
@@ -144,7 +143,6 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	for (i = 0; field = mysql_fetch_field(result); i++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
-		int id;
 
 		/* replace all underscores with dots */
 		strncpy(buf, field->name, ULOGD_MAX_KEYLEN);
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 7ece626..b04526a 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -183,7 +183,6 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 	for (i = 0; i < PQntuples(pi->pgres); i++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
-		int id;
 
 		/* replace all underscores with dots */
 		strncpy(buf, PQgetvalue(pi->pgres, i, 0), ULOGD_MAX_KEYLEN);
diff --git a/src/ulogd.c b/src/ulogd.c
index 4e36984..33d58ee 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -204,7 +204,6 @@ int ulogd_wildcard_inputkeys(struct ulogd_pluginstance *upi)
 
 	/* second pass: copy key names */
 	llist_for_each_entry(pi_cur, &stack->list, list) {
-		struct ulogd_key *cur;
 		int i;
 
 		for (i = 0; i < pi_cur->plugin->output.num_keys; i++)
@@ -1022,7 +1021,7 @@ static struct option opts[] = {
 	{ "help", 0, NULL, 'h' },
 	{ "configfile", 1, NULL, 'c'},
 	{ "uid", 1, NULL, 'u' },
-	{ "info", 1, NULL, 'i'},
+	{ "info", 1, NULL, 'i' },
 	{ 0 }
 };
 
diff --git a/util/db.c b/util/db.c
index 946458a..9b4da8d 100644
--- a/util/db.c
+++ b/util/db.c
@@ -31,6 +31,7 @@
 #include <errno.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
+#include <time.h>
 
 #include <ulogd/ulogd.h>
 #include <ulogd/db.h>
@@ -62,8 +63,6 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *mi = (struct db_instance *) upi->private;
 	unsigned int size;
-	char buf[ULOGD_MAX_KEYLEN];
-	char *underscore;
 	int i;
 	char *table = table_ce(upi->config_kset).u.string;
 	char *procedure = procedure_ce(upi->config_kset).u.string;
@@ -245,8 +244,6 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 		}
 		
 		switch (res->type) {
-			char *tmpstr;
-			struct in_addr addr;
 		case ULOGD_RET_INT8:
 			sprintf(di->stmt_ins, "%d,", res->u.value.i8);
 			break;
diff --git a/util/printpkt.c b/util/printpkt.c
index 90fec0e..c64a4cb 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -276,7 +276,6 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
-	char tmp[INET6_ADDRSTRLEN];
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
@@ -353,7 +352,6 @@ int printpkt_arp(struct ulogd_key *res, char *buf)
 	char *buf_cur = buf;
 	u_int16_t code = 0;
 	u_int8_t *mac;
-	char tmp[INET_ADDRSTRLEN];
 
 	if (pp_is_valid(res, KEY_ARP_SPA))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-- 
1.5.4.3

