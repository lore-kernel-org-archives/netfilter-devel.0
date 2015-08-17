From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: precondition validation fails on map construct
Date: Mon, 17 Aug 2015 15:24:47 +0100
Message-ID: <20150817142447.GA19864@macbook.localdomain>
References: <55CCA98D.2030908@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61506 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbbHQOYw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Aug 2015 10:24:52 -0400
Content-Disposition: inline
In-Reply-To: <55CCA98D.2030908@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13.08, Andreas Schultz wrote:
> Hi,
> 
> As far as I can tell the following construct should be valid:
> 
> # nft add nat prerouting ip protocol {tcp, udp} snat 10.200.4.1-10.200.4.254:10240-20480
> 
> However it fails with:
> 
> <cmdline>:1:72-82: Error: transport protocol mapping is only valid after transport protocol match
> add nat prerouting ip protocol {tcp, udp} snat 10.200.4.1-10.200.4.254:10240-20480
>                                           ~~~~                         ^^^^^^^^^^^
> 
> Is this intended behaviour?

Yes, sets don't create a protocol context since we can currently only handle
a single protocol. It could be made to work, but right now it is expected
behaviour.

> 
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
