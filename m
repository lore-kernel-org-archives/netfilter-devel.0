From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix switch statement warnings with recent gcc.
Date: Wed, 8 Apr 2015 18:46:14 +0200
Message-ID: <20150408164614.GA22526@salvia>
References: <20150407.230542.359453916233129441.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44500 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbbDHQmJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:42:09 -0400
Content-Disposition: inline
In-Reply-To: <20150407.230542.359453916233129441.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 07, 2015 at 11:05:42PM -0400, David Miller wrote:
> 
> More recent GCC warns about two kinds of switch statement uses:
> 
> 1) Switching on an enumeration, but not having an explicit case
>    statement for all members of the enumeration.  To show the
>    compiler this is intentional, we simply add a default case
>    with nothing more than a break statement.
> 
> 2) Switching on a boolean value.  I think this warning is dumb
>    but nevertheless you get it wholesale with -Wswitch.
> 
> This patch cures all such warnings in netfilter.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
