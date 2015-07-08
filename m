From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 0/4] netfilter: xtables: improve jumpstack handling
Date: Wed,  8 Jul 2015 23:15:35 +0200
Message-ID: <1436390139-4405-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37533 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbbGHVIR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 17:08:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During NFWS 2015 Eric Dumazet suggested various ideas to make
the xtables table traversers function setup less expensive.

In particular, the *_do_table functions keep track of the current
stack pointer.

It appears that we can simplify this to always start from 0
(therefore allowing us to avoid the save/restore) provided we make sure
that we use an alternate jump stack when we enter the traverser recursively
via TEE target.

This implements a few of Erics suggestions.

NOTE1: The last patch is only RFC material, see the patch description.

Its the clasic question wheter we're willing to reject bizarre ruleset
or not.  If this patch is acceptable, we can avoid one more dereference
by using percpu allocation for the jumpstack.

Florian Westphal (4):
      xtables: compute exact size needed for jumpstack
      netfilter: move tee_active to core
      netfilter: xtables: don't save/restore jumpstack offset
      netfilter: xtables: add upper limit on call chain depth

 include/linux/netfilter.h          |   11 ++++++
 include/linux/netfilter/x_tables.h |    1 
 net/ipv4/netfilter/arp_tables.c    |   31 +++++++++--------
 net/ipv4/netfilter/ip_tables.c     |   65 +++++++++++++++++++++----------------
 net/ipv6/netfilter/ip6_tables.c    |   49 ++++++++++++++++-----------
 net/netfilter/core.c               |    3 +
 net/netfilter/x_tables.c           |   30 ++++++++++-------
 net/netfilter/xt_TEE.c             |   13 +++----
 8 files changed, 122 insertions(+), 81 deletions(-)
