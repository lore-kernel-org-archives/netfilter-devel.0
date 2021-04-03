Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C36C433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 15:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23254611C0
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 15:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhDCPAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Apr 2021 11:00:03 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:50210 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhDCPAD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Apr 2021 11:00:03 -0400
Received: from [192.168.1.8] (unknown [180.157.172.243])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 1D1C5E02340;
        Sat,  3 Apr 2021 22:59:57 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_payload: fix vlan_tpid get from
 h_vlan_proto
From:   wenxu <wenxu@ucloud.cn>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1617347632-19283-1-git-send-email-wenxu@ucloud.cn>
 <20210402195403.GA22049@salvia>
 <6ce0f16c-69ae-265a-bea8-bc2c4705dd5b@ucloud.cn>
Message-ID: <920cc175-3bc9-912c-6d00-5e6bd02d546a@ucloud.cn>
Date:   Sat, 3 Apr 2021 22:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <6ce0f16c-69ae-265a-bea8-bc2c4705dd5b@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQkgZTE8fGk1JHR4ZVkpNSkxPTUpCQkxJTkJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjY6OTo4Kj00OQwQMjc4ARNI
        CT8wChRVSlVKTUpMT01KQkJMSEJJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSkxJVUlPSFlXWQgBWUFIQ0xNNwY+
X-HM-Tid: 0a78983f6e8f20bdkuqy1d1c5e02340
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2021/4/3 21:33, wenxu 写道:
> 在 2021/4/3 3:54, Pablo Neira Ayuso 写道:
>> On Fri, Apr 02, 2021 at 03:13:52PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> vlan_tpid of flow_dissector_key_vlan should be set as h_vlan_proto
>>> but not h_vlan_encapsulated_proto.
>> Probably this patch instead?
> I don't think so.  The vlan_tpid in flow_dissector_key_vlan should be the
>
> vlan proto (such as ETH_P_8021Q or ETH_P_8021AD) but not h_vlan_encapsulated_proto (for next header proto).
>
> But this is a problem that the vlan_h_proto is the same as offsetof(struct ethhdr, h_proto)


The design of flow_dissector_key_basic->n_porto should be set as next header proto(ipv4/6)

for vlan packet which is h_vlan_encapsulated_proto in the vlan header. (check from fl_set_key and skb_flow_dissect)

Maybe the patch should as following?

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb1c8c2..84c5ecc 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -233,8 +233,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
                if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
                        return -EOPNOTSUPP;
 
-               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
-                                 vlan_tpid, sizeof(__be16), reg);
+               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
+                                 n_proto, sizeof(__be16), reg);
                nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
                break;
        case offsetof(struct vlan_ethhdr, h_vlan_TCI) + sizeof(struct vlan_hdr):
@@ -249,8 +249,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
                if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
                        return -EOPNOTSUPP;
 
-               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
-                                 vlan_tpid, sizeof(__be16), reg);
+               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
+                                 n_proto, sizeof(__be16), reg);
                break;
        default:
                return -EOPNOTSUPP;

>
>
>
