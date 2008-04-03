From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 22:54:50 +0900 (JST)
Message-ID: <20080403.225450.17235422.yoshfuji@linux-ipv6.org>
References: <47F4C686.2000700@trash.net>
	<alpine.LNX.1.10.0804031444200.1301@fbirervta.pbzchgretzou.qr>
	<47F4D8F3.70606@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org,
	yoshfuji@linux-ipv6.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yue.linux-ipv6.org ([203.178.140.15]:60288 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYDCNxO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:53:14 -0400
In-Reply-To: <47F4D8F3.70606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In article <47F4D8F3.70606@trash.net> (at Thu, 03 Apr 2008 15:17:39 +0200), Patrick McHardy <kaber@trash.net> says:

:
> >>>   #define AF_ECONET    19    /* Acorn Econet            */
> >>>   #define AF_ATMSVC    20    /* ATM SVCs            */
> >>>  +#define AF_ARP        21    /* Address Resolution for IPv4    */
> >>
:
> I don't like exporting this since, as you say, userspace doesn't
> need it and arp isn't an address family. I would suggest to
:

Why not #ifdef __KERNEL__ .. #endif?
Or just add a comment not to use the value.

--yoshfuji
