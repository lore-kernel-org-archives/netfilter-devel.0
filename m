From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 5/9] tproxy: allow non-local binds of IPv6 sockets if
 IP_TRANSPARENT is enabled
Date: Sun, 24 Oct 2010 16:08:23 -0700 (PDT)
Message-ID: <20101024.160823.212694928.davem@davemloft.net>
References: <1287583653.29676.9.camel@bzorp.lan>
	<1287696252.2707.24.camel@takos>
	<1287845294.13882.4.camel@bzorp.lan>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yoshfuji@linux-ipv6.org, hidden@balabit.hu, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: bazsi@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47442
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab0JXXIA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 19:08:00 -0400
In-Reply-To: <1287845294.13882.4.camel@bzorp.lan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Balazs Scheidler <bazsi@balabit.hu>
Date: Sat, 23 Oct 2010 16:48:14 +0200

> IP_TRANSPARENT requires root (more precisely CAP_NET_ADMIN privielges)
> for IPV6.
> 
> However as I see right now this check was missed from the IPv6
> implementation.
> 
> Is that enough as a safeguard? e.g. something like this:

Applied, thanks everyone.
