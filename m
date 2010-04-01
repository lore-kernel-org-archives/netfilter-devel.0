From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter module and shared libraries
Date: Thu, 01 Apr 2010 14:05:22 +0200
Message-ID: <4BB48C02.40601@trash.net>
References: <m2zdac45061004010446o99e12733m645008caac88873c@mail.gmail.com> <alpine.LSU.2.01.1004011358350.17429@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, Mark Ryden <markryde@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50890 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0DAMFY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:05:24 -0400
In-Reply-To: <alpine.LSU.2.01.1004011358350.17429@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-04-01 13:46, Mark Ryden wrote:
> 
>> Is there a way to avoid this when adding such a rule,
>> using some default mechansim ?
> 
> Let's ask Patrick:
> 
> What do you think of enabling iptables to assume targets with .size=0 
> (which don't have options by design) if there was no libxt_XYZ.so found? 
> That would make things like libxt_NOTRACK.c obsolete, too.

No general objections, but how many modules are there really
that don't take options? Feel free to try, if your patch doesn't
affect error reporting and stays below 15 lines, I'll apply
it :)
