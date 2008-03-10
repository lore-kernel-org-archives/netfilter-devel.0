From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/09]: Netfilter fixes
Date: Mon, 10 Mar 2008 19:26:13 +0100 (MET)
Message-ID: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34252 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYCJS0P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these patches contain some netfilter fixes for 2.6.25, fixing undersized
skb allocation and incorrect EPERM errors in nfnetlink_queue and
nfnetlink_log, an xt_time bug that causes mismatches on Sundays, a
missing newline in a conntrack message and the "horrible hack" in
ct_extend.

Please apply, thanks.


 include/linux/netfilter/nfnetlink_compat.h  |    2 +-
 include/net/netfilter/nf_conntrack_extend.h |    1 -
 net/netfilter/nf_conntrack_expect.c         |    2 +-
 net/netfilter/nf_conntrack_extend.c         |   19 ++-------------
 net/netfilter/nf_queue.c                    |    2 +-
 net/netfilter/nfnetlink_log.c               |   32 ++++++++++++++------------
 net/netfilter/nfnetlink_queue.c             |   17 ++++----------
 net/netfilter/xt_time.c                     |    7 ++++-
 8 files changed, 33 insertions(+), 49 deletions(-)

Alexey Dobriyan (1):
      [NETFILTER]: nf_conntrack: add \n to "expectation table full" message

Andrew Schulman (1):
      [NETFILTER]: xt_time: fix failure to match on Sundays

Eric Leblond (2):
      [NETFILTER]: nfnetlink_queue: fix computation of allocated size for netlink skb.
      [NETFILTER]: nfnetlink_log: fix computation of netlink skb size

Patrick McHardy (4):
      [NETFILTER]: nfnetlink: fix ifdef in nfnetlink_compat.h
      [NETFILTER]; nfnetlink_log: fix EPERM when binding/unbinding and instance 0 exists
      [NETFILTER]: nfnetlink_queue: fix EPERM when binding/unbinding and instance 0 exists
      [NETFILTER]: nf_queue: don't return error when unregistering a non-existant handler

Pekka Enberg (1):
      [NETFILTER]: nf_conntrack: replace horrible hack with ksize()
