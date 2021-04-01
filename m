Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1CFC4363E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531816101A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhDARr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbhDARmy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:42:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33E6C08ECBE
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:08:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy0G-0001XM-D1; Thu, 01 Apr 2021 16:08:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] src: vlan: allow matching vlan id insider 802.1ad frame
Date:   Thu,  1 Apr 2021 16:08:43 +0200
Message-Id: <20210401140846.24452-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401140846.24452-1-fw@strlen.de>
References: <20210401140846.24452-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes "ether type 0x88a8 vlan id 342" work.

Before this change, nft would still insert a dependency on 802.1q so the
rule would never match.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index b75626df2861..b6466f8b65d4 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -1027,6 +1027,7 @@ const struct proto_desc proto_vlan = {
 		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
 		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
 		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_8021AD),	&proto_vlan),
 
 	},
 	.templates	= {
@@ -1099,6 +1100,7 @@ const struct proto_desc proto_eth = {
 		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
 		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
 		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_8021AD),	&proto_vlan),
 	},
 	.templates	= {
 		[ETHHDR_DADDR]		= ETHHDR_ADDR("daddr", ether_dhost),
@@ -1124,6 +1126,7 @@ const struct proto_desc proto_netdev = {
 		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
 		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
 		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+		PROTO_LINK(__constant_htons(ETH_P_8021AD),	&proto_vlan),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
-- 
2.26.3

