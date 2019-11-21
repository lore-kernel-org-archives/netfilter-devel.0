Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073C7C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F1B2075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfKUMgy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:36:54 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:2613 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfKUMgy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 07:36:54 -0500
Received: from [192.168.1.4] (unknown [116.237.146.20])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id F260741ACA;
        Thu, 21 Nov 2019 20:36:50 +0800 (CST)
Subject: Re: [PATCH nf-next v2 0/4] netfilter: nf_flow_table_offload: support
 tunnel offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, Paul Blakey <paulb@mellanox.com>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <6f29e69d-6dba-6b6b-b73a-05a6084c3b42@ucloud.cn>
Date:   Thu, 21 Nov 2019 20:36:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSU9NS0tLS05KT0JDT0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Py46Fjo6Czg#KQ8rIjAUTRIc
        GAkKCghVSlVKTkxPSEhCQ0pKSkJDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk9NVUlLWVdZCAFZQUhMTUo3Bg++
X-HM-Tid: 0a6e8df717352086kuqyf260741aca
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cc Paul

在 2019/11/21 17:54, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch provide tunnel offload based on route lwtunnel. 
> The first two patches support indr callback setup
> Then add tunnel match and action offload
>
> The version already test with mlx driver as following:
>
> ip link add user1 type vrf table 1
> ip l set user1 up 
> ip l set dev mlx_pf0vf1 down
> ip l set dev mlx_pf0vf1 master user1
> ifconfig mlx_pf0vf1 10.0.0.1/24 up
>
> ifconfig mlx_p0 172.168.152.75/24 up
>
> ip l add dev tun1 type gretap external
> ip l set dev tun1 master user1
> ifconfig tun1 10.0.1.1/24 up
>
> ip r r 10.0.0.75 dev mlx_pf0vf1 table 1
> ip r r 10.0.1.241 encap ip id 1000 dst 172.168.152.241 key dev tun1 table 1
>
> nft add table firewall
> nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "mlx_pf0vf1" : 1 }
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
> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { mlx_pf0vf1, tun1 } \; }
> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
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
