Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D7AC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDE22075C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MewwE8to"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfK3R6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:58:49 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54250 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfK3R6s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ylnKBALoIxWuzTItp1jGWu88hInloAG0UTJpbkEVG4o=; b=MewwE8toFhiN2d8mK53PFgKiiq
        8lTOQTOP8sf6RFKkxfEbVEJc3/ktoTFPB4VELo/nUvwLWMurmqe5hv9hoVcOHnz1vMtfXGKHIJqJp
        XU00LCcxuxsb3n1GkpafJ/E+Z7MKD3jEO8t6CODSpuUTcAAEYsVKDC5OEY5R6EyLFcAbfmJsJE7LZ
        1n9JaZ9cPDFy1L4EbJnkzXBG69bLD6P19LsAhFa3ezP2MtDce+ScKRqnEIvkgNAOMystpmMJkq8X+
        SzNasePwswxNdUF0OpgcllZmibdqVRfWyQYsWwDe4g8Svr+996ppZUYItyKL5yQqvfCe5JVSmXNlx
        1pb1l2UQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib714-0002eP-FW; Sat, 30 Nov 2019 17:58:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: [PATCH xtables-addons v2 3/3] xt_geoip: fix in6_addr little-endian byte-swapping.
Date:   Sat, 30 Nov 2019 17:58:45 +0000
Message-Id: <20191130175845.369240-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191130175845.369240-1-jeremy@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130175845.369240-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The Perl script that builds the GeoIP DB's uses inet_pton(3) to convert
the addresses to network byte-order.  This swaps 32-bit segments and
converts:

  1234:5678::90ab:cdef

to:

  8765:4321::fedc:ba09

The kernel module compares the addresses in packets with the ranges from
the DB in host byte-order using binary search.  It uses 32-bit swaps
when converting the addresses.

libxt_geoip, however, which the module uses to load the ranges from the
DB and convert them from NBO to HBO, uses 16-bit swaps to do so, and
this means that:

  1234:5678::90ab:cdef

becomes:

  4321:8765::ba09:fedc

Obviously, this is inconsistent with the kernel-module and DB build-
script and breaks the binary search.

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

