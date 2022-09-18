Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625FFC32771
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 12:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIRMk1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 08:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIRMk0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 08:40:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38563205FE
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 05:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pY5X4rvq20kcqjYDC31uUM2670iC00li6UXBJLJm/VA=; b=jc08ZCsSjgYYcHswLbQ/wA+FEj
        53BWAyxrDqnnsHaXeo8e/l6lIELItnhthuGI2VRVM9A01UWsBfVSH2tHng2z+cYYAQT6TsR5yxI8X
        00uXxcM82ETr0MfKKTDaYaNqdSy3tmateaKsKMaPaHL7FRE+L21/nyhYGmbKBbICcMYQpFnqQxsFX
        SOKO9InqZZmklubVp7ZXaK5NgTL11hE3/5M8ToFvCvyeVV952GXF1pPv5ZjqyM6N0CJzweEZN1UrT
        vE5ft54LnRgW93mrtPPXv/5tWbLya6eeEVO7XHoVi9mgOYM1X9NBf6//PWS6d7x8R5roal5vYNl7D
        Ii43eWiQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oZtav-004Scf-QG
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 13:40:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] tests: py: fix payloads for sets with user data
Date:   Sun, 18 Sep 2022 13:39:32 +0100
Message-Id: <20220918123932.3519245-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A change was recently made to libnftnl to stop set user data being truncated in
dumps.  This causes mismatches in the payloads of certain Python test-cases.
This commit updates them to include the formerly truncated user data.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/ip6/srh.t.payload | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tests/py/ip6/srh.t.payload b/tests/py/ip6/srh.t.payload
index b6247456eb72..678e570e6621 100644
--- a/tests/py/ip6/srh.t.payload
+++ b/tests/py/ip6/srh.t.payload
@@ -11,7 +11,8 @@ ip6 test-ip6 input
 # srh last-entry { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,7 +30,8 @@ ip6 test-ip6 input
 # srh flags { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -47,7 +49,8 @@ ip6 test-ip6 input
 # srh tag { 0, 4-127, 0xffff }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
+
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-- 
2.35.1

