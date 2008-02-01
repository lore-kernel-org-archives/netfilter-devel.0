From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 14:37:40 +0100
Message-ID: <47A320A4.3030203@netfilter.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de> <47A2E256.6080600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Holger Eitzenberger <heitzenberger@astaro.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45623 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932598AbYBANiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:38:03 -0500
In-Reply-To: <47A2E256.6080600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Holger Eitzenberger wrote:
>> are you talking about this particular patch or the end result after
>> applying all of the NFCT patches?
>>
>> Also note that IMO this particular patch turned a non-working NFCT
>> solution into some better-working solution.  I just suggest to
>> comment on the final NFCT code and not on this one.  Thanks.
> 
> I agree, this code has bitrotten for too long, I'm happy about
> any progress. Any objections should be clearly stated please.

I know, this code need some spins but there are several stuff that it's
better if we fix it now than later:

* CT_EVENTS is a duplicated flags, already exists NFCT_ALL_CT_GROUPS
* This patch arbitrarily disables loopback logging, this must be an option
* Default hashtable size reduced to 512, why?
* nfnl_recv_msgs looks like a duplicated of nfnl_catch (or nfct_catch).
nfct_msg_type is not required if you use the libnetfilter_conntrack API
properly. do_nfct_msg should use the libnetfilter_conntrack framework
which would simplify it.
* This patch checks if every conntrack exists in the kernel every N
seconds to handle overruns. Instead, why doesn't it wait for ENOBUFS in
the recv buffer and, then try to resync to kernel?
* Where is the NLMSG_OVERRUN flag used in the netlink code?
* ct_hash_find_seq is O(n). Overruns sometimes happen because the CPU
reaches 100% consumption, so if it can't backoff, this function won't
help that much in those cases.

I like that this patch kills the preallocation code which made this
thing more complex. Unfortunately it is mixed with many other things.
Still the netlink handling need some spins IMO.

An observation, the asynchronous nature of the ulogd timers keep this
hard since the timer callback can be called while accessing whatever
section of code. I think that the way to go is to use select and
implement time-slicing.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
