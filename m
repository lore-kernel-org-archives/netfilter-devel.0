From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Thu, 11 Oct 2007 06:10:23 +0200
Message-ID: <470DA22F.70807@trash.net>
References: <470CA4DF.6000803@oktetlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Konstantin Ushakov <kostik@oktetlabs.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46947 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXJKEKZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:10:25 -0400
In-Reply-To: <470CA4DF.6000803@oktetlabs.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Konstantin Ushakov wrote:
> Netfilter team,
> 
> we use netfilter under linux kernel 2.4.31 and have the problem
> described below.
> !Note, that it can be easily reproduced for latest kernels.
> 
>  - we want to connect to some on tcp port #80
>  - in the kernel and in some time we get to ip_route_output_slow function
>  - in this function kernel searches for route for the packet:
>          if (fib_lookup(&key, &res)) {
>             res.fi = NULL;
>             if (oldkey->oif) {               <- oif is zero at this
> point, so we miss that "if"
>                 ......
>             }
>             ...
>             err = -ENETUNREACH;
>             goto out;
>          }
>     It fails to find one as we don't have fwmark set for the packet and
> there is not route for packets without fwmark (see configuration
> attached). So, ENETUNREACH is returned and the packet fails to be sent.
> In fact the packet could be routed
> correctly, but this would happen in ip_build_xmit function in netfilter
> hook for LOCAL_OUT packets.
> 
> Questions:
>  - is it a bug or it's a deliberate decision to have such behaviour?
>  - is there any known add-hock solution for the problem?


Its a consequence of how routing by fwmark works. Its not perfect,
but I don't see a better solution since the initial routing takes
place before we even have a packet.

Just add a route to the dummy device or something like that, that
should make sure you don't get ENETUNREACH.
