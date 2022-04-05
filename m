Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6F9C43219
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 21:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiDEVUU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452406AbiDEPyw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 11:54:52 -0400
X-Greylist: delayed 912 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 07:54:07 PDT
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B39972479
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 07:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=FU4Lfv8nRHHmUR+KFU
        vWXrPpiDgMwBrE4j1Bvsidbs4=; b=kn1mRyC382H9sEo6VQxnphxblwKh51Mng1
        0IVT+2M3OfRKd5AI9zWsdUgHCAo8pwACz43EHMPED0PP4KIZ1ygw5j+L02OohJJC
        9FZ/a6L5YNSLKpIjYiwywYlCJvTNdEFL8YOK7vkR61RQIFvCDjkbqsgurDDvK+GL
        ToxGvwlFg=
Received: from CentOS7.localdomain (unknown [101.229.167.205])
        by smtp7 (Coremail) with SMTP id C8CowAAHBhtsVExiGmkxAg--.18061S2;
        Tue, 05 Apr 2022 22:38:36 +0800 (CST)
From:   wenx05124561@163.com
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next] nf_flow_table_offload: offload the vlan encap in the flowtable
Date:   Tue,  5 Apr 2022 10:38:35 -0400
Message-Id: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: C8CowAAHBhtsVExiGmkxAg--.18061S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArWxGFy8Zw1rWF43tryDGFg_yoW5Cry8pF
        45G34rtr4fWFn29wsak3y8ur15urW8CrW3Cw15A3y0yw15Xr1kWFZ5KayxZF4xGFWDtrya
        yF10v34Y9F4DX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UPb1nUUUUU=
X-Originating-IP: [101.229.167.205]
X-CM-SenderInfo: hzhq5iqvrskkiwr6il2tof0z/1tbitxnZK1aEOynHbwABs1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
mode. Xmit the packet with vlan can offload to the real dev directly.

It can support all kinds of VLAN dev path:
br0.100-->br0(vlan filter enable)-->eth
br0(vlan filter enable)-->eth
br0(vlan filter disable)-->eth.100-->eth

The packet xmit and recv offload to the 'eth' in both original and
reply direction.

Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
 net/netfilter/nf_flow_table_ip.c | 19 +++++++++++++++++++
 net/netfilter/nft_flow_offload.c |  7 +++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 32c0eb1..99ae2550 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -282,6 +282,23 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 	return false;
 }
 
+static void nf_flow_encap_push(struct sk_buff *skb,
+			       struct flow_offload_tuple_rhash *tuplehash)
+{
+	int i;
+
+	for (i = 0; i < tuplehash->tuple.encap_num; i++) {
+		switch (tuplehash->tuple.encap[i].proto) {
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
+			skb_vlan_push(skb,
+				      tuplehash->tuple.encap[i].proto,
+				      tuplehash->tuple.encap[i].id);
+			break;
+		}
+	}
+}
+
 static void nf_flow_encap_pop(struct sk_buff *skb,
 			      struct flow_offload_tuple_rhash *tuplehash)
 {
@@ -403,6 +420,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
@@ -659,6 +677,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 		ret = NF_STOLEN;
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 900d48c..f9837c9 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -119,12 +119,15 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
+			if (path->type == DEV_PATH_PPPOE) {
+				info->outdev = path->dev;
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			}
+			if (path->type == DEV_PATH_VLAN)
+				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
-- 
1.8.3.1

