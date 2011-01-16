From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2] NFQUEUE v2 target with 'queue bypass' support
Date: Sun, 16 Jan 2011 14:19:01 +0100
Message-ID: <1295183947-12786-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42904 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab1APNYY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:24:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is V2 of the NFQUEUEv2 target revision, adding support for accepting
packets in case the userspace listener is not available.
This fixes issues pointed out by Pablo in his review.

See individual patches for changes vs. V1.
Patch to iptables userspace follows in a couple of minutes.

These changes are also available via git pull:

The following changes since commit d862a6622e9db508d4b28cc7c5bc28bd548cc24e:

  netfilter: nf_conntrack: use is_vmalloc_addr() (2011-01-14 15:45:56 +0100)

are available in the git repository at:
  git://git.breakpoint.cc/fw/nf-next-2.6.git nfq_bypass_v2

Florian Westphal (6):
      netfilter: kconfig: NFQUEUE is useless without NETFILTER_NETLINK_QUEUE
      netfilter: nfnetlink_queue: return error number to caller
      netfilter: nfnetlink_queue: do not free skb on error
      netfilter: reduce NF_VERDICT_MASK to 0xff
      netfilter: allow NFQUEUE bypass if no listener is available
      netfilter: do not omit re-route check on NF_QUEUE verdict

 include/linux/netfilter.h            |   21 ++++++++---
 include/linux/netfilter/xt_NFQUEUE.h |    6 +++
 net/ipv4/netfilter/iptable_mangle.c  |    2 +-
 net/netfilter/Kconfig                |    1 +
 net/netfilter/core.c                 |   16 ++++++--
 net/netfilter/nf_queue.c             |   64 ++++++++++++++++++++++++----------
 net/netfilter/nfnetlink_queue.c      |   22 +++++++----
 net/netfilter/xt_NFQUEUE.c           |   28 +++++++++++++--
 8 files changed, 120 insertions(+), 40 deletions(-)
