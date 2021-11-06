Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2B2C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300B06120A
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhKFVBV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVBU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:01:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C87C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:39 -0700 (PDT)
Received: from localhost ([::1]:58782 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlp-00047h-L1; Sat, 06 Nov 2021 21:58:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/10] xshared: Merge and share parse_chain()
Date:   Sat,  6 Nov 2021 21:57:47 +0100
Message-Id: <20211106205756.14529-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have a common routine to perform chain name checks, combining all
variants' requirements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 26 --------------------------
 iptables/iptables.c  | 25 -------------------------
 iptables/xshared.c   | 24 ++++++++++++++++++++++++
 iptables/xshared.h   |  1 +
 iptables/xtables.c   |  9 +--------
 5 files changed, 26 insertions(+), 59 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index e967c040fd3c9..ec0ae759875e7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -233,32 +233,6 @@ static int is_exthdr(uint16_t proto)
 		proto == IPPROTO_DSTOPTS);
 }
 
-static void
-parse_chain(const char *chainname)
-{
-	const char *ptr;
-
-	if (strlen(chainname) >= XT_EXTENSION_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %u chars)",
-			   chainname, XT_EXTENSION_MAXNAMELEN);
-
-	if (*chainname == '-' || *chainname == '!')
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name not allowed to start "
-			   "with `%c'\n", *chainname);
-
-	if (xtables_find_target(chainname, XTF_TRY_LOAD))
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name may not clash "
-			   "with target name\n");
-
-	for (ptr = chainname; *ptr; ptr++)
-		if (isspace(*ptr))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid chain name `%s'", chainname);
-}
-
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
 {
diff --git a/iptables/iptables.c b/iptables/iptables.c
index b925f0892e0d5..246526a55a3c9 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -223,31 +223,6 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 
-static void
-parse_chain(const char *chainname)
-{
-	const char *ptr;
-
-	if (strlen(chainname) >= XT_EXTENSION_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %u chars)",
-			   chainname, XT_EXTENSION_MAXNAMELEN);
-
-	if (*chainname == '-' || *chainname == '!')
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name not allowed to start "
-			   "with `%c'\n", *chainname);
-
-	if (xtables_find_target(chainname, XTF_TRY_LOAD))
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name may not clash "
-			   "with target name\n");
-
-	for (ptr = chainname; *ptr; ptr++)
-		if (isspace(*ptr))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid chain name `%s'", chainname);
-}
 
 static void
 print_header(unsigned int format, const char *chain, struct xtc_handle *handle)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 2d3ef679fd765..bd545d6b31908 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -892,3 +892,27 @@ set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
 		*invflg |= inverse_for_options[i];
 	}
 }
+
+void parse_chain(const char *chainname)
+{
+	const char *ptr;
+
+	if (strlen(chainname) >= XT_EXTENSION_MAXNAMELEN)
+		xtables_error(PARAMETER_PROBLEM,
+			      "chain name `%s' too long (must be under %u chars)",
+			      chainname, XT_EXTENSION_MAXNAMELEN);
+
+	if (*chainname == '-' || *chainname == '!')
+		xtables_error(PARAMETER_PROBLEM,
+			      "chain name not allowed to start with `%c'\n",
+			      *chainname);
+
+	if (xtables_find_target(chainname, XTF_TRY_LOAD))
+		xtables_error(PARAMETER_PROBLEM,
+			      "chain name may not clash with target name\n");
+
+	for (ptr = chainname; *ptr; ptr++)
+		if (isspace(*ptr))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid chain name `%s'", chainname);
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index b59116ac49747..6d6acbca13da2 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -235,6 +235,7 @@ char cmd2char(int option);
 void add_command(unsigned int *cmd, const int newcmd,
 		 const int othercmds, int invert);
 int parse_rulenumber(const char *rule);
+void parse_chain(const char *chainname);
 
 void generic_opt_check(int command, int options);
 char opt2char(int option);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 5c69af7e0f1f0..32b93d2bfc8cd 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -424,14 +424,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'N':
-			if (optarg && (*optarg == '-' || *optarg == '!'))
-				xtables_error(PARAMETER_PROBLEM,
-					   "chain name not allowed to start "
-					   "with `%c'\n", *optarg);
-			if (xtables_find_target(optarg, XTF_TRY_LOAD))
-				xtables_error(PARAMETER_PROBLEM,
-					   "chain name may not clash "
-					   "with target name\n");
+			parse_chain(optarg);
 			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
 				    invert);
 			p->chain = optarg;
-- 
2.33.0

