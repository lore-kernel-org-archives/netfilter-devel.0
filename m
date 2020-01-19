Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144C2C33CB6
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC2DD20678
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FTpiQCMf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgASW5Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:57:16 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56584 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbgASW5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9J6vMRqXwsp855kEhNzUy8m+HTiK0YbTGvnaOBpsjMI=; b=FTpiQCMf66LaWSq7OSHX+Lu2Ed
        fr/mnGvJsO2F3QwXbD4yR2BAqBgaZaIqzlsKsfTOkwRCEl6aCbf8443YQydd/1EO+FVkttZyaOYTo
        UaLwQEyO0oIla0c8PrxP/fe+H8zhssAI609nZnHCN3QK28KnqHe8Xxxp1g2yeMNvGz5lYkbx/ppEl
        WYZso39GDmPkYqOOCkrBxz75Xwa9P9kMqzbt2hpxp2lSeUT0e+sy6mSZmcQLtkhrBdLcho+Zzfx5h
        nGMWV7HdNzKO/0PZmzOoGfAEpjPKA1QztwQgZC1khVDFzRMWiPbMJjIbE23uh0w5trsofz5Sab8BT
        R1/0IH6w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itJVH-0006wh-4J
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 22:57:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 5/9] parser: add parenthesized statement expressions.
Date:   Sun, 19 Jan 2020 22:57:06 +0000
Message-Id: <20200119225710.222976-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119225710.222976-1-jeremy@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
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

