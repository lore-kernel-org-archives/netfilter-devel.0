From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/5] Factorize definition of some macros.
Date: Sat,  9 Feb 2008 13:36:32 +0100
Message-ID: <12025605951159-git-send-email-eric@inl.fr>
References: <12025605952271-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54970 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753203AbYBIMgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:38 -0500
In-Reply-To: <12025605952271-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some macros were defined several time. This was the case of GET_VALUE,
pp_is_valid. This patch puts the definition in ulogd.h and fixes the
definition of pp_is_valid which was wrong (causing segfault by acessing to
fields at NULL).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 e490b64... 9b0110e... M	filter/ulogd_filter_IP2BIN.c
:100644 100644 2a61220... 39edc05... M	filter/ulogd_filter_IP2STR.c
:100644 100644 1bd0b6c... b1d0996... M	include/ulogd/ulogd.h
:100644 100644 d803633... 92c4f0f... M	util/printflow.c
:100644 100644 6606824... 35d8080... M	util/printpkt.c
 filter/ulogd_filter_IP2BIN.c |    5 -----
 filter/ulogd_filter_IP2STR.c |    5 -----
 include/ulogd/ulogd.h        |    5 +++++
 util/printflow.c             |    4 ----
 util/printpkt.c              |    4 ----
 5 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index e490b64..9b0110e 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -114,11 +114,6 @@ static struct ulogd_key ip2bin_keys[] = {
 
 };
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
-#define GET_FLAGS(res, x)	(res[x].u.source->flags)
-#define pp_is_valid(res, x)	\
-	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
-
 /**
  * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address:
  * add 96 bits prefix "::ffff:" to get IPv6 address "::ffff:a.b.c.d".
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 2a61220..39edc05 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -113,11 +113,6 @@ static struct ulogd_key ip2str_keys[] = {
 	},
 };
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
-#define GET_FLAGS(res, x)	(res[x].u.source->flags)
-#define pp_is_valid(res, x)	\
-	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
-
 static char *ip2str(struct ulogd_key* inp, int index, char family)
 {
 	char tmp[IPADDR_LENGTH];
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 1bd0b6c..b1d0996 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -216,6 +216,11 @@ void __ulogd_log(int level, char *file, int line, const char *message, ...);
 #define IS_NEEDED(x)	(x.flags & ULOGD_RETF_NEEDED)
 #define SET_NEEDED(x)	(x.flags |= ULOGD_RETF_NEEDED)
 
+#define GET_VALUE(res, x)	(res[x].u.source->u.value)
+#define GET_FLAGS(res, x)	(res[x].u.source->flags)
+#define pp_is_valid(res, x)	\
+	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
+
 int ulogd_key_size(struct ulogd_key *key);
 int ulogd_wildcard_inputkeys(struct ulogd_pluginstance *upi);
 
diff --git a/util/printflow.c b/util/printflow.c
index d803633..92c4f0f 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -131,10 +131,6 @@ struct ulogd_key printflow_keys[FLOW_IDS] = {
 };
 int printflow_keys_num = sizeof(printflow_keys)/sizeof(*printflow_keys);
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
-#define GET_FLAGS(res, x)	(res[x].u.source->flags)
-#define pp_is_valid(res, x)	(GET_FLAGS(res, x) & ULOGD_RETF_VALID)
-
 #define pp_print(buf_cur, label, res, x, type) \
 	if (pp_is_valid(res, x)) \
 		buf_cur += sprintf(buf_cur, label"=%u ", GET_VALUE(res, x).type);
diff --git a/util/printpkt.c b/util/printpkt.c
index 6606824..35d8080 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -89,10 +89,6 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_AHESP_SPI]		= { .name = "ahesp.spi", },
 };
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
-#define GET_FLAGS(res, x)	(res[x].u.source->flags)
-#define pp_is_valid(res, x)	(GET_FLAGS(res, x) & ULOGD_RETF_VALID)
-
 static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 {
 	char *buf_cur = buf;
-- 
1.5.2.5

