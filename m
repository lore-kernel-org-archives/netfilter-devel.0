Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB074C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9E920659
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbfG3OQa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:16:30 -0400
Received: from correo.us.es ([193.147.175.20]:53104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfG3OQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:16:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6537E11ED8B
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 586EEDA4D1
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C5F31150DA; Tue, 30 Jul 2019 16:16:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55EB3D1929;
        Tue, 30 Jul 2019 16:16:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:16:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BFF984265A32;
        Tue, 30 Jul 2019 16:16:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, bmastbergen@untangle.com
Subject: [PATCH nft,RFC,PoC 1/2] parser: add typeof keyword for declarations
Date:   Tue, 30 Jul 2019 16:16:16 +0200
Message-Id: <20190730141620.2129-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190730141620.2129-1-pablo@netfilter.org>
References: <20190730141620.2129-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a typeof keyword to automatically use the correct type in set and map
declarations.

table filter {
	set blacklist {
		typeof ip saddr
	}

	chain input {
		ip saddr @blacklist counter drop
	}
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 20 ++++++++++++++++++++
 src/scanner.l      |  1 +
 2 files changed, 21 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53e669521efa..5a1a37679a29 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -206,6 +206,8 @@ int nft_lex(void *, void *, void *);
 %token WSCALE			"wscale"
 %token SACKPERM			"sack-perm"
 
+%token TYPEOF			"typeof"
+
 %token HOOK			"hook"
 %token DEVICE			"device"
 %token DEVICES			"devices"
@@ -1624,6 +1626,12 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->key = $3;
 				$$ = $1;
 			}
+			|	set_block	TYPEOF		primary_expr	stmt_separator
+			{
+				$1->key = $3;
+				datatype_set($1->key, $3->dtype);
+				$$ = $1;
+			}
 			|	set_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags = $3;
@@ -1694,6 +1702,18 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
+			|	map_block	TYPEOF
+						primary_expr	COLON	primary_expr
+						stmt_separator
+			{
+				$1->key = $3;
+				datatype_set($1->key, $3->dtype);
+				$1->datatype = $5->dtype;
+
+				expr_free($5);
+				$1->flags |= NFT_SET_MAP;
+				$$ = $1;
+			}
 			|	map_block	TYPE
 						data_type_expr	COLON	COUNTER
 						stmt_separator
diff --git a/src/scanner.l b/src/scanner.l
index 4ed5f9241381..6a0f95776b38 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -238,6 +238,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "define"		{ return DEFINE; }
 "redefine"		{ return REDEFINE; }
 "undefine"		{ return UNDEFINE; }
+"typeof"		{ return TYPEOF; }
 
 "describe"		{ return DESCRIBE; }
 
-- 
2.11.0

