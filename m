From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 03/30] Replace timer code by working version
Date: Fri, 01 Feb 2008 09:15:17 +0100
Message-ID: <87abmlay96.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190126.735398130@kruemel.intranet.astaro.de>
	<47A2953E.2040600@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heitzenberger@astaro.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbYBAIPX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:15:23 -0500
In-Reply-To: <47A2953E.2040600@netfilter.org> (Pablo Neira Ayuso's message
 of "Fri, 01 Feb 2008 04:42:54 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

>> Replace existing timer code by simple and more importantly working
>> version.  Current resolution is one second, which may be easily
>> extended if need be.
>
> You lose precision here using time(), I think the way to go are the
> timeradd(), timercmp(), timersub(), etc. functions that lives in
> sys/time.h. I have a patch for those here that I want to test.

The inititial timer code was incomplete and IMO too complicated for what
it did.  AFAIRK at the time I started hacking on that there wasn't even
a single user of that API.

This patch turns the timers into simple and more importantly working
timers which with 1-sec resolution.  They might easily be adjusted or
improved later on.

  /holger
