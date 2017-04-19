From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: conntrack: removal prealloc support
Date: Wed, 19 Apr 2017 23:44:35 +0200
Message-ID: <20170419214438.20938-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45094 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1763577AbdDSVoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 17:44:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The prealloc flag is only used for the nat extension (and
that extension is not even needed anymore in some cases).

This removes prealloc, marks all extension structs as const and then
also simplifies the initial extension allocation.

Currently (default settings), each conntrack will use 64 bytes of the initial
extension allocation.

 include/net/netfilter/nf_conntrack_extend.h |   10 --
 net/netfilter/nf_conntrack_acct.c           |    2 
 net/netfilter/nf_conntrack_ecache.c         |    2 
 net/netfilter/nf_conntrack_extend.c         |  104 +++++-----------------------
 net/netfilter/nf_conntrack_helper.c         |    2 
 net/netfilter/nf_conntrack_labels.c         |    2 
 net/netfilter/nf_conntrack_seqadj.c         |    2 
 net/netfilter/nf_conntrack_timeout.c        |    2 
 net/netfilter/nf_conntrack_timestamp.c      |    2 
 net/netfilter/nf_nat_core.c                 |    1 
 10 files changed, 30 insertions(+), 99 deletions(-)
