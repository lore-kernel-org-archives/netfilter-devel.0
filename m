Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67857C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A4692184E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfCTKkV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:40:21 -0400
Received: from mail.us.es ([193.147.175.20]:40648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfCTKkU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 06:40:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D304154E90
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:40:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62D2EFEFC4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:40:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5BAB6FEFB9; Wed, 20 Mar 2019 11:40:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30196FC60B
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:40:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Mar 2019 11:40:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.hhotels.local (148.160.broadband14.iol.cz [90.181.160.148])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C43014265A50
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:40:15 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/2] src: use 'flow add' syntax
Date:   Wed, 20 Mar 2019 11:40:11 +0100
Message-Id: <20190320104012.15724-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As discussed during NFWS 2018. Old syntax is stilled allowed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt                                               | 2 +-
 doc/statements.txt                                        | 6 +++---
 src/ct.c                                                  | 2 +-
 src/parser_bison.y                                        | 4 ++++
 tests/shell/testcases/flowtable/0001flowtable_0           | 2 +-
 tests/shell/testcases/flowtable/0005delete_in_use_1       | 2 +-
 tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft | 2 +-
 7 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index a4ab4a8e5ca0..d162dad07e06 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -585,7 +585,7 @@ address - to update the destination link-layer address - to forward packets.
 The ttl and hoplimit fields are also decremented. Hence, flowtables provides an
 alternative path that allow packets to bypass the classic forwarding path.
 Flowtables reside in the ingress hook that is located before the prerouting
-hook. You can select which flows you want to offload through the flow offload
+hook. You can select which flows you want to offload through the flow
 expression from the forward chain. Flowtables are identified by their address
 family and their name. The address family must be one of ip, ip6, or inet. The inet
 address family is a dummy family which is used to create hybrid IPv4/IPv6
diff --git a/doc/statements.txt b/doc/statements.txt
index a5822cf0aeb7..63f7373caf77 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -439,13 +439,13 @@ table inet x {
 }
 -------------------------------------
 
-FLOW OFFLOAD STATEMENT
+FLOW STATEMENT
 ~~~~~~~~~~~~~~~~~~~~~~
-A flow offload statement allows us to select what flows you want to accelerate
+A flow statement allows us to select what flows you want to accelerate
 forwarding through layer 3 network stack bypass. You have to specify the
 flowtable name where you want to offload this flow.
 
-*flow offload* @flowtable
+*flow add* @flowtable
 
 QUEUE STATEMENT
 ~~~~~~~~~~~~~~~
diff --git a/src/ct.c b/src/ct.c
index e77c3201eb5d..ca31f49850d4 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -481,7 +481,7 @@ struct stmt *notrack_stmt_alloc(const struct location *loc)
 static void flow_offload_stmt_print(const struct stmt *stmt,
 				    struct output_ctx *octx)
 {
-	printf("flow offload @%s", stmt->flow.table_name);
+	printf("flow add @%s", stmt->flow.table_name);
 }
 
 static const struct stmt_ops flow_offload_stmt_ops = {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 48e44e5adc40..65b3fb3ebac2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3915,6 +3915,10 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = flow_offload_stmt_alloc(&@$, $4);
 			}
+			|	FLOW	ADD	AT string
+			{
+				$$ = flow_offload_stmt_alloc(&@$, $4);
+			}
 			;
 
 socket_expr		:	SOCKET	socket_key
diff --git a/tests/shell/testcases/flowtable/0001flowtable_0 b/tests/shell/testcases/flowtable/0001flowtable_0
index 90b23dc38d6f..8336ec5a8f37 100755
--- a/tests/shell/testcases/flowtable/0001flowtable_0
+++ b/tests/shell/testcases/flowtable/0001flowtable_0
@@ -7,7 +7,7 @@ EXPECTED='table inet t {
 	}
 
 	chain c {
-		flow offload @f
+		flow add @f
 	}
 }'
 
diff --git a/tests/shell/testcases/flowtable/0005delete_in_use_1 b/tests/shell/testcases/flowtable/0005delete_in_use_1
index 149d64442fdd..ef52620d9958 100755
--- a/tests/shell/testcases/flowtable/0005delete_in_use_1
+++ b/tests/shell/testcases/flowtable/0005delete_in_use_1
@@ -4,7 +4,7 @@ set -e
 $NFT add table x
 $NFT add chain x x
 $NFT add flowtable x y { hook ingress priority 0\; devices = { lo }\;}
-$NFT add rule x x flow offload @y
+$NFT add rule x x flow add @y
 
 $NFT delete flowtable x y || exit 0
 echo "E: delete flowtable in use"
diff --git a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
index 6a1c7b81dbd2..629bfe81cb18 100644
--- a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.nft
@@ -5,6 +5,6 @@ table inet t {
 	}
 
 	chain c {
-		flow offload @f
+		flow add @f
 	}
 }
-- 
2.11.0

