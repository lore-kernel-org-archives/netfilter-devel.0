From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TPROXY cleanups
Date: Mon, 06 Oct 2008 17:41:59 +0200
Message-ID: <48EA31C7.3040604@trash.net>
References: <20081006121943.GA13547@x200.localdomain> <20081006122603.GA18559@sch.bme.hu> <20081006123921.GA23796@x200.localdomain> <20081006141559.GC18559@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	hidden@sch.bme.hu, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44808 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYJFPmG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:42:06 -0400
In-Reply-To: <20081006141559.GC18559@sch.bme.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

KOVACS Krisztian wrote:
> On h, okt 06, 2008 at 04:39:21 +0400, Alexey Dobriyan wrote:
>> xt_TPROXY will pin it because it uses a symbol from it, so it won't
>> dissapear.
> 
> Yeah, that's true, and I think that it's impossible to remove the rule
> attaching the socket references while the skb's in flight. Ok, so let's
> add module_exit() then.

So Alexey's patch is fine for applying?


