From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD RFC 03/30] Replace timer code by working version
Date: Fri, 01 Feb 2008 10:25:50 +0100
Message-ID: <47A2E59E.5070209@trash.net>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190126.735398130@kruemel.intranet.astaro.de>	<47A2953E.2040600@netfilter.org> <87abmlay96.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, heitzenberger@astaro.com,
	netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42186 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYBAJZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:25:57 -0500
In-Reply-To: <87abmlay96.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>>> Replace existing timer code by simple and more importantly working
>>> version.  Current resolution is one second, which may be easily
>>> extended if need be.
>> You lose precision here using time(), I think the way to go are the
>> timeradd(), timercmp(), timersub(), etc. functions that lives in
>> sys/time.h. I have a patch for those here that I want to test.

Patches welcome :)

> The inititial timer code was incomplete and IMO too complicated for what
> it did.  AFAIRK at the time I started hacking on that there wasn't even
> a single user of that API.
> 
> This patch turns the timers into simple and more importantly working
> timers which with 1-sec resolution.  They might easily be adjusted or
> improved later on.
+

Agreed, from what I remeber about ulogd2 and our discussions there
doesn't seem to be any need for higher precision. I'll look into
the details later.

