Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56404C64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 13:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCINoW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 08:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCINoR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 08:44:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38584E1FC5
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2023 05:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WSNvfK8RFbRyNdZT/k7OBcmdf2cGryDBMYvhFpHwqH8=; b=cy97C/9U3rMg9Pz8xmAbIJHGPr
        vaH/0In3gGJ8Y4Li8GkXe7sGXXTNk7QGmXoL/izmoOLM9RDLQ7KVcaN6sysS/cw7XNzoixGTtn6hY
        cbAoJvZ+dcTPgEFsYSa7Q4kyc66WKuhgNICR8msoaWBeJmGDQFQncsscUBExSRiNpOA1WHuQyDdaG
        M38S3LplP+PRhdWAPRou3wqZDmbWD2seSoDJawiPqQTT06dMQffCZWdKrYbtTbKEDcBvotjZfrR8b
        tOretsEK3uoqNuE/lNFmt5sv775zMfxdheV32if6qyN2zaILXJ+SZKTmCcrGGgbxBOOMZHGnMjU3a
        bPhGyGlQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1paGYp-0006AY-2I; Thu, 09 Mar 2023 14:43:59 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] xt: Fix fallback printing for extensions matching keywords
Date:   Thu,  9 Mar 2023 14:43:50 +0100
Message-Id: <20230309134350.9803-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Yet another Bison workaround: Instead of the fancy error message, an
incomprehensible syntax error is emitted:

| # iptables-nft -A FORWARD -p tcp -m osf --genre linux
| # nft list ruleset | nft -f -
| # Warning: table ip filter is managed by iptables-nft, do not touch!
| /dev/stdin:4:29-31: Error: syntax error, unexpected osf, expecting string
| 		meta l4proto tcp xt match osf counter packets 0 bytes 0
| 		                          ^^^

Avoid this by quoting the extension name when printing:

| # nft list ruleset | sudo ./src/nft -f -
| # Warning: table ip filter is managed by iptables-nft, do not touch!
| /dev/stdin:4:20-33: Error: unsupported xtables compat expression, use iptables-nft with this ruleset
| 		meta l4proto tcp xt match "osf" counter packets 0 bytes 0
| 		                 ^^^^^^^^^^^^^^

Fixes: 79195a8cc9e9d ("xt: Rewrite unsupported compat expression dumping")
Fixes: e41c53ca5b043 ("xt: Fall back to generic printing from translation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 2 +-
 src/xt.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 824e5db8ad90c..32f6b32268f49 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2992,7 +2992,7 @@ stmt			:	verdict_stmt
 			|	xt_stmt		close_scope_xt
 			;
 
-xt_stmt			:	XT	STRING	STRING
+xt_stmt			:	XT	STRING	string
 			{
 				$$ = NULL;
 				xfree($2);
diff --git a/src/xt.c b/src/xt.c
index 2405d3c34773c..f63096a554e7f 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -116,7 +116,7 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 	xfree(entry);
 #endif
 	if (!rc)
-		nft_print(octx, "xt %s %s",
+		nft_print(octx, "xt %s \"%s\"",
 			  typename[stmt->xt.type], stmt->xt.name);
 }
 
-- 
2.38.0

