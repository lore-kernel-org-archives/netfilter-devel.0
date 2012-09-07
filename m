From: pablo@netfilter.org
Subject: [PATCH 1/2] iptables: fix wrong error messages
Date: Fri,  7 Sep 2012 10:55:18 +0200
Message-ID: <1347008119-3835-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50178 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGI42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:56:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

iptables -P INPUT
iptables v1.4.15: -X requires a chain and a policy
Try `iptables -h' or 'iptables --help' for more information.

Note that it says -X when we have used -P.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/ip6tables.c |    2 +-
 iptables/iptables.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b191d5d..7a16b97 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -85,7 +85,7 @@
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'Z', 'N', 'X', 'P', 'E', 'S', 'C' };
+				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 03ac63b..9e3d696 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -81,7 +81,7 @@
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'Z', 'N', 'X', 'P', 'E', 'S', 'C' };
+				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
 #define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-- 
1.7.10.4

