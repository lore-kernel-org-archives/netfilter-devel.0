From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 06/17] iptables: fix order of internal commands list
Date: Sun, 30 Sep 2012 12:22:09 +0200
Message-ID: <1349000540-17508-7-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38812 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2I3KW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:27 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Specifying -S on the command line would add 4096 (0x1000, 1<<12) to the
cmd flags, but -S was in fact commands_v_options[13]. This led to a
bogus option checking and an error message:

$ iptables -A foo -S
iptables v1.4.14: Cannot use -E with -A

References: http://bugs.debian.org/642173
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.c |   12 ++++++------
 iptables/iptables.c  |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index f93bfb3..b2c8776 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -76,12 +76,12 @@
 #define CMD_LIST		0x0020U
 #define CMD_FLUSH		0x0040U
 #define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_RENAME_CHAIN	0x0800U
-#define CMD_LIST_RULES		0x1000U
-#define CMD_ZERO_NUM		0x2000U
+#define CMD_ZERO_NUM		0x0100U
+#define CMD_NEW_CHAIN		0x0200U
+#define CMD_DELETE_CHAIN	0x0400U
+#define CMD_SET_POLICY		0x0800U
+#define CMD_RENAME_CHAIN	0x1000U
+#define CMD_LIST_RULES		0x2000U
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 5786bfd..8884c6a 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -72,12 +72,12 @@
 #define CMD_LIST		0x0020U
 #define CMD_FLUSH		0x0040U
 #define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_RENAME_CHAIN	0x0800U
-#define CMD_LIST_RULES		0x1000U
-#define CMD_ZERO_NUM		0x2000U
+#define CMD_ZERO_NUM		0x0100U
+#define CMD_NEW_CHAIN		0x0200U
+#define CMD_DELETE_CHAIN	0x0400U
+#define CMD_SET_POLICY		0x0800U
+#define CMD_RENAME_CHAIN	0x1000U
+#define CMD_LIST_RULES		0x2000U
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-- 
1.7.10.4

