From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 09/13] iptables: fix order of internal commands list
Date: Wed, 26 Dec 2012 00:11:25 +0100
Message-ID: <1356477089-13241-10-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38909 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab2LYXLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:34 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
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
index 0e11a9e..7f14dde 100644
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
index f765cf9..10a0417 100644
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

