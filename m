From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 15:58:38 +0200
Message-ID: <47F4E28E.4050606@trash.net>
References: <47F4C686.2000700@trash.net>	<alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr>	<47F4D8F3.70606@trash.net> <20080403.225450.17235422.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: yoshfuji@linux-ipv6.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35519 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbYDCN6m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:58:42 -0400
In-Reply-To: <20080403.225450.17235422.yoshfuji@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

YOSHIFUJI Hideaki / $B5HF#1QL@ wrote:
> In article <47F4D8F3.70606@trash.net> (at Thu, 03 Apr 2008 15:17:39 +0200), Patrick McHardy <kaber@trash.net> says:
> 
> :
>>>>>   #define AF_ECONET    19    /* Acorn Econet            */
>>>>>   #define AF_ATMSVC    20    /* ATM SVCs            */
>>>>>  +#define AF_ARP        21    /* Address Resolution for IPv4    */
> :
>> I don't like exporting this since, as you say, userspace doesn't
>> need it and arp isn't an address family. I would suggest to
> :
> 
> Why not #ifdef __KERNEL__ .. #endif?
> Or just add a comment not to use the value.


It sets a bad example to add new non-families there as well.
We're dimensioning lots of things using AF_MAX, so its better
to avoid misuse.

