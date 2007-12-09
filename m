From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] Add support for NAT sequence adjustments
Date: Sun, 09 Dec 2007 20:09:34 +0100
Message-ID: <475C3D6E.9000800@trash.net>
References: <475C302C.1070402@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60027 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLITJv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:09:51 -0500
In-Reply-To: <475C302C.1070402@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> The combination of NAT and helpers may produce TCP sequence adjustments.
> In failover setups, this information needs to be replicated in order to
> achieve a successful recovery of mangled, related connections. This
> patch is particularly useful for conntrackd, see:
>
>   
+	/* NAT sequence adjustment */
+	IPCT_NATSEQADJ_BIT = 13,
+	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),

You don't seem to be using this bit for anything.

