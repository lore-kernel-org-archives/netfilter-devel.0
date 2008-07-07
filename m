From: Patrick McHardy <kaber@trash.net>
Subject: Re: HTTP connection tracking
Date: Mon, 07 Jul 2008 17:25:50 +0200
Message-ID: <4872357E.4010601@trash.net>
References: <alpine.LNX.1.10.0807071547330.8248@fbirervta.pbzchgretzou.qr> <48722643.80608@trash.net> <alpine.LNX.1.10.0807071643090.8248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63520 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYGGPZy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:25:54 -0400
In-Reply-To: <alpine.LNX.1.10.0807071643090.8248@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-07-07 16:20, Patrick McHardy wrote:
>>> Connection helpers seemed like a good idea at first, since
>>> expected connections inherit the connmark value of the original
>>> connection. However, once an expectation is set up, there is no
>>> way to set up another right after one expectation has been
>>> confirmed.
>> Why not?
>>
> Hm, so this is possible through the conntrack notifier chain?

Why the notifier chain? You can use expectfns for that.

> Could this be prone to races -- windows where no exp is set up
> but a connection is already made?
> 
> - core#1 create tcp packet (src:1024 -> dst:80)
> - core#1 send off, conntrack hook sees it
> - core#2 creates expectation (src:0 -> dst:80)
> - core#2 create tcp packet (src:1025 -> dst:80)
> - core#2 send off, conntrack sees it, confirms exp.
> - core#3 create tcp packet (src:1026 -> dst:80)
> - core#3 no expectation yet => bad
> - core#2 notification delivered, exp. (src:0 -> dst:80) created

Expectation registration, notifier calls and expectfn calls
are all synchronous, so there should be no race.
