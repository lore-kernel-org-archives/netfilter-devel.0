From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/4] libnetfilter_queue: gso handling support
Date: Thu, 25 Apr 2013 12:43:27 +0200
Message-ID: <1366886611-21666-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45143 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757592Ab3DYKl0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:41:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1UVJcA-0005tj-J1
	for netfilter-devel@vger.kernel.org; Thu, 25 Apr 2013 12:41:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

these are the userspace changes for gso-avoidance in nf_queue.
These are really just updates to header files to get the new flag
and attribute, plus a small change to the validation function.

Two major changes:
- the example program
- partial revert of the libmnl API change

The latter needs double-checking that everything is consistent
now.

I'll push these changes to -next branch after a couple of days
[ unless there are issues that need fixing, of course ].

Cheers,
Florian
