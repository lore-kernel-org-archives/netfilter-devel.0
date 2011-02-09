From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/11] src: move OPT_FRAGMENT to the end so the list can be shared
Date: Wed,  9 Feb 2011 02:48:50 +0100
Message-ID: <1297216137-18505-6-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38715 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab1BIBtG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:06 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables.c b/iptables.c
index 9d4f10c..4a3860a 100644
--- a/iptables.c
+++ b/iptables.c
@@ -93,12 +93,12 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 #define OPT_EXPANDED	0x00040U
 #define OPT_VIANAMEIN	0x00080U
 #define OPT_VIANAMEOUT	0x00100U
-#define OPT_FRAGMENT    0x00200U
-#define OPT_LINENUMBERS 0x00400U
-#define OPT_COUNTERS	0x00800U
+#define OPT_LINENUMBERS 0x00200U
+#define OPT_COUNTERS	0x00400U
+#define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	12
 static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c'};
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
 
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
@@ -163,19 +163,19 @@ struct xtables_globals iptables_globals = {
 static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f --line -c */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -f */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
 /*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x','x'},
 /*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
-- 
1.7.1

