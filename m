From: pablo@netfilter.org
Subject: [PATCH 3/3] libxtables: add xtables_print_num
Date: Thu, 27 Dec 2012 01:20:05 +0100
Message-ID: <1356567605-3246-2-git-send-email-pablo@netfilter.org>
References: <1356567605-3246-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39997 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab2L0AUP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:20:15 -0500
In-Reply-To: <1356567605-3246-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This function is used both by iptables and ip6tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/xtables.h    |   16 ++++++++++++++++
 iptables/ip6tables.c |   48 ++++--------------------------------------------
 iptables/iptables.c  |   49 ++++---------------------------------------------
 libxtables/xtables.c |   29 +++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 89 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index add76ae..75de958 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -469,6 +469,22 @@ extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
  */
 extern void xtables_save_string(const char *value);
 
+#define FMT_NUMERIC		0x0001
+#define FMT_NOCOUNTS		0x0002
+#define FMT_KILOMEGAGIGA	0x0004
+#define FMT_OPTIONS		0x0008
+#define FMT_NOTABLE		0x0010
+#define FMT_NOTARGET		0x0020
+#define FMT_VIA			0x0040
+#define FMT_NONEWLINE		0x0080
+#define FMT_LINENUMBERS		0x0100
+
+#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
+                        | FMT_NUMERIC | FMT_NOTABLE)
+#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
+
+extern void xtables_print_num(uint64_t number, unsigned int format);
+
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 #	ifdef _INIT
 #		undef _init
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index e9e753a..556647f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -52,21 +52,6 @@
 #define FALSE 0
 #endif
 
-#define FMT_NUMERIC	0x0001
-#define FMT_NOCOUNTS	0x0002
-#define FMT_KILOMEGAGIGA 0x0004
-#define FMT_OPTIONS	0x0008
-#define FMT_NOTABLE	0x0010
-#define FMT_NOTARGET	0x0020
-#define FMT_VIA		0x0040
-#define FMT_NONEWLINE	0x0080
-#define FMT_LINENUMBERS 0x0100
-
-#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
-			| FMT_NUMERIC | FMT_NOTABLE)
-#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
-
-
 #define CMD_NONE		0x0000U
 #define CMD_INSERT		0x0001U
 #define CMD_DELETE		0x0002U
@@ -442,31 +427,6 @@ set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
 	}
 }
 
-static void
-print_num(uint64_t number, unsigned int format)
-{
-	if (format & FMT_KILOMEGAGIGA) {
-		if (number > 99999) {
-			number = (number + 500) / 1000;
-			if (number > 9999) {
-				number = (number + 500) / 1000;
-				if (number > 9999) {
-					number = (number + 500) / 1000;
-					if (number > 9999) {
-						number = (number + 500) / 1000;
-						printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
-					}
-					else printf(FMT("%4lluG ","%lluG "), (unsigned long long)number);
-				}
-				else printf(FMT("%4lluM ","%lluM "), (unsigned long long)number);
-			} else
-				printf(FMT("%4lluK ","%lluK "), (unsigned long long)number);
-		} else
-			printf(FMT("%5llu ","%llu "), (unsigned long long)number);
-	} else
-		printf(FMT("%8llu ","%llu "), (unsigned long long)number);
-}
-
 
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
@@ -478,9 +438,9 @@ print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 		printf(" (policy %s", pol);
 		if (!(format & FMT_NOCOUNTS)) {
 			fputc(' ', stdout);
-			print_num(counters.pcnt, (format|FMT_NOTABLE));
+			xtables_print_num(counters.pcnt, (format|FMT_NOTABLE));
 			fputs("packets, ", stdout);
-			print_num(counters.bcnt, (format|FMT_NOTABLE));
+			xtables_print_num(counters.bcnt, (format|FMT_NOTABLE));
 			fputs("bytes", stdout);
 		}
 		printf(")\n");
@@ -563,8 +523,8 @@ print_firewall(const struct ip6t_entry *fw,
 		printf(FMT("%-4u ", "%u "), num);
 
 	if (!(format & FMT_NOCOUNTS)) {
-		print_num(fw->counters.pcnt, format);
-		print_num(fw->counters.bcnt, format);
+		xtables_print_num(fw->counters.pcnt, format);
+		xtables_print_num(fw->counters.bcnt, format);
 	}
 
 	if (!(format & FMT_NOTARGET))
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 7cc8251..00e3f01 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -48,21 +48,6 @@
 #define FALSE 0
 #endif
 
-#define FMT_NUMERIC	0x0001
-#define FMT_NOCOUNTS	0x0002
-#define FMT_KILOMEGAGIGA 0x0004
-#define FMT_OPTIONS	0x0008
-#define FMT_NOTABLE	0x0010
-#define FMT_NOTARGET	0x0020
-#define FMT_VIA		0x0040
-#define FMT_NONEWLINE	0x0080
-#define FMT_LINENUMBERS 0x0100
-
-#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
-			| FMT_NUMERIC | FMT_NOTABLE)
-#define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
-
-
 #define CMD_NONE		0x0000U
 #define CMD_INSERT		0x0001U
 #define CMD_DELETE		0x0002U
@@ -429,32 +414,6 @@ set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
 }
 
 static void
-print_num(uint64_t number, unsigned int format)
-{
-	if (format & FMT_KILOMEGAGIGA) {
-		if (number > 99999) {
-			number = (number + 500) / 1000;
-			if (number > 9999) {
-				number = (number + 500) / 1000;
-				if (number > 9999) {
-					number = (number + 500) / 1000;
-					if (number > 9999) {
-						number = (number + 500) / 1000;
-						printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
-					}
-					else printf(FMT("%4lluG ","%lluG "), (unsigned long long)number);
-				}
-				else printf(FMT("%4lluM ","%lluM "), (unsigned long long)number);
-			} else
-				printf(FMT("%4lluK ","%lluK "), (unsigned long long)number);
-		} else
-			printf(FMT("%5llu ","%llu "), (unsigned long long)number);
-	} else
-		printf(FMT("%8llu ","%llu "), (unsigned long long)number);
-}
-
-
-static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
 	struct xt_counters counters;
@@ -464,9 +423,9 @@ print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 		printf(" (policy %s", pol);
 		if (!(format & FMT_NOCOUNTS)) {
 			fputc(' ', stdout);
-			print_num(counters.pcnt, (format|FMT_NOTABLE));
+			xtables_print_num(counters.pcnt, (format|FMT_NOTABLE));
 			fputs("packets, ", stdout);
-			print_num(counters.bcnt, (format|FMT_NOTABLE));
+			xtables_print_num(counters.bcnt, (format|FMT_NOTABLE));
 			fputs("bytes", stdout);
 		}
 		printf(")\n");
@@ -551,8 +510,8 @@ print_firewall(const struct ipt_entry *fw,
 		printf(FMT("%-4u ", "%u "), num);
 
 	if (!(format & FMT_NOCOUNTS)) {
-		print_num(fw->counters.pcnt, format);
-		print_num(fw->counters.bcnt, format);
+		xtables_print_num(fw->counters.pcnt, format);
+		xtables_print_num(fw->counters.bcnt, format);
 	}
 
 	if (!(format & FMT_NOTARGET))
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index da174e2..009ab91 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1912,6 +1912,35 @@ xtables_parse_protocol(const char *s)
 	return -1;
 }
 
+void xtables_print_num(uint64_t number, unsigned int format)
+{
+	if (!(format & FMT_KILOMEGAGIGA)) {
+		printf(FMT("%8llu ","%llu "), (unsigned long long)number);
+		return;
+	}
+	if (number <= 99999) {
+		printf(FMT("%5llu ","%llu "), (unsigned long long)number);
+		return;
+	}
+	number = (number + 500) / 1000;
+	if (number <= 9999) {
+		printf(FMT("%4lluK ","%lluK "), (unsigned long long)number);
+		return;
+	}
+	number = (number + 500) / 1000;
+	if (number <= 9999) {
+		printf(FMT("%4lluM ","%lluM "), (unsigned long long)number);
+		return;
+	}
+	number = (number + 500) / 1000;
+	if (number <= 9999) {
+		printf(FMT("%4lluG ","%lluG "), (unsigned long long)number);
+		return;
+	}
+	number = (number + 500) / 1000;
+	printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
+}
+
 int kernel_version;
 
 void get_kernel_version(void)
-- 
1.7.10.4

