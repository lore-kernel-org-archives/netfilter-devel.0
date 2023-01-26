Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B3BC54E94
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbjAZMZH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbjAZMZH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:25:07 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65AE6C542
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OyeQ6I/v9LzXDFWJ1yO5gv1GPVTdP8D6N4Er5iDmaY4=; b=nk3QEc42qQxpm6hdIFjZHES8Ow
        x3yAR7hj1A6EQK+oyOaBhmacrWVsaEy+VvTLihRnfYyHVBKry5raXL/Rh+Yo3qKwP4zvjVlyRc3IO
        xBoJjXkmt3VIhs/C2vwP1p0xjECBW6AdgbXB+GqZkMx5TGRqML3dfxhnMhduPSJ63Ykj12shaYZCw
        i2mjYo3r751neyNnRohLSktdGUSXcbceGAp/pbifNzBdJi8J53EQIZ9c91LP+blAZJIbt1ls6//Or
        J/b0rpCjw/uNgypqwPugBbldpQqrI1dUJ3qK/AhlcBWMAGTcqR+CH3dDNvG4ez55UFIn/36blq9/3
        bNSzefGw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1JC-00058n-AC
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/7] ebtables-translate: Ignore '-j CONTINUE'
Date:   Thu, 26 Jan 2023 13:24:04 +0100
Message-Id: <20230126122406.23288-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is default behaviour. Does not hurt here, but reducing diff to
xtables-eb.c can't hurt.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 49ae6f64a9741..99347c0c3ee46 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -355,7 +355,9 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				break;
 			} else if (c == 'j') {
 				ebt_check_option2(&flags, OPT_JUMP);
-				command_jump(&cs, optarg);
+				if (strcmp(optarg, "CONTINUE") != 0) {
+					command_jump(&cs, optarg);
+				}
 				break;
 			} else if (c == 's') {
 				ebt_check_option2(&flags, OPT_SOURCE);
-- 
2.38.0

