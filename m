From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net: check the length of the data before dereferencing
 it
Date: Mon, 02 Apr 2012 05:45:45 +0200
Message-ID: <1333338345.2325.6591.camel@edumazet-glaptop>
References: <1333336250-4110-1-git-send-email-xiaosuo@gmail.com>
	 <1333336773.2325.6531.camel@edumazet-glaptop>
	 <20120401.232942.1829187970291547571.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: xiaosuo@gmail.com, kaber@trash.net, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2DBDpu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:45:50 -0400
In-Reply-To: <20120401.232942.1829187970291547571.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2012-04-01 at 23:29 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 02 Apr 2012 05:19:33 +0200
> 
> >> @@ -3845,6 +3845,8 @@ void tcp_parse_options(const struct sk_buff *skb, struct tcp_options_received *o
> >>  			length--;
> >>  			continue;
> >>  		default:
> >> +			if (length < 2)
> >> +				return;
> >>  			opsize = *ptr++;
> >>  			if (opsize < 2) /* "silly options" */
> >>  				return;
> > 
> > Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Tag Eric, you're it.
> 
> You ACK'd this patch, so you get to show how this is actually able
> to cause some kind of problem.
> 
> I assert that this is adding a useless test, that doesn't fix any kind
> of possible crash or misbehavior.  If length == 1 at the default:, the
> code will absolutely do the right thing.
> 
> Prove me wrong.

No problem.

You can have NOP,NOP,NOP,EVIL-OPTION

initial length=4  (multiple of 4)

We can read 5 bytes, and access 'out of bound' memory.

Usually not a problem since we have many bytes after our head.



