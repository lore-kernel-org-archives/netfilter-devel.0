Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51836C35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2694A2080D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="oFdANNjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33246 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9J6vMRqXwsp855kEhNzUy8m+HTiK0YbTGvnaOBpsjMI=; b=oFdANNjxPWw4XC0wEw/hZclOKc
        cIuDykVCNlPuc6VWUFq1BRa2CxVLQWhqIAoR9msWDFlYy02bhJRP3aDrFQZQZ9HS3aPYnAydAim2S
        nnfPRBMZ9tbl2bnUjYoYjnEBtVT9DZcy8PltkphgoytBag4vJ+U9dtXSv9mbEkXyKpMAb0xvYNL2x
        msKPlcpmycbr+mZn9qRzqPwnh9xByyIlWg3tuqfdyQmH0W3rHhXP2fJNRpb7HblDBRiNKamr/sXUX
        UYKVEGKKIBC5G80pN+tN3X9s9FEw7HZMaY6zXk2f0s6VImVY/s4WjDLoXpbguY+G8ZQNSO2EbcUU+
        WnmjWTAA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-8T
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 1/6] parser: add parenthesized statement expressions.
Date:   Mon,  3 Feb 2020 11:20:18 +0000
Message-Id: <20200203112023.646840-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Primary and primary RHS expressions support parenthesized basic and
basic RHS expressions.  However, primary statement expressions do not
support parenthesized basic statement expressions.  Add them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_bison.y | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 799f7a308b07..45cc013cfe28 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2992,18 +2992,19 @@ synproxy_sack		:	/* empty */	{ $$ = 0; }
 			}
 			;
 
-primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
-			|	integer_expr		{ $$ = $1; }
-			|	boolean_expr		{ $$ = $1; }
-			|	meta_expr		{ $$ = $1; }
-			|	rt_expr			{ $$ = $1; }
-			|	ct_expr			{ $$ = $1; }
-			|	numgen_expr             { $$ = $1; }
-			|	hash_expr               { $$ = $1; }
-			|	payload_expr		{ $$ = $1; }
-			|	keyword_expr		{ $$ = $1; }
-			|	socket_expr		{ $$ = $1; }
-			|	osf_expr		{ $$ = $1; }
+primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
+			|	integer_expr			{ $$ = $1; }
+			|	boolean_expr			{ $$ = $1; }
+			|	meta_expr			{ $$ = $1; }
+			|	rt_expr				{ $$ = $1; }
+			|	ct_expr				{ $$ = $1; }
+			|	numgen_expr             	{ $$ = $1; }
+			|	hash_expr               	{ $$ = $1; }
+			|	payload_expr			{ $$ = $1; }
+			|	keyword_expr			{ $$ = $1; }
+			|	socket_expr			{ $$ = $1; }
+			|	osf_expr			{ $$ = $1; }
+			|	'('	basic_stmt_expr	')'	{ $$ = $2; }
 			;
 
 shift_stmt_expr		:	primary_stmt_expr
-- 
2.24.1

