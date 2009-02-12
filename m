From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 06:58:25 +0100
Message-ID: <4993BA81.8030404@trash.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr> <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40612 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLF6c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:58:32 -0500
In-Reply-To: <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-02-12 06:13, Patrick McHardy wrote:
>>> I have the code ready, it is easily mergeable-and-revertible(*) too, but let's
>>> wait with that because it currently relies on a certain revision of
>>> Makefile.am (IOW: merge conflicts with nf).
>>>
>>> (*) That is, changing it from 'lib_LTLIBRARIES' to 'noinst_LTLIBARIES' and it
>>> automatically becomes static wrt. the executables again. Oh I love automake :)
>> I'd prefer to wait until after the next release with this.
> 
> I'd rather not want to wait another 4 months with this change
> [of enabling iptc to be installed].
> If Jesper then wants to play with the API, no problem, just
> don't forget bumping the so_version correctly.
> 
>> We already have quite a few changes and missed the last release,
> 
> Maybe releases should be more coordinated. 
> I could come up with a big bunch of suggested guidelines upfront.
> Release-early-release-often is the one I miss most.
> 	.oO( and before I know it, I wrote another book )

If you write me a script to take care of all the website crap,
I'll happily release more often :) Its just a major PITA currently.

>> so I want to start stabilizing a nice new release for 2.6.29 soon.
> 
> Here is your chance to make 1.4.3 nice - it does happen that some
> projects seem to use libiptc, and because it's not installed with
> distros because it is noinst_ in our happy Makefile.am, projects do a
> verbatim copy which a deed worse than having the current API -
> cherry-steal commit 1715851e now! :-D

I know. We've told them that this is a bad idea. Anyways, lets
see how intrusive these changes get.


