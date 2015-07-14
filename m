From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next v2 0/6] netfilter: xtables: improve jumpstack handling
Date: Tue, 14 Jul 2015 17:51:05 +0200
Message-ID: <1436889071-3637-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49913 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbbGNPvT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jul 2015 11:51:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During NFWS 2015 Eric Dumazet suggested various ideas to make
the xtables table traverser function setup less expensive.

In particular, the *_do_table functions keep track of the current
stack pointer.

It appears that we can simplify this to always start from 0
(therefore allowing us to avoid the save/restore) provided we make sure
that we use an alternate jump stack when we enter the traverser recursively
via TEE target.

This implements some of Erics ideas.

NOTE1: The last patch may break valid iptables rulesets.
Its the clasic question wheter we're willing to reject bizarre ruleset
or not.  If this patch is acceptable, we can avoid one more dereference
by using percpu allocation for the jumpstack as follow work.

If not, just ignore the last patch.

Florian Westphal (6):
      netfilter: xtables: compute exact size needed for jumpstack
      netfilter: move tee_active to core
      netfilter: xtables: don't save/restore jumpstack offset
      netfilter: add and use jump label for xt_tee
      netfilter: xtables: remove __pure annotation
      netfilter: xtables: add upper limit on call chain depth

 include/linux/netfilter.h          |   11 +++++
 include/linux/netfilter/x_tables.h |    8 +++-
 net/ipv4/netfilter/arp_tables.c    |   32 ++++++++---------
 net/ipv4/netfilter/ip_tables.c     |   68 +++++++++++++++++++++----------------
 net/ipv6/netfilter/ip6_tables.c    |   52 ++++++++++++++++------------
 net/netfilter/core.c               |    3 +
 net/netfilter/x_tables.c           |   31 +++++++++++-----
 net/netfilter/xt_TEE.c             |   15 ++++----
 8 files changed, 137 insertions(+), 83 deletions(-)

