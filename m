From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: reduce size of hook entry points
Date: Sun,  3 Dec 2017 00:58:46 +0100
Message-ID: <20171202235848.22737-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46488 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752365AbdLBX7n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Dec 2017 18:59:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

struct net contains:

struct nf_hook_entries __rcu *hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];

where NFPROTO_NUMPROTO = 13 and NF_MAX_HOOKS = 8.

... and that needs a *lot* more space than what we really need.
We only need hooks for arp, bridge, ipv4, ipv6 and decnet.

Arp only has 3 hook types, decnet has 7, all others have 5.
So replace this with dedicated arrays of the correct size to save
some space.

Changes since RFC:
 - bridge only needs 5, not 6 hooks (BROUTE isn't a real hookpoint)
 - Use run-time check to reject register requests for hook types that
   don't fit the array size.
   RFC tried to use BUILD_BUG_ON checks in nf_hook(), but that breaks build
   on some older gcc releases.

 include/linux/netfilter.h       |   30 ++++++++++++++++++--
 include/net/netns/netfilter.h   |   15 +++++++++-
 net/bridge/br_netfilter_hooks.c |    2 -
 net/netfilter/core.c            |   60 ++++++++++++++++++++++++++++++++++------
 net/netfilter/nf_queue.c        |   21 ++++++++++++--
 5 files changed, 114 insertions(+), 14 deletions(-)
