Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDBAC0650E
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 14:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B305C20828
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 14:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfGFO33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 10:29:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50328 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfGFO33 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 10:29:29 -0400
Received: from [192.168.1.3] (unknown [58.37.149.201])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2F1AB416E5;
        Sat,  6 Jul 2019 22:29:26 +0800 (CST)
Subject: Re: [PATCH nf-next v2] netfilter:nft_meta: add NFT_META_VLAN support
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562332598-17415-1-git-send-email-wenxu@ucloud.cn>
 <1562332598-17415-7-git-send-email-wenxu@ucloud.cn>
 <caaaa242-6bb8-9d5e-af66-a0cd6592f81d@cumulusnetworks.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <83e9506d-8888-f841-f16c-0d038e52b39e@ucloud.cn>
Date:   Sat, 6 Jul 2019 22:29:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <caaaa242-6bb8-9d5e-af66-a0cd6592f81d@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS05DS0tLSElNSk5NTUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kxg6FBw6Kjg0Mg89LxY1VkhI
        FQ4wCkNVSlVKTk1JT0lISE1NSENDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhM
        VUpPQlVJS0pZV1kIAVlBSUNOSzcG
X-HM-Tid: 0a6bc7b092b52086kuqy2f1ab416e5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/7/6 20:02, Nikolay Aleksandrov 写道:
> On 05/07/2019 16:16, wenxu@ucloud.cn wrote:
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
>>  net/netfilter/nft_meta.c                 | 25 +++++++++++++++++++++++++
>>  3 files changed, 33 insertions(+), 1 deletion(-)
>>
> The patch looks fine, just a note: you'll only be able to work with the
> outer tag, so guessing to achieve a double-tagged frame you'll have to
> add another NFT_META_VLAN_INNER(?) and will have to organize them one
> after another.

yes, It's just set/mangle the meta vlan data. 
I think it's a good idear for stacked tagged with NFT_META_VLAN_INNER, in 
this case it should check the the proto of vlan tag already on packet
There are three case:
1. packet already contain a vlan header with proto 0x88a8, it should push the inner vlan tag
2. there is no outer vlan tag, maybe we should add a inner 0x8100 tag 
and outer 0x88a8 tag?
3.  packet already contain a vlan tag with proto 0x8100, push the vlan tag and add outer 0x88a8 tag ?

>
>
>
