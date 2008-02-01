From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 09:09:54 +0100
Message-ID: <87r6fx14j1.fsf@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190127.400747893@kruemel.intranet.astaro.de>
	<47A27481.7080700@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-52.dex002.intermedia.net ([64.78.21.154]:38383 "EHLO
	dhost002-52.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYBAIKD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:10:03 -0500
In-Reply-To: <47A27481.7080700@netfilter.org> (Pablo Neira Ayuso's message of "Fri\, 01 Feb 2008 02\:23\:13 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Well, this NFCT stuff is a big hack. I'm sure that you have solved
> several issues with those patches but sorry, I don't like them at all.
> There's several parts of conntrackd that we could use to rework this eg.
> an implementation of a generic hash table in conntrackd that we can
> reuse and nfnl_recv_msgs looks very similar to nfnl_catch, etc. Also,
> the ENOBUFS handling is still a mess. I'm better keeping back these NFCT
> patches. I'll try to give some spins to it.

Hi Pablo,

are you talking about this particular patch or the end result after
applying all of the NFCT patches?

Also note that IMO this particular patch turned a non-working NFCT
solution into some better-working solution.  I just suggest to
comment on the final NFCT code and not on this one.  Thanks.

  /holger

