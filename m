From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 05/12] proto: add debugging for protocol context updates
Date: Wed,  8 Jan 2014 13:08:56 +0000
Message-ID: <1389186543-6919-6-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40192 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbaAHNJQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:16 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new debugging level to debug updates to the protocol context.

Sample output:

<cmdline>:1:15-23: Evaluate
filter output tcp dport ssh
              ^^^^^^^^^
tcp

update transport layer protocol context:
 link layer          : none
 network layer       : ip
 transport layer     : tcp <-

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/nftables.h |  1 +
 src/main.c         |  6 +++++-
 src/proto.c        | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/nftables.h b/include/nftables.h
index 12f3c49..801000e 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -17,6 +17,7 @@ enum debug_level {
 	DEBUG_PARSER		= 0x2,
 	DEBUG_EVALUATION	= 0x4,
 	DEBUG_NETLINK		= 0x8,
+	DEBUG_PROTO_CTX		= 0x10,
 };
 
 #define INCLUDE_PATHS_MAX	16
diff --git a/src/main.c b/src/main.c
index 0c97120..859ddaa 100644
--- a/src/main.c
+++ b/src/main.c
@@ -111,7 +111,7 @@ static void show_help(const char *name)
 "  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
-"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, all)\n"
+"  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, proto-ctx, all)\n"
 #endif
 "\n",
 	name);
@@ -139,6 +139,10 @@ static const struct {
 		.level		= DEBUG_NETLINK,
 	},
 	{
+		.name		= "proto-ctx",
+		.level		= DEBUG_PROTO_CTX,
+	},
+	{
 		.name		= "all",
 		.level		= ~0,
 	},
diff --git a/src/proto.c b/src/proto.c
index f611c97..c3fb7bf 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -128,6 +128,26 @@ const struct hook_proto_desc hook_proto_desc[] = {
 	[NFPROTO_ARP]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_arp),
 };
 
+static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
+{
+#ifdef DEBUG
+	unsigned int i;
+
+	if (!(debug_level & DEBUG_PROTO_CTX))
+		return;
+
+	pr_debug("update %s protocol context:\n", proto_base_names[base]);
+	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
+		pr_debug(" %-20s: %s%s\n",
+			 proto_base_names[i],
+			 ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
+						 "none",
+			 i == base ? " <-" : "");
+	}
+	pr_debug("\n");
+#endif
+}
+
 /**
  * proto_ctx_init - initialize protocol context for a given hook family
  *
@@ -141,6 +161,8 @@ void proto_ctx_init(struct proto_ctx *ctx, unsigned int family)
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->family = family;
 	ctx->protocol[h->base].desc = h->desc;
+
+	proto_ctx_debug(ctx, h->base);
 }
 
 /**
@@ -157,6 +179,8 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 {
 	ctx->protocol[base].location	= *loc;
 	ctx->protocol[base].desc	= desc;
+
+	proto_ctx_debug(ctx, base);
 }
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
-- 
1.8.4.2

