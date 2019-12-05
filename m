Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCFCC43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7182464D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfLEJ4g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:56:36 -0500
Received: from marjorie02.plutex.de ([91.202.40.203]:55782 "EHLO
        marjorie01.plutex.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729017AbfLEJ4g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 04:56:36 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2019 04:56:34 EST
Received: from smtprelay02.isp.plutex.de (smtprelay02.isp.plutex.de [91.202.40.194])
        by marjorie01.plutex.de (Postfix) with ESMTPS id 50DB8602C3
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:46:36 +0100 (CET)
Received: from mail01.plutex.de (mail01.plutex.de [91.202.40.205])
        by smtprelay02.isp.plutex.de (Postfix) with ESMTP id 318A480085
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:46:34 +0100 (CET)
Received: from [10.254.49.83] (unknown [10.254.49.83])
        by mail01.plutex.de (Postfix) with ESMTPSA id 22769CC877C
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2019 10:46:34 +0100 (CET)
From:   Jan-Philipp Litza <jpl@plutex.de>
Subject: [PATCH] nftables: Bump dependency on libnftnl to 1.1.5
To:     netfilter-devel@vger.kernel.org
Autocrypt: addr=jpl@plutex.de; prefer-encrypt=mutual; keydata=
 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
Organization: PLUTEX GmbH
Message-ID: <34285bec-d708-d115-dd8c-207aa4a5f718@plutex.de>
Date:   Thu, 5 Dec 2019 10:46:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The multidevice support was introduced in libnftnl commit e3ac19b5ec162,
which is first included in version 1.1.5

With version 1.1.4, compile errors like the following occur:

netlink.c:423:38: error: 'NFTNL_CHAIN_DEVICES' undeclared (first use in
this function); did you mean 'NFTNL_CHAIN_DEV'?

Fixes: 3fdc7541fba07 ("src: add multidevice support for netdev chain")
Signed-off-by: Jan-Philipp Litza <janphilipp@litza.de>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 5ed3f18a..c487029a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,7 +57,7 @@ AS_IF([test "x$enable_man_doc" = "xyes"], [
 ])

 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.1.4])
+PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.1.5])

 AC_ARG_WITH([mini-gmp], [AS_HELP_STRING([--with-mini-gmp],
             [Use builtin mini-gmp (for embedded builds)])],

-- 
Jan-Philipp Litza
PLUTEX GmbH
Hermann-Ritter-Str. 108
28197 Bremen

Hotline: 0800 100 400 800
Telefon: 0800 100 400 821
Telefax: 0800 100 400 888
E-Mail: support@plutex.de
Internet: http://www.plutex.de

USt-IdNr.: DE 815030856
Handelsregister: Amtsgericht Bremen, HRB 25144
Geschäftsführer: Torben Belz, Hendrik Lilienthal
