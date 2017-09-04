From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add select_ops for
 stateful objects
Date: Mon, 4 Sep 2017 13:13:33 +0200
Message-ID: <20170904111333.GA29836@salvia>
References: <20170823204125.31427-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45766 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753371AbdIDLOD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 07:14:03 -0400
Content-Disposition: inline
In-Reply-To: <20170823204125.31427-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 23, 2017 at 10:41:23PM +0200, Pablo M. Bermudo Garay wrote:
> This patch adds support for overloading stateful objects operations
> through the select_ops() callback, just as it is implemented for
> expressions.
> 
> This change is needed for upcoming additions to the stateful objects
> infrastructure.

Applied with changes, see below.
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  include/net/netfilter/nf_tables.h | 30 ++++++++++++++++++++++--------
>  net/netfilter/nf_tables_api.c     | 27 ++++++++++++++++++++-------
>  net/netfilter/nft_counter.c       | 12 ++++++++----
>  net/netfilter/nft_ct.c            | 12 ++++++++----
>  net/netfilter/nft_objref.c        |  4 ++--
>  net/netfilter/nft_quota.c         | 12 ++++++++----
>  6 files changed, 68 insertions(+), 29 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index f9795fe394f3..b53639af1c7b 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1008,6 +1008,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
>   *	@list: table stateful object list node
>   *	@table: table this object belongs to
>   *	@type: pointer to object type
> + *	@ops: object operations
>   *	@data: pointer to object data
>   *	@name: name of this stateful object
>   *	@genmask: generation mask
> @@ -1022,6 +1023,7 @@ struct nft_object {
>  					use:30;
>  	/* runtime data below here */
>  	const struct nft_object_type	*type ____cacheline_aligned;
> +	const struct nft_object_ops	*ops;

We can just leave *ops here, and place *type in nft_object_ops.

No need to rework this, I have mangled this patch here.
