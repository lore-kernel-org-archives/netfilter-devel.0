Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519A6C64E7B
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A17222073C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="t08gnPuQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgK3LcJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgK3LcI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 06:32:08 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7FDC0613D4
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 03:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Tl1oB3l69oS3qgO59XYxZt7GP4h8uv7DvuryWdFfhgQ=; b=t08gnPuQPpsGvHGE0SGfTQo1H9
        797PAVKBwt8uved4Fv3Ty8OBUmC6fDXgzWLsjYF6hCIAu+8sTyeq0zvLTJr3jQ+I8WuiVCPdOgjUF
        KFOFTgtDSym8sbwK/GvMpc0gQudfibKPPfy07Lm8I5G1hjdH/c1JiMFoNVYiHSpkOGXdOppwGlUEW
        dUkX2ilkoaBqnWppcbcgqVED16vn8h9HlqhPTEh5Xl5KtnTH7eNwatvbbEEL/ui0V7HlB39cxdYCS
        tjJdgFAUVh70PB5b3PYZfU7KyRCaig0mPHzK2dDuHdMuf1WeghSXucP+mfVmdUOGjLYasiB/0STNU
        16t1WChA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kjhOw-0002ji-VH; Mon, 30 Nov 2020 11:31:27 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 2/2] build: link libnetfilter_log_libipulog.so explicitly to libnfnetlink.so.
Date:   Mon, 30 Nov 2020 11:31:25 +0000
Message-Id: <20201130113125.1346744-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130113125.1346744-1-jeremy@azazel.net>
References: <20201130113125.1346744-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It uses symbols from libnfnetlink.so, but doesn't link to it, relying on an
implicit transitive linkage through libnetfilter_log.so.  Add
`$(LIBNFNETLINK_LIBS)` to `$(libnetfilter_log_libipulog_la_LIBADD)`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 33be04828223..335c393f760a 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -34,6 +34,6 @@ lib_LTLIBRARIES += libnetfilter_log_libipulog.la
 
 libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles	\
 					-version-info 1:0:0
-libnetfilter_log_libipulog_la_LIBADD = libnetfilter_log.la
+libnetfilter_log_libipulog_la_LIBADD = libnetfilter_log.la ${LIBNFNETLINK_LIBS}
 libnetfilter_log_libipulog_la_SOURCES = libipulog_compat.c
 endif
-- 
2.29.2

