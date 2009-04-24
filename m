From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [iptables PATCH] socket match: added '--transparent' option
Date: Fri, 24 Apr 2009 15:33:15 +0200
Message-ID: <1240579995-18785-1-git-send-email-panther@balabit.hu>
Cc: Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:55656 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756850AbZDXNdb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:33:31 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 68B6139D394
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2009 15:33:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the '--transparent' parameter is specified, the sockets, which
transparent socket option is not set, are ignored.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 extensions/libxt_socket.c           |   49 ++++++++++++++++++++++++++++++++---
 extensions/libxt_socket.man         |    6 +++-
 include/linux/netfilter/xt_socket.h |    8 +++++
 3 files changed, 58 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index eebc7c5..8d789c3 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -6,31 +6,72 @@
 #include <stdio.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <linux/netfilter/xt_socket.h>
 
 static void socket_mt_help(void)
 {
-	printf("socket v%s has no options\n\n", XTABLES_VERSION);
+	printf("socket match options:\n"
+"--transparent      Matches only if the socket's transparent option is set\n");
 }
 
+static const struct option socket_opts[] = {
+	{ "transparent", 0, NULL, '1' },
+	{ }
+};
+
 static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 			const void *entry, struct xt_entry_match **match)
 {
-	return 0;
+	struct xt_socket_match_info *info = (struct xt_socket_match_info *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Can't specify multiple --transparent");
+		info->transparent = 1;
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
 }
 
 static void socket_mt_check(unsigned int flags)
 {
 }
+static void socket_mt_print(const void *ip,
+			    const struct xt_entry_match *target,
+			    int numeric)
+{
+	const struct xt_socket_match_info *info = (const void *)target->data;
+	printf("socket ");
+	if (info->transparent)
+		printf("transparent ");
+}
+
+static void socket_mt_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_socket_match_info *info =
+	    (const struct xt_socket_match_info*) match->data;
+
+	if (info->transparent)
+		printf("--transparent ");
+}
 
 static struct xtables_match socket_mt_reg = {
 	.name	       = "socket",
 	.version       = XTABLES_VERSION,
 	.family	       = NFPROTO_IPV4,
-	.size	       = XT_ALIGN(0),
-	.userspacesize = XT_ALIGN(0),
+	.size	       = XT_ALIGN(sizeof(struct xt_socket_match_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_socket_match_info)),
 	.parse	       = socket_mt_parse,
+	.print         = socket_mt_print,
+	.save          = socket_mt_save,
 	.final_check   = socket_mt_check,
 	.help	       = socket_mt_help,
+	.extra_opts    = socket_opts,
 };
 
 void _init(void)
diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
index 50c8854..edc9d75 100644
--- a/extensions/libxt_socket.man
+++ b/extensions/libxt_socket.man
@@ -1,2 +1,6 @@
 This matches if an open socket can be found by doing a socket lookup on the
-packet.
+packet which doesn\'t listen on the \'any\' IP address (0.0.0.0).
+.TP
+.BI "\-\-transparent"
+Enables additional check, that the actual socket's transparent socket option
+has to be set.
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..2222d63
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,8 @@
+#ifndef _XT_SOCKET_H_match
+#define _XT_SOCKET_H_match
+
+struct xt_socket_match_info {
+	__u8 transparent:1;
+};
+
+#endif /* _XT_SOCKET_H_match */
-- 
1.6.2.2.404.ge96f3

