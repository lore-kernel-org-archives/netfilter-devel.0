From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Wed, 2 Apr 2008 13:15:36 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804021312280.6604@fbirervta.pbzchgretzou.qr>
References: <47F2723D.2080509@kotiportti.fi> <47F36349.8050400@trash.net> <47F3666E.4020103@kotiportti.fi> <47F3689D.9040308@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Casper Gripenberg <casper.gripenberg@kotiportti.fi>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43201 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYDBLPh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:15:37 -0400
In-Reply-To: <47F3689D.9040308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-02 13:06, Patrick McHardy wrote:
>>
>>  The router is my ISP's internet router, which I do not
>>  control. But I doubt the router is doing anything wrong
>>  though. The weirdness is more on the Linux side..
>
> Sure, for full transparency the packets should ideally use
> the original source MAC address. I'll see if I can come
> up with a patch for this.

The problem is an interesting one. REJECT itself does not fill
in the MAC address, and probably should not try (there is more
than just Ethernet). Yet the routing code is so deeply buried
that drawing a seam through the entire call chain seems intrusive.
</random thoughts>


-- 
make boldconfig -- to boldly select what no one has selected before
