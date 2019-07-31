Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB622C32751
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 11:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CCFE206A3
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 11:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfGaLf0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:35:26 -0400
Received: from correo.us.es ([193.147.175.20]:53032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfGaLfZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 07:35:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 17EE681403
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 13:35:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 081EF115101
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 13:35:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F1ECFDA704; Wed, 31 Jul 2019 13:35:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0B3FDA708;
        Wed, 31 Jul 2019 13:35:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 13:35:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BE93E4265A2F;
        Wed, 31 Jul 2019 13:35:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com
Subject: [PATCH nft,v2] cache: incorrect flush flag for table/chain
Date:   Wed, 31 Jul 2019 13:35:14 +0200
Message-Id: <20190731113514.26396-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laura Garcia Liebana <nevola@gmail.com>

After the new cache system, nft raises a table error flushing a chain in
a transaction.

 # nft "flush chain ip nftlb filter-newfarm ; \
    add rule ip nftlb filter-newfarm update \
    @persist-newfarm {  ip saddr : ct mark } ; \
    flush chain ip nftlb nat-newfarm"
 Error: No such file or directory
 flush chain ip nftlb filter-newfarm ; add rule ip nftlb (...)
                                                   ^^^^^

This patch sets the cache flag properly to save this case.

Fixes: 01e5c6f0ed031 ("src: add cache level flags")
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: original patch v1 is: "src: fix flush chain cache flag"
    do force empty cache when flushing specific table/chain

 src/cache.c                                        |  1 -
 tests/shell/testcases/cache/0005_cache_chain_flush | 16 ++++++++++++++++
 tests/shell/testcases/cache/0006_cache_table_flush | 16 ++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/cache/0005_cache_chain_flush
 create mode 100755 tests/shell/testcases/cache/0006_cache_table_flush

diff --git a/src/cache.c b/src/cache.c
index 0d38034e853f..cffcbb623ced 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -75,7 +75,6 @@ static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 		flags |= NFT_CACHE_FLUSHED;
 		break;
 	default:
-		flags = NFT_CACHE_EMPTY;
 		break;
 	}
 
diff --git a/tests/shell/testcases/cache/0005_cache_chain_flush b/tests/shell/testcases/cache/0005_cache_chain_flush
new file mode 100755
index 000000000000..7dfe5c1cbf20
--- /dev/null
+++ b/tests/shell/testcases/cache/0005_cache_chain_flush
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+RULESET="add table ip x
+add chain x y
+add chain x z
+add map ip x mapping { type ipv4_addr : inet_service; flags dynamic,timeout; }
+add rule x y counter
+add rule x z counter"
+
+$NFT -f - <<< "$RULESET" 2>&1
+
+RULESET="flush chain x y; add rule x y update @mapping { ip saddr : tcp sport }; flush chain x z"
+
+$NFT "$RULESET" 2>&1
diff --git a/tests/shell/testcases/cache/0006_cache_table_flush b/tests/shell/testcases/cache/0006_cache_table_flush
new file mode 100755
index 000000000000..fa4da97a7da8
--- /dev/null
+++ b/tests/shell/testcases/cache/0006_cache_table_flush
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+RULESET="add table ip x
+add chain x y
+add chain x z
+add map ip x mapping { type ipv4_addr : inet_service; flags dynamic,timeout; }
+add rule x y counter
+add rule x z counter"
+
+$NFT -f - <<< "$RULESET" 2>&1
+
+RULESET="flush table x; add rule x y update @mapping { ip saddr : tcp sport }; flush chain x z"
+
+$NFT "$RULESET" 2>&1
-- 
2.11.0

