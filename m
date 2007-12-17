From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Mon, 17 Dec 2007 14:44:23 +0100
Message-ID: <47667D37.2080501@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr> <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr> <4763F8FE.5040607@netfilter.org> <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr> <47640412.5050207@netfilter.org> <47666FF4.6040102@trash.net> <476674B2.8050808@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXLQNpL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:45:11 -0500
In-Reply-To: <476674B2.8050808@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>
>>> Not that I'm against your patches, I'm just stating the right direction
>>> to go for those 5-10 years that you have mentioned. And of course, we
>>> don't have a single line of such interface at the moment :)
>>
>> Actually we do, I've been working on it, but had to interrupt
>> for some other stuff. I hope to get back to it over christmas
>> and beginning of next year. The goal is to add a compat layer
>> for old iptables userspace, but I don't really care about how
>> ugly it gets since we hopefully never have to look at it again
>> until its removal :)
> 
> Cool, consider putting it somewhere, I'm willing to contribute to it ;).

Its not really in a state for that yet, but I will as soon as it is.

> BTW, if nobody complains I'll release iptables 1.4.0 final between today
> and tomorrow.

Great, thanks.

