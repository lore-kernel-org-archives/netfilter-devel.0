From: pablo@netfilter.org
Subject: [PATCH 0/2] netfilter updates for net tree
Date: Fri, 24 Feb 2012 23:38:22 +0100
Message-ID: <1330123104-3953-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37269 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2BXWij (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:38:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

This patchset revert the previous fix for ctnetlink soft lockup when
the conntrack table is full. There was a race condition between the
possible creation of the conntrack by one packet and ctnetlink itself.
Then it follows the new fix which is complete.

I'm sorry for puzzling, I'll put more care on this next time.

You can pull these changes from:

git://1984.lsi.us.es/net master

Thanks.

Jozsef Kadlecsik (1):
  netfilter: ctnetlink: fix soft lockup when netlink adds new entries
    (v2)

Pablo Neira Ayuso (1):
  Revert "netfilter: ctnetlink: fix soft lockup when netlink adds new
    entries"

 include/net/netfilter/nf_conntrack.h |    2 +-
 net/netfilter/nf_conntrack_core.c    |   38 ++++++++++++++++++++++++++++++---
 net/netfilter/nf_conntrack_netlink.c |   11 +++------
 3 files changed, 39 insertions(+), 12 deletions(-)

-- 
1.7.7.3

