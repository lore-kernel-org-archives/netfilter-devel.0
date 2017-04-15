From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/6] netfilter: remove support for variably-sized extensions
Date: Sun, 16 Apr 2017 01:29:13 +0200
Message-ID: <20170415232919.13671-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754704AbdDOX3C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 19:29:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

3 years ago we had to bump the offsets to the extensions
(223b02d923ecd7c84cf9780bb3686f455d279279,
"netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len")
because total size of all extensions had increased to a point where u8
did overflow.

We already dieted the extensions back to more reasonable sizes, however,
I never wanted to switch back because overflow produces hard to diagnose
crash bugs, and we could not add compile-time assert because extensions
can be dynamically sized.

This series makes the last veriable-sized extension (helper)
fixed in size by adding a 32byte scratch area for helpers to use
and then adds the compile-time asserts to catch overflow during build
time.

 include/net/netfilter/nf_conntrack.h        |   19 ----------------
 include/net/netfilter/nf_conntrack_extend.h |   12 ++--------
 include/net/netfilter/nf_conntrack_helper.h |   31 ++++++++++++++++++++++----
 net/netfilter/nf_conntrack_amanda.c         |    2 +
 net/netfilter/nf_conntrack_core.c           |   33 ++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_extend.c         |   16 +++++--------
 net/netfilter/nf_conntrack_ftp.c            |    8 +++---
 net/netfilter/nf_conntrack_h323_main.c      |    6 +----
 net/netfilter/nf_conntrack_helper.c         |    6 +----
 net/netfilter/nf_conntrack_irc.c            |    2 -
 net/netfilter/nf_conntrack_netbios_ns.c     |    2 +
 net/netfilter/nf_conntrack_pptp.c           |    3 +-
 net/netfilter/nf_conntrack_sane.c           |    8 +++---
 net/netfilter/nf_conntrack_sip.c            |   14 +++++------
 net/netfilter/nf_conntrack_tftp.c           |    6 +++--
 net/netfilter/nfnetlink_cthelper.c          |   10 ++++++--
 16 files changed, 106 insertions(+), 72 deletions(-)
