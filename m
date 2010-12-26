From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] NFQUEUE v2 target with 'queue bypass' support
Date: Mon, 27 Dec 2010 00:58:18 +0100
Message-ID: <1293407904-31464-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53931 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab0L0ADR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 19:03:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following patch series (for net-next) adds a NFQUEUE v2 target revision
that introduces a "--queue-bypass" flag.

If the flag is used with a -j NFQUEUE rule, then NFQUEUE will behave
like ACCEPT instead of DROP iff no program has opened the queue.

I will send the userspace patch for iptables in a couple of days.

The patch series is also available via git, but beware:
the tree is based on net-next-2.6 and NOT nf-next, because the former
includes Eric Paris' selinux netfilter changes which would
cause merge conflicts with these patches.

The following changes since commit 041110a439e21cd40709ead4ffbfa8034619ad77:

  Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/jkirsher/net-next-2.6 (2010-12-25 19:20:38 -0800)

are available in the git repository at:

  git://git.breakpoint.cc/fw/net-next-2.6.git nfq_bypass

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
 net/netfilter/core.c                 |   14 +++++--
 net/netfilter/nf_queue.c             |   66 +++++++++++++++++++++------------
 net/netfilter/nfnetlink_queue.c      |   22 +++++++----
 net/netfilter/xt_NFQUEUE.c           |   28 +++++++++++++--
 8 files changed, 115 insertions(+), 45 deletions(-)

