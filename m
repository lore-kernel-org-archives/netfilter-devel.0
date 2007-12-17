From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Mon, 17 Dec 2007 13:55:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712171353030.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr>
 <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr>
 <47666D72.3060406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48341 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXLQMzV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:55:21 -0500
In-Reply-To: <47666D72.3060406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 17 2007 13:37, Patrick McHardy wrote:
>> Old revisions should be purged after a "reasonable time" (whatever
>> that means for everyone), or perhaps whenever there is a Linux kernel
>> version with a trailing .0 (2.7.0, 2.8.0), or when great new things
>> appear (pkttables, or whatever is in the works).
>> 
>> I think the step should better be made now than later, or this cruft
>> will be carried for the next 10 instead of 5 years.
>
>
> Mhh .. well, I guess I would apply patches that fix the types
> for all matches and targets and adds the old revisions to
> feature-removal-schedule with a timeframe of maybe two years.
> But this should happen for all of them at once, we don't
> want 20 different dates for removal.
>
>
I am working my way through... I just began with MARK because that
was most obvious.

Not all matches/targets are conversion-only. E.g. MARK where I done
both use-fixed-types and implement-XOR as a single revision/update,
which is, IMO, a good thing.
