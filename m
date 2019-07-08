Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4BCC606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F5AD20651
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfGHJbN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 05:31:13 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:23165 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbfGHJbM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 05:31:12 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B7F1C41C75;
        Mon,  8 Jul 2019 17:31:08 +0800 (CST)
Subject: Re: [PATCH nf-next v3] netfilter:nft_meta: add NFT_META_VLAN support
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
 <8dbddc50-c49a-346f-8df7-95d6b460f950@cumulusnetworks.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c0029264-a207-8408-bd17-0f11bced2707@ucloud.cn>
Date:   Mon, 8 Jul 2019 17:31:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <8dbddc50-c49a-346f-8df7-95d6b460f950@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0NLQkJCTEhJS0pMTklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQg6NRw4ETgzGA4yViJDFTQP
        MTdPChlVSlVKTk1JTkxDSU1DQk5JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUxCTTcG
X-HM-Tid: 0a6bd0ec32c02086kuqyb7f1c41c75
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/8/2019 5:20 PM, Nikolay Aleksandrov wrote:
> On 07/07/2019 16:37, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide a meta vlan to set the vlan tag of the packet.
>>
>> for q-in-q outer vlan id 20:
>> meta vlan set 0x88a8:20
>>
>> set the default 0x8100 vlan type with vlan id 20
>> meta vlan set 20
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  include/net/netfilter/nft_meta.h         |  5 ++++-
>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>>  net/netfilter/nft_meta.c                 | 27 +++++++++++++++++++++++++++
>>  3 files changed, 35 insertions(+), 1 deletion(-)
>>
> So mac_len is (mostly) only updated at receive, how do you deal with the
> mac header at egress, specifically if it's a locally originating packet ?
> I think it will be 0 and data will be pointing at the network header, take
> NF_INET_LOCAL_OUT for example.

The nft_meta set mode in the bridge family is only limit for NF_BR_PRE_ROUTING( ingress)


static int nft_meta_set_validate(const struct nft_ctx *ctx,
                 const struct nft_expr *expr,
                 const struct nft_data **data)
{
    struct nft_meta *priv = nft_expr_priv(expr);
    unsigned int hooks;

    if (priv->key != NFT_META_PKTTYPE)
        return 0;

    switch (ctx->family) {
    case NFPROTO_BRIDGE:
        hooks = 1 << NF_BR_PRE_ROUTING;
        break;
 

>
>
>
>
