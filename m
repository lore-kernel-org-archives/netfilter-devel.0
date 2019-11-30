Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CCEC432C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3148D2073C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="i5KOYTS2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfK3RCV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:02:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:52164 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3RCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FQTskD11BXu3Iey6eJM0Z5A7Uj/U1A9ELCxxZ7p5teU=; b=i5KOYTS2BPrCcQuDkt5e8eNf0K
        zDHf2LTAXyeQoSkBZ/lM7nlyM+rILDCp22biFyQ+eTuGFGGWw6yosoVzC6vT/mUMkuUmF+AAh/dvR
        zNn9joNJLoY/G7NB049aUcC1ASKSU7kAAdkNalQcNx8OHwGyvGSi/dkipYAsMpflYjFPyKWMSv0tc
        tDggqdh9NdPIwla8/ll5zusPvMznP1Y3qLtQeZaY7ANxmZBBU10FY+L7meupMhTaGEg9kRnX3soqW
        0lPiYDhpcYW/f6cIsP/zanpiejeYm/QaADkiDGgOBgnF24/XMM5YtGNIfVL5nEr5v1CtHI5xkqRHu
        knN2iq4w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib68S-0001qd-B9; Sat, 30 Nov 2019 17:02:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: [PATCH xtables-addons 2/3] xt_geoip: white-space fixes.
Date:   Sat, 30 Nov 2019 17:02:18 +0000
Message-Id: <20191130170219.368867-4-jeremy@azazel.net>
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

Fix the indentation of some xt_geoip module function parameters.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_geoip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
index 27e60a4643b7..d64d951f19a9 100644
--- a/extensions/xt_geoip.c
+++ b/extensions/xt_geoip.c
@@ -140,7 +140,7 @@ static void geoip_try_remove_node(struct geoip_country_kernel *p)
 }
 
 static struct geoip_country_kernel *find_node(unsigned short cc,
-    enum geoip_proto proto)
+					      enum geoip_proto proto)
 {
 	struct geoip_country_kernel *p;
 	spin_lock(&geoip_lock);
@@ -172,7 +172,7 @@ ipv6_cmp(const struct in6_addr *p, const struct in6_addr *q)
 }
 
 static bool geoip_bsearch6(const struct geoip_subnet6 *range,
-    const struct in6_addr *addr, int lo, int hi)
+			   const struct in6_addr *addr, int lo, int hi)
 {
 	int mid;
 
@@ -227,7 +227,7 @@ xt_geoip_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 }
 
 static bool geoip_bsearch4(const struct geoip_subnet4 *range,
-    uint32_t addr, int lo, int hi)
+			   uint32_t addr, int lo, int hi)
 {
 	int mid;
 
-- 
2.24.0

