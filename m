Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF47C43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 17:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiFIRFu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiFIRFu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 13:05:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34DB0D0E
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ESc8weCYn4XYDNPLHl6WOE4zGhCK2F5Eo11Kvl8toYE=; b=JCEGi1+MH8M1Kx3tso2QnTfR8s
        3DOuKkqKztN2sEmkhdwe4F3t8VCcBdSeWZDEyrXp8TIaoHgmEBrbPbpJcuZLqtQbAG8MqS3eogi4k
        dG0/BddiI14h/XgpO/tjiQs5cQ4beHnpni7s05cT2S9OoLwc5NBAunwr6BzowcgBKWrUifmby2Sx6
        ww72NVCjgAlEVzbLCHR2wDGf9sryatLXQdbJ8WMDOHGMHpmSZV0u4hx1z2HKlda1B+3xQBubSTw1l
        rRH1zi2NmKt61TLAhIXdMO+J71LWlvQfaNc8YPcL8WfC27Rt9xe0eg0WkusNa1NkxlxPyOhsZRdpz
        MClVEI0w==;
Received: from localhost ([::1] helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nzLbM-0005uG-Cw
        for netfilter-devel@vger.kernel.org; Thu, 09 Jun 2022 19:05:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xshared: Make some functions static
Date:   Thu,  9 Jun 2022 19:05:39 +0200
Message-Id: <20220609170539.14769-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220609170539.14769-1-phil@nwl.cc>
References: <20220609170539.14769-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With all ip(6)tables variants using the same do_parse() function, quite
a bunch of functions are not used outside of xshared.c anymore. Make them
static.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 30 +++++++++++++++++-------------
 iptables/xshared.h | 21 ---------------------
 2 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 9b5e5b5bddc27..bd4e10225de95 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -39,8 +39,8 @@ char *arp_opcodes[] =
  * to the commandline, and see expected results. So we call help for all
  * specified matches and targets.
  */
-void print_extension_helps(const struct xtables_target *t,
-    const struct xtables_rule_match *m)
+static void print_extension_helps(const struct xtables_target *t,
+				  const struct xtables_rule_match *m)
 {
 	for (; t != NULL; t = t->next) {
 		if (t->used) {
@@ -129,8 +129,8 @@ static struct xtables_match *load_proto(struct iptables_command_state *cs)
 			  cs->options & OPT_NUMERIC, &cs->matches);
 }
 
-int command_default(struct iptables_command_state *cs,
-		    struct xtables_globals *gl, bool invert)
+static int command_default(struct iptables_command_state *cs,
+			   struct xtables_globals *gl, bool invert)
 {
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
@@ -789,7 +789,7 @@ void save_iface(char letter, const char *iface,
 	}
 }
 
-void command_match(struct iptables_command_state *cs, bool invert)
+static void command_match(struct iptables_command_state *cs, bool invert)
 {
 	struct option *opts = xt_params->opts;
 	struct xtables_match *m;
@@ -827,7 +827,7 @@ void command_match(struct iptables_command_state *cs, bool invert)
 	xt_params->opts = opts;
 }
 
-const char *xt_parse_target(const char *targetname)
+static const char *xt_parse_target(const char *targetname)
 {
 	const char *ptr;
 
@@ -889,7 +889,7 @@ void command_jump(struct iptables_command_state *cs, const char *jumpto)
 	xt_params->opts = opts;
 }
 
-char cmd2char(int option)
+static char cmd2char(int option)
 {
 	/* cmdflags index corresponds with position of bit in CMD_* values */
 	static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
@@ -905,8 +905,8 @@ char cmd2char(int option)
 	return cmdflags[i];
 }
 
-void add_command(unsigned int *cmd, const int newcmd,
-		 const int othercmds, int invert)
+static void add_command(unsigned int *cmd, const int newcmd,
+			const int othercmds, int invert)
 {
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
@@ -917,7 +917,7 @@ void add_command(unsigned int *cmd, const int newcmd,
 }
 
 /* Can't be zero. */
-int parse_rulenumber(const char *rule)
+static int parse_rulenumber(const char *rule)
 {
 	unsigned int rulenum;
 
@@ -928,6 +928,10 @@ int parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
+#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
+static const char optflags[]
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f', 2, 3, 'l', 4, 5, 6 };
+
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
  * CMD_LIST and CMD_ZERO only).
@@ -957,7 +961,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
 };
 
-void generic_opt_check(int command, int options)
+static void generic_opt_check(int command, int options)
 {
 	int i, j, legal = 0;
 
@@ -992,7 +996,7 @@ void generic_opt_check(int command, int options)
 	}
 }
 
-char opt2char(int option)
+static char opt2char(int option)
 {
 	const char *ptr;
 
@@ -1024,7 +1028,7 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 /* 6 */ IPT_INV_PROTO,
 };
 
-void
+static void
 set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   bool invert)
 {
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2498e32d39e03..1d6b9bf4ee9b7 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -39,10 +39,6 @@ enum {
 	OPT_P_TYPE	= 1 << 17,
 };
 
-#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-static const char optflags[]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f', 2, 3, 'l', 4, 5, 6 };
-
 enum {
 	CMD_NONE		= 0,
 	CMD_INSERT		= 1 << 0,
@@ -79,10 +75,6 @@ struct xtables_target;
 #define IPT_INV_ARPOP		0x0400
 #define IPT_INV_ARPHRD		0x0800
 
-void
-set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
-	   bool invert);
-
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")
@@ -164,10 +156,6 @@ enum {
 	XT_OPTION_OFFSET_SCALE = 256,
 };
 
-extern void print_extension_helps(const struct xtables_target *,
-	const struct xtables_rule_match *);
-extern int command_default(struct iptables_command_state *,
-	struct xtables_globals *, bool invert);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
@@ -239,19 +227,10 @@ void save_iface(char letter, const char *iface,
 void print_fragment(unsigned int flags, unsigned int invflags,
 		    unsigned int format, bool fake);
 
-void command_match(struct iptables_command_state *cs, bool invert);
-const char *xt_parse_target(const char *targetname);
 void command_jump(struct iptables_command_state *cs, const char *jumpto);
 
-char cmd2char(int option);
-void add_command(unsigned int *cmd, const int newcmd,
-		 const int othercmds, int invert);
-int parse_rulenumber(const char *rule);
 void assert_valid_chain_name(const char *chainname);
 
-void generic_opt_check(int command, int options);
-char opt2char(int option);
-
 void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 			const char *targname, uint8_t proto, uint8_t flags,
 			uint8_t invflags, unsigned int format);
-- 
2.34.1

