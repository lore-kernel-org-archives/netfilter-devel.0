From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: reduce netns create/delete cost
Date: Fri,  1 Dec 2017 00:21:01 +0100
Message-ID: <20171130232104.541-1-fw@strlen.de>
Cc: gscrivan@redhat.com
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750761AbdK3XeI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 18:34:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch series removes all synchronize_net() calls from netfilter core
to speed up net namespace create/delete rate.

Freeing of hooks is moved to call_rcu at the cost of additional 24 bytes
at the end of each rule blob.

 include/linux/netfilter.h        |   19 +++++--
 include/net/netfilter/nf_queue.h |    2 
 net/netfilter/core.c             |   99 ++++++++++++---------------------------
 net/netfilter/nf_internals.h     |    2 
 net/netfilter/nf_queue.c         |    7 --
 net/netfilter/nfnetlink_queue.c  |    9 ---
 6 files changed, 53 insertions(+), 85 deletions(-)
