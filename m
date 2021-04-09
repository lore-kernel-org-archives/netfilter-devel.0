Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F321AC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 14:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52C461185
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 14:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhDIO24 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:28:56 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:59270 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhDIO24 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 10:28:56 -0400
Received: from [192.168.1.10] (unknown [180.157.172.243])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 2FC90E02918;
        Fri,  9 Apr 2021 22:28:30 +0800 (CST)
Subject: Re: [PATCH nf v2] netfilter: nft_payload: fix the
 h_vlan_encapsulated_proto flow_dissector vlaue
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1617944629-10338-1-git-send-email-wenxu@ucloud.cn>
 <20210409082717.GA9793@salvia> <20210409093106.GA10639@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <80137d78-801e-77b3-7a32-f1ff326dcd26@ucloud.cn>
Date:   Fri, 9 Apr 2021 22:28:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20210409093106.GA10639@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHktDQkpNHUNNHR4dVkpNSkxCTENOSktITk9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6KRw4HT04F0g*Niw1LjMf
        NikKCTZVSlVKTUpMQkxDTkpLTkpJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSkxJVUlPSFlXWQgBWUFNT01LNwY+
X-HM-Tid: 0a78b708cbbc20bdkuqy2fc90e02918
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2021/4/9 17:31, Pablo Neira Ayuso 写道:
> On Fri, Apr 09, 2021 at 10:27:17AM +0200, Pablo Neira Ayuso wrote:
>> On Fri, Apr 09, 2021 at 01:03:49PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> For the vlan packet the h_vlan_encapsulated_proto should be set
>>> on the flow_dissector_key_basic->n_porto flow_dissector.
>>>
>>> Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
>>> Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>>  net/netfilter/nft_payload.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
>>> index cb1c8c2..84c5ecc 100644
>>> --- a/net/netfilter/nft_payload.c
>>> +++ b/net/netfilter/nft_payload.c
>>> @@ -233,8 +233,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
>>>  		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
>>>  			return -EOPNOTSUPP;
>>>  
>>> -		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
>>> -				  vlan_tpid, sizeof(__be16), reg);
>>> +		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
>>> +				  n_proto, sizeof(__be16), reg);
>> nftables already sets KEY_BASIC accordingly to 0x8100.
>>
>> # nft --debug=netlink add rule netdev x y vlan id 100
>> netdev
>>   [ meta load iiftype => reg 1 ]
>>   [ cmp eq reg 1 0x00000001 ]
>>   [ payload load 2b @ link header + 12 => reg 1 ]
>>   [ cmp eq reg 1 0x00000081 ] <----------------------------- HERE
>>   [ payload load 2b @ link header + 14 => reg 1 ]
>>   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
>>   [ cmp eq reg 1 0x00006400 ]
>>
>> What are you trying to fix?

First the vlan_tpid of KEY_VLAN is not the representation h_vlan_encapsulated_proto, So this

need be fixed. Just see the fl_set_key in the cls_flower.c

fl_set_key-->fl_set_key_vlan(pass the ethernet type of vlan to the vlan_tpid which normal is 0x8100)


Then if the rule match the h_vlan_encapsulated_proto(normally ipv4/6), The h_vlan_encapsulated_proto

will be set to the n_proto of BASIC_KEY. Also see the fl_set_key in the cls_flower.c


     if (tb[TCA_FLOWER_KEY_ETH_TYPE]) {
                ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_ETH_TYPE]);

                if (eth_type_vlan(ethertype)) {
                        fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
                                        TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
                                        &mask->vlan);

                        if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {  <----------------------------- HERE

                                ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
                                if (eth_type_vlan(ethertype)) {
                                        fl_set_key_vlan(tb, ethertype,
                                                        TCA_FLOWER_KEY_CVLAN_ID,
                                                        TCA_FLOWER_KEY_CVLAN_PRIO,
                                                        &key->cvlan, &mask->cvlan);
                                        fl_set_key_val(tb, &key->basic.n_proto,
                                                       TCA_FLOWER_KEY_CVLAN_ETH_TYPE, <----------------------------- HERE
                                                       &mask->basic.n_proto,
                                                       TCA_FLOWER_UNSPEC,
                                                       sizeof(key->basic.n_proto));
                                } else {
                                        key->basic.n_proto = ethertype;  <----------------------------- HERE

                                        mask->basic.n_proto = cpu_to_be16(~0);
                                }   
                        }   
                } else {
                        key->basic.n_proto = ethertype;
                        mask->basic.n_proto = cpu_to_be16(~0);
                }   
        }   


BR

wenxu

> Could you provide a rule that works for tc offload with vlan? I'd like
> to check what internal representation is triggering in the kernel.
>
