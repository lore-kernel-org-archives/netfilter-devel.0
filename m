From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 06:13:29 +0100
Message-ID: <4993AFF9.9010002@trash.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39845 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZBLFNf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:13:35 -0500
In-Reply-To: <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-02-11 15:37, Patrick McHardy wrote:
> 
>> Jesper Dangaard Brouer wrote:
>>>
>>> Patrick, what do you say?
>> Agreed on your reasoning. I don't have much of an opinion, we
>> mainly tried to hide it because it was never suitable for anything
>> else than a short "iptables ..." command because of memory leaks
>> etc. I think we're a lot better with this nowadays, if we can
>> get the worst remaining ones plugged and somewhat of a usable
>> API we can certainly add it as a library.
>>
> I have the code ready, it is easily mergeable-and-revertible(*) too, but 
> let's wait with that because it currently relies on a certain revision 
> of Makefile.am (IOW: merge conflicts with nf).
> 
> (*) That is, changing it from 'lib_LTLIBRARIES' to 'noinst_LTLIBARIES' 
> and it automatically becomes static wrt. the executables again. Oh I 
> love automake :)

I'd prefer to wait until after the next release with this. We already
have quite a few changes and missed the last release, so I want to
start stabilizing a nice new release for 2.6.29 soon.
