From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: reduce hook array sizes to what is needed
Date: Thu,  7 Dec 2017 14:06:17 +0100
Message-ID: <20171207130620.7585-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753536AbdLGNGn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 08:06:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series further reduces size of the hook arrays by only resevering space
for the hooks that are implemented/supported (e.g., arp only supports 3 different
hook points as it lacks PRE/POST_ROUTING).

Furthermore, add #ifdef guard to not declare arp/bridge/decnet hooks unless
they are needed.

At least Fedora has CONFIG_DECNET=n so this even reduces size for some
distro kernels.

I ran a few randconfig builds last night and it did not catch any
build errors.

Florian Westphal (3):
      netfilter: reduce hook array sizes to what is needed
      netfilter: don't allocate space for decnet hooks unless needed
      netfilter: don't allocate space for arp/bridge hooks unless needed

 include/linux/netfilter.h     |    6 ++++++
 include/net/netns/netfilter.h |   19 ++++++++++++++-----
 net/Kconfig                   |    1 +
 net/bridge/netfilter/Kconfig  |    2 ++
 net/ipv4/netfilter/Kconfig    |    2 ++
 net/netfilter/Kconfig         |    6 ++++++
 net/netfilter/core.c          |   22 ++++++++++++++++++++++
 net/netfilter/nf_queue.c      |    2 ++
 8 files changed, 55 insertions(+), 5 deletions(-)
