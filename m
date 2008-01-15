From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [NETFILTER] xt_pkttype match fixes
Date: Mon, 14 Jan 2008 22:43:46 -0800
Message-ID: <20080115064346.GA10022@kroah.com>
References: <Pine.LNX.4.64.0712220340490.8607@fbirervta.pbzchgretzou.qr> <20080114230711.GA8342@kroah.com> <478C4DBF.2070107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, stable@kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51394 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYASFJC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:09:02 -0500
Content-Disposition: inline
In-Reply-To: <478C4DBF.2070107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 15, 2008 at 07:07:59AM +0100, Patrick McHardy wrote:
> Greg KH wrote:
>> On Sat, Dec 22, 2007 at 03:41:29AM +0100, Jan Engelhardt wrote:
>>> We were always interpreting an IPv6 packet as IPv4, but
>>> ipv4_is_multicast() is only valid for AF_INET (obviously). Fix this
>>> by adding an extra condition to check for AF_INET.
>>>
>>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>
>> Did this ever go into Linus's tree?  I don't see it there, and as such,
>> I can't take this for the -stable tree, sorry.
>
>
> I have it queued for 2.6.25 since I missed Jan's initial posting.
>
> But the patch only affects a minor corner case (IPv6 multicast
> on loopback might be classified as broadcast), so I don't think
> it qualifies for -stable anyways.

Ok, thanks for letting me know, I'll drop it from my to-apply queue.

greg k-h
