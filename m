From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 2/3] add mark event filter
Date: Tue, 8 Apr 2014 19:32:19 +0900
Message-ID: <20140408103218.GC29462@gmail.com>
References: <20140408102614.GA29462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49922 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaDHKcZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:32:25 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so826386pdi.2
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2014 03:32:25 -0700 (PDT)
Received: from gmail.com (softbank220009032009.bbtec.net. [220.9.32.9])
        by mx.google.com with ESMTPSA id hr5sm8377239pac.18.2014.04.08.03.32.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 08 Apr 2014 03:32:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140408102614.GA29462@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new configuration variable which is used to limit
conntrack event to connection of the mark.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 configure.ac                    | 15 +++++++++
 input/flow/ulogd_inpflow_NFCT.c | 75 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 522c345..7e5f5fc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -58,6 +58,20 @@ AS_IF([test "x$enable_nfct" = "xyes"], [
     AC_DEFINE([BUILD_NFCT], [1], [Building nfct module])
 ])
 AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
+AS_IF([test "x$enable_nfct" = "xyes"], [
+    AC_MSG_CHECKING([for enable mark filter for event])
+    AC_CACHE_VAL(ac_cv_nfct_filter_mark,
+    AC_TRY_COMPILE(
+        [ #include <libnetfilter_conntrack/libnetfilter_conntrack.h>],
+        [ int i = NFCT_FILTER_MARK; ],
+        ac_cv_nfct_filter_mark=yes,
+        ac_cv_nfct_filter_mark=no))
+    AC_MSG_RESULT($ac_cv_nfct_filter_mark)
+    AS_IF([test "x$ac_cv_nfct_filter_mark" = "xyes"], [
+        AC_DEFINE([HAVE_NFCT_FILTER_MARK], [1], [Building nfct mark event filter])
+    ])
+])
+
 AC_ARG_ENABLE(nfacct,
        AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),,[enable_nfacct=yes])
 AS_IF([test "x$enable_nfacct" = "xyes"], [
@@ -156,6 +170,7 @@ Ulogd configuration:
   Input plugins:
     NFLOG plugin:			${enable_nflog}
     NFCT plugin:			${enable_nfct}
+      with MARK event filter		${ac_cv_nfct_filter_mark}
     NFACCT plugin:			${enable_nfacct}
   Output plugins:
     PCAP plugin:			${enable_pcap}
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3..a5cf854 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -35,6 +35,7 @@
 
 #include <sys/time.h>
 #include <time.h>
+#include <ctype.h>
 #include <netinet/in.h>
 #include <netdb.h>
 #include <ulogd/linuxlist.h>
@@ -78,7 +79,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 12,
+	.num_ces = 13,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -149,6 +150,11 @@ static struct config_keyset nfct_kset = {
 			.type	 = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
+		{
+			.key	 = "accept_mark_filter",
+			.type	 = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -163,6 +169,7 @@ static struct config_keyset nfct_kset = {
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
 #define proto_filter_ce(x)	((x)->ces[11])
+#define mark_filter_ce(x)	((x)->ces[12])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -1221,6 +1228,60 @@ static int build_nfct_filter_proto(struct nfct_filter *filter, char* filter_stri
 	return 0;
 }
 
+#if defined HAVE_NFCT_FILTER_MARK
+static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_string)
+{
+	char *p, *endptr;
+	uintmax_t v;
+	struct nfct_filter_dump_mark filter_mark;
+	errno = 0;
+
+	for (p = filter_string; isspace(*p); ++p)
+		;
+	v = strtoumax(p, &endptr, 0);
+	if (endptr == p)
+		goto invalid_error;
+	if ((errno == ERANGE && v == UINTMAX_MAX) || errno != 0)
+		goto invalid_error;
+	filter_mark.val = (uint32_t)v;
+
+	if (*endptr != '\0') {
+		for (p = endptr; isspace(*p); ++p)
+			;
+		if (*p++ != '/')
+			goto invalid_error;
+		for (; isspace(*p); ++p)
+			;
+		v = strtoumax(p, &endptr, 0);
+		if (endptr == p)
+			goto invalid_error;
+		if ((errno == ERANGE && v == UINTMAX_MAX) || errno != 0)
+			goto invalid_error;
+		filter_mark.mask = (uint32_t)v;
+		if (*endptr != '\0')
+			goto invalid_error;
+	} else {
+		filter_mark.mask = UINT32_MAX;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "adding mark to filter: \"%u/%u\"\n",
+		  filter_mark.val, filter_mark.mask);
+	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &filter_mark);
+
+	return 0;
+
+invalid_error:
+	ulogd_log(ULOGD_FATAL, "invalid val/mask %s\n", filter_string);
+	return -1;
+
+}
+#else
+static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_string)
+{
+	ulogd_log(ULOGD_FATAL, "mark filter is not supported\n");
+	return -1;
+}
+#endif /* HAVE_NFCT_FILTER_MARK */
 
 static int build_nfct_filter(struct ulogd_pluginstance *upi)
 {
@@ -1264,6 +1325,15 @@ static int build_nfct_filter(struct ulogd_pluginstance *upi)
 		}
 	}
 
+	if (strlen(mark_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = mark_filter_ce(upi->config_kset).u.string;
+		if (build_nfct_filter_mark(filter, filter_string) != 0) {
+			ulogd_log(ULOGD_FATAL,
+					"Unable to create mark filter\n");
+			goto err_filter;
+		}
+	}
+
 	if (filter) {
 		if (nfct_filter_attach(nfct_fd(cpi->cth), filter) == -1) {
 			ulogd_log(ULOGD_FATAL, "nfct_filter_attach");
@@ -1296,7 +1366,8 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 
 	if ((strlen(src_filter_ce(upi->config_kset).u.string) != 0) ||
 		(strlen(dst_filter_ce(upi->config_kset).u.string) != 0) ||
-		(strlen(proto_filter_ce(upi->config_kset).u.string) != 0)
+		(strlen(proto_filter_ce(upi->config_kset).u.string) != 0) ||
+		(strlen(mark_filter_ce(upi->config_kset).u.string) != 0)
 	   ) {
 		if (build_nfct_filter(upi) != 0) {
 			ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
-- 
1.8.5.3

