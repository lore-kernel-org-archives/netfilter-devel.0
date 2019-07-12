Return-Path: <SRS0=tLP1=VJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CBDC742B3
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F893206B8
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfGLKfK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:35:10 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40774 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfGLKfK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 06:35:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hlstQ-0004YD-VZ; Fri, 12 Jul 2019 12:35:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src/ct: provide fixed data lengh sizes for ip/ip6 keys
Date:   Fri, 12 Jul 2019 12:35:03 +0200
Message-Id: <20190712103503.22825-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft can load but not list this:

table inet filter {
 chain input {
  ct original ip daddr {1.2.3.4} accept
 }
}

Problem is that the ct template length is 0, so we believe the right hand
side is a concatenation because left->len < set->key->len is true.
nft then calls abort() during concatenation parsing.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1222
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 4f7807deea0f..14cc0e5e8a4e 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -292,13 +292,13 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("event", &ct_event_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
 	[NFT_CT_SRC_IP]		= CT_TEMPLATE("ip saddr", &ipaddr_type,
-					      BYTEORDER_BIG_ENDIAN, 0),
+					      BYTEORDER_BIG_ENDIAN, 32),
 	[NFT_CT_DST_IP]		= CT_TEMPLATE("ip daddr", &ipaddr_type,
-					      BYTEORDER_BIG_ENDIAN, 0),
+					      BYTEORDER_BIG_ENDIAN, 32),
 	[NFT_CT_SRC_IP6]	= CT_TEMPLATE("ip6 saddr", &ip6addr_type,
-					      BYTEORDER_BIG_ENDIAN, 0),
+					      BYTEORDER_BIG_ENDIAN, 128),
 	[NFT_CT_DST_IP6]	= CT_TEMPLATE("ip6 daddr", &ip6addr_type,
-					      BYTEORDER_BIG_ENDIAN, 0),
+					      BYTEORDER_BIG_ENDIAN, 128),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
-- 
2.21.0

