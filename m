From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Wed, 28 Nov 2007 09:30:44 +0100
Message-ID: <474D2734.3010601@trash.net>
References: <474C4B67.3000200@trash.net> <Pine.LNX.4.64.0711272245390.9483@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39812 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXK1Iax (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:30:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711272245390.9483@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Tue, 27 Nov 2007, Patrick McHardy wrote:
> 
>> I have a large number of pending patches for iptables for new
>> matches and targets. I'm not going apply patches for new things
>> unless they are at least in a -rc kernel, so we have a chance to
>> fix mistakes. So my question is whether we're ready to release
>> the current iptables -rc anytime soon (before/when 2.6.24 is
>> released) or whether we're more likely going to need until 2.6.25,
>> in which case I would apply them now.
> 
> What about my performance/scalability patches, do I need to wait another 
> kernel cycle to see them released?
> 
> I think that, at least patch 1/2 should be applied, as its a obvious fix.

Yes, the first one is obviously fine. I'm going to apply it now.

> For at patch 2/2, I would like some comments on the type casting, e.g. 
> if it will work on all platforms e.g. 64-bit.

I'll have a closer look.
