From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Wed, 02 Apr 2008 13:18:28 +0200
Message-ID: <47F36B84.5070708@trash.net>
References: <47F2723D.2080509@kotiportti.fi> <47F36349.8050400@trash.net> <47F3666E.4020103@kotiportti.fi> <47F3689D.9040308@trash.net> <alpine.LNX.1.10.0804021312280.6604@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Casper Gripenberg <casper.gripenberg@kotiportti.fi>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYDBLSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:18:32 -0400
In-Reply-To: <alpine.LNX.1.10.0804021312280.6604@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> On Wednesday 2008-04-02 13:06, Patrick McHardy wrote:
>>>
>>>  The router is my ISP's internet router, which I do not
>>>  control. But I doubt the router is doing anything wrong
>>>  though. The weirdness is more on the Linux side..
>>
>> Sure, for full transparency the packets should ideally use
>> the original source MAC address. I'll see if I can come
>> up with a patch for this.
> 
> The problem is an interesting one. REJECT itself does not fill
> in the MAC address, and probably should not try (there is more
> than just Ethernet). Yet the routing code is so deeply buried
> that drawing a seam through the entire call chain seems intrusive.
> </random thoughts>


One way is to have REJECT specifically handle the bridging case
by setting up an appropriate skb->nf_bridge struct, which will
make the bridging code fill in the correct MAC address. For
REJECT this would be borderline OK, but icmp_send really shouldn't
care about this, so a generic method would be preferrable.
