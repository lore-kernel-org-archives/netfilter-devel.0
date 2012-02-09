From: pablo@netfilter.org
Subject: [PATCH 0/6] [RFC] ctnetlink updates for net-next
Date: Thu,  9 Feb 2012 20:33:01 +0100
Message-ID: <1328815987-28020-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57789 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422Ab2BITdX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:33:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

The following are six patches for ctnetlink, four of them to finish
the expectation support (this is required by conntrackd, next version
will support expectation synchronization).

Two of them allows you to filter dumpings by mark. So we save cycles
on building and parsing messages. One for netlink itself, to allow
passing the filtering data (or whatever any other data you want to
pass to the ->dump and ->done callbacks).

Let me know if you have any comment. I'll push the to my tree if
nobody complains in the following days.

Thank you!

Pablo Neira Ayuso (6):
  netfilter: ctnetlink: allow to set helper for new expectations
  netfilter: ctnetlink: allow to set expectation class
  netfilter: ctnetlink: add NAT support for expectations
  netfilter: ctnetlink: allow to set expectfn for expectations
  netlink: netlink_dump_start may take data pointer for callbacks
  netfilter: ctnetlink: support kernel-space dump filterings

 crypto/crypto_user.c                          |    2 +-
 drivers/infiniband/core/netlink.c             |    2 +-
 include/linux/netfilter/nfnetlink_conntrack.h |   12 ++
 include/linux/netlink.h                       |    2 +
 include/net/netfilter/nf_conntrack_helper.h   |   13 ++
 net/core/rtnetlink.c                          |    2 +-
 net/ipv4/inet_diag.c                          |    4 +-
 net/ipv4/netfilter/nf_nat_core.c              |    8 ++
 net/ipv4/netfilter/nf_nat_h323.c              |   14 +++
 net/ipv4/netfilter/nf_nat_sip.c               |    7 +
 net/netfilter/ipset/ip_set_core.c             |    2 +-
 net/netfilter/nf_conntrack_helper.c           |   54 +++++++++
 net/netfilter/nf_conntrack_netlink.c          |  157 +++++++++++++++++++++++-
 net/netfilter/nfnetlink_acct.c                |    2 +-
 net/netlink/af_netlink.c                      |    2 +
 net/netlink/genetlink.c                       |    2 +-
 net/unix/diag.c                               |    2 +-
 net/xfrm/xfrm_user.c                          |    2 +-
 18 files changed, 272 insertions(+), 17 deletions(-)

-- 
1.7.7.3

