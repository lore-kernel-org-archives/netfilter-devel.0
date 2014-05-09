From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 00/15 RFC] per-netns sysctl for br_netfilter
Date: Sat, 10 May 2014 01:26:28 +0400
Message-ID: <536D4804.2060801@parallels.com>
References: <536A8054.90201@pandora.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:38598 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbaEIV2m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:28:42 -0400
In-Reply-To: <536A8054.90201@pandora.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set implements per-netns sysctl for br_netfilter.

I would be very grateful for any feedback and improvement recommendations.

I'm not sure is it safe to use dev_net(skb->dev) to get reference to net namespace
(see patches 11-15 for details), however I expect that skb inside bridge
should have correct reference to device.

Vasily Averin (15):
 1 br_netfilter: brnf_net structure definition
 2 br_netfilter: default settings in init_brnf_net
 3 br_netfilter: switch sysctl nf_call_arptables to init_brnf_net
 4 br_netfilter: switch sysctl nf_call_iptables to init_brnf_net
 5 br_netfilter: switch sysctl nf_call_ip6tables to init_brnf_net
 6 br_netfilter: switch sysctl filter_vlan_tagged to init_brnf_net
 7 br_netfilter: switch sysctl filter_pppoe_tagged to init_brnf_net
 8 br_netfilter: switch sysctl pass_vlan_indev to init_brnf_net
 9 br_netfilter: pernet_operations brnf_net_ops without per-netns sysctl
    registration
10 br_netfilter: added per-netns sysctl registration
11 br_netfilter: switch sysctl nf_call_arptables to per-netns processing
12 br_netfilter: switch sysctls nf_call_iptables and nf_call_ip6tables
    to per-netns processing
13 br_netfilter: switch sysctl filter_vlan_tagged to per-netns
    processing
14 br_netfilter: switch sysctl filter_pppoe_tagged to per-netns
    processing
15 br_netfilter: switch sysctl pass_vlan_indev to per-netns processing

 net/bridge/br_netfilter.c |  168 ++++++++++++++++++++++++++++++++-------------
 net/bridge/br_private.h   |   15 ++++
 2 files changed, 136 insertions(+), 47 deletions(-)

-- 
1.7.5.4

