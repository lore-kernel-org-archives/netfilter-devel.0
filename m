From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Wed, 02 Apr 2008 13:06:05 +0200
Message-ID: <47F3689D.9040308@trash.net>
References: <47F2723D.2080509@kotiportti.fi> <47F36349.8050400@trash.net> <47F3666E.4020103@kotiportti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Casper Gripenberg <casper.gripenberg@kotiportti.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61486 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYDBLGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:06:10 -0400
In-Reply-To: <47F3666E.4020103@kotiportti.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Casper Gripenberg wrote:
> Patrick McHardy wrote:
>> Casper Gripenberg wrote:
>>> [...]
>>> https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=531
>>
>> I'm wondering, why does your client care about the source MAC
>> address of the REJECT packet? Or is there another switch in
>> between that does MAC filtering?
> 
> Yes..there is a switch or router between the Linux bridge
> and the computer that is supposed to receive the REJECT
> packet.
> 
> The packet stops at this router, because presumably it's
> doing some sort of MAC spoof filtering, or it just doesn't
> understand what is happening when the MAC of the source IP
> suddenly changes.
> 
> The router is my ISP's internet router, which I do not
> control. But I doubt the router is doing anything wrong
> though. The weirdness is more on the Linux side..


Sure, for full transparency the packets should ideally use
the original source MAC address. I'll see if I can come
up with a patch for this.

