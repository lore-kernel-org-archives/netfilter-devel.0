From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next 0/4] netfilter reverse path filter matches
Date: Tue, 15 Nov 2011 10:58:26 +0100
Message-ID: <20111115095826.GA29506@1984>
References: <1320877188-1972-1-git-send-email-fw@strlen.de>
 <20111114.004716.1099241210794134345.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44367 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab1KOJ6n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:58:43 -0500
Content-Disposition: inline
In-Reply-To: <20111114.004716.1099241210794134345.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 14, 2011 at 12:47:16AM -0500, David Miller wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Wed,  9 Nov 2011 23:19:44 +0100
> 
> > Version 3 of the ipv4/v6 reverse path filter matches discussed
> > during nfws 2011.
> 
> I fully support these changes, please feel free to merge them in
> via the netfilter tree and to add my ack:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks for taking the time to review this, I need some time to test it
here but I think we'll get it into net-next soon.
