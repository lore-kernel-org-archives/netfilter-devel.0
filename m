Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D77C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 21:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98CA320873
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 21:13:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="fRkgUO95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfENVNr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 17:13:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48690 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfENVNr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 17:13:47 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 79B661A070D
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 14:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557868426; bh=It2+ceLMfW18P6l0vsfC6hqh4B2pN/UCZSN3UhkT/fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRkgUO95DiDWPgLLQoiprSSOWkpmusKwSXABYt94LCqinvjXk94yMMOTLI4V/AlZ/
         1ubp+RPXzWeq9RFrYbLwSgRn9sXn6Ab/QZYecCa/IqCazXrmKuEiBhIk5VdU9ZYPif
         L4Fw2wqbETckyRdBWJcCaBA+AmfFZivGAt6whyPg=
X-Riseup-User-ID: 1FFFB2E5E30CD72BCAA6AA1471DEE7FDB2433704863211CDEC382E90476F5F87
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id A45182232E9;
        Tue, 14 May 2019 14:13:45 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using nft input files
Date:   Tue, 14 May 2019 23:13:40 +0200
Message-Id: <20190514211340.913-2-ffmancera@riseup.net>
In-Reply-To: <20190514211340.913-1-ffmancera@riseup.net>
References: <20190514211340.913-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in 'jump' and 'goto'
statements, e.g.

define dest = ber

add table ip foo
add chain ip foo bar {type filter hook input priority 0;}
add chain ip foo ber
add rule ip foo ber counter
add rule ip foo bar jump $dest

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
		jump ber
	}

	chain ber {
		counter packets 71 bytes 6664
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/datatype.c     | 11 +++++++++++
 src/parser_bison.y |  6 +++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 6aaf9ea..7e9ec5e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -297,11 +297,22 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
+static struct error_record *verdict_type_parse(const struct expr *sym,
+					       struct expr **res)
+{
+	*res = constant_expr_alloc(&sym->location, &string_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
+				   sym->identifier);
+	return NULL;
+}
+
 const struct datatype verdict_type = {
 	.type		= TYPE_VERDICT,
 	.name		= "verdict",
 	.desc		= "netfilter verdict",
 	.print		= verdict_type_print,
+	.parse		= verdict_type_parse,
 };
 
 static const struct symbol_table nfproto_tbl = {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 69b5773..a955cb5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3841,7 +3841,11 @@ verdict_expr		:	ACCEPT
 			}
 			;
 
-chain_expr		:	identifier
+chain_expr		:	variable_expr
+			{
+				$$ = $1;
+			}
+			|	identifier
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
 							 BYTEORDER_HOST_ENDIAN,
-- 
2.20.1

