Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DC4C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 08:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D53E619AB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 08:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCaI7R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 04:59:17 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:37238 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhCaI6v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 04:58:51 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2021 04:58:51 EDT
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 1528FE02B9E;
        Wed, 31 Mar 2021 16:53:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: fix set software outdev on top of the net_device_path_stack
Date:   Wed, 31 Mar 2021 16:53:43 +0800
Message-Id: <1617180823-21881-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZShpLGkIYHksYSh9LVkpNSkxKQ0tDSU9ITEpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PyI6KQw5Iz0*NQpLCAEJDh8o
        KS8KCxNVSlVKTUpMSkNLQ0lPTU9KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlIQk83Bg++
X-HM-Tid: 0a78877d124b20bdkuqy1528fe02b9e
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The outdev of nft_forward_info should be set on the top of stack device.
Such the following case:
br0 is a bridge with pvid 100 and veth is in the vlan 100 without untagged

ip l add dev br0 type bridge vlan_filtering 1
brctl addif br0 veth
bridge vlan add dev veth vid 100
bridge vlan add dev br0 vid 100 pvid untagged self

The net device path should be br0-->veth
The software offload doesn't encap the vlan tag and the outdev should
be the top device in the stack(route device).
So thehe outdev for softeware offload should set on br0 but not veth.
Or the vlan didn't tagged outgoing through veth

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_flow_offload.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4843dd2..53f641b 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -119,7 +119,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			info->outdev = path->dev;
+			if (!info->outdev)
+				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
@@ -129,6 +130,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+			if (!info->outdev)
+				info->outdev = path->dev;
 
 			switch (path->bridge.vlan_mode) {
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
-- 
1.8.3.1

