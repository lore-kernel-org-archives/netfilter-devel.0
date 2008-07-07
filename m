From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: HTTP connection tracking
Date: Mon, 7 Jul 2008 16:52:52 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807071643090.8248@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807071547330.8248@fbirervta.pbzchgretzou.qr> <48722643.80608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43721 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYGGOwy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:52:54 -0400
In-Reply-To: <48722643.80608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-07 16:20, Patrick McHardy wrote:
>>
>> Connection helpers seemed like a good idea at first, since
>> expected connections inherit the connmark value of the original
>> connection. However, once an expectation is set up, there is no
>> way to set up another right after one expectation has been
>> confirmed.
>
> Why not?
>
Hm, so this is possible through the conntrack notifier chain?
Could this be prone to races -- windows where no exp is set up
but a connection is already made?

- core#1 create tcp packet (src:1024 -> dst:80)
- core#1 send off, conntrack hook sees it
- core#2 creates expectation (src:0 -> dst:80)
- core#2 create tcp packet (src:1025 -> dst:80)
- core#2 send off, conntrack sees it, confirms exp.
- core#3 create tcp packet (src:1026 -> dst:80)
- core#3 no expectation yet => bad
- core#2 notification delivered, exp. (src:0 -> dst:80) created
