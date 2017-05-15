From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] monitor: Support printing processes which caused the event
Date: Mon, 15 May 2017 16:51:52 +0200
Message-ID: <20170515145154.26189-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59361 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965652AbdEOOwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 10:52:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a hopefully correct implementation of what I wanted to achieve
in the same named RFC sent before: Instead of relying on the netlink
msgid to be equal to the sender's PID, make use of the kernel
infrastructure added in a previous patch.

Note that this implementation does not use libnftnl like other parts of
the code. I skipped that because handling of NFT_MSG_PROC_INFO type
messages is unidirectional only and they contain just two attributes -
the amount of code to add to libnftnl to parse them there seemed not
feasible just to follow coding-style.

The first patch is probably redundant since it's changes will be
imported by a generic kernel header update anyway, but it allows for
quickly testing the implementation so left here for reference.

Phil Sutter (2):
  include: Add proc_info symbols to nf_tables.h
  monitor: Support printing processes which caused the event

 include/linux/netfilter/nf_tables.h | 15 ++++++++
 include/nftables.h                  |  1 +
 src/main.c                          | 12 +++++-
 src/netlink.c                       | 76 ++++++++++++++++++++++++++++++++++---
 src/rule.c                          |  2 -
 5 files changed, 98 insertions(+), 8 deletions(-)

-- 
2.11.0

