Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64E4C19F2D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiHCUNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbiHCUNp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:45 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0EB4F65E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8K3oK2cEo5YPDIFhg3Rpn97CQOtb/soy2fATPTQreJA=; b=NM4Lu8c7LRh2fD3NprLm12+0ua
        i6Kgs6TyHkydOkdcXbA8mooRqdNPfxxff8WaInOZI/drDjTHOQDh6+RFyAd6vmeaQEGngvrPr22kX
        U3UFK5CTFdxvK+vLm2hOsMO6l61W+hBIPlvcANnIdv1AmsoaSElh99mfM4yoHoGMKg+Dh9SercnQR
        46weZz14U2vTAPuH8eCmwuFitADjiDoQGbJTD300qW3jlOrjsu0FgjEzMb7Hr8mkxO2+djsdisda+
        ZuL7f2tyhlv38QUjV2NKqIk2CG0SOOEVt+iX84hkvAJpyHLddJ6jHEI2A5nTbcO5I5H/udI1ILGyd
        A/u5a8qQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkK-001Fnp-Bz; Wed, 03 Aug 2022 21:13:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 6/6] doc: fix doxygen `clean-local` rule
Date:   Wed,  3 Aug 2022 21:12:47 +0100
Message-Id: <20220803201247.3057365-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220803201247.3057365-1-jeremy@azazel.net>
References: <20220803201247.3057365-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The html and man directories are created in the current working directory,
$(top_builddir)/doxygen, not $(top_srcdir)/doxygen.

Remove doxyfile.stamp in `clean-local` and remove `CLEANFILES` in order to do
all cleaning in one place.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doxygen/Makefile.am | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 4770fc788068..90154c2eb869 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -7,11 +7,9 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 	$(SHELL) $(top_srcdir)/doxygen/finalize_manpages.sh
 	touch doxyfile.stamp
 
-CLEANFILES = doxyfile.stamp
-
 all-local: doxyfile.stamp
 clean-local:
-	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+	rm -rf doxyfile.stamp html man
 install-data-local:
 	mkdir -p $(DESTDIR)$(mandir)/man3
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
-- 
2.35.1

