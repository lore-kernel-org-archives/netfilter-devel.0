From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/11] src: put shared option flags into xshared
Date: Wed,  9 Feb 2011 02:48:51 +0100
Message-ID: <1297216137-18505-7-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38725 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab1BIBtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:07 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be needed for the find_proto function.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   16 ++--------------
 iptables.c  |   16 ++--------------
 xshared.h   |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index ac376e2..7f8a8df 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -86,20 +86,8 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'Z', 'N', 'X', 'P', 'E', 'S' };
 
-#define OPT_NONE	0x00000U
-#define OPT_NUMERIC	0x00001U
-#define OPT_SOURCE	0x00002U
-#define OPT_DESTINATION	0x00004U
-#define OPT_PROTOCOL	0x00008U
-#define OPT_JUMP	0x00010U
-#define OPT_VERBOSE	0x00020U
-#define OPT_EXPANDED	0x00040U
-#define OPT_VIANAMEIN	0x00080U
-#define OPT_VIANAMEOUT	0x00100U
-#define OPT_LINENUMBERS 0x00200U
-#define OPT_COUNTERS	0x00400U
-#define NUMBER_OF_OPT	11
-static const char optflags[NUMBER_OF_OPT]
+#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
+static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
 
 static struct option original_opts[] = {
diff --git a/iptables.c b/iptables.c
index 4a3860a..0de656e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -83,21 +83,9 @@
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'Z', 'N', 'X', 'P', 'E', 'S' };
 
-#define OPT_NONE	0x00000U
-#define OPT_NUMERIC	0x00001U
-#define OPT_SOURCE	0x00002U
-#define OPT_DESTINATION	0x00004U
-#define OPT_PROTOCOL	0x00008U
-#define OPT_JUMP	0x00010U
-#define OPT_VERBOSE	0x00020U
-#define OPT_EXPANDED	0x00040U
-#define OPT_VIANAMEIN	0x00080U
-#define OPT_VIANAMEOUT	0x00100U
-#define OPT_LINENUMBERS 0x00200U
-#define OPT_COUNTERS	0x00400U
 #define OPT_FRAGMENT    0x00800U
-#define NUMBER_OF_OPT	12
-static const char optflags[NUMBER_OF_OPT]
+#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
+static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
 
 static struct option original_opts[] = {
diff --git a/xshared.h b/xshared.h
index 11d95fe..06d73ab 100644
--- a/xshared.h
+++ b/xshared.h
@@ -5,6 +5,21 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
+enum {
+	OPT_NONE        = 0,
+	OPT_NUMERIC     = 1 << 0,
+	OPT_SOURCE      = 1 << 1,
+	OPT_DESTINATION = 1 << 2,
+	OPT_PROTOCOL    = 1 << 3,
+	OPT_JUMP        = 1 << 4,
+	OPT_VERBOSE     = 1 << 5,
+	OPT_EXPANDED    = 1 << 6,
+	OPT_VIANAMEIN   = 1 << 7,
+	OPT_VIANAMEOUT  = 1 << 8,
+	OPT_LINENUMBERS = 1 << 9,
+	OPT_COUNTERS    = 1 << 10,
+};
+
 struct xtables_rule_match;
 struct xtables_target;
 
-- 
1.7.1

