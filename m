Return-Path: <SRS0=YpW3=ZI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF1CC432C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 08:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F84820723
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 08:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfKPIG1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 03:06:27 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12931 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfKPIG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 03:06:26 -0500
Received: from [192.168.1.6] (unknown [101.81.112.54])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7D83741627;
        Sat, 16 Nov 2019 16:06:22 +0800 (CST)
Subject: Re: [PATCH nf-next 0/4] netfilter: nf_flow_table_offload: support
 tunnel match
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
 <20191115214827.lyu35l2y3nqusplh@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <eb382034-7462-ef2c-4b76-518c488771f8@ucloud.cn>
Date:   Sat, 16 Nov 2019 16:06:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191115214827.lyu35l2y3nqusplh@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUxDS0tLSUpKTEpOTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDo6URw4FDg9PQoDH1YUGS0Y
        GgwKCSNVSlVKTkxIQ0JKTkNISU9KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVKSklVTk9ZV1kIAVlBSU1DSzcG
X-HM-Tid: 0a6e733faa712086kuqy7d83741627
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/11/16 5:48, Pablo Neira Ayuso 写道:
> On Fri, Nov 15, 2019 at 08:03:26PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide tunnel offload based on route lwtunnel. 
>> The first two patches support indr callback setup
>> Then add tunnel match and action offload
> Could you provide a configuration script for this tunnel setup?
>
> Thanks.


The following is a simple configure for tunnel offload forward


ip link add dev gre_sys type gretap key 1000

ip link add user1 type vrf table 1

ip l set dev gre1000 master user1

ip l set dev vf master user1

ip r a 10.0.0.7 dev vf table 1
ip r a default via 10.0.0.100 encap ip id 1000 dst 172.168.0.7 key dev gre1000 table 1 onlink

nft add flowtable firewall fb1 { hook ingress priority 0 \;  flags offload \; devices = { gre1000, vf } \; }



>
>> This patch is based on 
>> http://patchwork.ozlabs.org/patch/1194247/
>> http://patchwork.ozlabs.org/patch/1195539/
>>
>> wenxu (4):
>>   netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
>>     to support indir setup
>>   netfilter: nf_flow_table_offload: add indr block setup support
>>   netfilter: nf_flow_table_offload: add tunnel match offload support
>>   netfilter: nf_flow_table_offload: add tunnel encap/decap action
>>     offload support
>>
>>  net/netfilter/nf_flow_table_offload.c | 240 +++++++++++++++++++++++++++++++---
>>  1 file changed, 223 insertions(+), 17 deletions(-)
>>
>> -- 
>> 1.8.3.1
>>
