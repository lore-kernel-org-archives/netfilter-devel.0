From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: nat: do not use rhltable
Date: Wed,  6 Sep 2017 14:39:50 +0200
Message-ID: <20170906123952.12555-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753161AbdIFMjd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 08:39:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This reverts the conversion of the nat bysource table to rhlist that
I did last year.

It was a bad idea to begin with.

Fast lookup is not essential; in most cases there is no lookup
at all because original tuple is not taken and can be used as-is.
What needs to be fast is insertion and deletion.

With rhlist, deletion is slow as it requires a list traversal.
So, switch back to a statically-sized table for bysource hash.

 include/net/netfilter/nf_conntrack.h |    3 
 include/net/netfilter/nf_nat.h       |    1 
 net/netfilter/nf_nat_core.c          |  142 ++++++++++++++++-------------------
 3 files changed, 66 insertions(+), 80 deletions(-)

