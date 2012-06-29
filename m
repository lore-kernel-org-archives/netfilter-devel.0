From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] nfnetlink: Check callbacks before using those in
 nfnetlink_rcv_msg
Date: Fri, 29 Jun 2012 13:15:05 +0200
Message-ID: <20120629111505.GC15598@1984>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2F2LPL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:15:11 -0400
Content-Disposition: inline
In-Reply-To: <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 28, 2012 at 03:57:47PM +0300, Tomasz Bursztyka wrote:
> nfnetlink_rcv_msg() might call a NULL callback which will cause NULL pointer
> dereference.
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  net/netfilter/nfnetlink.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 3e797d1..4acdd76 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -184,9 +184,11 @@ replay:
>  					lockdep_is_held(&nfnl_mutex)) != ss ||
>  			    nfnetlink_find_client(type, ss) != nc)
>  				err = -EAGAIN;
> -			else
> +			else if (nc->call)
>  				err = nc->call(net->nfnl, skb, nlh,
>  						   (const struct nlattr **)cda);
> +			else
> +				err = -EINVAL;

Hm, I think this is redundant. We got the ipset problem fixed with
2/3. I think we can add some BUG_ON instead as all nc->call needs to
be defined. Otherwise, spot a bug message so it is fixed.
