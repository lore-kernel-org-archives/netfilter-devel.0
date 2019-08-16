Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D823C3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F0E206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfHPOpH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:45:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46184 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfHPOpH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:45:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTW-0002oZ-6r; Fri, 16 Aug 2019 16:45:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 5/8] src: add "typeof" keyword
Date:   Fri, 16 Aug 2019 16:42:38 +0200
Message-Id: <20190816144241.11469-6-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows users to specify named sets by using the expression
directly, rather than having to lookup the data type to use, or
the needed size via 'nft describe".

Example:

table filter {
    set allowed_dports {
        type typeof(tcp dport);
    }
    map nametomark {
        type typeof(osf name) : typeof(meta mark);
    }
    map port2helper {
        type ipv4_addr . inet_service : typeof(ct helper);
    }
}

Currently, listing such a table will lose the typeof() expression:

nft will print the datatype instead, just as if "type inet_service"
would have been used.

For types with non-fixed widths, the new "type, width" format
added in previous patch is used.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 5 +++++
 src/scanner.l      | 1 +
 2 files changed, 6 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ee169fbac194..876050ba6863 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -192,6 +192,7 @@ int nft_lex(void *, void *, void *);
 %token DEFINE			"define"
 %token REDEFINE			"redefine"
 %token UNDEFINE			"undefine"
+%token TYPEOF			"typeof"
 
 %token FIB			"fib"
 
@@ -1844,6 +1845,10 @@ data_type_atom_expr	:	type_identifier
 							 $3, NULL);
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

