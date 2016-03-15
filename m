From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH 0/3] connlabel set support using extra setter attr
Date: Tue, 15 Mar 2016 17:10:08 +0100
Message-ID: <1458058211-11147-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55484 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335AbcCOQJz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:09:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo

This attempts to implement the set support via your proposed
setter attribute.

IOW instead of taking an sreg and replacing the entire label
area with whatever is contained therein take a bit number
passed in from userspace and set only that one bit.

So ct label set foo

will really mean 'set the foo bit in the label area', just like
iptables -m connlabel --label foo --set

I'm sure that there are better ways to implement the expr <-> attr
conversion, see patch #3.

Comments welcome, I'll respin it once -next is open again.

Thanks,
Florian
