From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] xt_conntrack: revision 2 for enlarged state_mask member
Date: Wed,  5 Aug 2009 18:22:34 +0200
Message-ID: <1249489355-20598-2-git-send-email-jengelh@medozas.de>
References: <1249489355-20598-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55951 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbZHEQWk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:22:40 -0400
In-Reply-To: <1249489355-20598-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This complements the xt_conntrack revision 2 code added to the kenrel.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c           |  175 +++++++++++++++++++++++++++-----
 include/linux/netfilter/xt_conntrack.h |   13 +++
 2 files changed, 161 insertions(+), 27 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 96ea3ec..68d40f8 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -12,6 +12,7 @@
 #include <getopt.h>
 #include <netdb.h>
 #include <stdbool.h>
+#include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -115,7 +116,7 @@ parse_states(const char *arg, struct xt_conntrack_info *sinfo)
 }
 
 static bool
-conntrack_ps_state(struct xt_conntrack_mtinfo1 *info, const char *state,
+conntrack_ps_state(struct xt_conntrack_mtinfo2 *info, const char *state,
                    size_t z)
 {
 	if (strncasecmp(state, "INVALID", z) == 0)
@@ -138,7 +139,7 @@ conntrack_ps_state(struct xt_conntrack_mtinfo1 *info, const char *state,
 }
 
 static void
-conntrack_ps_states(struct xt_conntrack_mtinfo1 *info, const char *arg)
+conntrack_ps_states(struct xt_conntrack_mtinfo2 *info, const char *arg)
 {
 	const char *comma;
 
@@ -189,7 +190,7 @@ parse_statuses(const char *arg, struct xt_conntrack_info *sinfo)
 }
 
 static bool
-conntrack_ps_status(struct xt_conntrack_mtinfo1 *info, const char *status,
+conntrack_ps_status(struct xt_conntrack_mtinfo2 *info, const char *status,
                     size_t z)
 {
 	if (strncasecmp(status, "NONE", z) == 0)
@@ -208,7 +209,7 @@ conntrack_ps_status(struct xt_conntrack_mtinfo1 *info, const char *status,
 }
 
 static void
-conntrack_ps_statuses(struct xt_conntrack_mtinfo1 *info, const char *arg)
+conntrack_ps_statuses(struct xt_conntrack_mtinfo2 *info, const char *arg)
 {
 	const char *comma;
 
@@ -263,7 +264,7 @@ parse_expires(const char *s, struct xt_conntrack_info *sinfo)
 }
 
 static void
-conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
+conntrack_ps_expires(struct xt_conntrack_mtinfo2 *info, const char *s)
 {
 	unsigned int min, max;
 	char *end;
@@ -437,10 +438,9 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-                   struct xt_entry_match **match)
+conntrack_mt_parse(int c, bool invert, unsigned int *flags,
+                   struct xt_conntrack_mtinfo2 *info)
 {
-	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
 	unsigned int port;
 	char *p;
 
@@ -543,10 +543,9 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+conntrack_mt4_parse(int c, bool invert, unsigned int *flags,
+                    struct xt_conntrack_mtinfo2 *info)
 {
-	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
 	struct in_addr *addr = NULL;
 	unsigned int naddrs = 0;
 
@@ -605,7 +604,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 
 
 	default:
-		return conntrack_mt_parse(c, argv, invert, flags, match);
+		return conntrack_mt_parse(c, invert, flags, info);
 	}
 
 	*flags = info->match_flags;
@@ -613,10 +612,9 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+conntrack_mt6_parse(int c, bool invert, unsigned int *flags,
+                    struct xt_conntrack_mtinfo2 *info)
 {
-	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
 	struct in6_addr *addr = NULL;
 	unsigned int naddrs = 0;
 
@@ -675,13 +673,62 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 
 
 	default:
-		return conntrack_mt_parse(c, argv, invert, flags, match);
+		return conntrack_mt_parse(c, invert, flags, info);
 	}
 
 	*flags = info->match_flags;
 	return true;
 }
 
+#define cinfo_transform(r, l) \
+	do { \
+		memcpy((r), (l), offsetof(typeof(*(l)), state_mask)); \
+		(r)->state_mask  = (l)->state_mask; \
+		(r)->status_mask = (l)->status_mask; \
+	} while (false);
+
+static int
+conntrack1_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	if (!conntrack_mt4_parse(c, invert, flags, &up))
+		return false;
+	cinfo_transform(info, &up);
+	return true;
+}
+
+static int
+conntrack1_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	if (!conntrack_mt6_parse(c, invert, flags, &up))
+		return false;
+	cinfo_transform(info, &up);
+	return true;
+}
+
+static int
+conntrack2_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	return conntrack_mt4_parse(c, invert, flags, (void *)(*match)->data);
+}
+
+static int
+conntrack2_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
+{
+	return conntrack_mt6_parse(c, invert, flags, (void *)(*match)->data);
+}
+
 static void conntrack_mt_check(unsigned int flags)
 {
 	if (flags == 0)
@@ -894,7 +941,7 @@ matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric,
 }
 
 static void
-conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
+conntrack_dump(const struct xt_conntrack_mtinfo2 *info, const char *prefix,
                unsigned int family, bool numeric)
 {
 	if (info->match_flags & XT_CONNTRACK_STATE) {
@@ -1004,6 +1051,28 @@ static void conntrack_print(const void *ip, const struct xt_entry_match *match,
 }
 
 static void
+conntrack1_mt4_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
+{
+	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	conntrack_dump(&up, "", NFPROTO_IPV4, numeric);
+}
+
+static void
+conntrack1_mt6_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
+{
+	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	conntrack_dump(&up, "", NFPROTO_IPV6, numeric);
+}
+
+static void
 conntrack_mt_print(const void *ip, const struct xt_entry_match *match,
                    int numeric)
 {
@@ -1034,7 +1103,27 @@ static void conntrack_mt6_save(const void *ip,
 	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true);
 }
 
-static struct xtables_match conntrack_match = {
+static void
+conntrack1_mt4_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	conntrack_dump(&up, "--", NFPROTO_IPV4, true);
+}
+
+static void
+conntrack1_mt6_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+	struct xt_conntrack_mtinfo2 up;
+
+	cinfo_transform(&up, info);
+	conntrack_dump(&up, "--", NFPROTO_IPV6, true);
+}
+
+static struct xtables_match conntrack_mt_v0_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 0,
@@ -1049,7 +1138,7 @@ static struct xtables_match conntrack_match = {
 	.extra_opts    = conntrack_mt_opts_v0,
 };
 
-static struct xtables_match conntrack_mt_reg = {
+static struct xtables_match conntrack_mt_v1_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
@@ -1057,14 +1146,14 @@ static struct xtables_match conntrack_mt_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.help          = conntrack_mt_help,
-	.parse         = conntrack_mt4_parse,
+	.parse         = conntrack1_mt4_parse,
 	.final_check   = conntrack_mt_check,
-	.print         = conntrack_mt_print,
-	.save          = conntrack_mt_save,
+	.print         = conntrack1_mt4_print,
+	.save          = conntrack1_mt4_save,
 	.extra_opts    = conntrack_mt_opts,
 };
 
-static struct xtables_match conntrack_mt6_reg = {
+static struct xtables_match conntrack_mt6_v1_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
@@ -1072,7 +1161,37 @@ static struct xtables_match conntrack_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.help          = conntrack_mt_help,
-	.parse         = conntrack_mt6_parse,
+	.parse         = conntrack1_mt6_parse,
+	.final_check   = conntrack_mt_check,
+	.print         = conntrack1_mt6_print,
+	.save          = conntrack1_mt6_save,
+	.extra_opts    = conntrack_mt_opts,
+};
+
+static struct xtables_match conntrack_mt_v2_reg = {
+	.version       = XTABLES_VERSION,
+	.name          = "conntrack",
+	.revision      = 2,
+	.family        = NFPROTO_IPV4,
+	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+	.help          = conntrack_mt_help,
+	.parse         = conntrack2_mt4_parse,
+	.final_check   = conntrack_mt_check,
+	.print         = conntrack_mt_print,
+	.save          = conntrack_mt_save,
+	.extra_opts    = conntrack_mt_opts,
+};
+
+static struct xtables_match conntrack_mt6_v2_reg = {
+	.version       = XTABLES_VERSION,
+	.name          = "conntrack",
+	.revision      = 2,
+	.family        = NFPROTO_IPV6,
+	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+	.help          = conntrack_mt_help,
+	.parse         = conntrack2_mt6_parse,
 	.final_check   = conntrack_mt_check,
 	.print         = conntrack_mt6_print,
 	.save          = conntrack_mt6_save,
@@ -1081,7 +1200,9 @@ static struct xtables_match conntrack_mt6_reg = {
 
 void _init(void)
 {
-	xtables_register_match(&conntrack_match);
-	xtables_register_match(&conntrack_mt_reg);
-	xtables_register_match(&conntrack_mt6_reg);
+	xtables_register_match(&conntrack_mt_v0_reg);
+	xtables_register_match(&conntrack_mt_v1_reg);
+	xtables_register_match(&conntrack_mt6_v1_reg);
+	xtables_register_match(&conntrack_mt_v2_reg);
+	xtables_register_match(&conntrack_mt6_v2_reg);
 }
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 8f53452..21b222e 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -81,4 +81,17 @@ struct xt_conntrack_mtinfo1 {
 	u_int8_t state_mask, status_mask;
 };
 
+struct xt_conntrack_mtinfo2 {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	__u32 expires_min, expires_max;
+	__u16 l4proto;
+	__be16 origsrc_port, origdst_port;
+	__be16 replsrc_port, repldst_port;
+	__u16 match_flags, invert_flags;
+	__u16 state_mask, status_mask;
+};
+
 #endif /*_XT_CONNTRACK_H*/
-- 
1.6.3.3

