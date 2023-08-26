Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706DAC83F16
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Aug 2023 16:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjHZQcx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Aug 2023 12:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjHZQcr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2023 12:32:47 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7018170F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2023 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WkeZsXsiSEUKmiVwiDPEP62KziCvr2e7usw1y3m9QwI=; b=Rh+6462yrPiktDIcfvv0YOIKYM
        5j+3Ce3lzOglvMa1STSczl8484YDUL+uECnHJ3BwTVRpOTn5PfnaVxgLW4EXjUJ+CZ0ZzCXPgfc6z
        lEOC7NeOI0RBnKqchdc9KGKAJm1YhmimgkUxtbeL575g6JPR8O2l6WcTEualVSu/yZfdu0N2seZFY
        xLkvDr1IS3/4T4v3n608NbgkK/CnmPLImMh9oPaSgRUqKFQf3770Hrycf5KlsGwWbe8vdM7fFzkSi
        1U862TBzICaqTYRJKzUMvcQri90l4JcpN8P8yPa+bfYPKNg1UbxTHb6IwmMyWOWvmXXDQg1jnKxW4
        fdT1KPKQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qZwDJ-00DpTC-0z
        for netfilter-devel@vger.kernel.org;
        Sat, 26 Aug 2023 17:32:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH conntrack-tools 3/4] read_config_yy: correct `yyerror` prototype
Date:   Sat, 26 Aug 2023 17:32:25 +0100
Message-Id: <20230826163226.1104220-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230826163226.1104220-1-jeremy@azazel.net>
References: <20230826163226.1104220-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Change it to take a `const char *`.  It doesn't modify the string and yacc
passes string literals, so cause compiler warnings.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/read_config_yy.y | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index f06c6afff7cb..be927c049056 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -47,7 +47,7 @@ extern char *yytext;
 extern int   yylineno;
 
 int yylex (void);
-int yyerror (char *msg);
+int yyerror (const char *msg);
 void yyrestart (FILE *input_file);
 
 struct ct_conf conf;
@@ -1681,7 +1681,7 @@ helper_policy_expect_timeout: T_HELPER_EXPECT_TIMEOUT T_NUMBER
 %%
 
 int __attribute__((noreturn))
-yyerror(char *msg)
+yyerror(const char *msg)
 {
 	dlog(LOG_ERR, "parsing config file in line (%d), symbol '%s': %s",
 	     yylineno, yytext, msg);
-- 
2.40.1

