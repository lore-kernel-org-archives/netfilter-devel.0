From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: speed up netns cleanup
Date: Mon, 24 Apr 2017 15:37:38 +0200
Message-ID: <20170424133741.2707-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43538 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1170993AbdDXNh3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 09:37:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

low hanging fruits to speed up netns cleanup in netfilter.
We're way too happy to issue expensive synchronize_rcu() all
over the place.

On my test vm 8 processes doing 32 unshare each finish in ~3 minutes,
with these patches it gets down to 40 seconds.

We could probably further improve this.

 include/net/netfilter/nf_queue.h |    3 --
 net/netfilter/core.c             |   55 ++++++++++++++++++++++++++++++++-------
 net/netfilter/nf_internals.h     |    2 -
 net/netfilter/nf_log.c           |    1 
 net/netfilter/nf_queue.c         |    7 +++-
 net/netfilter/nfnetlink_queue.c  |   18 +++++-------
 6 files changed, 61 insertions(+), 25 deletions(-)
