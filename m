Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591C5CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C01121734
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbfJ1OFD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:05:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39884 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfJ1OFC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 10:05:02 -0400
Received: from localhost ([::1]:52974 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP5dl-0000uP-5K; Mon, 28 Oct 2019 15:05:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/10] xshared: Share a common add_command() implementation
Date:   Mon, 28 Oct 2019 15:04:23 +0100
Message-Id: <20191028140431.13882-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028140431.13882-1-phil@nwl.cc>
References: <20191028140431.13882-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The shared definition of cmdflags is a super set of the previous one in
xtables-arp.c so while not being identical, they're compatible.

Avoid accidental array overstep in cmd2char() by incrementing an index
variable and checking its final value before using it as such.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 23 -----------------------
 iptables/iptables.c    | 23 -----------------------
 iptables/xshared.c     | 27 +++++++++++++++++++++++++++
 iptables/xshared.h     |  4 ++++
 iptables/xtables-arp.c | 22 ----------------------
 iptables/xtables.c     | 23 -----------------------
 6 files changed, 31 insertions(+), 91 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index ee463c9586862..9a9d71f1cdadc 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -69,8 +69,6 @@
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
@@ -336,27 +334,6 @@ opt2char(int option)
 	return *ptr;
 }
 
-static char
-cmd2char(int option)
-{
-	const char *ptr;
-	for (ptr = cmdflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
-static void
-add_command(unsigned int *cmd, const int newcmd, const int othercmds,
-	    int invert)
-{
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
-	if (*cmd & (~othercmds))
-		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
-			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
-	*cmd |= newcmd;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 544e87596e7e4..5fec25376c24f 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -65,8 +65,6 @@
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
 #define NUMBER_OF_CMD	16
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
 #define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
@@ -335,27 +333,6 @@ opt2char(int option)
 	return *ptr;
 }
 
-static char
-cmd2char(int option)
-{
-	const char *ptr;
-	for (ptr = cmdflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
-static void
-add_command(unsigned int *cmd, const int newcmd, const int othercmds, 
-	    int invert)
-{
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
-	if (*cmd & (~othercmds))
-		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
-			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
-	*cmd |= newcmd;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 97f1b5d22fdbe..3baa805c64e6d 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -732,3 +732,30 @@ void command_jump(struct iptables_command_state *cs, const char *jumpto)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 	xt_params->opts = opts;
 }
+
+char cmd2char(int option)
+{
+	/* cmdflags index corresponds with position of bit in CMD_* values */
+	static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
+					 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
+	int i;
+
+	for (i = 0; option > 1; option >>= 1, i++)
+		;
+	if (i >= ARRAY_SIZE(cmdflags))
+		xtables_error(OTHER_PROBLEM,
+			      "cmd2char(): Invalid command number %u.\n",
+			      1 << i);
+	return cmdflags[i];
+}
+
+void add_command(unsigned int *cmd, const int newcmd,
+		 const int othercmds, int invert)
+{
+	if (invert)
+		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
+	if (*cmd & (~othercmds))
+		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
+			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
+	*cmd |= newcmd;
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 64b7e8fc4b690..0b9b357c7bdaa 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -183,4 +183,8 @@ void command_match(struct iptables_command_state *cs);
 const char *xt_parse_target(const char *targetname);
 void command_jump(struct iptables_command_state *cs, const char *jumpto);
 
+char cmd2char(int option);
+void add_command(unsigned int *cmd, const int newcmd,
+		 const int othercmds, int invert);
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 8503f47fe2afe..584b6f0646821 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -81,8 +81,6 @@ typedef char arpt_chainlabel[32];
 #define CMD_CHECK		0x0800U
 #define CMD_RENAME_CHAIN	0x1000U
 #define NUMBER_OF_CMD	13
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E' };
 
 #define OPTION_OFFSET 256
 
@@ -462,26 +460,6 @@ opt2char(int option)
 	return *ptr;
 }
 
-static char
-cmd2char(int option)
-{
-	const char *ptr;
-	for (ptr = cmdflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
-static void
-add_command(unsigned int *cmd, const int newcmd, const unsigned int othercmds, int invert)
-{
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
-	if (*cmd & (~othercmds))
-		xtables_error(PARAMETER_PROBLEM, "Can't use -%c with -%c\n",
-			      cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
-	*cmd |= newcmd;
-}
-
 static int
 check_inverse(const char option[], int *invert, int *optidx, int argc)
 {
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 8a9e0edc3bea2..6dfa3f1171183 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -51,8 +51,6 @@
 #endif
 
 #define NUMBER_OF_CMD	16
-static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };
 
 #define OPT_FRAGMENT	0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
@@ -319,27 +317,6 @@ opt2char(int option)
 	return *ptr;
 }
 
-static char
-cmd2char(int option)
-{
-	const char *ptr;
-	for (ptr = cmdflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
-static void
-add_command(unsigned int *cmd, const int newcmd, const int othercmds,
-	    int invert)
-{
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
-	if (*cmd & (~othercmds))
-		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
-			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
-	*cmd |= newcmd;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
-- 
2.23.0

