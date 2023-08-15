Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAA0C001DE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 16:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbjHOQIg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbjHOQIX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 12:08:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA9C5
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2023 09:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4elCZOGVWT0DsddoC5zvxmnzT9f+c1GSCH0Wolh8+YA=; b=DmeEH0DwVP/3VDoV3L7u7GfBgL
        8f2/yhwVN7iYmXJfvWwEU/Pvu6DzFVmCRXigeDiaYIvn/SnaZePjiY9md0Bb5dYXJDsyefpctRbNO
        j/W2WFx7jNc8OEJ89YbPg8ys0mNX9KgCsaa2625M2R/8He1ebpqllt59HgicWvYMEb4apz8jGMFPl
        0lUR7pnQl/GIyTvidKZCgBfcS8PHmhi3pbJxOVDwxaPr5tZKrvBEXEGkZxhqlv6aypIzP+K8xHJKY
        02R5fFkPoqomrL5zhUZplKSWubVMYb2Qhm557XvfJAtE4jtw2UPVuOHuzWjSBR3JzBhbW7T4xhOaJ
        QiPBh1rQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qVwae-0006DR-IO; Tue, 15 Aug 2023 18:08:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH] Revert --compat option related commits
Date:   Tue, 15 Aug 2023 18:08:07 +0200
Message-Id: <20230815160807.4033-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts the following commits:

b14c971db6db0 ("tests: Test compat mode")
11c464ed015b5 ("Add --compat option to *tables-nft and *-nft-restore commands")
ca709b5784c98 ("nft: Introduce and use bool nft_handle::compat")
402b9b3c07c81 ("nft: Pass nft_handle to add_{target,action}()")

This implementation of a compatibility mode implements rules using
xtables extensions if possible and thus relies upon existence of those
in kernel space. Assuming no viable replacement for the internal
mechanics of this mode will be found in foreseeable future, it will
effectively block attempts at deprecating and removing of these xtables
extensions in favor of nftables expressions and thus hinder upstream's
future plans for iptables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py                              | 19 ++----
 iptables/arptables-nft-restore.8              | 15 ++---
 iptables/arptables-nft.8                      |  8 ---
 iptables/ebtables-nft.8                       |  6 --
 iptables/iptables-restore.8.in                | 11 +---
 iptables/iptables.8.in                        |  7 ---
 iptables/nft-arp.c                            |  2 +-
 iptables/nft-bridge.c                         |  9 ++-
 iptables/nft-ipv4.c                           |  2 +-
 iptables/nft-ipv6.c                           |  2 +-
 iptables/nft-shared.c                         |  2 +-
 iptables/nft.c                                | 19 +++---
 iptables/nft.h                                |  7 +--
 .../testcases/nft-only/0011-compat-mode_0     | 63 -------------------
 iptables/xshared.c                            |  7 +--
 iptables/xshared.h                            |  1 -
 iptables/xtables-arp.c                        |  1 -
 iptables/xtables-eb.c                         |  7 +--
 iptables/xtables-restore.c                    | 43 ++-----------
 iptables/xtables.c                            |  2 -
 20 files changed, 35 insertions(+), 198 deletions(-)
 delete mode 100755 iptables/tests/shell/testcases/nft-only/0011-compat-mode_0

diff --git a/iptables-test.py b/iptables-test.py
index 22b445df00b9c..6f63cdbeda9af 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -28,8 +28,6 @@ EBTABLES_SAVE = "ebtables-save"
 #IPTABLES_SAVE = ['xtables-save','-4']
 #IP6TABLES_SAVE = ['xtables-save','-6']
 
-COMPAT_ARG = ""
-
 EXTENSIONS_PATH = "extensions"
 LOGFILE="/tmp/iptables-test.log"
 log_file = None
@@ -85,7 +83,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     '''
     ret = 0
 
-    cmd = iptables + COMPAT_ARG + " -A " + rule
+    cmd = iptables + " -A " + rule
     ret = execute_cmd(cmd, filename, lineno, netns)
 
     #
@@ -320,7 +318,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     # load all rules via iptables_restore
 
-    command = EXECUTABLE + " " + iptables + "-restore" + COMPAT_ARG
+    command = EXECUTABLE + " " + iptables + "-restore"
     if netns:
         command = "ip netns exec " + netns + " " + command
 
@@ -560,8 +558,6 @@ STDERR_IS_TTY = sys.stderr.isatty()
                         help='Check for missing tests')
     parser.add_argument('-n', '--nftables', action='store_true',
                         help='Test iptables-over-nftables')
-    parser.add_argument('-c', '--nft-compat', action='store_true',
-                        help='Test iptables-over-nftables in compat mode')
     parser.add_argument('-N', '--netns', action='store_const',
                         const='____iptables-container-test',
                         help='Test netnamespace path')
@@ -581,10 +577,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
         variants.append("legacy")
     if args.nftables:
         variants.append("nft")
-    if args.nft_compat:
-        variants.append("nft_compat")
     if len(variants) == 0:
-        variants = [ "legacy", "nft", "nft_compat" ]
+        variants = [ "legacy", "nft" ]
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
@@ -604,12 +598,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     total_tests = 0
     for variant in variants:
         global EXECUTABLE
-        global COMPAT_ARG
-        if variant == "nft_compat":
-            EXECUTABLE = "xtables-nft-multi"
-            COMPAT_ARG = " --compat"
-        else:
-            EXECUTABLE = "xtables-" + variant + "-multi"
+        EXECUTABLE = "xtables-" + variant + "-multi"
 
         test_files = 0
         tests = 0
diff --git a/iptables/arptables-nft-restore.8 b/iptables/arptables-nft-restore.8
index 12ac9ebd5062d..09d9082cf9fd3 100644
--- a/iptables/arptables-nft-restore.8
+++ b/iptables/arptables-nft-restore.8
@@ -22,23 +22,18 @@
 .SH NAME
 arptables-restore \- Restore ARP Tables (nft-based)
 .SH SYNOPSIS
-.BR arptables\-restore " [" --compat ]
+\fBarptables\-restore
 .SH DESCRIPTION
+.PP
 .B arptables-restore
 is used to restore ARP Tables from data specified on STDIN or
 via a file as first argument.
-Use I/O redirection provided by your shell to read from a file.
-.P
+Use I/O redirection provided by your shell to read from a file
+.TP
 .B arptables-restore
 flushes (deletes) all previous contents of the respective ARP Table.
-.TP
-.BR -C , " --compat"
-Create rules in a mostly compatible way, enabling older versions of
-\fBarptables\-nft\fP to correctly parse the rules received from kernel. This
-mode is only useful in very specific situations and will likely impact packet
-filtering performance.
-
 .SH AUTHOR
 Jesper Dangaard Brouer <brouer@redhat.com>
 .SH SEE ALSO
 \fBarptables\-save\fP(8), \fBarptables\fP(8)
+.PP
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 673a7bd58e9cd..ea31e0842acd4 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -220,14 +220,6 @@ counters of a rule (during
 .B APPEND,
 .B REPLACE
 operations).
-.SS "OTHER OPTIONS"
-The following additional options can be specified:
-.TP
-\fB\-\-compat\fP
-Create rules in a mostly compatible way, enabling older versions of
-\fBarptables\-nft\fP to correctly parse the rules received from kernel. This
-mode is only useful in very specific situations and will likely impact packet
-filtering performance.
 
 .SS RULE-SPECIFICATIONS
 The following command line arguments make up a rule specification (as used 
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index baada6c67437f..0304b5088cd8c 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -359,12 +359,6 @@ to try to automatically load missing kernel modules.
 .TP
 .B --concurrent
 Use a file lock to support concurrent scripts updating the ebtables kernel tables.
-.TP
-.B --compat
-Create rules in a mostly compatible way, enabling older versions of
-\fBebtables\-nft\fP to correctly parse the rules received from kernel. This
-mode is only useful in very specific situations and will likely impact packet
-filtering performance.
 
 .SS
 RULE SPECIFICATIONS
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 383099929e3bd..aa816f794d6f3 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -23,11 +23,11 @@ iptables-restore \(em Restore IP Tables
 .P
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-cChntvV\fP] [\fB\-w\fP \fIseconds\fP]
+\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fIfile\fP]
 .P
-\fBip6tables\-restore\fP [\fB\-cChntvV\fP] [\fB\-w\fP \fIseconds\fP]
+\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fIfile\fP]
 .SH DESCRIPTION
@@ -74,13 +74,6 @@ determine the executable's path.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
-.TP
-\fB\-C\fP, \fB\-\-compat\fP
-This flag is only relevant with \fBnft\fP-variants and ignored otherwise. If
-set, rules will be created in a mostly compatible way, enabling older versions
-of \fBiptables\-nft\fP to correctly parse the rules received from kernel. This
-mode is only useful in very specific situations and will likely impact packet
-filtering performance.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index c0e92f27dc722..ecaa5553942df 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -397,13 +397,6 @@ corresponding to that rule's position in the chain.
 \fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
-.TP
-\fB\-\-compat\fP
-This flag is only relevant with \fBnft\fP-variants and ignored otherwise. If
-set, rules will be created in a mostly compatible way, enabling older versions
-of \fBiptables\-nft\fP to correctly parse the rules received from kernel. This
-mode is only useful in very specific situations and will likely impact packet
-filtering performance.
 
 .SH LOCK FILE
 iptables uses the \fI@XT_LOCK_NAME@\fP file to take an exclusive lock at
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 14b352cebf9d3..9868966a03688 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -151,7 +151,7 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			ret = add_verdict(r, NFT_RETURN);
 		else
-			ret = add_target(h, r, cs->target->t);
+			ret = add_target(r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* No goto in arptables */
 		ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 616ae5a3a2a3c..391a8ab723c1c 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -117,8 +117,7 @@ static int add_meta_broute(struct nftnl_rule *r)
 	return 0;
 }
 
-static int _add_action(struct nft_handle *h, struct nftnl_rule *r,
-		       struct iptables_command_state *cs)
+static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 {
 	const char *table = nftnl_rule_get_str(r, NFTNL_RULE_TABLE);
 
@@ -134,7 +133,7 @@ static int _add_action(struct nft_handle *h, struct nftnl_rule *r,
 		}
 	}
 
-	return add_action(h, r, cs, false);
+	return add_action(r, cs, false);
 }
 
 static int
@@ -222,7 +221,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 			if (nft_bridge_add_match(h, fw, ctx, r, iter->u.match->m))
 				break;
 		} else {
-			if (add_target(h, r, iter->u.watcher->t))
+			if (add_target(r, iter->u.watcher->t))
 				break;
 		}
 	}
@@ -230,7 +229,7 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return _add_action(h, r, cs);
+	return _add_action(r, cs);
 }
 
 static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 663052fc57f0a..2f10220edd509 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -95,7 +95,7 @@ static int nft_ipv4_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(h, r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
+	return add_action(r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
 }
 
 static bool nft_ipv4_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 8bc633df0e93a..d53f87c1d26e3 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -81,7 +81,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(h, r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
+	return add_action(r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
 }
 
 static bool nft_ipv6_is_same(const struct iptables_command_state *a,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 5e0ca00e7dd36..34ca9d16569d0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -198,7 +198,7 @@ void add_addr(struct nft_handle *h, struct nftnl_rule *r,
 
 	for (i = 0; i < len; i++) {
 		if (m[i] != 0xff) {
-			bitwise = h->compat || m[i] != 0;
+			bitwise = m[i] != 0;
 			break;
 		}
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 09ff9cf11e195..97fd4f49fdb4c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1476,12 +1476,10 @@ int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	case NFT_COMPAT_RULE_APPEND:
 	case NFT_COMPAT_RULE_INSERT:
 	case NFT_COMPAT_RULE_REPLACE:
-		if (!strcmp(m->u.user.name, "among"))
-			return add_nft_among(h, r, m);
-		else if (h->compat)
-			break;
-		else if (!strcmp(m->u.user.name, "limit"))
+		if (!strcmp(m->u.user.name, "limit"))
 			return add_nft_limit(r, m);
+		else if (!strcmp(m->u.user.name, "among"))
+			return add_nft_among(h, r, m);
 		else if (!strcmp(m->u.user.name, "udp"))
 			return add_nft_udp(h, r, m);
 		else if (!strcmp(m->u.user.name, "tcp"))
@@ -1540,13 +1538,12 @@ static int add_meta_nftrace(struct nftnl_rule *r)
 	return 0;
 }
 
-int add_target(struct nft_handle *h, struct nftnl_rule *r,
-	       struct xt_entry_target *t)
+int add_target(struct nftnl_rule *r, struct xt_entry_target *t)
 {
 	struct nftnl_expr *expr;
 	int ret;
 
-	if (!h->compat && strcmp(t->u.user.name, "TRACE") == 0)
+	if (strcmp(t->u.user.name, "TRACE") == 0)
 		return add_meta_nftrace(r);
 
 	expr = nftnl_expr_alloc("target");
@@ -1590,8 +1587,8 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 	return 0;
 }
 
-int add_action(struct nft_handle *h, struct nftnl_rule *r,
-	       struct iptables_command_state *cs, bool goto_set)
+int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
+	       bool goto_set)
 {
 	int ret = 0;
 
@@ -1607,7 +1604,7 @@ int add_action(struct nft_handle *h, struct nftnl_rule *r,
 		else if (strcmp(cs->jumpto, "NFLOG") == 0)
 			ret = add_log(r, cs);
 		else
-			ret = add_target(h, r, cs->target->t);
+			ret = add_target(r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
diff --git a/iptables/nft.h b/iptables/nft.h
index fb9fc81ea2704..5acbbf82e2c29 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -111,7 +111,6 @@ struct nft_handle {
 	struct list_head	cmd_list;
 	bool			cache_init;
 	int			verbose;
-	bool			compat;
 
 	/* meta data, for error reporting */
 	struct {
@@ -193,11 +192,9 @@ int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
 int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m);
-int add_target(struct nft_handle *h, struct nftnl_rule *r,
-	       struct xt_entry_target *t);
+int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
-int add_action(struct nft_handle *h, struct nftnl_rule *r,
-	       struct iptables_command_state *cs, bool goto_set);
+int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
 int add_log(struct nftnl_rule *r, struct iptables_command_state *cs);
 char *get_comment(const void *data, uint32_t data_len);
 
diff --git a/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0 b/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0
deleted file mode 100755
index c8cee8aef1b94..0000000000000
--- a/iptables/tests/shell/testcases/nft-only/0011-compat-mode_0
+++ /dev/null
@@ -1,63 +0,0 @@
-#!/bin/bash
-
-[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
-
-set -e
-
-# reduce noise in debug output
-$XT_MULTI iptables -t raw -A OUTPUT
-$XT_MULTI iptables -t raw -F
-
-# add all the things which were "optimized" here
-RULE='-t raw -A OUTPUT'
-
-# prefix matches on class (actually: byte) boundaries no longer need a bitwise
-RULE+=' -s 10.0.0.0/8 -d 192.168.0.0/16'
-
-# these were turned into native matches meanwhile
-# (plus -m tcp, but it conflicts with -m udp)
-RULE+=' -m limit --limit 1/min'
-RULE+=' -p udp -m udp --sport 1024:65535'
-RULE+=' -m mark --mark 0xfeedcafe/0xfeedcafe'
-RULE+=' -j TRACE'
-
-EXPECT_COMMON='TRACE  udp opt -- in * out *  10.0.0.0/8  -> 192.168.0.0/16   limit: avg 1/min burst 5 udp spts:1024:65535 mark match 0xfeedcafe/0xfeedcafe
-ip raw OUTPUT'
-
-EXPECT="$EXPECT_COMMON
-  [ payload load 1b @ network header + 12 => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 2b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0000a8c0 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ limit rate 1/minute burst 5 type packets flags 0x0 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ range eq reg 1 0x00000004 0x0000ffff ]
-  [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0xfeedcafe ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0xfeedcafe ]
-  [ counter pkts 0 bytes 0 ]
-  [ immediate reg 9 0x00000001 ]
-  [ meta set nftrace with reg 9 ]
-"
-
-diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables -vv $RULE)
-
-EXPECT="$EXPECT_COMMON
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x0000a8c0 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ match name limit rev 0 ]
-  [ match name udp rev 0 ]
-  [ match name mark rev 1 ]
-  [ counter pkts 0 bytes 0 ]
-  [ target name TRACE rev 0 ]
-"
-
-diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables --compat -vv $RULE)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 74b7a041516df..5f75a0a57a023 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1263,8 +1263,7 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 	printf(
 "  --modprobe=<command>		try to insert modules using this command\n"
 "  --set-counters -c PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version\n"
-"  --compat			create rules compatible for parsing with old binaries\n");
+"[!] --version	-V		print package version.\n");
 
 	if (afinfo->family == NFPROTO_ARP) {
 		int i;
@@ -1788,10 +1787,6 @@ void do_parse(int argc, char *argv[],
 
 			exit_tryhelp(2, p->line);
 
-		case 15: /* --compat */
-			p->compat = true;
-			break;
-
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index f69a7b432d33f..a200e0d620ad3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -283,7 +283,6 @@ struct xt_cmd_parse {
 	int				line;
 	int				verbose;
 	bool				xlate;
-	bool				compat;
 	struct xt_cmd_parse_ops		*ops;
 };
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index c6a9c6d68cb10..71518a9cbdb6a 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -78,7 +78,6 @@ static struct option original_opts[] = {
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
-	{ "compat", 0, 0, 15 },
 	{ 0 }
 };
 
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index ffd51efaaf0f0..08eec79d80400 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -223,7 +223,6 @@ struct option ebt_original_options[] =
 	{ "init-table"     , no_argument      , 0, 11  },
 	{ "concurrent"     , no_argument      , 0, 13  },
 	{ "check"          , required_argument, 0, 14  },
-	{ "compat"         , no_argument      , 0, 15  },
 	{ 0 }
 };
 
@@ -336,8 +335,7 @@ static void print_help(const struct xtables_target *t,
 "--modprobe -M program         : try to insert modules using this program\n"
 "--concurrent                  : use a file lock to support concurrent scripts\n"
 "--verbose -v                  : verbose mode\n"
-"--version -V                  : print package version\n"
-"--compat                      : create rules compatible for parsing with old binaries\n\n"
+"--version -V                  : print package version\n\n"
 "Environment variable:\n"
 /*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
 "\n\n");
@@ -1099,9 +1097,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			return 1;
 		case 13 :
 			break;
-		case 15:
-			h->compat = true;
-			break;
 		case 1 :
 			if (!strcmp(optarg, "!"))
 				ebt_check_inverse2(optarg, argc, argv);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index bd8c6bc15549f..23cd349819f4f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -26,7 +26,6 @@ static int counters, verbose;
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
-	{.name = "compat",   .has_arg = false, .val = 'C'},
 	{.name = "verbose",  .has_arg = false, .val = 'v'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "test",     .has_arg = false, .val = 't'},
@@ -46,9 +45,8 @@ static const struct option options[] = {
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-C] [-v] [-V] [-t] [-h] [-n] [-T table] [-M command] [-4] [-6] [file]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-V] [-t] [-h] [-n] [-T table] [-M command] [-4] [-6] [file]\n"
 			"	   [ --counters ]\n"
-			"	   [ --compat ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --version]\n"
 			"	   [ --test ]\n"
@@ -291,7 +289,6 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		.cb = &restore_cb,
 	};
 	bool noflush = false;
-	bool compat = false;
 	struct nft_handle h;
 	int c;
 
@@ -306,7 +303,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcCvVthnM:T:wW", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvVthnM:T:wW", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -314,9 +311,6 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			case 'c':
 				counters = 1;
 				break;
-			case 'C':
-				compat = true;
-				break;
 			case 'v':
 				verbose++;
 				break;
@@ -393,7 +387,6 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	}
 	h.noflush = noflush;
 	h.restore = true;
-	h.compat = compat;
 
 	xtables_restore_parse(&h, &p);
 
@@ -424,7 +417,6 @@ static const struct nft_xt_restore_cb ebt_restore_cb = {
 };
 
 static const struct option ebt_restore_options[] = {
-	{.name = "compat",  .has_arg = 0, .val = 'C'},
 	{.name = "noflush", .has_arg = 0, .val = 'n'},
 	{.name = "verbose", .has_arg = 0, .val = 'v'},
 	{ 0 }
@@ -437,16 +429,12 @@ int xtables_eb_restore_main(int argc, char *argv[])
 		.cb = &ebt_restore_cb,
 	};
 	bool noflush = false;
-	bool compat = false;
 	struct nft_handle h;
 	int c;
 
-	while ((c = getopt_long(argc, argv, "Cnv",
+	while ((c = getopt_long(argc, argv, "nv",
 				ebt_restore_options, NULL)) != -1) {
 		switch(c) {
-		case 'C':
-			compat = true;
-			break;
 		case 'n':
 			noflush = 1;
 			break;
@@ -455,7 +443,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 			break;
 		default:
 			fprintf(stderr,
-				"Usage: ebtables-restore [ --compat ] [ --verbose ] [ --noflush ]\n");
+				"Usage: ebtables-restore [ --verbose ] [ --noflush ]\n");
 			exit(1);
 			break;
 		}
@@ -463,7 +451,6 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
-	h.compat = compat;
 	xtables_restore_parse(&h, &p);
 	nft_fini_eb(&h);
 
@@ -478,37 +465,15 @@ static const struct nft_xt_restore_cb arp_restore_cb = {
 	.chain_restore  = nft_cmd_chain_restore,
 };
 
-static const struct option arp_restore_options[] = {
-	{.name = "compat",  .has_arg = 0, .val = 'C'},
-	{ 0 }
-};
-
 int xtables_arp_restore_main(int argc, char *argv[])
 {
 	struct nft_xt_restore_parse p = {
 		.in = stdin,
 		.cb = &arp_restore_cb,
 	};
-	bool compat = false;
 	struct nft_handle h;
-	int c;
-
-	while ((c = getopt_long(argc, argv, "C",
-				arp_restore_options, NULL)) != -1) {
-		switch(c) {
-		case 'C':
-			compat = true;
-			break;
-		default:
-			fprintf(stderr,
-				"Usage: arptables-restore [ --compat ]\n");
-			exit(1);
-			break;
-		}
-	}
 
 	nft_init_arp(&h, "arptables-restore");
-	h.compat = compat;
 	xtables_restore_parse(&h, &p);
 	nft_fini(&h);
 	xtables_fini();
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 25b4dbc6b8475..22d6ea58376fc 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -82,7 +82,6 @@ static struct option original_opts[] = {
 	{.name = "goto",	  .has_arg = 1, .val = 'g'},
 	{.name = "ipv4",	  .has_arg = 0, .val = '4'},
 	{.name = "ipv6",	  .has_arg = 0, .val = '6'},
-	{.name = "compat",        .has_arg = 0, .val = 15 },
 	{NULL},
 };
 
@@ -162,7 +161,6 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	do_parse(argc, argv, &p, &cs, &args);
 	h->verbose = p.verbose;
-	h->compat = p.compat;
 
 	if (!nft_table_builtin_find(h, p.table))
 		xtables_error(VERSION_PROBLEM,
-- 
2.40.0

