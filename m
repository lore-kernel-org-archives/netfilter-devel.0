From: Casper Gripenberg <casper.gripenberg@kotiportti.fi>
Subject: Re: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Wed, 02 Apr 2008 13:56:46 +0300
Message-ID: <47F3666E.4020103@kotiportti.fi>
References: <47F2723D.2080509@kotiportti.fi> <47F36349.8050400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:59071 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYDBK5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:57:04 -0400
In-Reply-To: <47F36349.8050400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Casper Gripenberg wrote:
>> [...]
>> https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=531
> 
> I'm wondering, why does your client care about the source MAC
> address of the REJECT packet? Or is there another switch in
> between that does MAC filtering?

Yes..there is a switch or router between the Linux bridge
and the computer that is supposed to receive the REJECT
packet.

The packet stops at this router, because presumably it's
doing some sort of MAC spoof filtering, or it just doesn't
understand what is happening when the MAC of the source IP
suddenly changes.

The router is my ISP's internet router, which I do not
control. But I doubt the router is doing anything wrong
though. The weirdness is more on the Linux side..

Casper


