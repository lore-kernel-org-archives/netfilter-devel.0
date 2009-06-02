From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter updates for nf-next tree (2.6.31) (2nd try)
Date: Tue, 02 Jun 2009 20:17:39 +0200
Message-ID: <20090602181336.18573.85368.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbZFBS1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:27:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here it follows the first bunch of updates for your nf-next tree
(2nd try). This patchset is mostly oriented to cleanups and the
conntrack event subsystem.

You can pull this changes from:

git://1984.lsi.us.es/nf-next-2.6 master

This is the first time that I prepare a git tree to be pulled, so
let me know if I'm missing anything!

---

Pablo Neira Ayuso (9):
      netfilter: conntrack: replace notify chain by function pointer
      netfilter: conntrack: simplify event caching system
      netfilter: conntrack: remove events flags from userspace exposed file
      netfilter: conntrack: don't report events on module removal
      netfilter: ctnetlink: cleanup message-size calculation
      netfilter: ctnetlink: use nlmsg_* helper function to build messages
      netfilter: ctnetlink: rename tuple() by nf_ct_tuple() macro definition
      netfilter: ctnetlink: remove nowait parameter from *fill_info()
      netfilter: nfnetlink: cleanup for nfnetlink_rcv_msg() function


 include/linux/netfilter/nf_conntrack_common.h  |   69 ------
 include/linux/netfilter/nfnetlink.h            |    2 
 include/net/netfilter/nf_conntrack.h           |    4 
 include/net/netfilter/nf_conntrack_ecache.h    |  113 +++++++++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    1 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 
 net/netfilter/nf_conntrack_core.c              |   29 +--
 net/netfilter/nf_conntrack_ecache.c            |  101 ++++++++-
 net/netfilter/nf_conntrack_ftp.c               |    2 
 net/netfilter/nf_conntrack_netlink.c           |  261 +++++++++++-------------
 net/netfilter/nf_conntrack_proto_tcp.c         |    1 
 net/netfilter/nfnetlink.c                      |   28 +--
 12 files changed, 321 insertions(+), 291 deletions(-)

