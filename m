From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 0/5] netfilter: nf_queue: avoid expensive gso/checksumming
Date: Tue, 16 Apr 2013 17:32:03 +0200
Message-ID: <1366126328-25874-1-git-send-email-fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41716 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab3DPPaB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

please consider pulling from

git://git.breakpoint.cc/fw/nf-next.git nfqueue_gso_avoidance_04

to retrieve the following changes since commit aaa795ad25e18488b026572c7ba2ca8f99ced0b7:

  netfilter: nat: propagate errors from xfrm_me_harder() (2013-04-08 12:34:01 +0200)

Florian Westphal (5):
      netfilter: nf_queue: move device refcount bump to extra function
      netfilter: nfnetlink_queue: avoid peer_portid test
      netfilter: move skb_gso_segment into nfnetlink_queue module
      netfilter: nfnetlink_queue: add skb info attribute
      netfilter: nfqueue: avoid expensive gso segmentation and checksum fixup

With these patches, userspace can now instruct the kernel that it is gso/gro
aware and can handle "invalid" checksums that appear in packet headers.

For old userspace, nothing is changed: the kernel segments gso skbs
and adjusts checksums.

To avoid gso/checksum fixup overhead, userspace applications must set the
new NFQA_CFG_F_GSO config flag via NFQA_CFG_FLAGS attribute AND
check the new NFQA_SKB_INFO attribute when processing a packet.

This new attribute currently contains two bits:

- NFQA_SKB_CSUMNOTREADY means 'checksums will be fixed in kernel
later, pretend they are ok'.

- NFQA_SKB_GSO could be used for statistics, or to determine when
packet size exceeds mtu.

I've done a few tests with old userspace and did not notice any issues.

Feedback welcome.

Update for libnetfilter_queue (including example program/documentation)
will follow later.

diffstat:

 include/net/netfilter/nf_queue.h               |    6 +
 include/uapi/linux/netfilter/nfnetlink_queue.h |   10 ++-
 net/netfilter/nf_queue.c                       |  143 +++++---------------
 net/netfilter/nfnetlink_queue_core.c           |  169 ++++++++++++++++++++---
 4 files changed, 198 insertions(+), 130 deletions(-)

