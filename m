Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7474C43215
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE47920833
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OLe9esF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfK3RCW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:02:22 -0500
Received: from kadath.azazel.net ([81.187.231.250]:52172 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfK3RCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d0TMecq856/VrrLDv7rtdrLeX4GlCwNuwB5C2FPChic=; b=OLe9esF3FN8xoVBbjQSDR+JKBW
        kM4kh5CusPPLnrAWBLyQ+HgpDwmxzzBA+qEt/XsoXM5GSbaMlGHjZrM8nwSh1FEXO/dIj5EEMuxfG
        upQfV/7O/R/IoxhxmTg17EQEnqv8hBsi2mF9vbD4fmkB47b/IDXiFcqqHj+2qHoKAld3wY9S2A52y
        KFwqBHMpL/ubnEo4JSpxnAQY3RiS5Trjd1H+W6LaWv/Fk+v13vM7TQK9p3NJFlRfgtRZy+PTlvw2J
        0cJwv8woU5GKMNvnrAf4UkPaGlPBS+BVY4X2ON1FMUk592o1N8H/rnSk0T1r6UdUM9veRldCZJF8D
        fm8CKZrg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib68S-0001qd-GI; Sat, 30 Nov 2019 17:02:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: [PATCH xtables-addons 3/3] xt_geoip: fix in6_addr little-endian byte-swapping.
Date:   Sat, 30 Nov 2019 17:02:19 +0000
Message-Id: <20191130170219.368867-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191130170219.368867-1-jeremy@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130170219.368867-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libxt_geoip attempts to byte-swap IPv6 addresses on little-endian
systems but it doesn't get it quite right.  Rather than doing ntohl on
each 32-bit segment, it does ntohs on each 16-bit segment.

This means that:

  1234::cdef

becomes:

  2143::dcfe

instead of:

  4321::fedc

Fixes: b91dbd03c717 ("geoip: store database in network byte order")
Reported-by: "Thomas B. Clark" <kernel@clark.bz>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_geoip.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_geoip.c b/extensions/libxt_geoip.c
index 116f5f86eb01..5b8697dc6161 100644
--- a/extensions/libxt_geoip.c
+++ b/extensions/libxt_geoip.c
@@ -50,26 +50,6 @@ static struct option geoip_opts[] = {
 };
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
-static void geoip_swap_le16(uint16_t *buf)
-{
-	unsigned char *p = (void *)buf;
-	uint16_t n= p[0] + (p[1] << 8);
-	p[0] = (n >> 8) & 0xff;
-	p[1] = n & 0xff;
-}
-
-static void geoip_swap_in6(struct in6_addr *in6)
-{
-	geoip_swap_le16(&in6->s6_addr16[0]);
-	geoip_swap_le16(&in6->s6_addr16[1]);
-	geoip_swap_le16(&in6->s6_addr16[2]);
-	geoip_swap_le16(&in6->s6_addr16[3]);
-	geoip_swap_le16(&in6->s6_addr16[4]);
-	geoip_swap_le16(&in6->s6_addr16[5]);
-	geoip_swap_le16(&in6->s6_addr16[6]);
-	geoip_swap_le16(&in6->s6_addr16[7]);
-}
-
 static void geoip_swap_le32(uint32_t *buf)
 {
 	unsigned char *p = (void *)buf;
@@ -79,6 +59,14 @@ static void geoip_swap_le32(uint32_t *buf)
 	p[2] = (n >> 8) & 0xff;
 	p[3] = n & 0xff;
 }
+
+static void geoip_swap_in6(struct in6_addr *in6)
+{
+	geoip_swap_le32(&in6->s6_addr32[0]);
+	geoip_swap_le32(&in6->s6_addr32[1]);
+	geoip_swap_le32(&in6->s6_addr32[2]);
+	geoip_swap_le32(&in6->s6_addr32[3]);
+}
 #endif
 
 static void *
-- 
2.24.0

