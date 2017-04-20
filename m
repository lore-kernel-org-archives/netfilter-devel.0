From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/3] netfilter: conntrack: removal prealloc support
Date: Thu, 20 Apr 2017 09:54:21 +0200
Message-ID: <20170420075424.12190-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46726 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938741AbdDTHyG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 03:54:06 -0400
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
 net/netfilter/nf_conntrack_extend.c         |   98 +++++-----------------------
 net/netfilter/nf_conntrack_helper.c         |    2
 net/netfilter/nf_conntrack_labels.c         |    2
 net/netfilter/nf_conntrack_seqadj.c         |    2
 net/netfilter/nf_conntrack_timeout.c        |    2
 net/netfilter/nf_conntrack_timestamp.c      |    2
 net/netfilter/nf_nat_core.c                 |    1
 10 files changed, 27 insertions(+), 96 deletions(-)

