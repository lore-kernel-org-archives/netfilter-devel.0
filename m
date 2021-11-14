Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23086C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0215660FE3
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhKNQRt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 11:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbhKNQRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 11:17:43 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09FBC061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 08:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ezdX1ljJ0+CjfteV1LQXMBs75rvR0pzvIcVBz8RA5d0=; b=p3a0McIlrhsEL9Uonkjncn/ci0
        zw6laxsdAJgheLSCYrcw9qnrMgYN4MHRFmYu/2uLPXulywazoJdPogsJpE191rqSHDD8a+gO1OT/c
        cNsmzVz9YMzA9InnUTMurbkcO0snzEXYqdUDh4Zj/YvL/9qk/AxfDko1AfeneHtU4QqDaszAhm8PN
        fllOqaZqkM8+fwsB4LDugjhE4flGvT2zOjKqRNMdIFvcWwOZhG3mcwrsGfAeGVVWwbjdHazt+jtJg
        j28jHAzpiHdDoJ2gjeJiiQmbzXtpaqlQhgAfBUcGOcPxLy8CjeYLCMGoDYf6OpWDx/rW7cK1KigEp
        fzCFwAPg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-DS
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 10/15] build: delete commented-out code
Date:   Sun, 14 Nov 2021 15:52:26 +0000
Message-Id: <20211114155231.793594-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a few of commented-out variable definitions left over from
the introduction of Automake.  Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/flow/Makefile.am | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 2171a0cd80c8..fc95bdb85af8 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,10 +2,7 @@ include $(top_srcdir)/Make_global.am
 
 AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
+pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
-
-#ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
-#ulogd_inpflow_IPFIX_la_LDFLAGS = -avoid-version -module
-- 
2.33.0

