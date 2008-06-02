From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [PATCH net-2.6 2/2] [IPV4] [NETFILTER] Misc Cleanups.
Date: Mon, 02 Jun 2008 11:48:17 +0200
Message-ID: <4843C1E1.8020309@trash.net>
References: <20080601.234615.204287317.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ramirose@gmail.com
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62761 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYFBJsX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:48:23 -0400
In-Reply-To: <20080601.234615.204287317.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> This patch removes nf_ct_ipv4_ct_gather_frags() method declaration from
> include/net/netfilter/ipv4/nf_conntrack_ipv4.h, since it is unused in
> the Linux kernel.

Applied, thanks.
