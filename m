Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D519C38A24
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD54E2070B
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 09:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgEFJqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 05:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726935AbgEFJqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 05:46:47 -0400
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA76C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 02:46:47 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 3B62D201E7;
        Wed,  6 May 2020 11:46:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 0E03D6221;
        Wed,  6 May 2020 11:46:44 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zoqHig2zH8ll; Wed,  6 May 2020 11:46:43 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Wed,  6 May 2020 11:46:43 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 7BF52306A950; Wed,  6 May 2020 11:46:43 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 3/3] netfilter: enable reject with bridge vlan
Date:   Wed,  6 May 2020 11:46:25 +0200
Message-Id: <1b723dbc8a1a5124794bc3deb7dedf8d46dafcbc.1588758255.git.michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1588758255.git.michael-dev@fami-braun.de>
References: <cover.1588758255.git.michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, using the bridge reject target with tagged packets
results in untagged packets being sent back.

Fix this by mirroring the vlan id as well.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/bridge/netfilter/nft_reject_bridge.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index b325b569e761..f48cf4cfb80f 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -31,6 +31,12 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	ether_addr_copy(eth->h_dest, eth_hdr(oldskb)->h_source);
 	eth->h_proto = eth_hdr(oldskb)->h_proto;
 	skb_pull(nskb, ETH_HLEN);
+
+	if (skb_vlan_tag_present(oldskb)) {
+		u16 vid = skb_vlan_tag_get(oldskb);
+
+		__vlan_hwaccel_put_tag(nskb, oldskb->vlan_proto, vid);
+	}
 }
 
 static int nft_bridge_iphdr_validate(struct sk_buff *skb)
-- 
2.20.1

