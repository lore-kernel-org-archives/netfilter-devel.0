Return-Path: <SRS0=xhJ7=B3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5011AC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Aug 2020 11:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36FE02067C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Aug 2020 11:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHQLEv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Aug 2020 07:04:51 -0400
Received: from correo.us.es ([193.147.175.20]:54002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgHQLEu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Aug 2020 07:04:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DEABBE8621
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2020 13:04:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2FBDDA704
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2020 13:04:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8B92DA73D; Mon, 17 Aug 2020 13:04:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EC85DA704
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2020 13:04:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Aug 2020 13:04:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7C07441E4800
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2020 13:04:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add comment support for map too
Date:   Mon, 17 Aug 2020 13:04:30 +0200
Message-Id: <20200817110430.29644-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend and slightly rework tests/shell to cover this case too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                                      | 5 +++++
 tests/shell/testcases/sets/0054comments_set_0           | 8 +++-----
 tests/shell/testcases/sets/dumps/0054comments_set_0.nft | 6 ++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7e094ff60eac..d4e994175fea 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1896,6 +1896,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
+			|	map_block	comment_spec	stmt_separator
+			{
+				$1->comment = $2;
+				$$ = $1;
+			}
 			|	map_block	set_mechanism	stmt_separator
 			;
 
diff --git a/tests/shell/testcases/sets/0054comments_set_0 b/tests/shell/testcases/sets/0054comments_set_0
index 93a73f0d2fa2..9c8f7875fc83 100755
--- a/tests/shell/testcases/sets/0054comments_set_0
+++ b/tests/shell/testcases/sets/0054comments_set_0
@@ -1,11 +1,9 @@
 #!/bin/bash
 
+set -e
+
 # Test that comments are added to sets
 
 $NFT add table t
 $NFT add set t s {type ipv4_addr \; flags interval \; comment "test" \;}
-if ! $NFT list ruleset | grep test >/dev/null ; then
-	echo "E: missing comment in set" >&2
-	exit 1
-fi
-
+$NFT add map t m {type ipv4_addr : ipv4_addr \; flags interval \; comment \"another test\" \;}
diff --git a/tests/shell/testcases/sets/dumps/0054comments_set_0.nft b/tests/shell/testcases/sets/dumps/0054comments_set_0.nft
index 2ad840039350..79299241f8e6 100644
--- a/tests/shell/testcases/sets/dumps/0054comments_set_0.nft
+++ b/tests/shell/testcases/sets/dumps/0054comments_set_0.nft
@@ -4,4 +4,10 @@ table ip t {
 		flags interval
 		comment "test"
 	}
+
+	map m {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		comment "another test"
+	}
 }
-- 
2.20.1

