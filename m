Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CBAECE58D
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A3121721
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfJIJyk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:54:40 -0400
Received: from correo.us.es ([193.147.175.20]:48766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfJIJyj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 05:54:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4631F118456
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:54:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37D98FB362
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:54:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3709752577; Wed,  9 Oct 2019 11:54:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26A4A3C63E
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:54:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Oct 2019 11:54:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 11E3A42EE38E
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:54:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: always close interval in non-anonymous sets
Date:   Wed,  9 Oct 2019 11:54:32 +0200
Message-Id: <20191009095432.11757-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip this optimization for non-anonymous sets, otherwise, element
deletion breaks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                      |  3 +-
 .../shell/testcases/maps/0008interval_map_delete_0 | 32 ++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/maps/0008interval_map_delete_0

diff --git a/src/segtree.c b/src/segtree.c
index eff0653a8dfb..5d6ecd4fcab1 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -496,7 +496,8 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 			 * (prev_right, ei_left).
 			 */
 			mpz_add_ui(p, prev->right, 1);
-			if (mpz_cmp(p, ei->left) < 0) {
+			if (mpz_cmp(p, ei->left) < 0 ||
+			    !(set->flags & NFT_SET_ANONYMOUS)) {
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
 				list_add_tail(&nei->list, list);
diff --git a/tests/shell/testcases/maps/0008interval_map_delete_0 b/tests/shell/testcases/maps/0008interval_map_delete_0
new file mode 100755
index 000000000000..a43fd28019f7
--- /dev/null
+++ b/tests/shell/testcases/maps/0008interval_map_delete_0
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip filter {
+	map m {
+		type ipv4_addr : mark
+		flags interval
+		elements = { 127.0.0.2 : 0x00000002, 127.0.0.3 : 0x00000003 }
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		meta mark set ip daddr map @m
+		meta mark 0x00000002 counter accept
+		meta mark 0x00000003 counter accept
+		counter
+	}
+}"
+
+$NFT -f - <<< "$EXPECTED"
+$NFT delete element filter m { 127.0.0.2 }
+$NFT delete element filter m { 127.0.0.3 }
+$NFT add element filter m { 127.0.0.3 : 0x3 }
+$NFT add element filter m { 127.0.0.2 : 0x2 }
+
+GET=$($NFT list ruleset -s)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

