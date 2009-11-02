From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 01 Nov 2009 22:22:49 -0800 (PST)
Message-ID: <20091101.222249.93035620.davem@davemloft.net>
References: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
	<20091101130739.GC11601@piche.inl.fr>
	<alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pchifflier@edenwall.com, netfilter-devel@vger.kernel.org,
	eleblond@inl.fr
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49577
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZKBGWZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:22:25 -0500
In-Reply-To: <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Sun, 1 Nov 2009 14:41:21 +0100 (CET)

> +static inline uint32_t deref_get_32(const void *ptr)
> +{
> +       uint32_t ret;
> +       memcpy(&ret, ptr, sizeof(ret));
> +       return ret;
> +}
> 
> Is what I use in one project; however, trying to minimize the
> unalignedness - iptables is a "perfect" example, and netlink
> may do the same tho I am not sure - seems to be the best
> approach in serialized streams.

This will not work all the time.

If GCC can see at the inlining point that 'ptr' is of a type that
should be properly aligned it can inline the memcpy and still emit
the very unaligned load or store that you're trying to avoid.

Using a void pointer doesn't create a sort of "barrier" for typing
visibility like you think it does.

So I would argue against using this construct, because it only gives
you a false sense of security.
