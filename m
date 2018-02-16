From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/2] netfilter: ipt_CLUSTERIP: two more fixes
Date: Fri, 16 Feb 2018 12:49:31 +0100
Message-ID: <20180216114933.23667-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50900 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935132AbeBPLul (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:50:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During code audit I found two more bugs in CLUSTERIP,
first one is a refcount leak, second is possible use-after free
due to kfree() of rcu-protected (and already visible) structure.

I think its time to remove this target, so, if anyone has a good
reason to not nuke it in nf-next please let me know soon.

