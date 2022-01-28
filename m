Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D88BC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jan 2022 20:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiA1UhL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 15:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiA1UhL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 15:37:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE8C061714
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jan 2022 12:37:11 -0800 (PST)
Received: from localhost ([::1]:59154 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nDXzX-000123-Fp; Fri, 28 Jan 2022 21:37:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] iptables-restore: Support for extra debug output
Date:   Fri, 28 Jan 2022 21:37:00 +0100
Message-Id: <20220128203700.27071-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203700.27071-1-phil@nwl.cc>
References: <20220128203700.27071-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Treat --verbose just like iptables itself, increasing debug level with
number of invocations.

To propagate the level into do_command() callback, insert virtual '-v'
flags into rule lines.

The only downside of this is that simple verbose output is changed and
now also prints the rules as they are added - which would be useful if
the lines contained the chain they apply to.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in                           | 1 +
 iptables/iptables-restore.c                              | 6 +++++-
 .../shell/testcases/ipt-restore/0014-verbose-restore_0   | 9 ++++++---
 iptables/xtables-restore.c                               | 6 +++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index b4b62f92740d1..883da998b0f7e 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -54,6 +54,7 @@ Only parse and construct the ruleset, but do not commit it.
 .TP
 \fB\-v\fP, \fB\-\-verbose\fP
 Print additional debug info during ruleset processing.
+Specify multiple times to increase debug level.
 .TP
 \fB\-V\fP, \fB\-\-version\fP
 Print the program version number.
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index a3efb067d3d90..3c0a238917ecd 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -114,7 +114,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 				counters = 1;
 				break;
 			case 'v':
-				verbose = 1;
+				verbose++;
 				break;
 			case 'V':
 				printf("%s v%s\n",
@@ -317,11 +317,15 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			char *pcnt = NULL;
 			char *bcnt = NULL;
 			char *parsestart = buffer;
+			int i;
 
 			add_argv(&av_store, argv[0], 0);
 			add_argv(&av_store, "-t", 0);
 			add_argv(&av_store, curtable, 0);
 
+			for (i = 0; !noflush && i < verbose; i++)
+				add_argv(&av_store, "-v", 0);
+
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
 				add_argv(&av_store, "--set-counters", 0);
diff --git a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0 b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
index fc8559c5bac9e..5daf7a78a5334 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0014-verbose-restore_0
@@ -33,6 +33,7 @@ Flushing chain \`bar'
 Flushing chain \`foo'
 Deleting chain \`bar'
 Deleting chain \`foo'
+ACCEPT  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0
 Flushing chain \`PREROUTING'
 Flushing chain \`INPUT'
 Flushing chain \`OUTPUT'
@@ -41,6 +42,7 @@ Flushing chain \`natbar'
 Flushing chain \`natfoo'
 Deleting chain \`natbar'
 Deleting chain \`natfoo'
+ACCEPT  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0
 Flushing chain \`PREROUTING'
 Flushing chain \`OUTPUT'
 Flushing chain \`rawfoo'
@@ -58,9 +60,10 @@ Flushing chain \`OUTPUT'
 Flushing chain \`secfoo'
 Deleting chain \`secfoo'"
 
-for ipt in iptables-restore ip6tables-restore; do
-	diff -u -Z <(echo "$EXPECT") <($XT_MULTI $ipt -v <<< "$DUMP")
-done
+EXPECT6=$(sed -e 's/0\.0\.0\.0/::/g' -e 's/opt --/opt   /' <<< "$EXPECT")
+
+diff -u -Z <(echo "$EXPECT") <($XT_MULTI iptables-restore -v <<< "$DUMP")
+diff -u -Z <(echo "$EXPECT6") <($XT_MULTI ip6tables-restore -v <<< "$DUMP")
 
 DUMP="*filter
 :baz - [0:0]
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 8ca2abffa5d36..f5aabf3cc1944 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -206,11 +206,15 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		char *pcnt = NULL;
 		char *bcnt = NULL;
 		char *parsestart = buffer;
+		int i;
 
 		add_argv(&state->av_store, xt_params->program_name, 0);
 		add_argv(&state->av_store, "-t", 0);
 		add_argv(&state->av_store, state->curtable->name, 0);
 
+		for (i = 0; !h->noflush && i < verbose; i++)
+			add_argv(&state->av_store, "-v", 0);
+
 		tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 		if (counters && pcnt && bcnt) {
 			add_argv(&state->av_store, "--set-counters", 0);
@@ -309,7 +313,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				counters = 1;
 				break;
 			case 'v':
-				verbose = 1;
+				verbose++;
 				break;
 			case 'V':
 				printf("%s v%s\n", prog_name, prog_vers);
-- 
2.34.1

