Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB35C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391436AbiEFLpJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391435AbiEFLpI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFA960D88
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=exVtf4B5l5hEUBs1ZjNDceFTFDmjcSMwP4nt/GOJixU=; b=nzlu7biBbcw7dtBX2/t7BVGh7n
        AaEp3sjGWo9TQJ5+py1IFk/EGwioTO6DLvpMPmWqYo5tcPxHKq7ztE9lAQ5k6IrxPNVbjNESW3y9F
        0qgceQcnI4icDW5L3dchKpYBa4aoj7uFav4WM8ln19ZM4naf0gIskCMHhmiUcHlCmRqdW8TkRtfG6
        wDfmOi+LCgWqpmvZrQ/TdSwl9xW1nK/GNoyj9lCt+yB/3J/8lHoDQD5ZYQZUiOkF1k9mb+9ONUkDt
        YIkC3osrpS2valkv09Oz5YvxtWmU6XFAFGefGnC3HXBjsyi9ILp/p7q1PP5zQhtDP6hqXjlVlS4bN
        Mrbal3lg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwKq-0005qA-5W; Fri, 06 May 2022 13:41:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] xshared: Extend xtables_printhelp() for arptables
Date:   Fri,  6 May 2022 13:41:02 +0200
Message-Id: <20220506114104.7344-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506114104.7344-1-phil@nwl.cc>
References: <20220506114104.7344-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function checks afinfo->family already to cover ip6tables specifics,
doing the same for arptables does not make things much worse.

This changes arptables-nft help output slightly:

* List possible negations extrapositioned, which is preferred anyway
  (arptables-nft supports both)
* List --out-interface option at lexically sorted position
* Print --wait option, it's ignored just like with iptables
* Restore default target option printing as with legacy arptables (not
  sure if arptables-nft ever did this) by explicitly loading them.

While being at it, add --set-counters short option '-c' to help output
for ip(6)tables.

This effectively removes the need for (and all users of)
xtables_global's 'print_help' callback, so drop that field from the
struct.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      |   1 -
 iptables/ip6tables.c   |   1 -
 iptables/iptables.c    |   1 -
 iptables/xshared.c     |  53 +++++++++++++++++----
 iptables/xshared.h     |   1 -
 iptables/xtables-arp.c | 104 -----------------------------------------
 iptables/xtables.c     |   1 -
 7 files changed, 43 insertions(+), 119 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 84369dacb7e37..a93e8f6e91585 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -425,7 +425,6 @@ struct xtables_globals
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 	int (*compat_rev)(const char *name, uint8_t rev, int opt);
-	void (*print_help)(const struct xtables_rule_match *m);
 };
 
 #define XT_GETOPT_TABLEEND {.name = NULL, .has_arg = false}
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index f4796b897d74c..5806a13ce0710 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -93,7 +93,6 @@ struct xtables_globals ip6tables_globals = {
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = xtables_compatible_revision,
-	.print_help = xtables_printhelp,
 };
 
 /*
diff --git a/iptables/iptables.c b/iptables/iptables.c
index ccebb1a6c7eac..edde604cf2367 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -90,7 +90,6 @@ struct xtables_globals iptables_globals = {
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = xtables_compatible_revision,
-	.print_help = xtables_printhelp,
 };
 
 /*
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 674b49cb72798..e959f203e5cc9 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1156,7 +1156,7 @@ int print_match_save(const struct xt_entry_match *e, const void *ip)
 	return 0;
 }
 
-void
+static void
 xtables_printhelp(const struct xtables_rule_match *matches)
 {
 	const char *prog_name = xt_params->program_name;
@@ -1203,23 +1203,40 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 "				Change policy on chain to target\n"
 "  --rename-chain\n"
 "            -E old-chain new-chain\n"
-"				Change chain name, (moving any references)\n");
+"				Change chain name, (moving any references)\n"
+"\n"
+"Options:\n");
 
-	printf(
-"Options:\n"
+	if (afinfo->family == NFPROTO_ARP) {
+		printf(
+"[!] --source-ip	-s address[/mask]\n"
+"				source specification\n"
+"[!] --destination-ip -d address[/mask]\n"
+"				destination specification\n"
+"[!] --source-mac address[/mask]\n"
+"[!] --destination-mac address[/mask]\n"
+"    --h-length   -l   length[/mask] hardware length (nr of bytes)\n"
+"    --opcode code[/mask] operation code (2 bytes)\n"
+"    --h-type   type[/mask]  hardware type (2 bytes, hexadecimal)\n"
+"    --proto-type   type[/mask]  protocol type (2 bytes)\n");
+	} else {
+		printf(
 "    --ipv4	-4		%s (line is ignored by ip6tables-restore)\n"
 "    --ipv6	-6		%s (line is ignored by iptables-restore)\n"
 "[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'\n"
 "[!] --source	-s address[/mask][...]\n"
 "				source specification\n"
 "[!] --destination -d address[/mask][...]\n"
-"				destination specification\n"
+"				destination specification\n",
+		afinfo->family == NFPROTO_IPV4 ? "Nothing" : "Error",
+		afinfo->family == NFPROTO_IPV4 ? "Error" : "Nothing");
+	}
+
+	printf(
 "[!] --in-interface -i input name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 " --jump	-j target\n"
-"				target for rule (may load target extension)\n",
-	afinfo->family == NFPROTO_IPV4 ? "Nothing" : "Error",
-	afinfo->family == NFPROTO_IPV4 ? "Error" : "Nothing");
+"				target for rule (may load target extension)\n");
 
 	if (0
 #ifdef IPT_F_GOTO
@@ -1250,9 +1267,25 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 
 	printf(
 "  --modprobe=<command>		try to insert modules using this command\n"
-"  --set-counters PKTS BYTES	set the counter during insert/append\n"
+"  --set-counters -c PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
+	if (afinfo->family == NFPROTO_ARP) {
+		int i;
+
+		printf(" opcode strings: \n");
+		for (i = 0; i < ARP_NUMOPCODES; i++)
+			printf(" %d = %s\n", i + 1, arp_opcodes[i]);
+		printf(
+	" hardware type string: 1 = Ethernet\n"
+	" protocol type string: 0x800 = IPv4\n");
+
+		xtables_find_target("standard", XTF_TRY_LOAD);
+		xtables_find_target("mangle", XTF_TRY_LOAD);
+		xtables_find_target("CLASSIFY", XTF_TRY_LOAD);
+		xtables_find_target("MARK", XTF_TRY_LOAD);
+	}
+
 	print_extension_helps(xtables_targets, matches);
 }
 
@@ -1475,7 +1508,7 @@ void do_parse(int argc, char *argv[],
 				xtables_find_match(cs->protocol,
 					XTF_TRY_LOAD, &cs->matches);
 
-			xt_params->print_help(cs->matches);
+			xtables_printhelp(cs->matches);
 			exit(0);
 
 			/*
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2fdebc326a6d6..e69da7351efa4 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -258,7 +258,6 @@ void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
 
 int print_match_save(const struct xt_entry_match *e, const void *ip);
 
-void xtables_printhelp(const struct xtables_rule_match *matches);
 void exit_tryhelp(int status, int line) __attribute__((noreturn));
 
 struct addr_mask {
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index f1a128fc55647..bf7d44e7b815b 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -83,118 +83,14 @@ static struct option original_opts[] = {
 
 #define opts xt_params->opts
 
-static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION " (nf_tables)",
 	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
 	.compat_rev		= nft_compatible_revision,
-	.print_help		= printhelp,
 };
 
-static void
-printhelp(const struct xtables_rule_match *m)
-{
-	struct xtables_target *t = NULL;
-	int i;
-
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
-	       arptables_globals.program_name,
-	       arptables_globals.program_version,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name,
-	       arptables_globals.program_name);
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
-"  --source-ip	-s [!] address[/mask]\n"
-"				source specification\n"
-"  --destination-ip -d [!] address[/mask]\n"
-"				destination specification\n"
-"  --source-mac [!] address[/mask]\n"
-"  --destination-mac [!] address[/mask]\n"
-"  --h-length   -l   length[/mask] hardware length (nr of bytes)\n"
-"  --opcode code[/mask] operation code (2 bytes)\n"
-"  --h-type   type[/mask]  hardware type (2 bytes, hexadecimal)\n"
-"  --proto-type   type[/mask]  protocol type (2 bytes)\n"
-"  --in-interface -i [!] input name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --out-interface -o [!] output name[+]\n"
-"				network interface name ([+] for wildcard)\n"
-"  --jump	-j target\n"
-"				target for rule (may load target extension)\n"
-"  --match	-m match\n"
-"				extended match (may load extension)\n"
-"  --numeric	-n		numeric output of addresses and ports\n"
-"  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
-"  --line-numbers		print line numbers when listing\n"
-"  --exact	-x		expand numbers (display exact values)\n"
-"  --modprobe=<command>		try to insert modules using this command\n"
-"  --set-counters -c PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
-	printf(" opcode strings: \n");
-        for (i = 0; i < NUMOPCODES; i++)
-                printf(" %d = %s\n", i + 1, arp_opcodes[i]);
-        printf(
-" hardware type string: 1 = Ethernet\n"
-" protocol type string: 0x800 = IPv4\n");
-
-	/* Print out any special helps. A user might like to be able
-		to add a --help to the commandline, and see expected
-		results. So we call help for all matches & targets */
-	for (t = xtables_targets; t; t = t->next) {
-		if (strcmp(t->name, "CLASSIFY") && strcmp(t->name, "mangle"))
-			continue;
-		printf("\n");
-		t->help();
-	}
-}
-
 int nft_init_arp(struct nft_handle *h, const char *pname)
 {
 	arptables_globals.program_name = pname;
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c65c3fce5cfbe..41b6eb4838733 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -91,7 +91,6 @@ struct xtables_globals xtables_globals = {
 	.optstring = OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = nft_compatible_revision,
-	.print_help = xtables_printhelp,
 };
 
 /*
-- 
2.34.1

