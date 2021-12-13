Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67174C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhLMSIV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhLMSIU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:08:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52513C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:08:20 -0800 (PST)
Received: from localhost ([::1]:58962 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpkI-0004Ij-1E; Mon, 13 Dec 2021 19:08:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 2/6] xshared: Share a common printhelp function
Date:   Mon, 13 Dec 2021 19:07:43 +0100
Message-Id: <20211213180747.20707-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213180747.20707-1-phil@nwl.cc>
References: <20211213180747.20707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Help texts in legacy and nft variants are supposed to be identical, but
those of iptables and ip6tables largely overlapped already. By referring
to xt_params and afinfo pointers, it is relatively trivial to craft a
suitable help text on demand, so duplicated help texts can be
eliminated.

As a side-effect, this fixes ip6tables-nft help text - it was identical
to that of iptables-nft.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |  79 +--------------------------------
 iptables/iptables.c  |  78 +-------------------------------
 iptables/xshared.c   | 103 +++++++++++++++++++++++++++++++++++++++++++
 iptables/xshared.h   |   2 +
 iptables/xtables.c   |  85 +----------------------------------
 5 files changed, 108 insertions(+), 239 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 0509c36c839b7..46f7785b8a9c5 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -114,84 +114,7 @@ exit_tryhelp(int status)
 static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
-	printf("%s v%s\n\n"
-"Usage: %s -[ACD] chain rule-specification [options]\n"
-"       %s -I chain [rulenum] rule-specification [options]\n"
-"       %s -R chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
-"       %s -[LS] [chain [rulenum]] [options]\n"
-"       %s -[FZ] [chain] [options]\n"
-"       %s -[NX] chain\n"
-"       %s -E old-chain-name new-chain-name\n"
-"       %s -P chain target [options]\n"
-"       %s -h (print this help information)\n\n",
-	       prog_name, prog_vers, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name);
-
-	printf(
-"Commands:\n"
-"Either long or short options are allowed.\n"
-"  --append  -A chain		Append to chain\n"
-"  --check   -C chain		Check for the existence of a rule\n"
-"  --delete  -D chain		Delete matching rule from chain\n"
-"  --delete  -D chain rulenum\n"
-"				Delete rule rulenum (1 = first) from chain\n"
-"  --insert  -I chain [rulenum]\n"
-"				Insert in chain as rulenum (default 1=first)\n"
-"  --replace -R chain rulenum\n"
-"				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain [rulenum]]\n"
-"				List the rules in a chain or all chains\n"
-"  --list-rules -S [chain [rulenum]]\n"
-"				Print the rules in a chain or all chains\n"
-"  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain [rulenum]]\n"
-"				Zero counters in chain or all chains\n"
-"  --new     -N chain		Create a new user-defined chain\n"
-"  --delete-chain\n"
-"            -X [chain]		Delete a user-defined chain\n"
-"  --policy  -P chain target\n"
-"				Change policy on chain to target\n"
-"  --rename-chain\n"
-"            -E old-chain new-chain\n"
-"				Change chain name, (moving any references)\n"
-
-"Options:\n"
-"    --ipv4	-4		Error (line is ignored by ip6tables-restore)\n"
-"    --ipv6	-6		Nothing (line is ignored by iptables-restore)\n"
-"[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
-"[!] --source	-s address[/mask][,...]\n"
-"				source specification\n"
-"[!] --destination -d address[/mask][,...]\n"
-"				destination specification\n"
-"[!] --in-interface -i input name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --jump	-j target\n"
-"				target for rule (may load target extension)\n"
-#ifdef IP6T_F_GOTO
-"  --goto	-g chain\n"
-"				jump to chain with no return\n"
-#endif
-"  --match	-m match\n"
-"				extended match (may load extension)\n"
-"  --numeric	-n		numeric output of addresses and ports\n"
-"[!] --out-interface -o output name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
-"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
-"				interval to wait for xtables lock\n"
-"				default is 1 second\n"
-"  --line-numbers		print line numbers when listing\n"
-"  --exact	-x		expand numbers (display exact values)\n"
-/*"[!] --fragment	-f		match second or further fragments only\n"*/
-"  --modprobe=<command>		try to insert modules using this command\n"
-"  --set-counters PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
-
-	print_extension_helps(xtables_targets, matches);
+	xtables_printhelp(matches);
 	exit(0);
 }
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index a69d42387f062..7b4503498865d 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -112,83 +112,7 @@ exit_tryhelp(int status)
 static void
 exit_printhelp(const struct xtables_rule_match *matches)
 {
-	printf("%s v%s\n\n"
-"Usage: %s -[ACD] chain rule-specification [options]\n"
-"       %s -I chain [rulenum] rule-specification [options]\n"
-"       %s -R chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
-"       %s -[LS] [chain [rulenum]] [options]\n"
-"       %s -[FZ] [chain] [options]\n"
-"       %s -[NX] chain\n"
-"       %s -E old-chain-name new-chain-name\n"
-"       %s -P chain target [options]\n"
-"       %s -h (print this help information)\n\n",
-	       prog_name, prog_vers, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name);
-
-	printf(
-"Commands:\n"
-"Either long or short options are allowed.\n"
-"  --append  -A chain		Append to chain\n"
-"  --check   -C chain		Check for the existence of a rule\n"
-"  --delete  -D chain		Delete matching rule from chain\n"
-"  --delete  -D chain rulenum\n"
-"				Delete rule rulenum (1 = first) from chain\n"
-"  --insert  -I chain [rulenum]\n"
-"				Insert in chain as rulenum (default 1=first)\n"
-"  --replace -R chain rulenum\n"
-"				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain [rulenum]]\n"
-"				List the rules in a chain or all chains\n"
-"  --list-rules -S [chain [rulenum]]\n"
-"				Print the rules in a chain or all chains\n"
-"  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain [rulenum]]\n"
-"				Zero counters in chain or all chains\n"
-"  --new     -N chain		Create a new user-defined chain\n"
-"  --delete-chain\n"
-"            -X [chain]		Delete a user-defined chain\n"
-"  --policy  -P chain target\n"
-"				Change policy on chain to target\n"
-"  --rename-chain\n"
-"            -E old-chain new-chain\n"
-"				Change chain name, (moving any references)\n"
-
-"Options:\n"
-"    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)\n"
-"    --ipv6	-6		Error (line is ignored by iptables-restore)\n"
-"[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
-"[!] --source	-s address[/mask][...]\n"
-"				source specification\n"
-"[!] --destination -d address[/mask][...]\n"
-"				destination specification\n"
-"[!] --in-interface -i input name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-" --jump	-j target\n"
-"				target for rule (may load target extension)\n"
-#ifdef IPT_F_GOTO
-"  --goto      -g chain\n"
-"                              jump to chain with no return\n"
-#endif
-"  --match	-m match\n"
-"				extended match (may load extension)\n"
-"  --numeric	-n		numeric output of addresses and ports\n"
-"[!] --out-interface -o output name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
-"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
-"				default is 1 second\n"
-"  --line-numbers		print line numbers when listing\n"
-"  --exact	-x		expand numbers (display exact values)\n"
-"[!] --fragment	-f		match second or further fragments only\n"
-"  --modprobe=<command>		try to insert modules using this command\n"
-"  --set-counters PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
-
-	print_extension_helps(xtables_targets, matches);
+	xtables_printhelp(matches);
 	exit(0);
 }
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 94a2d08815d92..9b32610772ba5 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1149,3 +1149,106 @@ int print_match_save(const struct xt_entry_match *e, const void *ip)
 	}
 	return 0;
 }
+
+void
+xtables_printhelp(const struct xtables_rule_match *matches)
+{
+	const char *prog_name = xt_params->program_name;
+	const char *prog_vers = xt_params->program_version;
+
+	printf("%s v%s\n\n"
+"Usage: %s -[ACD] chain rule-specification [options]\n"
+"       %s -I chain [rulenum] rule-specification [options]\n"
+"       %s -R chain rulenum rule-specification [options]\n"
+"       %s -D chain rulenum [options]\n"
+"       %s -[LS] [chain [rulenum]] [options]\n"
+"       %s -[FZ] [chain] [options]\n"
+"       %s -[NX] chain\n"
+"       %s -E old-chain-name new-chain-name\n"
+"       %s -P chain target [options]\n"
+"       %s -h (print this help information)\n\n",
+	       prog_name, prog_vers, prog_name, prog_name,
+	       prog_name, prog_name, prog_name, prog_name,
+	       prog_name, prog_name, prog_name, prog_name);
+
+	printf(
+"Commands:\n"
+"Either long or short options are allowed.\n"
+"  --append  -A chain		Append to chain\n"
+"  --check   -C chain		Check for the existence of a rule\n"
+"  --delete  -D chain		Delete matching rule from chain\n"
+"  --delete  -D chain rulenum\n"
+"				Delete rule rulenum (1 = first) from chain\n"
+"  --insert  -I chain [rulenum]\n"
+"				Insert in chain as rulenum (default 1=first)\n"
+"  --replace -R chain rulenum\n"
+"				Replace rule rulenum (1 = first) in chain\n"
+"  --list    -L [chain [rulenum]]\n"
+"				List the rules in a chain or all chains\n"
+"  --list-rules -S [chain [rulenum]]\n"
+"				Print the rules in a chain or all chains\n"
+"  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"				Zero counters in chain or all chains\n"
+"  --new     -N chain		Create a new user-defined chain\n"
+"  --delete-chain\n"
+"            -X [chain]		Delete a user-defined chain\n"
+"  --policy  -P chain target\n"
+"				Change policy on chain to target\n"
+"  --rename-chain\n"
+"            -E old-chain new-chain\n"
+"				Change chain name, (moving any references)\n");
+
+	printf(
+"Options:\n"
+"    --ipv4	-4		%s (line is ignored by ip6tables-restore)\n"
+"    --ipv6	-6		%s (line is ignored by iptables-restore)\n"
+"[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
+"[!] --source	-s address[/mask][...]\n"
+"				source specification\n"
+"[!] --destination -d address[/mask][...]\n"
+"				destination specification\n"
+"[!] --in-interface -i input name[+]\n"
+"				network interface name ([+] for wildcard)\n"
+" --jump	-j target\n"
+"				target for rule (may load target extension)\n",
+	afinfo->family == NFPROTO_IPV4 ? "Nothing" : "Error",
+	afinfo->family == NFPROTO_IPV4 ? "Error" : "Nothing");
+
+	if (0
+#ifdef IPT_F_GOTO
+	    || afinfo->family == NFPROTO_IPV4
+#endif
+#ifdef IP6T_F_GOTO
+	    || afinfo->family == NFPROTO_IPV6
+#endif
+	   )
+		printf(
+"  --goto      -g chain\n"
+"			       jump to chain with no return\n");
+	printf(
+"  --match	-m match\n"
+"				extended match (may load extension)\n"
+"  --numeric	-n		numeric output of addresses and ports\n"
+"[!] --out-interface -o output name[+]\n"
+"				network interface name ([+] for wildcard)\n"
+"  --table	-t table	table to manipulate (default: `filter')\n"
+"  --verbose	-v		verbose mode\n"
+"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
+"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
+"				interval to wait for xtables lock\n"
+"				default is 1 second\n"
+"  --line-numbers		print line numbers when listing\n"
+"  --exact	-x		expand numbers (display exact values)\n");
+
+	if (afinfo->family == NFPROTO_IPV4)
+		printf(
+"[!] --fragment	-f		match second or further fragments only\n");
+
+	printf(
+"  --modprobe=<command>		try to insert modules using this command\n"
+"  --set-counters PKTS BYTES	set the counter during insert/append\n"
+"[!] --version	-V		print package version.\n");
+
+	print_extension_helps(xtables_targets, matches);
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 1ee64d9e4010d..3310954c1f441 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -259,4 +259,6 @@ void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
 
 int print_match_save(const struct xt_entry_match *e, const void *ip);
 
+void xtables_printhelp(const struct xtables_rule_match *matches);
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 32b93d2bfc8cd..36324a5de22a8 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -87,7 +87,6 @@ static struct option original_opts[] = {
 };
 
 void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
-static void printhelp(const struct xtables_rule_match *m);
 
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
@@ -96,7 +95,7 @@ struct xtables_globals xtables_globals = {
 	.orig_opts = original_opts,
 	.exit_err = xtables_exit_error,
 	.compat_rev = nft_compatible_revision,
-	.print_help = printhelp,
+	.print_help = xtables_printhelp,
 };
 
 #define opts xt_params->opts
@@ -114,88 +113,6 @@ exit_tryhelp(int status)
 	exit(status);
 }
 
-static void
-printhelp(const struct xtables_rule_match *matches)
-{
-	printf("%s v%s\n\n"
-"Usage: %s -[ACD] chain rule-specification [options]\n"
-"	%s -I chain [rulenum] rule-specification [options]\n"
-"	%s -R chain rulenum rule-specification [options]\n"
-"	%s -D chain rulenum [options]\n"
-"	%s -[LS] [chain [rulenum]] [options]\n"
-"	%s -[FZ] [chain] [options]\n"
-"	%s -[NX] chain\n"
-"	%s -E old-chain-name new-chain-name\n"
-"	%s -P chain target [options]\n"
-"	%s -h (print this help information)\n\n",
-	       prog_name, prog_vers, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name,
-	       prog_name, prog_name, prog_name, prog_name);
-
-	printf(
-"Commands:\n"
-"Either long or short options are allowed.\n"
-"  --append  -A chain		Append to chain\n"
-"  --check   -C chain		Check for the existence of a rule\n"
-"  --delete  -D chain		Delete matching rule from chain\n"
-"  --delete  -D chain rulenum\n"
-"				Delete rule rulenum (1 = first) from chain\n"
-"  --insert  -I chain [rulenum]\n"
-"				Insert in chain as rulenum (default 1=first)\n"
-"  --replace -R chain rulenum\n"
-"				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain [rulenum]]\n"
-"				List the rules in a chain or all chains\n"
-"  --list-rules -S [chain [rulenum]]\n"
-"				Print the rules in a chain or all chains\n"
-"  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain [rulenum]]\n"
-"				Zero counters in chain or all chains\n"
-"  --new     -N chain		Create a new user-defined chain\n"
-"  --delete-chain\n"
-"	     -X [chain]		Delete a user-defined chain\n"
-"  --policy  -P chain target\n"
-"				Change policy on chain to target\n"
-"  --rename-chain\n"
-"	     -E old-chain new-chain\n"
-"				Change chain name, (moving any references)\n"
-
-"Options:\n"
-"    --ipv4	-4		Nothing (line is ignored by ip6tables-restore)\n"
-"    --ipv6	-6		Error (line is ignored by iptables-restore)\n"
-"[!] --proto	-p proto	protocol: by number or name, eg. `tcp'\n"
-"[!] --source	-s address[/mask][...]\n"
-"				source specification\n"
-"[!] --destination -d address[/mask][...]\n"
-"				destination specification\n"
-"[!] --in-interface -i input name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-" --jump	-j target\n"
-"				target for rule (may load target extension)\n"
-#ifdef IPT_F_GOTO
-"  --goto      -g chain\n"
-"			       jump to chain with no return\n"
-#endif
-"  --match	-m match\n"
-"				extended match (may load extension)\n"
-"  --numeric	-n		numeric output of addresses and ports\n"
-"[!] --out-interface -o output name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
-"  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
-"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
-"				default is 1 second\n"
-"  --line-numbers		print line numbers when listing\n"
-"  --exact	-x		expand numbers (display exact values)\n"
-"[!] --fragment	-f		match second or further fragments only\n"
-"  --modprobe=<command>		try to insert modules using this command\n"
-"  --set-counters PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
-
-	print_extension_helps(xtables_targets, matches);
-}
-
 void
 xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 {
-- 
2.33.0

