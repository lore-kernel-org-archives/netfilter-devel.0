From: Patrick McHardy <kaber@trash.net>
Subject: Re: [stable] [NETFILTER] xt_pkttype match fixes
Date: Tue, 15 Jan 2008 07:07:59 +0100
Message-ID: <478C4DBF.2070107@trash.net>
References: <Pine.LNX.4.64.0712220340490.8607@fbirervta.pbzchgretzou.qr> <20080114230711.GA8342@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, stable@kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61907 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYAOGIG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:08:06 -0500
In-Reply-To: <20080114230711.GA8342@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg KH wrote:
> On Sat, Dec 22, 2007 at 03:41:29AM +0100, Jan Engelhardt wrote:
>> We were always interpreting an IPv6 packet as IPv4, but
>> ipv4_is_multicast() is only valid for AF_INET (obviously). Fix this
>> by adding an extra condition to check for AF_INET.
>>
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Did this ever go into Linus's tree?  I don't see it there, and as such,
> I can't take this for the -stable tree, sorry.


I have it queued for 2.6.25 since I missed Jan's initial posting.

But the patch only affects a minor corner case (IPv6 multicast
on loopback might be classified as broadcast), so I don't think
it qualifies for -stable anyways.


