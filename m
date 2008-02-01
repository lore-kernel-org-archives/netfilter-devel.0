From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [ULOGD RFC 03/30] Replace timer code by working version
Date: Fri, 01 Feb 2008 10:43:38 +0100
Message-ID: <87hcgtxb91.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190126.735398130@kruemel.intranet.astaro.de>
	<47A2953E.2040600@netfilter.org> <87abmlay96.fsf@kruemel.eitzenberger.org>
	<47A2E59E.5070209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, heitzenberger@astaro.com,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:64544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYBAJn4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:43:56 -0500
In-Reply-To: <47A2E59E.5070209@trash.net> (Patrick McHardy's message of
 "Fri, 01 Feb 2008 10:25:50 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> writes:

>> The inititial timer code was incomplete and IMO too complicated for what
>> it did.  AFAIRK at the time I started hacking on that there wasn't even
>> a single user of that API.
>> This patch turns the timers into simple and more importantly working
>> timers which with 1-sec resolution.  They might easily be adjusted or
>> improved later on.

> Agreed, from what I remeber about ulogd2 and our discussions there
> doesn't seem to be any need for higher precision. I'll look into
> the details later.

Yes, there currently is no need for higher-precision timers in ulogd.
Looking at the code I think that Haralds intention was to have those
timers because IPFIX supports (at least principially) higher-precision
timerstamps.  IMO ideally there should be added a config switch for
that.

My next round of patches will clean up the existing code base further,
with focus on the ulogd core.

 /holger
