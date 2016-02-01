From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] meta: random match for statistic sampling
Date: Tue,  2 Feb 2016 00:18:58 +0100
Message-ID: <1454368741-16368-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35227 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbcBAXVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 18:21:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replacement for iptables -m statistic 'random' mode.
I added it to meta match even though its not directly related to an skb
member. We already have cpu match which isn't related to skb either and
adding a new expression just for this seemed overkill.

If you'd rather like a new prandom expression just let me know and
I can rework it.

There is also a libnftnl patch but its only so that debug output
displays 'meta prandom' rather than 'meta unknown'.

Result after several minutes of constant flooding:

counter packets 2961796882 bytes 248790938088
meta random <= 0.900000000 counter packets 2665649546 bytes 223914561864
meta random <= 0.500000000 counter packets 1480856860 bytes 124391976240
meta random <= 0.100000000 counter packets 296190072 bytes 24879966048
meta random <= 0.010000000 counter packets 29618610 bytes 2487963240
meta random <= 0.001000000 counter packets 2963660 bytes 248947440
meta random <= 0.000100000 counter packets 295486 bytes 24820824
meta random <= 0.000010000 counter packets 29450 bytes 2473800
meta random <= 0.000001000 counter packets 2911 bytes 244524
meta random <= 0.000000100 counter packets 267 bytes 22428
meta random <= 0.000000010 counter packets 26 bytes 2184
meta random <= 0.000000001 counter packets 4 bytes 336

... so it seems to work as intended.

Let me know if you spot any issues with current approach.

Kernel part only does '*dest = prandom_u32()', I'll submit it once
I know that this approach is deemed sane.

Thanks!
