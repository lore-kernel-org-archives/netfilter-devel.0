From: Harout Hedeshian <harouth@codeaurora.org>
Subject: [PATCH iptables] xt_socket: add --restore-skmark option
Date: Mon, 15 Jun 2015 18:41:19 -0600
Message-ID: <1434415279-15517-1-git-send-email-harouth@codeaurora.org>
Cc: Lorenzo Colitti <lorenzo@google.com>,
	Harout Hedeshian <harouth@codeaurora.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45140 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbFPAlc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 20:41:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_socket is useful for matching sockets with IP_TRANSPARENT and
taking some action on the matching packets. However, it lacks the
ability to match only a small subset of transparent sockets.

Suppose there are 2 applications, each with its own set of transparent
sockets. The first application wants all matching packets dropped,
while the second application wants them forwarded somewhere else.

Add the ability to retore the skb->mark from the sk_mark. The mark
is only restored if a matching socket is found and the transparent /
nowildcard conditions are satisfied.

Now the 2 hypothetical applications can differentiate their sockets
based on a mark value set with SO_MARK.

iptables -t mangle -I PREROUTING -m socket --transparent \
                                           --restore-skmark -j action
iptables -t mangle -I PREROUTING -m socket --transparent \
                                           --restore-skmark -j action
iptables -t mangle -A action -m mark --mark 10 -j action2
iptables -t mangle -A action -m mark --mark 11 -j action3

Signed-off-by: Harout Hedeshian <harouth@codeaurora.org>
---
 extensions/libxt_socket.c           | 71 +++++++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_socket.h |  8 +++++
 2 files changed, 79 insertions(+)

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index f19c280..a99135c 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -10,6 +10,7 @@
 enum {
 	O_TRANSPARENT = 0,
 	O_NOWILDCARD = 1,
+	O_RESTORESKMARK = 2,
 };
 
 static const struct xt_option_entry socket_mt_opts[] = {
@@ -23,6 +24,13 @@ static const struct xt_option_entry socket_mt_opts_v2[] = {
 	XTOPT_TABLEEND,
 };
 
+static const struct xt_option_entry socket_mt_opts_v3[] = {
+	{.name = "transparent", .id = O_TRANSPARENT, .type = XTTYPE_NONE},
+	{.name = "nowildcard", .id = O_NOWILDCARD, .type = XTTYPE_NONE},
+	{.name = "restore-skmark", .id = O_RESTORESKMARK, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
 static void socket_mt_help(void)
 {
 	printf(
@@ -38,6 +46,17 @@ static void socket_mt_help_v2(void)
 		"  --transparent    Ignore non-transparent sockets\n\n");
 }
 
+static void socket_mt_help_v3(void)
+{
+	printf(
+		"socket match options:\n"
+		"  --nowildcard     Do not ignore LISTEN sockets bound on INADDR_ANY\n"
+		"  --transparent    Ignore non-transparent sockets\n"
+		"  --restore-skmark Set the packet mark to the socket mark if\n"
+		"                   the socket matches and transparent / \n"
+		"                   nowildcard conditions are satisfied\n\n");
+}
+
 static void socket_mt_parse(struct xt_option_call *cb)
 {
 	struct xt_socket_mtinfo1 *info = cb->data;
@@ -65,6 +84,24 @@ static void socket_mt_parse_v2(struct xt_option_call *cb)
 	}
 }
 
+static void socket_mt_parse_v3(struct xt_option_call *cb)
+{
+	struct xt_socket_mtinfo2 *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_TRANSPARENT:
+		info->flags |= XT_SOCKET_TRANSPARENT;
+		break;
+	case O_NOWILDCARD:
+		info->flags |= XT_SOCKET_NOWILDCARD;
+		break;
+	case O_RESTORESKMARK:
+		info->flags |= XT_SOCKET_RESTORESKMARK;
+		break;
+	}
+}
+
 static void
 socket_mt_save(const void *ip, const struct xt_entry_match *match)
 {
@@ -101,6 +138,27 @@ socket_mt_print_v2(const void *ip, const struct xt_entry_match *match,
 	socket_mt_save_v2(ip, match);
 }
 
+static void
+socket_mt_save_v3(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_socket_mtinfo3 *info = (const void *)match->data;
+
+	if (info->flags & XT_SOCKET_TRANSPARENT)
+		printf(" --transparent");
+	if (info->flags & XT_SOCKET_NOWILDCARD)
+		printf(" --nowildcard");
+	if (info->flags & XT_SOCKET_RESTORESKMARK)
+		printf(" --restore-skmark");
+}
+
+static void
+socket_mt_print_v3(const void *ip, const struct xt_entry_match *match,
+		   int numeric)
+{
+	printf(" socket");
+	socket_mt_save_v3(ip, match);
+}
+
 static struct xtables_match socket_mt_reg[] = {
 	{
 		.name          = "socket",
@@ -136,6 +194,19 @@ static struct xtables_match socket_mt_reg[] = {
 		.x6_parse      = socket_mt_parse_v2,
 		.x6_options    = socket_mt_opts_v2,
 	},
+	{
+		.name          = "socket",
+		.revision      = 3,
+		.family        = NFPROTO_UNSPEC,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_socket_mtinfo2)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_socket_mtinfo2)),
+		.help          = socket_mt_help_v3,
+		.print         = socket_mt_print_v3,
+		.save          = socket_mt_save_v3,
+		.x6_parse      = socket_mt_parse_v3,
+		.x6_options    = socket_mt_opts_v3,
+	},
 };
 
 void _init(void)
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
index 6315e2a..87644f8 100644
--- a/include/linux/netfilter/xt_socket.h
+++ b/include/linux/netfilter/xt_socket.h
@@ -6,6 +6,7 @@
 enum {
 	XT_SOCKET_TRANSPARENT = 1 << 0,
 	XT_SOCKET_NOWILDCARD = 1 << 1,
+	XT_SOCKET_RESTORESKMARK = 1 << 2,
 };
 
 struct xt_socket_mtinfo1 {
@@ -18,4 +19,11 @@ struct xt_socket_mtinfo2 {
 };
 #define XT_SOCKET_FLAGS_V2 (XT_SOCKET_TRANSPARENT | XT_SOCKET_NOWILDCARD)
 
+struct xt_socket_mtinfo3 {
+	__u8 flags;
+};
+#define XT_SOCKET_FLAGS_V3 (XT_SOCKET_TRANSPARENT \
+			   | XT_SOCKET_NOWILDCARD \
+			   | XT_SOCKET_RESTORESKMARK)
+
 #endif /* _XT_SOCKET_H */
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

