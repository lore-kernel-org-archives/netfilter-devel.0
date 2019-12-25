Return-Path: <SRS0=NQ4I=2P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B36C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Dec 2019 09:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410D620722
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Dec 2019 09:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfLYJuc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Dec 2019 04:50:32 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:31320 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfLYJuc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Dec 2019 04:50:32 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 60024419EA;
        Wed, 25 Dec 2019 17:50:27 +0800 (CST)
Subject: Re: [PATCH nf-next v3 0/4] netfilter: nf_flow_table_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1575962785-14812-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <9f5857b4-d194-378a-877b-378329c5dc8b@ucloud.cn>
Date:   Wed, 25 Dec 2019 17:50:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575962785-14812-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSk1LS0tLS0NOQ0hLTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mio6Ehw6PTg*OUIVGhcqKBRL
        KBwKCypVSlVKTkxMSU1MT0lMTklOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0hJSTcG
X-HM-Tid: 0a6f3c76f8832086kuqy60024419ea
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Please drop this. I will repost new one with some bug fix in with net-next tree. Thanks


BR

wenxu

On 12/10/2019 3:26 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch provide tunnel offload based on route lwtunnel. 
> The first two patches support indr callback setup
> Then add tunnel match and action offload
>
> Test with mlx driver as following:
>
> ip link add user1 type vrf table 1
> ip l set user1 up 
> ip l set dev mlx_pf0vf0 down
> ip l set dev mlx_pf0vf0 master user1
> ifconfig mlx_pf0vf0 10.0.0.1/24 up
>
> ifconfig mlx_p0 172.168.152.75/24 up
>
> ip l add dev tun1 type gretap key 1000
> ip l set dev tun1 master user1
> ifconfig tun1 10.0.1.1/24 up
>
> ip r r 10.0.1.241 encap ip id 1000 dst 172.168.152.241 key dev tun1 table 1
>
> nft add table firewall
> nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "mlx_pf0vf0" : 1 }
> nft add chain firewall rule-1000-ingress
> nft add rule firewall rule-1000-ingress ct zone 1 ct state established,related counter accept
> nft add rule firewall rule-1000-ingress ct zone 1 ct state invalid counter drop
> nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 5001 ct state new counter accept
> nft add rule firewall rule-1000-ingress ct zone 1 udp dport 5001 ct state new counter accept
> nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
> nft add rule firewall rule-1000-ingress ct zone 1 ip protocol icmp ct state new counter accept
> nft add rule firewall rule-1000-ingress counter drop
> nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
> nft add rule firewall rules-all meta iifkind "vrf" counter accept
> nft add rule firewall rules-all iif vmap { "tun1" : jump rule-1000-ingress }
>
> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1, mlx_pf0vf0 } \; }
> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1
>
> This version rebase on the following upstream fixes:
>
> netfilter: nf_flow_table_offload: Fix block setup as TC_SETUP_FT cmd
> netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
> netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat
> netfilter: nf_flow_table_offload: add IPv6 match description
> netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle()
>
>
> wenxu (4):
>   netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
>     to support indir setup
>   netfilter: nf_flow_table_offload: add indr block setup support
>   netfilter: nf_flow_table_offload: add tunnel match offload support
>   netfilter: nf_flow_table_offload: add tunnel encap/decap action
>     offload support
>
>  net/netfilter/nf_flow_table_offload.c | 253 +++++++++++++++++++++++++++++++---
>  1 file changed, 236 insertions(+), 17 deletions(-)
>
