Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9495C761A8
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B59922CBD
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbfGYKnG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:43:06 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:46081 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387643AbfGYKnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:43:05 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0CF9A41A48;
        Thu, 25 Jul 2019 18:42:57 +0800 (CST)
Subject: Re: [PATCH nf-next 3/7] netfilter: nft_table_offload: Add rtnl for
 chain and rule operations
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1563886364-11164-1-git-send-email-wenxu@ucloud.cn>
 <1563886364-11164-4-git-send-email-wenxu@ucloud.cn>
 <20190725094826.kv7cvjsiykuwr6em@salvia>
 <20190725101412.ubkqqzjkftrajnmx@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b884ca6c-ce62-494d-06b5-9793e5e41f22@ucloud.cn>
Date:   Thu, 25 Jul 2019 18:42:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725101412.ubkqqzjkftrajnmx@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSU5NS0tLS09KQk1KTUxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mgg6SRw6DTgwUVYtDRoqTBdJ
        FyMaC0hVSlVKTk1PS05KSExMSkJJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEtMSTcG
X-HM-Tid: 0a6c28ba0bf32086kuqy0cf9a41a48
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/25/2019 6:14 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Tue, Jul 23, 2019 at 08:52:40PM +0800, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> The nft_setup_cb_call and ndo_setup_tc callback should be under rtnl lock
>>>
>>> or it will report:
>>> kernel: RTNL: assertion failed at
>>> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c (635)
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>>  net/netfilter/nf_tables_offload.c | 16 ++++++++++++----
>>>  1 file changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>>> index 33543f5..3e1a1a8 100644
>>> --- a/net/netfilter/nf_tables_offload.c
>>> +++ b/net/netfilter/nf_tables_offload.c
>>> @@ -115,14 +115,18 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
>>>  			     enum tc_setup_type type, void *type_data)
>>>  {
>>>  	struct flow_block_cb *block_cb;
>>> -	int err;
>>> +	int err = 0;
>>>  
>>> +	rtnl_lock();
>> Please, have a look at 90d2723c6d4cb2ace50fc3b932a2bcc77710450b and
>> review if this assumption is correct. Probably nfnl_lock() is missing
>> from __nft_release_basechain().
> The mlx driver has a ASSERT_RTNL() in the mlx5e_rep_indr_setup_tc_block()
> callpath.  Or are you proposing to remove that assertion?  If so, what
> lock should protect the callback lists?
yes, most of the setup_tc callback in mlx driver has a 

ASSERT_RTNL() directly or indirectly. Maybe remove this is a good idear

>
>
