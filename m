From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] bridge reject fixes
Date: Tue, 28 Oct 2014 14:38:49 +0100
Message-ID: <1414503534-10324-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, stephen@networkplumber.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56638 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaJ1Nhb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:37:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I made an early design mistake by adding support for bridge reject that
relies on the IP stack, that was not a good idea. So this patchset
amends the situation by:

1) Refactoring common code that can be reused to forge the reject packets
   now available at nf_reject_ipv4 and nf_reject_ipv6 from the bridge stack.

2) Forge the reject packets (TCP and ICMP dest unreach) that are injected
   into the bridge stack using br_deliver() to the bridge port origin.

So the idea is to avoid any interaction with the IP stack, that has been
causing us problems specifically in the br_netfilter code. This also
aims to provide a native replacement to the use of iptables ... -j REJECT
from br_netfilter.

Note that I have restricted the reject expression to bridge prerouting and
input. Otherwise, I think we may send several reject reject packets when
there is no destination yet in the bridge fdb.

Comments welcome. Thanks.

Pablo Neira Ayuso (5):
  netfilter: nf_tables_bridge: update hook_mask to allow {pre,post}routing
  netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions
  netfilter: nf_reject_ipv6: split nf_send_reset6() in smaller functions
  netfilter: nft_reject_bridge: don't use IP stack to reject traffic
  netfilter: nft_reject_bridge: restrict reject to prerouting and input

 include/net/netfilter/ipv4/nf_reject.h   |   10 +
 include/net/netfilter/ipv6/nf_reject.h   |   10 +
 net/bridge/br_forward.c                  |    1 +
 net/bridge/netfilter/nf_tables_bridge.c  |    6 +-
 net/bridge/netfilter/nft_reject_bridge.c |  296 ++++++++++++++++++++++++++++--
 net/ipv4/netfilter/nf_reject_ipv4.c      |   88 ++++++---
 net/ipv6/netfilter/nf_reject_ipv6.c      |  174 +++++++++++-------
 7 files changed, 480 insertions(+), 105 deletions(-)

-- 
1.7.10.4

