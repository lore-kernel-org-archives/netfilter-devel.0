From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH 1/1] iptables-xml: Fix segfault on jump without a target
Date: Fri,  2 Jun 2017 15:34:37 +0000
Message-ID: <1496417677-8228-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33298 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdFBPeo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2017 11:34:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id b84so19596977wmh.0
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jun 2017 08:34:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As reported in Bugzilla #1152, a segfault occurs in iptables-xml if a
jump or goto argument lacks a target argument. The following input will
segfault:
*filter
:INPUT ACCEPT [0:0]
-A INPUT -p tcp --dport 2200 -j

Problem occurs in do_rule_part, where the existsChain() function is called
with argv[arg + 1]. If the jump/goto argument is the last argument, then
arg + 1 is out of the array bounds. The fix ensures that arg + 1 is within
the array bounds before the call to existsChain() is made.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/iptables-xml.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 56b8372..80de2de 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -427,11 +427,8 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 				printf("%s%s", spacer, argv[arg]);
 			spacer = " ";
 		} else if (!argvattr[arg] && isTarget(argv[arg])
-			   && existsChain(argv[arg + 1])
-			   && (2 + arg >= argc)) {
-			if (!((1 + arg) < argc))
-				// no args to -j, -m or -g, ignore & finish loop
-				break;
+			   && (arg + 1 < argc)
+			   && existsChain(argv[arg + 1])) {
 			CLOSE_LEVEL(2);
 			if (level1)
 				printf("%s", leveli1);
-- 
2.11.0


