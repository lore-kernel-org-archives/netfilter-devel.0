From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Per-conntrack timeout target
Date: Mon, 19 Nov 2007 11:32:52 +0100
Message-ID: <47416654.7020300@trash.net>
References: <20071117181123.GA15156@linuxace.com> <473F457C.1000708@trash.net> <20071119014049.GA2013@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61802 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXKSKdM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:33:12 -0500
In-Reply-To: <20071119014049.GA2013@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> On Sat, Nov 17, 2007 at 08:48:12PM +0100, Patrick McHardy wrote:
>> The only downside I see is that it adds another 4 bytes to the conntrack
>> structure and distributions are probably going to enable it, like
>> everything else. 
> 
> Yep, that's a problem.
> 
>> It would be nice if we could put this in a ct_extend
>> structure, but that would mean you're only able to set it for new
>> connections. What do you think about this?
> 
> Complicates my life, but is the Right Thing.  I'll work on this.
> Should we be considering the same for mark/secmark?


That would be incompatible to todays behaviour, so I think no.
We could of course consider making ct_extend work for confirmed
conntracks, for thats a lot more complicated without adding
extra locking everywhere :) What would work though is to specify
which connections will have manually managed timeouts while they're
unconfirmed (either through a target or by registering a prealloc
type, so we allocate accordingly), and only allow to change the
settings of confirmed connections.
