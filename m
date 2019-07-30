Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16E0C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87654206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbfG3Oi5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:38:57 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42934 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbfG3Oi5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:38:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hsTHD-0004Ws-KX; Tue, 30 Jul 2019 16:38:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] typeof keyword
Date:   Tue, 30 Jul 2019 16:37:32 +0200
Message-Id: <20190730143732.2126-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730143732.2126-1-fw@strlen.de>
References: <20190730143732.2126-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allows to do this:

table filter {
    set foo {
        type typeof(osf name);
    }
    map bar {
        type typeof(osf name) : typeof(meta mark);
    }
    map baz {
        type typeof(osf name) : typeof(ct helper);
    }
}

Problem is that listing such a table produces "type string" -- it
can't be restored.

Use in concatenations doesn't work either.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 5 +++++
 src/scanner.l      | 1 +
 2 files changed, 6 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5771f9f7469e..bc0105673f38 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -191,6 +191,7 @@ int nft_lex(void *, void *, void *);
 %token DEFINE			"define"
 %token REDEFINE			"redefine"
 %token UNDEFINE			"undefine"
+%token TYPEOF			"typeof"
 
 %token FIB			"fib"
 
@@ -1824,6 +1825,10 @@ data_type_atom_expr	:	type_identifier
 							 dtype->size, NULL);
 				xfree($1);
 			}
+			|	TYPEOF	'('	primary_expr	')'
+			{
+				$$ = $3;
+			}
 			;
 
 data_type_expr		:	data_type_atom_expr
diff --git a/src/scanner.l b/src/scanner.l
index c1adcbddbd73..cd563aa0ca1f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -243,6 +243,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "define"		{ return DEFINE; }
 "redefine"		{ return REDEFINE; }
 "undefine"		{ return UNDEFINE; }
+"typeof"		{ return TYPEOF; }
 
 "describe"		{ return DESCRIBE; }
 
-- 
2.21.0

