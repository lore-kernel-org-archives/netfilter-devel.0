From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next v2 0/5] netfilter: nf_queue: avoid expensive gso/checksums
Date: Fri, 19 Apr 2013 16:58:22 +0200
Message-ID: <1366383507-16633-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56697 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030705Ab3DSO4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:56:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1UTCjb-00022F-Hc
	for netfilter-devel@vger.kernel.org; Fri, 19 Apr 2013 16:56:19 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

here is V2 of the gso avoidance patchset for nfnetlink_queue.

With these patches, userspace can now instruct the kernel that it is gso/gro
aware and can handle "invalid" checksums that appear in packet headers.

For old userspace, nothing is changed: the kernel segments gso skbs
and adjusts checksums.

To avoid gso/checksum fixup overhead, userspace applications must set the
new NFQA_CFG_F_GSO config flag via NFQA_CFG_FLAGS attribute.

Then, for every packet received, userspace needs to check for the presence
of the new NFQA_SKB_INFO attribute.  If it exists, userspace needs to test
NFQA_SKB_CSUMNOTREADY bit.  If set, this means that userspace
must NOT very packet checksums, since they will be fixed later on
by the kernel.

The other bit is
NFQA_SKB_GSO, which could be used for statistics, or to determine when
packet size exceeds mtu.

Feedback welcome.

Update for libnetfilter_queue (including example program/documentation)
will follow later.

The following changes since commit d37d696804a83479f240b397670a07ccb53a7417:

  netfilter: xt_rpfilter: depend on raw or mangle table (2013-04-19 00:22:55 +0200)

are available in the git repository at:
  git://git.breakpoint.cc/fw/nf-next.git nfqueue_gso_avoidance_06

Florian Westphal (5):
      netfilter: nf_queue: move device refcount bump to extra function
      netfilter: nfnetlink_queue: avoid peer_portid test
      netfilter: move skb_gso_segment into nfnetlink_queue module
      netfilter: nfnetlink_queue: add skb info attribute
      netfilter: nfqueue: avoid expensive gso segmentation and checksum fixup

Changes since V1:
 - fix OOPS if CONFIG_BRIDGE_NETFILTER=y and old non-gso userspace listener is killed
 - only add NFQA_SKB_INFO when skb is gso or CHECKSUM_PARTIAL

 include/net/netfilter/nf_queue.h               |    6 +
 include/uapi/linux/netfilter/nfnetlink_queue.h |   10 ++-
 net/netfilter/nf_queue.c                       |  143 +++++--------------
 net/netfilter/nfnetlink_queue_core.c           |  180 +++++++++++++++++++++---
 4 files changed, 209 insertions(+), 130 deletions(-)
