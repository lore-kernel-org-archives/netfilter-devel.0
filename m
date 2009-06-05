From: Florian Westphal <fw@strlen.de>
Subject: NFQUEUE balancing extension (userspace changes)
Date: Fri,  5 Jun 2009 03:17:57 +0200
Message-ID: <1244164679-11032-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48521 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZFEBNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:13:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list,

this adds a new revision of the NFQUEUE target.

In particular, a new "--queue-balance" option, which allows to
specify a range of queues to use.
Packets are then balanced across the given queues by the kernel.

This is useful for multicore systems:
start multiple instances of the userspace program on queues
x, x+1, .. x+n and use "--queue-balance x:x+n".

As for naming, if you'd prefer a different name (or just extend
the existing --queue-num option to accept "firstid:lastid" instead),
please let me know and I'll be happy to change it.

Both paches can also be pulled from
git://git.breakpoint.cc/fw/iptables.git nfq-balance

Thanks for reviewing,
Florian

