From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 0/5] netfilter: reduce hook array sizes
Date: Thu,  7 Dec 2017 16:28:22 +0100
Message-ID: <20171207152827.24317-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45012 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750779AbdLGP2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 10:28:50 -0500
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

See individual patches for changes since v2.

Florian Westphal (5):
      netfilter: add defines for arp/decnet max hooks
      netfilter: reduce hook array sizes to what is needed
      netfilter: don't allocate space for decnet hooks unless needed
      netfilter: don't allocate space for arp/bridge hooks unless needed
      netfilter: reduce NF_MAX_HOOKS define

 include/linux/netfilter.h             |    6 +++++
 include/linux/netfilter_defs.h        |   12 ++++++++++-
 include/net/netns/netfilter.h         |   16 ++++++++++-----
 include/uapi/linux/netfilter_arp.h    |    3 ++
 include/uapi/linux/netfilter_decnet.h |    4 ++-
 net/Kconfig                           |    1 
 net/bridge/netfilter/Kconfig          |    2 +
 net/ipv4/netfilter/Kconfig            |    2 +
 net/netfilter/Kconfig                 |    6 +++++
 net/netfilter/core.c                  |   36 +++++++++++++++++++++++++++-------
 net/netfilter/nf_queue.c              |    2 +
 11 files changed, 76 insertions(+), 14 deletions(-)

