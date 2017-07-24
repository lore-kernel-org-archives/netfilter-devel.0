From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: handle race w. module removal and nfqueue
Date: Mon, 24 Jul 2017 18:57:20 +0200
Message-ID: <20170724165724.10576-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48302 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751864AbdGXQ5G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 12:57:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is a long-standing race that occurs with module removal (such as helpers)
nfqueue, and unconfirmed (not in hash table) conntracks.

The main issue is that
a). unconfirmed conntracks can't safely be mangled from other cpu (we assume
    exclusive access to grow/alter the extension area) and
b). nfqueued skbs leave RCU protection

This series address this by making the queue event similar to a confirm event:

Just as we do not commit 'dying' conntracks to the main table, refuse
to queue dying and unconfirmed conntracks to userspace.

Combined with a 'drop queued skbs' when a module exit path calls
the ct_iterate_destroy function this closes the hole, see patch #4 for details.

