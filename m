Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AD8C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:03:16 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E191022265
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E191022265
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=netfilter-devel-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgKPOC7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 09:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgKPOC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 09:02:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B899C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 06:02:59 -0800 (PST)
Received: from localhost ([::1]:51040 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kef5t-0001Rl-Ig; Mon, 16 Nov 2020 15:02:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] xshared: Merge some command option-related code
Date:   Mon, 16 Nov 2020 15:02:38 +0100
Message-Id: <20201116140238.25955-4-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201116140238.25955-1-phil@nwl.cc>
References: <20201116140238.25955-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add OPT_FRAGMENT define into the enum of other OPT_* defines at the
right position and adjust the arptables-specific ones that follow
accordingly. Appropriately adjust inverse_for_options array in
xtables-arp.c.

Extend optflags from iptables.c by the arptables values for the sake of
completeness, then move it to xshared.h along with NUMBER_OF_OPT
definition. As a side-effect, this fixes for wrong ordering of entries
in arptables' 'optflags' copy.

Add arptables-specific bits to commands_v_options table (the speicific
options are matches on ARP header fields, just treat them like '-s'
option. This is also just a cosmetic change, arptables doesn't have a
generic_opt_check() implementation and hence doesn't use such a table.

With things potentially ready for common use, move commands_v_options
table along with generic_opt_check() and opt2char() into xshared.c and
drop the local (identical) implementations from iptables.c, ip6tables.c
xtables.c and xtables-arp.c. While doing so, fix ordering of entries in
that table: the row for CMD_ZERO_NUM was in the wrong position. Since
all moved rows though are identical, this had no effect in practice.

Fixes: d960a991350ca ("xtables-arp: Integrate OPT_* defines into xshared.h")
Fixes: 384958620abab ("use nf_tables and nf_tables compatibility interface")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 79 -----------------------------------------
 iptables/iptables.c    | 80 ------------------------------------------
 iptables/xshared.c     | 74 ++++++++++++++++++++++++++++++++++++++
 iptables/xshared.h     | 20 +++++++----
 iptables/xtables-arp.c | 14 +-------
 iptables/xtables.c     | 80 ------------------------------------------
 6 files changed, 89 insertions(+), 258 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 576c2cf8b0d9f..c95355b091568 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -45,10 +45,6 @@
 #include "ip6tables-multi.h"
 #include "xshared.h"
 
-#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-static const char optflags[]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
-
 static const char unsupported_rev[] = " [unsupported revision]";
 
 static struct option original_opts[] = {
@@ -100,36 +96,6 @@ struct xtables_globals ip6tables_globals = {
 	.compat_rev = xtables_compatible_revision,
 };
 
-/* Table of legal combinations of commands and options.  If any of the
- * given commands make an option legal, that option is legal (applies to
- * CMD_LIST and CMD_ZERO only).
- * Key:
- *  +  compulsory
- *  x  illegal
- *     optional
- */
-
-static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
-/* Well, it's better than "Re: Linux vs FreeBSD" */
-{
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
-};
-
 static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
 {
 /* -n */ 0,
@@ -264,51 +230,6 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
-static void
-generic_opt_check(int command, int options)
-{
-	int i, j, legal = 0;
-
-	/* Check that commands are valid with options.  Complicated by the
-	 * fact that if an option is legal with *any* command given, it is
-	 * legal overall (ie. -z and -l).
-	 */
-	for (i = 0; i < NUMBER_OF_OPT; i++) {
-		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
-
-		for (j = 0; j < NUMBER_OF_CMD; j++) {
-			if (!(command & (1<<j)))
-				continue;
-
-			if (!(options & (1<<i))) {
-				if (commands_v_options[j][i] == '+')
-					xtables_error(PARAMETER_PROBLEM,
-						   "You need to supply the `-%c' "
-						   "option for this command\n",
-						   optflags[i]);
-			} else {
-				if (commands_v_options[j][i] != 'x')
-					legal = 1;
-				else if (legal == 0)
-					legal = -1;
-			}
-		}
-		if (legal == -1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Illegal option `-%c' with this command\n",
-				   optflags[i]);
-	}
-}
-
-static char
-opt2char(int option)
-{
-	const char *ptr;
-	for (ptr = optflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 88ef6cf666d4b..7d6183116d265 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -41,11 +41,6 @@
 #include <fcntl.h>
 #include "xshared.h"
 
-#define OPT_FRAGMENT    0x00800U
-#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-static const char optflags[]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
-
 static const char unsupported_rev[] = " [unsupported revision]";
 
 static struct option original_opts[] = {
@@ -99,36 +94,6 @@ struct xtables_globals iptables_globals = {
 	.compat_rev = xtables_compatible_revision,
 };
 
-/* Table of legal combinations of commands and options.  If any of the
- * given commands make an option legal, that option is legal (applies to
- * CMD_LIST and CMD_ZERO only).
- * Key:
- *  +  compulsory
- *  x  illegal
- *     optional
- */
-
-static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
-/* Well, it's better than "Re: Linux vs FreeBSD" */
-{
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -f */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
-};
-
 static const int inverse_for_options[NUMBER_OF_OPT] =
 {
 /* -n */ 0,
@@ -263,51 +228,6 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
-static void
-generic_opt_check(int command, int options)
-{
-	int i, j, legal = 0;
-
-	/* Check that commands are valid with options.  Complicated by the
-	 * fact that if an option is legal with *any* command given, it is
-	 * legal overall (ie. -z and -l).
-	 */
-	for (i = 0; i < NUMBER_OF_OPT; i++) {
-		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
-
-		for (j = 0; j < NUMBER_OF_CMD; j++) {
-			if (!(command & (1<<j)))
-				continue;
-
-			if (!(options & (1<<i))) {
-				if (commands_v_options[j][i] == '+')
-					xtables_error(PARAMETER_PROBLEM,
-						   "You need to supply the `-%c' "
-						   "option for this command\n",
-						   optflags[i]);
-			} else {
-				if (commands_v_options[j][i] != 'x')
-					legal = 1;
-				else if (legal == 0)
-					legal = -1;
-			}
-		}
-		if (legal == -1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Illegal option `-%c' with this command\n",
-				   optflags[i]);
-	}
-}
-
-static char
-opt2char(int option)
-{
-	const char *ptr;
-	for (ptr = optflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 7d97637f7e129..71f689901e1d4 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -779,3 +779,77 @@ int parse_rulenumber(const char *rule)
 
 	return rulenum;
 }
+
+/* Table of legal combinations of commands and options.  If any of the
+ * given commands make an option legal, that option is legal (applies to
+ * CMD_LIST and CMD_ZERO only).
+ * Key:
+ *  +  compulsory
+ *  x  illegal
+ *     optional
+ */
+static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
+/* Well, it's better than "Re: Linux vs FreeBSD" */
+{
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -f 2 3 l 4 5 6 */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' ',' ',' ',' ',' ',' ',' '},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x','x','x','x','x','x','x','x'},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x','x','x','x','x','x','x'},
+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' ',' ',' ',' ',' ',' ',' '},
+};
+
+void generic_opt_check(int command, int options)
+{
+	int i, j, legal = 0;
+
+	/* Check that commands are valid with options. Complicated by the
+	 * fact that if an option is legal with *any* command given, it is
+	 * legal overall (ie. -z and -l).
+	 */
+	for (i = 0; i < NUMBER_OF_OPT; i++) {
+		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
+
+		for (j = 0; j < NUMBER_OF_CMD; j++) {
+			if (!(command & (1<<j)))
+				continue;
+
+			if (!(options & (1<<i))) {
+				if (commands_v_options[j][i] == '+')
+					xtables_error(PARAMETER_PROBLEM,
+						   "You need to supply the `-%c' "
+						   "option for this command\n",
+						   optflags[i]);
+			} else {
+				if (commands_v_options[j][i] != 'x')
+					legal = 1;
+				else if (legal == 0)
+					legal = -1;
+			}
+		}
+		if (legal == -1)
+			xtables_error(PARAMETER_PROBLEM,
+				   "Illegal option `-%c' with this command\n",
+				   optflags[i]);
+	}
+}
+
+char opt2char(int option)
+{
+	const char *ptr;
+
+	for (ptr = optflags; option > 1; option >>= 1, ptr++)
+		;
+
+	return *ptr;
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index c41bd054bf36f..9159b2b1f3768 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -30,15 +30,20 @@ enum {
 	OPT_VIANAMEOUT  = 1 << 8,
 	OPT_LINENUMBERS = 1 << 9,
 	OPT_COUNTERS    = 1 << 10,
+	OPT_FRAGMENT	= 1 << 11,
 	/* below are for arptables only */
-	OPT_S_MAC	= 1 << 11,
-	OPT_D_MAC	= 1 << 12,
-	OPT_H_LENGTH	= 1 << 13,
-	OPT_OPCODE	= 1 << 14,
-	OPT_H_TYPE	= 1 << 15,
-	OPT_P_TYPE	= 1 << 16,
+	OPT_S_MAC	= 1 << 12,
+	OPT_D_MAC	= 1 << 13,
+	OPT_H_LENGTH	= 1 << 14,
+	OPT_OPCODE	= 1 << 15,
+	OPT_H_TYPE	= 1 << 16,
+	OPT_P_TYPE	= 1 << 17,
 };
 
+#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
+static const char optflags[]
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f', 2, 3, 'l', 4, 5, 6 };
+
 enum {
 	CMD_NONE		= 0,
 	CMD_INSERT		= 1 << 0,
@@ -216,4 +221,7 @@ void add_command(unsigned int *cmd, const int newcmd,
 		 const int othercmds, int invert);
 int parse_rulenumber(const char *rule);
 
+void generic_opt_check(int command, int options);
+char opt2char(int option);
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index a557f258b437a..4a89ae9507051 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -53,10 +53,6 @@
 #include "nft-arp.h"
 #include <linux/netfilter_arp/arp_tables.h>
 
-#define NUMBER_OF_OPT	16
-static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 2, 3, 7, 8, 4, 5, 6, 'j', 'v', 'i', 'o', '0', 'c'};
-
 static struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
 	{ "delete", 1, 0,  'D' },
@@ -123,6 +119,7 @@ static int inverse_for_options[] =
 /* -o */ IPT_INV_VIA_OUT,
 /*--line*/ 0,
 /* -c */ 0,
+/* -f */ 0,
 /* 2 */ IPT_INV_SRCDEVADDR,
 /* 3 */ IPT_INV_TGTDEVADDR,
 /* -l */ IPT_INV_ARPHLN,
@@ -281,15 +278,6 @@ printhelp(void)
 	}
 }
 
-static char
-opt2char(int option)
-{
-	const char *ptr;
-	for (ptr = optflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
 static int
 check_inverse(const char option[], int *invert, int *optidx, int argc)
 {
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 9d2e441e0b773..9779bd83d53b3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -43,11 +43,6 @@
 #include "nft-shared.h"
 #include "nft.h"
 
-#define OPT_FRAGMENT	0x00800U
-#define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
-static const char optflags[]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
-
 static struct option original_opts[] = {
 	{.name = "append",	  .has_arg = 1, .val = 'A'},
 	{.name = "delete",	  .has_arg = 1, .val = 'D'},
@@ -99,36 +94,6 @@ struct xtables_globals xtables_globals = {
 	.compat_rev = nft_compatible_revision,
 };
 
-/* Table of legal combinations of commands and options.  If any of the
- * given commands make an option legal, that option is legal (applies to
- * CMD_LIST and CMD_ZERO only).
- * Key:
- *  +  compulsory
- *  x  illegal
- *     optional
- */
-
-static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
-/* Well, it's better than "Re: Linux vs FreeBSD" */
-{
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -f */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*ZERO_NUM*/  {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '},
-};
-
 static const int inverse_for_options[NUMBER_OF_OPT] =
 {
 /* -n */ 0,
@@ -262,51 +227,6 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
-static void
-generic_opt_check(int command, int options)
-{
-	int i, j, legal = 0;
-
-	/* Check that commands are valid with options.	Complicated by the
-	 * fact that if an option is legal with *any* command given, it is
-	 * legal overall (ie. -z and -l).
-	 */
-	for (i = 0; i < NUMBER_OF_OPT; i++) {
-		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
-
-		for (j = 0; j < NUMBER_OF_CMD; j++) {
-			if (!(command & (1<<j)))
-				continue;
-
-			if (!(options & (1<<i))) {
-				if (commands_v_options[j][i] == '+')
-					xtables_error(PARAMETER_PROBLEM,
-						   "You need to supply the `-%c' "
-						   "option for this command\n",
-						   optflags[i]);
-			} else {
-				if (commands_v_options[j][i] != 'x')
-					legal = 1;
-				else if (legal == 0)
-					legal = -1;
-			}
-		}
-		if (legal == -1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Illegal option `-%c' with this command\n",
-				   optflags[i]);
-	}
-}
-
-static char
-opt2char(int option)
-{
-	const char *ptr;
-	for (ptr = optflags; option > 1; option >>= 1, ptr++);
-
-	return *ptr;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
-- 
2.28.0

