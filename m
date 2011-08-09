From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/12] headers, xtables: Add missing #include <linux/netfilter.h>
Date: Tue, 09 Aug 2011 17:29:13 +0200
Message-ID: <4E415249.5010909@trash.net>
References: <1312809302.2591.1139.camel@deadeye> <1312809632.2591.1148.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39505 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1HIP3R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:29:17 -0400
In-Reply-To: <1312809632.2591.1148.camel@deadeye>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.08.2011 15:20, Ben Hutchings wrote:
> Various headers use union nf_inet_addr, defined in <linux/netfilter.h>.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

All netfilter related patches:

Acked-by: Patrick McHardy <kaber@trash.net>
