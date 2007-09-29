From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Sat, 29 Sep 2007 11:16:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709291115240.22032@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43776 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXI2JQE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:16:04 -0400
In-Reply-To: <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 29 2007 11:04, Sven Schnelle wrote:
>> Jan Engelhardt wrote:
>>> Since I had nothing better to do, I did a cleanup :)
>>
>> Great :) My main question is what the use case of this is.
>
>Main intention for writing this module was to strip of TCP Options from
>the SYN packets sent by some Hosts - for example Hosts that are
>announcing that they can do window scaling, but in fact some broken
>implementation/routers inbetween are preventing this. Simply stripping
>of these Option allows communicating with such device, without the need
>to disable window scaling kernel-wide.

Come to speak of it, I would need this, as there is a broken
netgear router in this house :-/
