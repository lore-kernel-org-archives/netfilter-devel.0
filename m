From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 21/43] Use unified API in string match.
Date: Sun, 15 Jul 2007 03:10:07 +0900 (JST)
Message-ID: <200707141810.l6EIA8mV017376@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


---
 extensions/libipt_string.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/extensions/libipt_string.c b/extensions/libipt_string.c
index 186013a..e879dca 100644
--- a/extensions/libipt_string.c
+++ b/extensions/libipt_string.c
@@ -26,9 +26,9 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <ctype.h>
-#include <iptables.h>
+#include <xtables.h>
 #include <stddef.h>
-#include <linux/netfilter_ipv4/ipt_string.h>
+#include <linux/netfilter/xt_string.h>
 
 /* Function which prints out usage message. */
 static void
@@ -56,17 +56,17 @@ static struct option opts[] = {
 static void
 init(struct xt_entry_match *m, unsigned int *nfcache)
 {
-	struct ipt_string_info *i = (struct ipt_string_info *) m->data;
+	struct xt_string_info *i = (struct xt_string_info *) m->data;
 
 	if (i->to_offset == 0)
 		i->to_offset = (u_int16_t) ~0UL;
 }
 
 static void
-parse_string(const char *s, struct ipt_string_info *info)
+parse_string(const char *s, struct xt_string_info *info)
 {	
-	if (strlen(s) <= IPT_STRING_MAX_PATTERN_SIZE) {
-		strncpy(info->pattern, s, IPT_STRING_MAX_PATTERN_SIZE);
+	if (strlen(s) <= XT_STRING_MAX_PATTERN_SIZE) {
+		strncpy(info->pattern, s, XT_STRING_MAX_PATTERN_SIZE);
 		info->patlen = strlen(s);
 		return;
 	}
@@ -74,17 +74,17 @@ parse_string(const char *s, struct ipt_string_info *info)
 }
 
 static void
-parse_algo(const char *s, struct ipt_string_info *info)
+parse_algo(const char *s, struct xt_string_info *info)
 {
-	if (strlen(s) <= IPT_STRING_MAX_ALGO_NAME_SIZE) {
-		strncpy(info->algo, s, IPT_STRING_MAX_ALGO_NAME_SIZE);
+	if (strlen(s) <= XT_STRING_MAX_ALGO_NAME_SIZE) {
+		strncpy(info->algo, s, XT_STRING_MAX_ALGO_NAME_SIZE);
 		return;
 	}
 	exit_error(PARAMETER_PROBLEM, "ALGO too long `%s'", s);
 }
 
 static void
-parse_hex_string(const char *s, struct ipt_string_info *info)
+parse_hex_string(const char *s, struct xt_string_info *info)
 {
 	int i=0, slen, sindex=0, schar;
 	short hex_f = 0, literal_f = 0;
@@ -154,7 +154,7 @@ parse_hex_string(const char *s, struct ipt_string_info *info)
 			info->pattern[sindex] = s[i];
 			i++;
 		}
-		if (sindex > IPT_STRING_MAX_PATTERN_SIZE)
+		if (sindex > XT_STRING_MAX_PATTERN_SIZE)
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 		sindex++;
 	}
@@ -174,7 +174,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-	struct ipt_string_info *stringinfo = (struct ipt_string_info *)(*match)->data;
+	struct xt_string_info *stringinfo = (struct xt_string_info *)(*match)->data;
 
 	switch (c) {
 	case '1':
@@ -293,8 +293,8 @@ print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	const struct ipt_string_info *info =
-	    (const struct ipt_string_info*) match->data;
+	const struct xt_string_info *info =
+	    (const struct xt_string_info*) match->data;
 
 	if (is_hex_string(info->pattern, info->patlen)) {
 		printf("STRING match %s", (info->invert) ? "!" : "");
@@ -315,8 +315,8 @@ print(const void *ip,
 static void
 save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_string_info *info =
-	    (const struct ipt_string_info*) match->data;
+	const struct xt_string_info *info =
+	    (const struct xt_string_info*) match->data;
 
 	if (is_hex_string(info->pattern, info->patlen)) {
 		printf("--hex-string %s", (info->invert) ? "! ": "");
@@ -333,11 +333,12 @@ save(const void *ip, const struct xt_entry_match *match)
 }
 
 
-static struct iptables_match string = {
+static struct xtables_match string = {
     .name		= "string",
+    .family			= AF_INET,
     .version		= IPTABLES_VERSION,
-    .size		= IPT_ALIGN(sizeof(struct ipt_string_info)),
-    .userspacesize	= offsetof(struct ipt_string_info, config),
+    .size		= XT_ALIGN(sizeof(struct xt_string_info)),
+    .userspacesize	= offsetof(struct xt_string_info, config),
     .help		= help,
     .init		= init,
     .parse		= parse,
@@ -350,5 +351,5 @@ static struct iptables_match string = {
 
 void _init(void)
 {
-	register_match(&string);
+	xtables_register_match(&string);
 }
-- 
1.5.2.2
