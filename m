Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF180C54EAA
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjAZMY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjAZMY0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763733BDB6
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZUWGtoCHSkEaEsL4KkicwL9U6j1VRa2xPBUnz26swZw=; b=W2Q8gIgi9U7g0V62KbIXfnlIiL
        lRL4AiafRqEoibb/IYfhcV074Q203dfMKL77UqtM4OntdfXGeG4eERNZ9k0pKibWh0VaU18zvSaTp
        kAcidQLs1n/WoC5MMK73+JC83cVXSsspt9AH/J+yg9dteVPupVRLuKsmhSvO0sR9OyvKDxdp/7Wb7
        0yYEjy0hktZrCkJBKL70a3EnXC7BW5YXyVEHReqFKY8nMvxg0h4EUxtzWl/LPtjzTu5R4JC2YYWMx
        mDYg0Nn3gJbElQPYdJXzOqKvyifJUc6n10Cv8/MP0+00BWeImi0NJcD37R1wa9hpVLs6l6e/kVZh4
        rwlDS/xQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1Il-00057a-Q2
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/7] Proper fix for "unknown argument" error message
Date:   Thu, 26 Jan 2023 13:24:00 +0100
Message-Id: <20230126122406.23288-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While commit 1b8210f848631 kind of fixed the corner-case of invalid
short-options packed with others, it broke error reporting for
long-options. Revert it and deploy a proper solution:

When passing an invalid short-option, e.g. 'iptables -vaL', getopt_long
sets the variable 'optopt' to the invalid character's value. Use it for
reporting instead of optind if set.

To distinguish between invalid options and missing option arguments,
ebtables-translate optstring needs adjustment.

Fixes: 1b8210f848631 ("ebtables: Fix error message for invalid parameters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/iptables/0009-unknown-arg_0     | 31 +++++++++++++++++++
 iptables/xshared.c                            |  9 ++++--
 iptables/xtables-eb-translate.c               |  8 ++---
 iptables/xtables-eb.c                         | 17 ++++++----
 4 files changed, 50 insertions(+), 15 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/iptables/0009-unknown-arg_0

diff --git a/iptables/tests/shell/testcases/iptables/0009-unknown-arg_0 b/iptables/tests/shell/testcases/iptables/0009-unknown-arg_0
new file mode 100755
index 0000000000000..ac6e743966196
--- /dev/null
+++ b/iptables/tests/shell/testcases/iptables/0009-unknown-arg_0
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+rc=0
+
+check() {
+	local cmd="$1"
+	local msg="$2"
+
+	$XT_MULTI $cmd 2>&1 | grep -q "$msg" || {
+		echo "cmd: $XT_MULTI $1"
+		echo "exp: $msg"
+		echo "res: $($XT_MULTI $cmd 2>&1)"
+		rc=1
+	}
+}
+
+cmds="iptables ip6tables"
+[[ $XT_MULTI == *xtables-nft-multi ]] && {
+	cmds+=" ebtables"
+	cmds+=" iptables-translate"
+	cmds+=" ip6tables-translate"
+	cmds+=" ebtables-translate"
+}
+
+for cmd in $cmds; do
+	check "${cmd} --foo" 'unknown option "--foo"'
+	check "${cmd} -A" 'option "-A" requires an argument'
+	check "${cmd} -aL" 'unknown option "-a"'
+done
+
+exit $rc
diff --git a/iptables/xshared.c b/iptables/xshared.c
index f93529b11a319..ac51fac5ce9ed 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -192,9 +192,12 @@ static int command_default(struct iptables_command_state *cs,
 	if (cs->c == ':')
 		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
 		              "requires an argument", cs->argv[optind-1]);
-	if (cs->c == '?')
-		xtables_error(PARAMETER_PROBLEM, "unknown option "
-			      "\"%s\"", cs->argv[optind-1]);
+	if (cs->c == '?') {
+		char optoptstr[3] = {'-', optopt, '\0'};
+
+		xtables_error(PARAMETER_PROBLEM, "unknown option \"%s\"",
+			      optopt ? optoptstr : cs->argv[optind - 1]);
+	}
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 13b6b864a5f24..0c35272051752 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -201,7 +201,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 	printf("nft ");
 	/* Getopt saves the day */
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
+	   "-:A:D:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
 		cs.c = c;
 		switch (c) {
 		case 'A': /* Add a rule */
@@ -491,11 +491,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 			continue;
 		default:
 			ebt_check_inverse2(optarg, argc, argv);
-
-			if (ebt_command_default(&cs))
-				xtables_error(PARAMETER_PROBLEM,
-					      "Unknown argument: '%s'",
-					      argv[optind - 1]);
+			ebt_command_default(&cs);
 
 			if (command != 'A' && command != 'I' &&
 			    command != 'D')
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 7214a767ffe96..412b5cccdc46a 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -640,7 +640,16 @@ int ebt_command_default(struct iptables_command_state *cs)
 			return 0;
 		}
 	}
-	return 1;
+	if (cs->c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", cs->argv[optind - 1]);
+	if (cs->c == '?') {
+		char optoptstr[3] = {'-', optopt, '\0'};
+
+		xtables_error(PARAMETER_PROBLEM, "unknown option \"%s\"",
+			      optopt ? optoptstr : cs->argv[optind - 1]);
+	}
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
 int nft_init_eb(struct nft_handle *h, const char *pname)
@@ -1084,11 +1093,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			continue;
 		default:
 			ebt_check_inverse2(optarg, argc, argv);
-
-			if (ebt_command_default(&cs))
-				xtables_error(PARAMETER_PROBLEM,
-					      "Unknown argument: '%s'",
-					      argv[optind]);
+			ebt_command_default(&cs);
 
 			if (command != 'A' && command != 'I' &&
 			    command != 'D' && command != 'C' && command != 14)
-- 
2.38.0

