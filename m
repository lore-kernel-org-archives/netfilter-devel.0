Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E167C76194
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D98AD217D6
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfGVKRQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 06:17:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45486 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfGVKRP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 06:17:15 -0400
Received: from localhost ([::1]:58576 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpVNa-0000e4-Cj; Mon, 22 Jul 2019 12:17:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 03/11] xtables-save: Unify *-save header/footer comments
Date:   Mon, 22 Jul 2019 12:16:20 +0200
Message-Id: <20190722101628.21195-4-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722101628.21195-1-phil@nwl.cc>
References: <20190722101628.21195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make eb- and arptables-save print both header and footer comments, too.
Also print them for each table separately - the timing information is
worth the extra lines in output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../arptables/0001-arptables-save-restore_0   |  7 +++----
 .../0002-arptables-restore-defaults_0         |  6 ++----
 .../arptables/0003-arptables-verbose-output_0 |  5 ++---
 .../ebtables/0002-ebtables-save-restore_0     |  4 +---
 .../ebtables/0003-ebtables-restore-defaults_0 |  6 ++----
 .../testcases/ebtables/0004-save-counters_0   |  9 +++------
 iptables/xtables-save.c                       | 19 ++++++++++---------
 7 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/iptables/tests/shell/testcases/arptables/0001-arptables-save-restore_0 b/iptables/tests/shell/testcases/arptables/0001-arptables-save-restore_0
index e10f61cc8f95b..bf04dc0a3e15a 100755
--- a/iptables/tests/shell/testcases/arptables/0001-arptables-save-restore_0
+++ b/iptables/tests/shell/testcases/arptables/0001-arptables-save-restore_0
@@ -50,13 +50,12 @@ DUMP='*filter
 -A foo -j MARK --set-mark 12345
 -A foo -j ACCEPT --opcode 1
 -A foo -j ACCEPT --proto-type 0x800
--A foo -j ACCEPT -i lo --opcode 1 --proto-type 0x800
-'
+-A foo -j ACCEPT -i lo --opcode 1 --proto-type 0x800'
 
-diff -u <(echo -e "$DUMP") <($XT_MULTI arptables-save)
+diff -u <(echo -e "$DUMP") <($XT_MULTI arptables-save | grep -v "^#")
 
 # make sure dump can be restored and check it didn't change
 
 $XT_MULTI arptables -F
 $XT_MULTI arptables-restore <<<$DUMP
-diff -u <(echo -e "$DUMP") <($XT_MULTI arptables-save)
+diff -u <(echo -e "$DUMP") <($XT_MULTI arptables-save | grep -v "^#")
diff --git a/iptables/tests/shell/testcases/arptables/0002-arptables-restore-defaults_0 b/iptables/tests/shell/testcases/arptables/0002-arptables-restore-defaults_0
index b2ed95e87bb40..38d387f327ebb 100755
--- a/iptables/tests/shell/testcases/arptables/0002-arptables-restore-defaults_0
+++ b/iptables/tests/shell/testcases/arptables/0002-arptables-restore-defaults_0
@@ -11,8 +11,7 @@ set -e
 DUMP='*filter
 :OUTPUT ACCEPT
 -A OUTPUT -j mangle --mangle-ip-s 10.0.0.1
--A OUTPUT -j mangle --mangle-ip-d 10.0.0.2
-'
+-A OUTPUT -j mangle --mangle-ip-d 10.0.0.2'
 
 # note how mangle-ip-s is unset in second rule
 
@@ -20,8 +19,7 @@ EXPECT='*filter
 :INPUT ACCEPT
 :OUTPUT ACCEPT
 -A OUTPUT -j mangle --mangle-ip-s 10.0.0.1
--A OUTPUT -j mangle --mangle-ip-d 10.0.0.2
-'
+-A OUTPUT -j mangle --mangle-ip-d 10.0.0.2'
 
 $XT_MULTI arptables -F
 $XT_MULTI arptables-restore <<<$DUMP
diff --git a/iptables/tests/shell/testcases/arptables/0003-arptables-verbose-output_0 b/iptables/tests/shell/testcases/arptables/0003-arptables-verbose-output_0
index 3a9807a1cfe0b..10c5ec33ada2c 100755
--- a/iptables/tests/shell/testcases/arptables/0003-arptables-verbose-output_0
+++ b/iptables/tests/shell/testcases/arptables/0003-arptables-verbose-output_0
@@ -58,7 +58,6 @@ EXPECT='*filter
 -A INPUT -j MARK -i eth23 --set-mark 42
 -A OUTPUT -j CLASSIFY -o eth23 --set-class 23:42
 -A OUTPUT -j foo -o eth23
--A foo -j mangle -o eth23 --mangle-ip-s 10.0.0.1
-'
+-A foo -j mangle -o eth23 --mangle-ip-s 10.0.0.1'
 
-diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI arptables-save)
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI arptables-save | grep -v '^#')
diff --git a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0 b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
index 080ba49a4974d..e18d46551509d 100755
--- a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
+++ b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
@@ -99,7 +99,6 @@ DUMP='*filter
 -A foo --802_3-sap 0x23 --limit 100/sec --limit-burst 5 -j ACCEPT
 -A foo --pkttype-type multicast --log-level notice --log-prefix "" -j CONTINUE
 -A foo --pkttype-type multicast --limit 100/sec --limit-burst 5 -j ACCEPT
-
 *nat
 :PREROUTING ACCEPT
 :OUTPUT DROP
@@ -107,8 +106,7 @@ DUMP='*filter
 :nat_foo DROP
 -A PREROUTING -j redirect 
 -A OUTPUT -j ACCEPT
--A POSTROUTING -j ACCEPT
-'
+-A POSTROUTING -j ACCEPT'
 
 diff -u <(echo -e "$DUMP") <($XT_MULTI ebtables-save | grep -v '^#')
 
diff --git a/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0 b/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
index c858054764d70..62d224134456b 100755
--- a/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
+++ b/iptables/tests/shell/testcases/ebtables/0003-ebtables-restore-defaults_0
@@ -13,8 +13,7 @@ DUMP='*filter
 -A FORWARD --limit 100 --limit-burst 42 -j ACCEPT
 -A FORWARD --limit 1000 -j ACCEPT
 -A FORWARD --log --log-prefix "foobar"
--A FORWARD --log
-'
+-A FORWARD --log'
 
 # note how limit-burst is 5 in second rule and log-prefix empty in fourth one
 
@@ -25,8 +24,7 @@ EXPECT='*filter
 -A FORWARD --limit 100/sec --limit-burst 42 -j ACCEPT
 -A FORWARD --limit 1000/sec --limit-burst 5 -j ACCEPT
 -A FORWARD --log-level notice --log-prefix "foobar" -j CONTINUE
--A FORWARD --log-level notice --log-prefix "" -j CONTINUE
-'
+-A FORWARD --log-level notice --log-prefix "" -j CONTINUE'
 
 $XT_MULTI ebtables --init-table
 $XT_MULTI ebtables-restore <<<$DUMP
diff --git a/iptables/tests/shell/testcases/ebtables/0004-save-counters_0 b/iptables/tests/shell/testcases/ebtables/0004-save-counters_0
index 8348dc7ee231f..46966f433139a 100755
--- a/iptables/tests/shell/testcases/ebtables/0004-save-counters_0
+++ b/iptables/tests/shell/testcases/ebtables/0004-save-counters_0
@@ -32,8 +32,7 @@ EXPECT='*filter
 :FORWARD ACCEPT
 :OUTPUT ACCEPT
 -A FORWARD -i nodev123 -o nodev432 -j ACCEPT
--A FORWARD -i nodev432 -o nodev123 -j ACCEPT
-'
+-A FORWARD -i nodev432 -o nodev123 -j ACCEPT'
 
 echo "ebtables-save"
 diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save | grep -v '^#')
@@ -43,8 +42,7 @@ EXPECT='*filter
 :FORWARD ACCEPT
 :OUTPUT ACCEPT
 [0:0] -A FORWARD -i nodev123 -o nodev432 -j ACCEPT
-[0:0] -A FORWARD -i nodev432 -o nodev123 -j ACCEPT
-'
+[0:0] -A FORWARD -i nodev432 -o nodev123 -j ACCEPT'
 
 echo "ebtables-save -c"
 diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save -c | grep -v '^#')
@@ -60,8 +58,7 @@ EXPECT='*filter
 :FORWARD ACCEPT
 :OUTPUT ACCEPT
 -A FORWARD -i nodev123 -o nodev432 -j ACCEPT -c 0 0
--A FORWARD -i nodev432 -o nodev123 -j ACCEPT -c 0 0
-'
+-A FORWARD -i nodev432 -o nodev123 -j ACCEPT -c 0 0'
 
 echo "EBTABLES_SAVE_COUNTER=yes ebtables-save"
 diff -u <(echo -e "$EXPECT") <($XT_MULTI ebtables-save | grep -v '^#')
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 491122f39bbb0..0cf11f998cc77 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -250,7 +250,6 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 {
 	struct nftnl_chain_list *chain_list;
 	unsigned int format = FMT_NOCOUNTS;
-	static bool first = true;
 	time_t now;
 
 	if (!nft_table_find(h, tablename)) {
@@ -265,12 +264,9 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 
 	chain_list = nft_chain_list_get(h, tablename);
 
-	if (first) {
-		now = time(NULL);
-		printf("# Generated by %s v%s on %s", prog_name,
-		       prog_vers, ctime(&now));
-		first = false;
-	}
+	now = time(NULL);
+	printf("# Generated by %s v%s on %s", prog_name,
+	       prog_vers, ctime(&now));
 	printf("*%s\n", tablename);
 
 	if (counters)
@@ -281,7 +277,8 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 	 * thereby preventing dependency conflicts */
 	nft_chain_save(h, chain_list);
 	nft_rule_save(h, tablename, format);
-	printf("\n");
+	now = time(NULL);
+	printf("# Completed on %s", ctime(&now));
 	return 0;
 }
 
@@ -361,6 +358,7 @@ int xtables_arp_save_main(int argc, char **argv)
 	struct nft_handle h = {
 		.family	= NFPROTO_ARP,
 	};
+	time_t now;
 	int c;
 
 	xtables_globals.program_name = basename(*argv);;
@@ -407,10 +405,13 @@ int xtables_arp_save_main(int argc, char **argv)
 		return 0;
 	}
 
+	printf("# Generated by %s v%s on %s", prog_name,
+	       prog_vers, ctime(&now));
 	printf("*filter\n");
 	nft_chain_save(&h, nft_chain_list_get(&h, "filter"));
 	nft_rule_save(&h, "filter", show_counters ? 0 : FMT_NOCOUNTS);
-	printf("\n");
+	now = time(NULL);
+	printf("# Completed on %s", ctime(&now));
 	nft_fini(&h);
 	return 0;
 }
-- 
2.22.0

