Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B212C433EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8FF619EE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhCXBbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbhCXBbQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:31:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36B59C061763;
        Tue, 23 Mar 2021 18:31:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 871FA63128;
        Wed, 24 Mar 2021 02:31:07 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 11/24] netfilter: flowtable: add bridge vlan filtering support
Date:   Wed, 24 Mar 2021 02:30:42 +0100
Message-Id: <20210324013055.5619-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add the vlan tag based when PVID is set on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/netfilter/nft_flow_offload.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 8392b1a8108b..651364d93efd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -111,6 +111,18 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
+			switch (path->bridge.vlan_mode) {
+			case DEV_PATH_BR_VLAN_TAG:
+				info->encap[info->num_encaps].id = path->bridge.vlan_id;
+				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
+				info->num_encaps++;
+				break;
+			case DEV_PATH_BR_VLAN_UNTAG:
+				info->num_encaps--;
+				break;
+			case DEV_PATH_BR_VLAN_KEEP:
+				break;
+			}
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
-- 
2.20.1

