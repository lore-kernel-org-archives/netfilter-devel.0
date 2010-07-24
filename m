From: Karl Hiramoto <karl@hiramoto.org>
Subject: [RFC 0/4] nfnetlink_queue bypass queue to userspace X bytes of connection
Date: Sat, 24 Jul 2010 17:44:41 +0200
Message-ID: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Cc: Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:37013 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0GXPqF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:46:05 -0400
Received: from homiemail-a30.g.dreamhost.com (caiajhbdccah.dreamhost.com [208.97.132.207])
	by hapkido.dreamhost.com (Postfix) with ESMTP id DAEEB17C78B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 08:46:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi, I'm working on a nf_queue based HTTP filter. Sometimes I want to
NF_ACCEPT X bytes of a connection. In a HTTP connection its part of the
Content-Length.  Being able to directly NF_ACCEPT large parts of a connection
is a 2X to 3X speedup, by not queuing these packets to user-space.

I've tested this patchset only with HTTP on IPv4, and it makes a large
difference in page load times (lower latency), max bandwidth utilization,
and CPU utilization (lower utilization).

This is something like connbytes, but with TCP look at the sequence number
to handle out of order and duplicate packets. I'm thinking about changing
the code to a always queue if the TCP flags SYN, FIN, or RST are set.

Besides HTTP I could imagine other L7 protocol filters using nf_queue
could this feature.

Bad points:

* making nfnetlink_queue depend on conntrack and on on L3 (TCP).


This patchset is also at:
git://github.com/karlhiramoto/linux-2.6.git nfq

libnl patches to send NFQA_ACCEPT_CONNBYTES are at:
git://github.com/karlhiramoto/libnl.git

Karl Hiramoto (4):
  netfilter/Kconfig: NF_QUEUE_CONNBYTES_BYPASS
  nf_conntrack_queue: define struct that will be stored in nf_ct_extend
  nf_conntrack: add nf_queue extension
  nfnetlink_queue: allow part of a connection to bypass the queue

 include/linux/netfilter/nfnetlink_queue.h   |    1 +
 include/net/netfilter/nf_conntrack_extend.h |    2 +
 include/net/netfilter/nf_conntrack_queue.h  |   17 ++++
 net/netfilter/Kconfig                       |   13 +++-
 net/netfilter/nf_conntrack_core.c           |   37 +++++++++-
 net/netfilter/nfnetlink_queue.c             |  112 ++++++++++++++++++++++++++-
 6 files changed, 179 insertions(+), 3 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_queue.h

