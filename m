From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/7] netfilter: conntrack: constify protocol trackers, part 1
Date: Sat, 12 Aug 2017 00:57:01 +0200
Message-ID: <20170811225708.22181-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54142 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753707AbdHKW5s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2017 18:57:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an initial series of patches to mark the l3 and l4 protocol handler
structs as const.

Only reason why we can't constify them now is that l3 and l4 trackers
compute netlink attribute size needed at init time and store result in
the proto struct.

First patch switches the l3 trackers to compile-time computation.

Next patches reduce size by (re)moving various pointers.

Last patch adds const qualifiers in a lot of places.  This patch
has no effect on its own but its needed to avoid compiler warnings
when part 2 of the series will constify the trackers.

