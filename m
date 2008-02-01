From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 10:11:50 +0100
Message-ID: <47A2E256.6080600@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41872 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYBAJL4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:11:56 -0500
In-Reply-To: <87r6fx14j1.fsf@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>> Well, this NFCT stuff is a big hack. I'm sure that you have solved
>> several issues with those patches but sorry, I don't like them at all.
>> There's several parts of conntrackd that we could use to rework this eg.
>> an implementation of a generic hash table in conntrackd that we can
>> reuse and nfnl_recv_msgs looks very similar to nfnl_catch, etc. Also,
>> the ENOBUFS handling is still a mess. I'm better keeping back these NFCT
>> patches. I'll try to give some spins to it.
> 
> Hi Pablo,
> 
> are you talking about this particular patch or the end result after
> applying all of the NFCT patches?
> 
> Also note that IMO this particular patch turned a non-working NFCT
> solution into some better-working solution.  I just suggest to
> comment on the final NFCT code and not on this one.  Thanks.


I agree, this code has bitrotten for too long, I'm happy about
any progress. Any objections should be clearly stated please.
