From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 4/7] escape strings
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.75218.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56480 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753382AbYA0SiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:38:14 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 extensions/libipt_LOG.c   |    6 ++++--
 extensions/libipt_ULOG.c  |    6 ++++--
 extensions/libxt_NFLOG.c  |    6 ++++--
 extensions/libxt_helper.c |    3 ++-
 include/xtables.h         |    6 ++++++
 xtables.c                 |   37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 7 deletions(-)


diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 5614aad..a3635e5 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -240,8 +240,10 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
 
-	if (strcmp(loginfo->prefix, "") != 0)
-		printf("--log-prefix \"%s\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		printf("--log-prefix ");
+		save_string(loginfo->prefix);
+	}
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
 		printf("--log-level %d ", loginfo->level);
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 2e56ab4..eddd79f 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -155,8 +155,10 @@ static void ULOG_save(const void *ip, const struct xt_entry_target *target)
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
 
-	if (strcmp(loginfo->prefix, "") != 0)
-		printf("--ulog-prefix \"%s\" ", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		fputs("--ulog-prefix ", stdout);
+		save_string(loginfo->prefix);
+	}
 
 	if (loginfo->nl_group != ULOG_DEFAULT_NLGROUP) {
 		printf("--ulog-nlgroup ");
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index e96878c..1125c37 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -112,8 +112,10 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 {
-	if (info->prefix[0] != '\0')
-		printf("%snflog-prefix \"%s\" ", prefix, info->prefix);
+	if (info->prefix[0] != '\0') {
+		printf("%snflog-prefix ", prefix);
+		save_string(info->prefix);
+	}
 	if (info->group)
 		printf("%snflog-group %u ", prefix, info->group);
 	if (info->len)
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 390930a..f2f3a3d 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -72,7 +72,8 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
-	printf("%s--helper \"%s\" ",info->invert ? "! " : "", info->name);
+	printf("%s--helper ",info->invert ? "! " : "");
+	save_string(info->name);
 }
 
 static struct xtables_match helper_match = {
diff --git a/include/xtables.h b/include/xtables.h
index 1e45a1a..484e436 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -251,6 +251,12 @@ extern const char *ip6mask_to_numeric(const struct in6_addr *);
 extern void ip6parse_hostnetworkmask(const char *, struct in6_addr **,
 	struct in6_addr *, unsigned int *);
 
+/**
+ * Print the specified value to standard output, quoting dangerous
+ * characters if required.
+ */
+extern void save_string(const char *value);
+
 #ifdef NO_SHARED_LIBS
 #	ifdef _INIT
 #		undef _init
diff --git a/xtables.c b/xtables.c
index 9aefc12..eba453b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1168,3 +1168,40 @@ void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
 			}
 	}
 }
+
+void save_string(const char *value)
+{
+	static const char no_quote_chars[] = "_-0123456789"
+		"abcdefghijklmnopqrstuvwxyz"
+		"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	static const char escape_chars[] = "\"\\'";
+	size_t length;
+	const char *p;
+
+	length = strcspn(value, no_quote_chars);
+	if (length > 0 && value[length] == 0) {
+		/* no quoting required */
+		fputs(value, stdout);
+		putchar(' ');
+	} else {
+		/* there is at least one dangerous character in the
+		   value, which we have to quote.  Write double quotes
+		   around the value and escape special characters with
+		   a backslash */
+		putchar('"');
+
+		for (p = strpbrk(value, escape_chars); p != NULL;
+		     p = strpbrk(value, escape_chars)) {
+			if (p > value)
+				fwrite(value, 1, p - value, stdout);
+			putchar('\\');
+			putchar(*p);
+			value = p + 1;
+		}
+
+		/* print the rest and finish the double quoted
+		   string */
+		fputs(value, stdout);
+		printf("\" ");
+	}
+}


