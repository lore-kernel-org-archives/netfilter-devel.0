From: Florian Westphal <fw@strlen.de>
Subject: NFQUEUE balancing extension (kernel changes)
Date: Fri,  5 Jun 2009 03:15:39 +0200
Message-ID: <1244164542-10739-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48516 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbZFEBKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:10:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello netfilter hackers,

here are three patches that i'd like to see in 2.6.31.

This extends the NFQUEUE target to enable a simple load-balancing
feature (packets are distributed among a range of queues, so several
instances of the same userspace-program can process data simultaneously).

I will be sending the userspace change in a separate patch series shortly.

If you have any objections, please let me know and I'll be happy
to fix the patches up.

The 3rd (unrelated) patch removes the rwlock from the MASQUERADE target,
it does not appear to have any use in its current form...

You may also pull these changes from:

git://git.breakpoint.cc/fw/nf-next-2.6.git for-kaber

Thanks for your time,
Florian

