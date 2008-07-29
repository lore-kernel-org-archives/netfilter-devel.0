From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 06:47:45 +0200
Message-ID: <488EA0F1.2050906@trash.net>
References: <20080729030104.GA15915@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39312 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYG2Esk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:48:40 -0400
In-Reply-To: <20080729030104.GA15915@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[List address fixed - I assume netfilter-devel@lists.debian.org doesn't 
exist :)]

Herbert Xu wrote:
> Hi:
>
> I've recently started keeping an eye on the number of connections
> in my router's conntrack table.  It was sad to see so many TCP
> connections that have died long ago still lingering in it.  We all
> know that wandering ghosts are bad :)
>
> Here's my proposal to lay them to rest once and for all.  The
> obvious solution is to reduce the timeout.  However, that runs
> afoul of idle connections.  So the key is how do we tell an
> idle connection apart from a dead one.
>
> Actually it isn't too hard.  The most common reason for a connection
> to die without sending FIN/RST is a retransmission timeout.  For
> example in Linux we can enter FIN_WAIT_1 without even transmitting
> the actual FIN because of outstanding data before it.  So if we
> tracked whether each connection has unacknowledged data then we
> will be able to easily distinguish them.  In other words, we can
> drastically lower the timeout on a connection with data outstanding.
>
> The only trouble now is to find a sucker^H^H^H^H^H^Hvolunteer
> to implement this :)
>   


That sounds like a pretty neat idea. I'm testing a patch now, I'll
send it over in a few minutes if it survives :)

