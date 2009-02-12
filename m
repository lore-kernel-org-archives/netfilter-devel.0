From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 15:50:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902121541540.25116@ask.diku.dk>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net>
 <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
 <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
 <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0902121014550.22322@ask.diku.dk> <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
 <alpine.LSU.2.00.0902121511030.27867@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hawk@comx.dk
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:35206 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZBLOuz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:50:55 -0500
In-Reply-To: <alpine.LSU.2.00.0902121511030.27867@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Feb 2009, Jan Engelhardt wrote:

>
> On Thursday 2009-02-12 11:42, Jesper Dangaard Brouer wrote:
>> On Thu, 12 Feb 2009, Jesper Dangaard Brouer wrote:
>>> On Thu, 12 Feb 2009, Jan Engelhardt wrote:
>>>
>>>> If Jesper then wants to play with the API, no problem, just
>>>> don't forget bumping the so_version correctly.
>>>
>>> I'll try it out today... lets see how intrusive it is...
>>
>> That was almost too easy...
>>
>> Whats missing is that the libiptc.h header file should be installed.
>> My patch below is not doing the right thing. I don't know automake well enough,
>> to make it create a directory libiptc/ under include/ where it should install
>> libiptc.h.
>
> Fixed now.

Thanks, that did the trick.

You changed the iptc branch commit a bit, so now its commit c102d69b8d1 
(and not f9eab59c61), that confused me a bit...  And you general commit 
f567ac9193b "build: restructure Makefile for include/ directory" was part 
of the solution.

Thanks, nice work!

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
