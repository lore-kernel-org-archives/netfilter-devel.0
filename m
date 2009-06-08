From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [resend2 iptables] socket match: new revision, match transparent sockets
Date: Mon,  8 Jun 2009 14:30:24 +0200
Message-ID: <1244464224-30692-3-git-send-email-panther@balabit.hu>
References: <4A27CD5A.6040303@trash.net>
 <1244464224-30692-1-git-send-email-panther@balabit.hu>
 <1244464224-30692-2-git-send-email-panther@balabit.hu>
Cc: kaber@trash.net, Laszlo Attila Toth <panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:41205 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753711AbZFHMa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:30:27 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 42BA813A295
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2009 14:30:27 +0200 (CEST)
In-Reply-To: <1244464224-30692-2-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added new revision of the socket match.

if the '--transparent' parameter is specified, the sockets without
set transparent socket option are ignored.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 extensions/libxt_socket.c           |   95 +++++++++++++++++++++++++++++-----
 extensions/libxt_socket.man         |    6 ++-
 include/linux/netfilter/xt_socket.h |   12 ++++
 3 files changed, 98 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index eebc7c5..2230a93 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -6,34 +6,101 @@
 #include <stdio.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <linux/netfilter/xt_socket.h>
 
-static void socket_mt_help(void)
+static void socket_mt_help_v0(void)
 {
-	printf("socket v%s has no options\n\n", XTABLES_VERSION);
+	printf("socket match has no options.\n\n");
 }
 
-static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-			const void *entry, struct xt_entry_match **match)
+static void socket_mt_help_v1(void)
+{
+	printf("socket match options:\n"
+"--transparent      Matches only if the socket's transparent option is set\n");
+}
+
+static const struct option socket_opts_v1[] = {
+	{ "transparent", 0, NULL, '1' },
+	{ }
+};
+
+static int socket_mt_parse_v0(int c, char **argv, int invert,
+			      unsigned int *flags, const void *entry,
+			      struct xt_entry_match **match)
 {
 	return 0;
 }
 
+static int socket_mt_parse_v1(int c, char **argv, int invert,
+			      unsigned int *flags, const void *entry,
+			      struct xt_entry_match **match)
+{
+	struct xt_socket_mtinfo1 *info = (void *) (*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Can't specify multiple --transparent");
+		info->flags |= XT_SOCKET_TRANSPARENT;
+		*flags = 1;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
 static void socket_mt_check(unsigned int flags)
 {
 }
 
-static struct xtables_match socket_mt_reg = {
-	.name	       = "socket",
-	.version       = XTABLES_VERSION,
-	.family	       = NFPROTO_IPV4,
-	.size	       = XT_ALIGN(0),
-	.userspacesize = XT_ALIGN(0),
-	.parse	       = socket_mt_parse,
-	.final_check   = socket_mt_check,
-	.help	       = socket_mt_help,
+static void socket_mt_print_v1(const void *ip,
+			       const struct xt_entry_match *match,
+			       int numeric)
+{
+	const struct xt_socket_mtinfo1 *info = (const void *)match->data;
+	printf("socket ");
+	if (info->flags & XT_SOCKET_TRANSPARENT)
+		printf("transparent ");
+}
+
+static void socket_mt_save_v1(const void *ip,
+			      const struct xt_entry_match *match)
+{
+	const struct xt_socket_mtinfo1 *info = (const void *)match->data;
+
+	if (info->flags & XT_SOCKET_TRANSPARENT)
+		printf("--transparent ");
+}
+
+static struct xtables_match socket_mt_reg_v0 = {
+	.name		= "socket",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV4,
+	.parse		= socket_mt_parse_v0,
+	.final_check	= socket_mt_check,
+	.help		= socket_mt_help_v0,
+};
+
+static struct xtables_match socket_mt_reg_v1 = {
+	.name		= "socket",
+	.version	= XTABLES_VERSION,
+	.revision	= 1,
+	.family		= NFPROTO_IPV4,
+	.size		= XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_socket_mtinfo1)),
+	.parse		= socket_mt_parse_v1,
+	.print		= socket_mt_print_v1,
+	.save		= socket_mt_save_v1,
+	.final_check	= socket_mt_check,
+	.help		= socket_mt_help_v1,
+	.extra_opts	= socket_opts_v1,
 };
 
 void _init(void)
 {
-	xtables_register_match(&socket_mt_reg);
+	xtables_register_match(&socket_mt_reg_v0);
+	xtables_register_match(&socket_mt_reg_v1);
 }
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
index 0000000..f6ba866
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,12 @@
+#ifndef _XT_SOCKET_H_match
+#define _XT_SOCKET_H_match
+
+enum {
+	XT_SOCKET_TRANSPARENT = 1 << 0,
+};
+
+struct xt_socket_mtinfo1 {
+	__u8 flags;
+};
+
+#endif /* _XT_SOCKET_H_match */
-- 
1.6.2.2.404.ge96f3

