From: Patrick McHardy <kaber@trash.net>
Subject: netfilter -stable 00/04: Netfilter -stable fixes
Date: Thu, 17 Sep 2009 13:58:25 +0200 (MEST)
Message-ID: <20090917115823.12728.87778.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZIQL6W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:58:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following four patches fix a couple of netfilter regressions:

- inverted logic for persistent NAT mappings, causing source mappings to
  multiple addresses to incorrectly use persistent addresses unless
  configured to do so

- conntrack cleanup in non-init namespaces

- a bridge netfilter in_device refcount leak

- an inverted return value in the ebt_ulog checkentry function, causing
  validation to fail unconditionally

Please apply, thanks!

 net/bridge/br_netfilter.c         |    2 +-
 net/bridge/netfilter/ebt_ulog.c   |    2 +-
 net/ipv4/netfilter/nf_nat_core.c  |    2 +-
 net/netfilter/nf_conntrack_core.c |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

Patrick McHardy (4):
      netfilter: nf_nat: fix inverted logic for persistent NAT mappings
      netfilter: nf_conntrack: netns fix re reliable conntrack event delivery
      netfilter: bridge: refcount fix
      netfilter: ebt_ulog: fix checkentry return value
