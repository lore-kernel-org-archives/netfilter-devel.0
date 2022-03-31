Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C05C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiCaKOD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 06:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiCaKOD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 06:14:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640DA1EECC
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 03:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yrr62dhrSbcuIiN1tzF+GxzvNJmYPdB4e7rSICvPnIw=; b=OiTiPTMFRmuXINEujnAq3Bm9Wt
        ek6eAGmWpVjCCnESOzPrwD2ACSH2IG5h0fh5dzhbcM9AoNJREk4bevhrh5jT9WPFvmPyi18YZPD5O
        mhggGGusLEfQrM3/uGKzWrhU0L9KGiA21+2F0zd3aAxKAyQyy4npw3PMn+4dioBvuG3xBvkYg4JJ2
        O5OS51SJTnTqeUAla5F6zoLWUMW/8R8wMWuyFgL7IQ9+18i2lnT7vLG5vtUBezSZnm2CzEEy+sLv3
        s1kFuUw8cNA/88g1p56yxK/F2BE7kyenDyRLmbeEqWTRM7gGNihTHe8kY0jGAHtMmjCQNEotSiHOq
        7BNzZrog==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZrmn-000664-Nq; Thu, 31 Mar 2022 12:12:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 9/9] extensions: man: Document service name support in DNAT and REDIRECT
Date:   Thu, 31 Mar 2022 12:12:11 +0200
Message-Id: <20220331101211.10099-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331101211.10099-1-phil@nwl.cc>
References: <20220331101211.10099-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unless as part of a range, service names may be used. Point this out to
avoid confusion.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.man     | 2 ++
 extensions/libxt_REDIRECT.man | 1 +
 2 files changed, 3 insertions(+)

diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index e044c8216fc09..12d334af5a479 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -21,6 +21,8 @@ will be modified.
 If \fBbaseport\fP is given, the difference of the original destination port and
 its value is used as offset into the mapping port range. This allows to create
 shifted portmap ranges and is available since kernel version 4.18.
+For a single port or \fIbaseport\fP, a service name as listed in
+\fB/etc/services\fP may be used.
 .TP
 \fB\-\-random\fP
 If option
diff --git a/extensions/libxt_REDIRECT.man b/extensions/libxt_REDIRECT.man
index 28d4d10b79046..10305597f87a3 100644
--- a/extensions/libxt_REDIRECT.man
+++ b/extensions/libxt_REDIRECT.man
@@ -16,6 +16,7 @@ This specifies a destination port or range of ports to use: without
 this, the destination port is never altered.  This is only valid
 if the rule also specifies one of the following protocols:
 \fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
+For a single port, a service name as listed in \fB/etc/services\fP may be used.
 .TP
 \fB\-\-random\fP
 If option
-- 
2.34.1

