Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D018BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 17:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhLPRFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 12:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbhLPRFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 12:05:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682ACC06173F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/qf9ItFzjku+kz6svi+RGy69e94IZF505HoyVaTVsWQ=; b=iare0ZG8h9S0JhGw6pH5gVpUDS
        vGlDq9EzMP1pKj9ErWBkleQ9Nu74vVfIWSLNFZsIDpzM8PL6dKPVNrxC0si+/GmWGALN9bIBuOL99
        Jh1RXhdsG+1aGnww+xvsM13AfZsH4O/gwCYXRnw3boLMkoQXfh10XZqhK5EK61PCNVvErkvBUXPVj
        /oqkE/5FvwzQAY9qkI4QplVeqRb1pBsedA24Eoqycf0Ptgiy1sawu8jcnzYTgopc+JeO7AWs4VxFb
        2GtUg4CuESOdEc5z3mEg7qG8ahWXAg6ejmqaott1/NRA/EG2lFSlBKelFrSR4LKz2hBfTdf4sfzF4
        P5q3RfaA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxuC0-009WE2-FG
        for netfilter-devel@vger.kernel.org; Thu, 16 Dec 2021 17:05:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools PATCH 3/3] build: replace `AM_PROG_LEX` with `AC_PROG_LEX`
Date:   Thu, 16 Dec 2021 17:05:13 +0000
Message-Id: <20211216170513.180579-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211216170513.180579-1-jeremy@azazel.net>
References: <20211216170513.180579-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AM_PROG_LEX` calls `AC_PROG_LEX` with no arguments, but this usage is
deprecated.  The only difference between `AM_PROG_LEX` and `AC_PROG_LEX`
is that the former defines `$LEX` as "./build-aux/missing lex" if no lex
is found to ensure a useful error is reported when make is run.  How-
ever, the configure script checks that we have a working lex and exits
with an error if none is available, so `$LEX` will never be called and
we can replace `AM_PROG_LEX` with `AC_PROG_LEX`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a20c6bb4ca1c..b12b722a3396 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,7 @@ AM_PROG_AR
 LT_INIT([disable-static])
 AC_PROG_INSTALL
 AC_PROG_LN_S
-AM_PROG_LEX
+AC_PROG_LEX([noyywrap])
 AC_PROG_YACC
 
 case "$host" in
-- 
2.34.1

