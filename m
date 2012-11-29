From: pablo@netfilter.org
Subject: [PATCH 0/2] improve conntrack object traceability
Date: Thu, 29 Nov 2012 14:51:20 +0100
Message-ID: <1354197082-8431-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37734 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab2K2Nvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:51:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

The following patchset modifies the conntrack subsystem to ensure
that nf_conn objects are always inserted in any of the existing
lists, they are: the hashtable, the unconfirmed and the dying lists.

ctnetlink is also extended to allow to dump their content. I know of
people debugging issues using simple scripts like these below:

DYING=`conntrack -L dying | wc -l`
ACTIVE=`conntrack -L | wc -l`
UNCONFIRMED=`conntrack -L unconfirmed | wc -l`
TOTAL=`conntrack -C`

echo "dying: $DYING"
echo "active: $ACTIVE"
echo "unconfirmed: $UNCONFIRMED"
SUM=$(($DYING + $ACTIVE + $UNCONFIRMED))
echo "sum: $SUM"
echo "total: $TOTAL"

So you can track that the active+dying+unconfirmed don't deviate
too much from global conntrack object counter.

I needed to slightly change the current behaviour so all objects
are inserted in the dying list while running through the destroy
path. Before this, this list was only used in conntrackd with
reliable event reporting were in using.

Pablo Neira Ayuso (2):
  netfilter: nf_conntrack: improve nf_conn object traceability
  netfilter: ctnetlink: dump entries from the dying and unconfirmed lists

 include/net/netfilter/nf_conntrack.h               |    2 +-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    2 +
 net/netfilter/nf_conntrack_core.c                  |   25 ++---
 net/netfilter/nf_conntrack_netlink.c               |  110 +++++++++++++++++++-
 4 files changed, 121 insertions(+), 18 deletions(-)

-- 
1.7.10.4

