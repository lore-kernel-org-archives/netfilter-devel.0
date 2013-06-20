From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nfqueue: add ability to dump list
 of supported attributes
Date: Thu, 20 Jun 2013 20:27:01 +0200
Message-ID: <20130620182701.GA8769@localhost>
References: <1370360273-20633-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab3FTS1M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:27:12 -0400
Content-Disposition: inline
In-Reply-To: <1370360273-20633-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, Jun 04, 2013 at 05:37:53PM +0200, Florian Westphal wrote:
> Allows userspace to dump the list of known (extended) attributes.
> For SKB_INFO, we set all the info flag bits supported by the running kernel.
> 
> The latter is required because absence of some bits in the info attribute will
> either mean "skb did not have the property" OR "this kernel doesn't know about
> this flag".
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Recent discussion of the
>  "netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag" patch
>  (http://patchwork.ozlabs.org/patch/246460/) shows that we'll need
>  to tell userspace the supported info bits in the NFAQ_SKB_INFO attribute.

After going back to this issue, I think I prefer to enqueue:

netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag

to net-next, and ask for -stable submission once this hits net, as it
will be fixing an inconsistent behaviour. Another reason for that is
that such patch is fairly small (~16 LOC).

Both approaches we discussed that are:

a) adding a new config flags

and

b) adding this infrastructure

look a bit too much to me just to resolve this.

Once this patch hits -stable, we can consistently say that:

NFQA_SKB_CSUMNOTREADY
NFQA_SKB_GSO
NFQA_SKB_CSUM_NOTVERIFIED

are obtained via NFQA_CFG_F_GSO.

For user-space application running with different, they can still send
every configuration incrementally, so you spot a message telling what
is available and what is not. I planned to use this to add GSO support
for the user-space helper infrastructure.

Let me know.
