From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 17:00:50 +1000
Message-ID: <4816C7A2.3060307@snapgear.com>
References: <4816B983.4030906@snapgear.com>	<20080428.231414.193695218.davem@davemloft.net>	<4816C550.6080602@snapgear.com> <20080428.235650.193704155.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	rmk@arm.linux.org.uk
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:46055 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753728AbYD2HAw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:00:52 -0400
In-Reply-To: <20080428.235650.193704155.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> But it still means the bit marked packed is going to be
> accessed using byte-at-a-time loads and stores.

That's not what my results showed (the bw() case).

> I guess this is immaterial, as it seems the memset() is the
> best solution anyways.

Yep.
