From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 13:18:16 +0100
Message-ID: <47C55508.7040007@trash.net>
References: <20080225094951.5bd89c9c@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:63045 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753860AbYB0MSs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 07:18:48 -0500
In-Reply-To: <20080225094951.5bd89c9c@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:
> Is there any strong reason why checking the status of iptables is restricted?
> 
> Vyatta makes a distribution for routers. In our case, we use a non-root account
> for operator commands, and some of the commands are about querying iptables status.
> It seems to be less risky to just fix the kernel to allow non-root user to query rules
> than the current script that uses sudo. Another alternative would be building a special
> restricted command that could be setuid root, but just changing the kernel seems easiest.
> 
> 
> 
> Subject: [PATCH] allow non-root to query iptables
> 
> This change allows non-root users to do 'iptables -L'.
> 
> ---
>  net/ipv4/netfilter/ip_tables.c  |    6 ------
>  net/ipv6/netfilter/ip6_tables.c |    3 ---
>  2 files changed, 0 insertions(+), 9 deletions(-)


We should also change arp_tables and ebtables. If you send me an
updated patch I'll queue it for 2.6.26.
