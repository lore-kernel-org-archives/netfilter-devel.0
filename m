From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] generic CONNTRACK target
Date: Tue, 15 Jan 2008 15:11:56 +0100
Message-ID: <478CBF2C.9070005@trash.net>
References: <478B8B74.3070903@netfilter.org> <478B8DF1.3060503@netfilter.org> <478C5541.9050809@trash.net> <Pine.LNX.4.64.0801151317010.30034@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40435 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYAOOMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:12:10 -0500
In-Reply-To: <Pine.LNX.4.64.0801151317010.30034@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 15 2008 07:40, Patrick McHardy wrote:
>> This doesn't seem to actually consolidate any code, just put
>> it all in one file and dispatch based on the desired operation.
>> Whats the advantage over the existing modules?
> 
> I could imagine it is the "less .ko overhead" thing as I tried with 
> xt_REJECT (12 kb, replacing a 24kb ipt_+ip6t_REJECT solution) and xt_ah.
> 
> Also, as noticed in http://lkml.org/lkml/2007/12/31/59, modules are 
> aligned at page boundaries, which means
> 
> ipt_REJECT.ko 11121 bytes uses up 12288 bytes of RAM.
> ip6t_REJECT.ko 12107 bytes also uses up 12288 bytes of RAM.
> (All values on x86_32).


Well, don't use module then. Putting everything in one module is
a rather strange way of doing this though :)

