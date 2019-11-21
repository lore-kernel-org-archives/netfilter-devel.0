Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5468EC432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8012067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKUJyW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 04:54:22 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49238 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfKUJyW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 04:54:22 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4DD70419D8;
        Thu, 21 Nov 2019 17:54:17 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 0/4] netfilter: nf_flow_table_offload: support tunnel offload
Date:   Thu, 21 Nov 2019 17:54:12 +0800
Message-Id: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0lCQkJCQklITEtNSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KzY6Qww5PDgzOQ86PEgtCTMD
        KTcwCUJVSlVKTkxPSEhLS05MT0pOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhLTU83Bg++
X-HM-Tid: 0a6e8d6242722086kuqy4dd70419d8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide tunnel offload based on route lwtunnel. 
The first two patches support indr callback setup
Then add tunnel match and action offload

The version already test with mlx driver as following:

ip link add user1 type vrf table 1
ip l set user1 up 
ip l set dev mlx_pf0vf1 down
ip l set dev mlx_pf0vf1 master user1
ifconfig mlx_pf0vf1 10.0.0.1/24 up

ifconfig mlx_p0 172.168.152.75/24 up

ip l add dev tun1 type gretap external
ip l set dev tun1 master user1
ifconfig tun1 10.0.1.1/24 up

ip r r 10.0.0.75 dev mlx_pf0vf1 table 1
ip r r 10.0.1.241 encap ip id 1000 dst 172.168.152.241 key dev tun1 table 1

nft add table firewall
nft add chain firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "mlx_pf0vf1" : 1 }
nft add chain firewall rule-1000-ingress
nft add rule firewall rule-1000-ingress ct zone 1 ct state established,related counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ct state invalid counter drop
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 5001 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 udp dport 5001 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
nft add rule firewall rule-1000-ingress ct zone 1 ip protocol icmp ct state new counter accept
nft add rule firewall rule-1000-ingress counter drop
nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
nft add rule firewall rules-all meta iifkind "vrf" counter accept
nft add rule firewall rules-all iif vmap { "tun1" : jump rule-1000-ingress }

nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { mlx_pf0vf1, tun1 } \; }
nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1

wenxu (4):
  netfilter: nf_flow_table_offload: refactor nf_flow_table_offload_setup
    to support indir setup
  netfilter: nf_flow_table_offload: add indr block setup support
  netfilter: nf_flow_table_offload: add tunnel match offload support
  netfilter: nf_flow_table_offload: add tunnel encap/decap action
    offload support

 net/netfilter/nf_flow_table_offload.c | 253 +++++++++++++++++++++++++++++++---
 1 file changed, 236 insertions(+), 17 deletions(-)

-- 
1.8.3.1

