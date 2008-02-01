From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 17:19:34 +0100
Message-ID: <47A34696.5070109@astaro.com>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de> <47A2E256.6080600@trash.net> <47A320A4.3030203@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-51.dex002.intermedia.net ([64.78.21.150]:56415 "EHLO
	DHOST002-51.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbYBAQTs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:19:48 -0500
In-Reply-To: <47A320A4.3030203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

> * CT_EVENTS is a duplicated flags, already exists NFCT_ALL_CT_GROUPS

I've already queued a patch for that, I'll send that later.

> * This patch arbitrarily disables loopback logging, this must be an option

I totally agree on that.  My plan is to provide a filtering capability 
as generic as possible later on.

> * Default hashtable size reduced to 512, why?

You are still talking about the ulogd-NFCT-plugin.diff, right?  Please 
comment on the version as it is at the end of the patchset.

> * This patch checks if every conntrack exists in the kernel every N
> seconds to handle overruns. Instead, why doesn't it wait for ENOBUFS in
> the recv buffer and, then try to resync to kernel?

This is one of the future improvements I've only queued locally.  As 
this isn't critical I suggest to wait for that.

> * Where is the NLMSG_OVERRUN flag used in the netlink code?

When the point above is implemented.

> * ct_hash_find_seq is O(n). Overruns sometimes happen because the CPU
> reaches 100% consumption, so if it can't backoff, this function won't
> help that much in those cases.

  [ULOGD RFC 15/30] NFCT: add sequence cache

That patch was provided exactly to solve that issue.

> An observation, the asynchronous nature of the ulogd timers keep this
> hard since the timer callback can be called while accessing whatever
> section of code. I think that the way to go is to use select and
> implement time-slicing.

Either I didn't understand your point or you totally missed what the 
'synchronous signal handlers' are all about.

  /holger
