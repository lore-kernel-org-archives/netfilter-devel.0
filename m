Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D23C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96FB2190F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 21:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="hWhdPlA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfIAVB2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 17:01:28 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53606 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbfIAVB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 17:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hDHDCgYoOWvYdGIiEvIkg/R709cjZHTGdsMOCZ1IUuU=; b=hWhdPlA6nv+I68zItRIAeKxZto
        Lcsao5uxz7ksdBmNheFO1/x+kg8cUJq+db7wX7/UDro67nBTO1Npd5WY5hnSMEMCits0437KCJnRN
        fJHSKe7ohZSrAMcTwxGi11nnIEFqC6/sTsWK1lW5fCxL73rJQTSP1HLW/TlpAnPocAGGzJoHIhXdX
        nilZVf0emcUV9d09qjR1J2D4WZt2iKiysY1wWfWY2w2XySW/XOANwyvO7IIIRamsDeWtHdUF5xswY
        zAbwn3szeK9aKssF2qioKj478+eUJ5A8UNxeKirHdRyB6MNxNxrXwleGze76y/U0Pvjbci+MOubMK
        QDc/rF3g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wos-0002Uf-9x; Sun, 01 Sep 2019 21:51:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 27/29] netfilter: add IP_SET_BITMAP config option.
Date:   Sun,  1 Sep 2019 21:51:23 +0100
Message-Id: <20190901205126.6935-28-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a hidden tristate option which is selected by all the
IP_SET_BITMAP_* options.  It will be used to wrap ip_set_bitmap.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/ipset/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
index 3c273483df23..8a5498a86df0 100644
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -25,9 +25,13 @@ config IP_SET_MAX
 	  The value can be overridden by the 'max_sets' module
 	  parameter of the 'ip_set' module.
 
+config IP_SET_BITMAP
+	tristate
+
 config IP_SET_BITMAP_IP
 	tristate "bitmap:ip set support"
 	depends on IP_SET
+	select IP_SET_BITMAP
 	help
 	  This option adds the bitmap:ip set type support, by which one
 	  can store IPv4 addresses (or network addresse) from a range.
@@ -37,6 +41,7 @@ config IP_SET_BITMAP_IP
 config IP_SET_BITMAP_IPMAC
 	tristate "bitmap:ip,mac set support"
 	depends on IP_SET
+	select IP_SET_BITMAP
 	help
 	  This option adds the bitmap:ip,mac set type support, by which one
 	  can store IPv4 address and (source) MAC address pairs from a range.
@@ -46,6 +51,7 @@ config IP_SET_BITMAP_IPMAC
 config IP_SET_BITMAP_PORT
 	tristate "bitmap:port set support"
 	depends on IP_SET
+	select IP_SET_BITMAP
 	help
 	  This option adds the bitmap:port set type support, by which one
 	  can store TCP/UDP port numbers from a range.
-- 
2.23.0.rc1

