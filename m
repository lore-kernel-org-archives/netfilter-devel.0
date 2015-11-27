From: Florian Westphal <fw@strlen.de>
Subject: GIT: [PATCH v3 0/3] netfilter trace infrastructure support
Date: Fri, 27 Nov 2015 19:43:17 +0100
Message-ID: <1448649800-26153-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39633 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbbK0Sna (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 13:43:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

3rd round.

See the individual patches for changelog vs. V 2.

Patrick: Nothing fancy from libnftnl side, just the 3 new attributes
(oiftype, nfproto, policy).

On kernel side I addressed all of the comments.

In case of NFPROTO_INET, the new NFTA_TRACE_NFPROTO will be 'NFPROTO_IPV4'
(or IPV6), the netlink header family is set to NFPROTO_INET.

I tried to reduce nft_do_chain bloat, +80 on my system.
We have one unconditional foo = false assignment, all nftrace calls
are avoided in 'no trace rules set' case via static key.

Let me know if you spot more problems.

Thanks,
Florian

