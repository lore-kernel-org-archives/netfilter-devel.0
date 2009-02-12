From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 15:11:17 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902121511030.27867@fbirervta.pbzchgretzou.qr>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
 <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0902121014550.22322@ask.diku.dk> <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hawk@comx.dk
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52637 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZBLOLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:11:20 -0500
In-Reply-To: <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-12 11:42, Jesper Dangaard Brouer wrote:
> On Thu, 12 Feb 2009, Jesper Dangaard Brouer wrote:
>> On Thu, 12 Feb 2009, Jan Engelhardt wrote:
>>
>>> If Jesper then wants to play with the API, no problem, just
>>> don't forget bumping the so_version correctly.
>>
>> I'll try it out today... lets see how intrusive it is...
>
> That was almost too easy...
>
> Whats missing is that the libiptc.h header file should be installed.
> My patch below is not doing the right thing. I don't know automake well enough,
> to make it create a directory libiptc/ under include/ where it should install
> libiptc.h.

Fixed now.
