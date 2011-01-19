From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_connlimit: add a --connlimit-upto option
Date: Wed, 19 Jan 2011 18:32:27 +0100
Message-ID: <1295458349-14106-3-git-send-email-jengelh@medozas.de>
References: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40840 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1ASRce (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:32:34 -0500
In-Reply-To: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Direct specifications like "upto" are easier to grasp than "not
above". This patch adds such an upto variant similar to what
libxt_hashlimit already has.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.c   |   70 ++++++++++++++++++++++++---------------
 extensions/libxt_connlimit.man |    9 +++--
 2 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 693adbf..b249259 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -9,16 +9,22 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_connlimit.h>
 
+enum {
+	FL_LIMIT = 1 << 0,
+	FL_MASK  = 1 << 1,
+};
+
 static void connlimit_help(void)
 {
 	printf(
 "connlimit match options:\n"
-"[!] --connlimit-above n        match if the number of existing "
-"                               connections is (not) above n\n"
-"    --connlimit-mask n         group hosts using prefix length (default: max len)\n");
+"  --connlimit-upto n     match if the number of existing connections is 0..n\n"
+"  --connlimit-above n    match if the number of existing connections is >n\n"
+"  --connlimit-mask n     group hosts using prefix length (default: max len)\n");
 }
 
 static const struct option connlimit_opts[] = {
+	{.name = "connlimit-upto",  .has_arg = true, .val = 'U'},
 	{.name = "connlimit-above", .has_arg = true, .val = 'A'},
 	{.name = "connlimit-mask",  .has_arg = true, .val = 'M'},
 	XT_GETOPT_TABLEEND,
@@ -61,21 +67,28 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	int i;
 
 	switch (c) {
-	case 'A':
-		if (*flags & 0x1)
-			xtables_error(PARAMETER_PROBLEM,
-				"--connlimit-above may be given only once");
-		*flags |= 0x1;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		info->limit   = strtoul(optarg, NULL, 0);
-		info->inverse = invert;
-		break;
-	case 'M':
-		if (*flags & 0x2)
-			xtables_error(PARAMETER_PROBLEM,
-				"--connlimit-mask may be given only once");
-
-		*flags |= 0x2;
+	case 'A': /* --connlimit-above */
+		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
+			"--connlimit-{upto,above}", *flags & FL_LIMIT);
+		*flags |= FL_LIMIT;
+		if (invert)
+			info->inverse = true;
+		info->limit = strtoul(optarg, NULL, 0);
+		return true;
+	case 'U': /* --connlimit-upto */
+		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
+			"--connlimit-{upto,above}", *flags & FL_LIMIT);
+		*flags |= FL_LIMIT;
+		if (!invert)
+			info->inverse = true;
+		info->limit = strtoul(optarg, NULL, 0);
+		return true;
+	case 'M': /* --connlimit-mask */
+		xtables_param_act(XTF_NO_INVERT, "connlimit",
+			"--connlimit-mask", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
+			"--connlimit-mask", *flags & FL_MASK);
+		*flags |= FL_MASK;
 		i = strtoul(optarg, &err, 0);
 		if (family == NFPROTO_IPV6) {
 			if (i > 128 || *err != '\0')
@@ -93,10 +106,9 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 			else
 				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
 		}
-		break;
+		return true;
 	}
-
-	return 1;
+	return false;
 }
 
 static int connlimit_parse4(int c, char **argv, int invert,
@@ -164,18 +176,22 @@ static void connlimit_save4(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
 
-	printf("%s--connlimit-above %u --connlimit-mask %u ",
-	       info->inverse ? "! " : "", info->limit,
-	       count_bits4(info->v4_mask));
+	if (info->inverse)
+		printf("--connlimit-upto %u ", info->limit);
+	else
+		printf("--connlimit-above %u ", info->limit);
+	printf("--connlimit-mask %u ", count_bits4(info->v4_mask));
 }
 
 static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connlimit_info *info = (const void *)match->data;
 
-	printf("%s--connlimit-above %u --connlimit-mask %u ",
-	       info->inverse ? "! " : "", info->limit,
-	       count_bits6(info->v6_mask));
+	if (info->inverse)
+		printf("--connlimit-upto %u ", info->limit);
+	else
+		printf("--connlimit-above %u ", info->limit);
+	printf("--connlimit-mask %u ", count_bits6(info->v6_mask));
 }
 
 static struct xtables_match connlimit_mt_reg[] = {
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index f8f9c7b..ecc8027 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -1,8 +1,11 @@
 Allows you to restrict the number of parallel connections to a server per
 client IP address (or client address block).
 .TP
-[\fB!\fP] \fB\-\-connlimit\-above\fP \fIn\fP
-Match if the number of existing connections is (not) above \fIn\fP.
+\fB\-\-connlimit\-upto\fP \fIn\fP
+Match if the number of existing connections is below or equal \fIn\fP.
+.TP
+\fB\-\-connlimit\-above\fP \fIn\fP
+Match if the number of existing connections is above \fIn\fP.
 .TP
 \fB\-\-connlimit\-mask\fP \fIprefix_length\fP
 Group hosts using the prefix length. For IPv4, this must be a number between
@@ -15,7 +18,7 @@ Examples:
 iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-above 2 \-j REJECT
 .TP
 # you can also match the other way around:
-iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit ! \-\-connlimit\-above 2 \-j ACCEPT
+iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-upto 2 \-j ACCEPT
 .TP
 # limit the number of parallel HTTP requests to 16 per class C sized \
 network (24 bit netmask)
-- 
1.7.1

