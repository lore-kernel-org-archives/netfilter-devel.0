From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: x_tables: pack percpu counter allocations
Date: Mon, 21 Nov 2016 14:57:31 +0100
Message-ID: <1479736654-2359-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38286 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754179AbcKUN5U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 08:57:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... to speed up iptables(-restore) calls.

Especially a pattern like

for i in $(seq 1 1000) ; iptables -A FORWARD ;done

is expensive, because adding the rule doubles the percpu counters (allocate 2nd blob, then free old one,
including its percpu counters).
This causes frequent expansion and shrinking of percpu memory pool.

This change batches calls to the allocator by packing multiple counters in one memory page.
Heavily based on suggestions from Eric Dumazet.

