From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 00/11] per-netns sysctl for br_netfilter
Date: Mon, 12 May 2014 16:56:37 +0400
Message-ID: <5370C505.5040405@parallels.com>
References: <536FD0FD.8010204@pandora.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:43761 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbaELM5r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:57:47 -0400
In-Reply-To: <536FD0FD.8010204@pandora.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Bart,
thank you for feedback, I've reworked patch set to fix your notes.

This patch set enables per network namespace managemnt for br_netfiltes sysctls,
it allows to enable processing br-nf-call hooks in one network namespace 
and keep it disabled in another ones.

v2: removed extra overhead for CONFIG_SYSCTL=n

Vasily Averin (11):
 1 br_netfilter: brnf_net structure for sysctl setting
 2 br_netfilter: default sysctl settings in init_brnf_net
 3 br_netfilter: brnf_flag macro
 4 br_netfilter: switch sysctl call_arptables to init_brnf_net
 5 br_netfilter: switch sysctls call_iptables call_ip6tables to init_brnf_net
 6 br_netfilter: switch sysctl filter_vlan_tagged to init_brnf_net
 7 br_netfilter: switch sysctl filter_pppoe_tagged to init_brnf_net
 8 br_netfilter: switch sysctl pass_vlan_indev to init_brnf_net
 9 br_netfilter: pernet_operations brnf_net_opts without sysctl registration
10 br_netfilter: per-netns sysctl registration
11 br_netfilter: switch all sysctls to per-netns processing

 net/bridge/br_netfilter.c |  155 ++++++++++++++++++++++++++++++++++-----------
 net/bridge/br_private.h   |   13 ++++
 2 files changed, 130 insertions(+), 38 deletions(-)

-- 
1.7.5.4

