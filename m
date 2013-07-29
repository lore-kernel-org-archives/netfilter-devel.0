From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/7 -next] rm tproxy_core, ct event redelivery via workqueue
Date: Mon, 29 Jul 2013 15:41:49 +0200
Message-ID: <1375105316-13216-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52394 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab3G2NkY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:40:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@breakpoint.cc>)
	id 1V3ngU-0004qQ-Gv
	for netfilter-devel@vger.kernel.org; Mon, 29 Jul 2013 15:40:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

The following contains a bunch of patches that id'like to see in -next tree.

The two tproxy patches remove the nf_tproxy_core module - the TPROXY
target is changed to use the generic sock_edemux destructor
(this is one reason for the negative diffstat).

The three conntrack patches are yet another attempt at removing
the extra ecache timer:  It implements redelivery via delayed work item
- the advantage is that redelivery is now under scheduler control and
thus competes fairly with the userspace event consumers.

I got slightly better results than current master branch, and a
lot better results compared to the old "single timer" based patch.

Because nf_conntrack_netlink.c contains a bit of redundant code copied
from nf_conntrack_core I rebased the "cleanup" parts of your patch titled

"netfilter: nf_conntrack: fix race in timer handling with reliable events"

which is sitting in patchwork: http://patchwork.ozlabs.org/patch/180436/

If you prefer to forward-port the cleanup bits yourself jsut let me know
when you're finished an I will rebase my changes.

Patches will also be sent in reply to this email.

The following changes since commit 496e4ae7dc944faa1721bfda7e9d834d5611a874:

  netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag (2013-06-30 18:15:48 +0200)

are available in the git repository at:
  git://chamillionaire.breakpoint.cc/fw/nf-next.git pull-20130729

Florian Westphal (7):
      netfilter: connlabels: remove unneeded includes
      netfilter: nf_queue: relax NFQA_CT attribute check
      netfilter: tproxy: remove nf_tproxy_core module, keep tw sock assigned to skb
      netfilter: tproxy: remove nf_tproxy_core.h
      netfilter: conntrack: remove duplicate code in conntrack_netlink
      netfilter: conntrack: don't send destroy events from iterator
      netfilter: conntrack: remove timer from ecache extension

 Documentation/networking/tproxy.txt                |    5 +-
 include/net/netfilter/nf_conntrack.h               |   14 +-
 include/net/netfilter/nf_conntrack_ecache.h        |    9 +-
 include/net/netfilter/nf_tproxy_core.h             |  210 --------------------
 include/net/netns/conntrack.h                      |    5 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |    8 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |    2 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |    2 +-
 net/netfilter/Kconfig                              |   22 +--
 net/netfilter/Makefile                             |    3 -
 net/netfilter/nf_conntrack_core.c                  |  131 +++----------
 net/netfilter/nf_conntrack_ecache.c                |   63 +++++-
 net/netfilter/nf_conntrack_labels.c                |    4 -
 net/netfilter/nf_conntrack_netlink.c               |   18 +--
 net/netfilter/nf_conntrack_proto.c                 |    4 +-
 net/netfilter/nf_nat_core.c                        |    6 +-
 net/netfilter/nf_tproxy_core.c                     |   62 ------
 net/netfilter/nfnetlink_queue_core.c               |    4 +-
 net/netfilter/xt_TPROXY.c                          |  167 ++++++++++++++++-
 net/netfilter/xt_socket.c                          |   66 ++++++-
 20 files changed, 353 insertions(+), 452 deletions(-)
 delete mode 100644 include/net/netfilter/nf_tproxy_core.h
 delete mode 100644 net/netfilter/nf_tproxy_core.c
