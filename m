Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF523C76195
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87BF62085A
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 16:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfGTQb3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 12:31:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40934 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfGTQb3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 12:31:29 -0400
Received: from localhost ([::1]:54024 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hosGd-0005V5-Vb; Sat, 20 Jul 2019 18:31:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/12] ebtables-save: Fix counter formatting
Date:   Sat, 20 Jul 2019 18:30:16 +0200
Message-Id: <20190720163026.15410-3-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720163026.15410-1-phil@nwl.cc>
References: <20190720163026.15410-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The initial problem was 'ebtables-save -c' printing iptables-style
counters but at the same time not disabling ebtables-style counter
output (which was even printed in wrong format for ebtables-save).

The code around counter output was complicated enough to motivate a
larger rework:

* Make FMT_C_COUNTS indicate the appended counter style for ebtables.

* Use FMT_EBT_SAVE to distinguish between '-c' style counters and the
  legacy pcnt/bcnt ones.

Consequently, ebtables-save sets format to:

FMT_NOCOUNTS			- for no counters
FMT_EBT_SAVE			- for iptables-style counters
FMT_EBT_SAVE | FMT_C_COUNTS	- for '-c' style counters

For regular ebtables, list_rules() always sets FMT_C_COUNTS
(iptables-style counters are never used there) and FMT_NOCOUNTS if no
counters are requested.

The big plus is if neither FMT_NOCOUNTS nor FMT_C_COUNTS is set,
iptables-style counters are to be printed - both in iptables and
ebtables. This allows to drop the ebtables-specific 'save_counters'
callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c                         | 39 +++--------
 .../testcases/ebtables/0004-save-counters_0   | 67 +++++++++++++++++++
 iptables/xtables-eb.c                         |  2 +-
 iptables/xtables-save.c                       |  3 +-
 4 files changed, 81 insertions(+), 30 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0004-save-counters_0

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index ddfbee165da93..2e4b309b86135 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -21,8 +21,6 @@
 #include "nft-bridge.h"
 #include "nft.h"
 
-static bool ebt_legacy_counter_fmt;
-
 void ebt_cs_clean(struct iptables_command_state *cs)
 {
 	struct ebt_match *m, *nm;
@@ -422,22 +420,6 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 		printf("%s ", ent->e_name);
 }
 
-static void nft_bridge_save_counters(const void *data)
-{
-	const char *ctr;
-
-	if (ebt_legacy_counter_fmt)
-		return;
-
-	ctr = getenv("EBTABLES_SAVE_COUNTER");
-	if (ctr) {
-		ebt_legacy_counter_fmt = true;
-		return;
-	}
-
-	save_counters(data);
-}
-
 static void nft_bridge_save_rule(const void *data, unsigned int format)
 {
 	const struct iptables_command_state *cs = data;
@@ -474,15 +456,16 @@ static void nft_bridge_save_rule(const void *data, unsigned int format)
 		cs->target->print(&cs->fw, cs->target->t, format & FMT_NUMERIC);
 	}
 
-	if (format & FMT_EBT_SAVE)
-		printf(" -c %"PRIu64" %"PRIu64"",
-		       (uint64_t)cs->counters.pcnt,
-		       (uint64_t)cs->counters.bcnt);
-
-	if (!(format & FMT_NOCOUNTS))
-		printf(" , pcnt = %"PRIu64" -- bcnt = %"PRIu64"",
-		       (uint64_t)cs->counters.pcnt,
-		       (uint64_t)cs->counters.bcnt);
+	if ((format & (FMT_NOCOUNTS | FMT_C_COUNTS)) == FMT_C_COUNTS) {
+		if (format & FMT_EBT_SAVE)
+			printf(" -c %"PRIu64" %"PRIu64"",
+			       (uint64_t)cs->counters.pcnt,
+			       (uint64_t)cs->counters.bcnt);
+		else
+			printf(" , pcnt = %"PRIu64" -- bcnt = %"PRIu64"",
+			       (uint64_t)cs->counters.pcnt,
+			       (uint64_t)cs->counters.bcnt);
+	}
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
@@ -763,7 +746,7 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.print_header		= nft_bridge_print_header,
 	.print_rule		= nft_bridge_print_rule,
 	.save_rule		= nft_bridge_save_rule,
-	.save_counters		= nft_bridge_save_counters,
+	.save_counters		= save_counters,
 	.save_chain		= nft_bridge_save_chain,
 	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_ebtables_command_state,
diff --git a/iptables/tests/shell/testcases/ebtables/0004-save-counters_0 b/iptables/tests/shell/testcases/ebtables/0004-save-counters_0
new file mode 100755
index 0000000000000..8348dc7ee231f
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0004-save-counters_0
@@ -0,0 +1,67 @@
+#!/bin/bash
+
+set -e
+
+# there is no legacy backend to test
+[[ $XT_MULTI == */xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+$XT_MULTI ebtables --init-table
+$XT_MULTI ebtables -A FORWARD -i nodev123 -o nodev432 -j ACCEPT
+$XT_MULTI ebtables -A FORWARD -i nodev432 -o nodev123 -j ACCEPT
+
+EXPECT='Bridge table: filter
+
+Bridge chain: FORWARD, entries: 2, policy: ACCEPT
+-i nodev123 -o nodev432 -j ACCEPT
+-i nodev432 -o nodev123 -j ACCEPT'
+
+echo "ebtables -L FORWARD"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -L FORWARD)
+
+EXPECT='Bridge table: filter
+
+Bridge chain: FORWARD, entries: 2, policy: ACCEPT
+-i nodev123 -o nodev432 -j ACCEPT , pcnt = 0 -- bcnt = 0
+-i nodev432 -o nodev123 -j ACCEPT , pcnt = 0 -- bcnt = 0'
+
+echo "ebtables -L FORWARD --Lc"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables -L FORWARD --Lc)
+
+EXPECT='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+-A FORWARD -i nodev123 -o nodev432 -j ACCEPT
+-A FORWARD -i nodev432 -o nodev123 -j ACCEPT
+'
+
+echo "ebtables-save"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save | grep -v '^#')
+
+EXPECT='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+[0:0] -A FORWARD -i nodev123 -o nodev432 -j ACCEPT
+[0:0] -A FORWARD -i nodev432 -o nodev123 -j ACCEPT
+'
+
+echo "ebtables-save -c"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save -c | grep -v '^#')
+
+export EBTABLES_SAVE_COUNTER=yes
+
+# -c flag overrides EBTABLES_SAVE_COUNTER variable
+echo "EBTABLES_SAVE_COUNTER=yes ebtables-save -c"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save -c | grep -v '^#')
+
+EXPECT='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+-A FORWARD -i nodev123 -o nodev432 -j ACCEPT -c 0 0
+-A FORWARD -i nodev432 -o nodev123 -j ACCEPT -c 0 0
+'
+
+echo "EBTABLES_SAVE_COUNTER=yes ebtables-save"
+diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save | grep -v '^#')
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b8d89ad974a42..121ecbecd0b64 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -410,7 +410,7 @@ static int list_rules(struct nft_handle *h, const char *chain, const char *table
 {
 	unsigned int format;
 
-	format = FMT_OPTIONS;
+	format = FMT_OPTIONS | FMT_C_COUNTS;
 	if (verbose)
 		format |= FMT_VIA;
 
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 98e004af4b1a4..3f389e8fdc234 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -273,7 +273,8 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 	printf("*%s\n", tablename);
 
 	if (counters)
-		format = ebt_legacy_counter_format ? FMT_EBT_SAVE : 0;
+		format = FMT_EBT_SAVE |
+			(ebt_legacy_counter_format ? FMT_C_COUNTS : 0);
 
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
-- 
2.22.0

