Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A73C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 08:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 458A72071E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 08:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfLZIbS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 03:31:18 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9678 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfLZIbS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 03:31:18 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 16F6A41B40;
        Thu, 26 Dec 2019 16:31:13 +0800 (CST)
Subject: Re: [PATCH nf-next v3 0/4] netfilter: nf_flow_table_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1575962785-14812-1-git-send-email-wenxu@ucloud.cn>
 <9f5857b4-d194-378a-877b-378329c5dc8b@ucloud.cn>
Message-ID: <ac01e1c8-ef7e-4dd7-4289-1975b580db47@ucloud.cn>
Date:   Thu, 26 Dec 2019 16:31:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9f5857b4-d194-378a-877b-378329c5dc8b@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0tCS0tLSk5DSEtCQk9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBQ6Fio5ITg1GjorKhI6DVER
        SQgKCwxVSlVKTkxMSE9CS0xISUNLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0xKSTcG
X-HM-Tid: 0a6f4154c90a2086kuqy16f6a41b40
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Sorry for trouble you, please Keep this series.

The bug I mention does not relate to this series. It should be fixed in net-next tree. Thx!


BR

wenxu

On 12/25/2019 5:50 PM, wenxu wrote:
> Hi pablo,
>
>
> Please drop this. I will repost new one with some bug fix in with net-next tree. Thanks
>
>
> BR
>
> wenxu
>
> On 12/10/2019 3:26 PM, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide tunnel offload based on route lwtunnel. 
>> The first two patches support indr callback setup
>> Then add tunnel match and action offload
>>
>> Test with mlx driver as following:
>>
>> ip link add user1 type vrf table 1
>> ip l set user1 up 
>> ip l set dev mlx_pf0vf0 down
>> ip l set dev mlx_pf0vf0 master user1
>> ifconfig mlx_pf0vf0 10.0.0.1/24 up
>>
>> ifconfig mlx_p0 172.168.152.75/24 up
>>
>> ip l add dev tun1 type gretap key 1000
>> ip l set dev tun1 master user1
>> ifconfig tun1 10.0.1.1/24 up
>>
>> ip r r 10.0.1.241 encap ip id 1000 dst 172.168.152.241 key dev tun1 table 1
>>
>> nft add table firewall
>> nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
>> nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "mlx_pf0vf0" : 1 }
>> nft add chain firewall rule-1000-ingress
>> nft add rule firewall rule-1000-ingress ct zone 1 ct state established,related counter accept
>> nft add rule firewall rule-1000-ingress ct zone 1 ct state invalid counter drop
>> nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 5001 ct state new counter accept
>> nft add rule firewall rule-1000-ingress ct zone 1 udp dport 5001 ct state new counter accept
>> nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
>> nft add rule firewall rule-1000-ingress ct zone 1 ip protocol icmp ct state new counter accept
>> nft add rule firewall rule-1000-ingress counter drop
>> nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
>> nft add rule firewall rules-all meta iifkind "vrf" counter accept
>> nft add rule firewall rules-all iif vmap { "tun1" : jump rule-1000-ingress }
>>
>> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1, mlx_pf0vf0 } \; }
>> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
>> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
>> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1
>>
>> This version rebase on the following upstream fixes:
>>
>> netfilter: nf_flow_table_offload: Fix block setup as TC_SETUP_FT cmd
>> netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
>> netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat
>> netfilter: nf_flow_table_offload: add IPv6 match description
>> netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle()
>>
>>
>> wenxu (4):
>>   netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
>>     to support indir setup
>>   netfilter: nf_flow_table_offload: add indr block setup support
>>   netfilter: nf_flow_table_offload: add tunnel match offload support
>>   netfilter: nf_flow_table_offload: add tunnel encap/decap action
>>     offload support
>>
>>  net/netfilter/nf_flow_table_offload.c | 253 +++++++++++++++++++++++++++++++---
>>  1 file changed, 236 insertions(+), 17 deletions(-)
>>
>
