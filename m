Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6222F14EC56
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718699302; cv=none; b=Hwipv2SdPq7SfFJf+jSJrQOjj0yk856dinuDCwmB+N0UoTGsKSnN5xhdRk8/1A8213GMkCWHypdzC0pyTCSb6TzIuDtYBRYffK3ZcKTxZdZg+6ogyo99fKsRqckoMz/UcaF64o0kIKJjfTGGFpwfM4w6ZSNkis2jHBpSAASo9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718699302; c=relaxed/simple;
	bh=27SuhPpkCku5ry19FNjwKp0o2uqM2QqA3U8gCcXqJh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7PA8fa6QKDubqZ64UnzqUkMLoBZDQRHVRFnGtHhda0Ak7bXJxGfXrroiRtPwpYbemnwSBdZ1CYQO+z6gBuqrQyNJISowFCOvbU9mwJwMp1CPeMgITVNiFtMvy+YTlmtKKjnxuX8mAxVKxfq+UvVX6JtzCprw1Y9MdiRiBPXOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48900 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJUCL-00D9VI-AA; Tue, 18 Jun 2024 10:28:15 +0200
Date: Tue, 18 Jun 2024 10:28:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 01/11] netfilter: nf_tables: make struct
 nft_trans first member of derived subtypes
Message-ID: <ZnFFHIcI1HRIDzbh@calendula>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240513130057.11014-2-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Mon, May 13, 2024 at 03:00:41PM +0200, Florian Westphal wrote:
> There is 'struct nft_trans', the basic structure for all transactional
> objects, and the the various different transactional objects, such as
> nft_trans_table, chain, set, set_elem and so on.
> 
> Right now 'struct nft_trans' uses a flexible member at the tail
> (data[]), and casting is needed to access the actual type-specific
> members.
> 
> Change this to make the hierarchy visible in source code, i.e. make
> struct nft_trans the first member of all derived subtypes.
> 
> This has several advantages:
> 1. pahole output reflects the real size needed by the particular subtype
> 2. allows to use container_of() to convert the base type to the actual
>    object type instead of casting ->data to the overlay structure.
> 3. It makes it easy to add intermediate types.
> 
> 'struct nft_trans' contains a 'binding_list' that is only needed
> by two subtypes, so it should be part of the two subtypes, not in
> the base structure.
> 
> But that makes it hard to interate over the binding_list, because
> there is no common base structure.
> 
> A follow patch moves the bind list to a new struct:
> 
>  struct nft_trans_binding {
>    struct nft_trans nft_trans;
>    struct list_head binding_list;
>  };
> 
> ... and makes that structure the new 'first member' for both
> nft_trans_chain and nft_trans_set.
> 
> No functional change intended in this patch.
> 
> Some numbers:
>  struct nft_trans { /* size: 88, cachelines: 2, members: 5 */
>  struct nft_trans_chain { /* size: 152, cachelines: 3, members: 10 */
>  struct nft_trans_elem { /* size: 112, cachelines: 2, members: 4 */
>  struct nft_trans_flowtable { /* size: 128, cachelines: 2, members: 5 */
>  struct nft_trans_obj { /* size: 112, cachelines: 2, members: 4 */
>  struct nft_trans_rule { /* size: 112, cachelines: 2, members: 5 */
>  struct nft_trans_set { /* size: 120, cachelines: 2, members: 8 */
>  struct nft_trans_table { /* size: 96, cachelines: 2, members: 2 */
> 
> Of particular interest is nft_trans_elem, which needs to be allocated
> once for each pending (to be added or removed) set element.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_tables.h | 88 +++++++++++++++++--------------
>  net/netfilter/nf_tables_api.c     | 10 ++--
>  2 files changed, 54 insertions(+), 44 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 2796153b03da..af0ef21f3780 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1608,14 +1608,16 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
>  }
>  
>  /**
> - *	struct nft_trans - nf_tables object update in transaction
> + * struct nft_trans - nf_tables object update in transaction
>   *
> - *	@list: used internally
> - *	@binding_list: list of objects with possible bindings
> - *	@msg_type: message type
> - *	@put_net: ctx->net needs to be put
> - *	@ctx: transaction context
> - *	@data: internal information related to the transaction
> + * @list: used internally
> + * @binding_list: list of objects with possible bindings
> + * @msg_type: message type
> + * @put_net: ctx->net needs to be put
> + * @ctx: transaction context
> + *
> + * This is the information common to all objects in the transaction,
> + * this must always be the first member of derived sub-types.
>   */
>  struct nft_trans {
>  	struct list_head		list;
> @@ -1623,10 +1625,10 @@ struct nft_trans {
>  	int				msg_type;
>  	bool				put_net;
>  	struct nft_ctx			ctx;
> -	char				data[];
>  };
>  
>  struct nft_trans_rule {
> +	struct nft_trans		nft_trans;
>  	struct nft_rule			*rule;
>  	struct nft_flow_rule		*flow;
>  	u32				rule_id;
> @@ -1634,15 +1636,16 @@ struct nft_trans_rule {
>  };
>  
>  #define nft_trans_rule(trans)	\
> -	(((struct nft_trans_rule *)trans->data)->rule)
> +	container_of(trans, struct nft_trans_rule, nft_trans)->rule

Another nitpicking comestic issue:

Maybe I can get this series slightly smaller if

        nft_trans_rule_container

is added here and use it, instead of the opencoded container_of.

For consistency with:

#define nft_trans_container_set(t)

which is used everywhere in this header in a follow up patch.

I mangle this at the expense of adding my own bugs :)

[...]
>  #define nft_trans_set(trans)	\
> -	(((struct nft_trans_set *)trans->data)->set)
> +	container_of(trans, struct nft_trans_set, nft_trans)->set
>  #define nft_trans_set_id(trans)	\
> -	(((struct nft_trans_set *)trans->data)->set_id)
> +	container_of(trans, struct nft_trans_set, nft_trans)->set_id
>  #define nft_trans_set_bound(trans)	\
> -	(((struct nft_trans_set *)trans->data)->bound)
> +	container_of(trans, struct nft_trans_set, nft_trans)->bound
>  #define nft_trans_set_update(trans)	\
> -	(((struct nft_trans_set *)trans->data)->update)
> +	container_of(trans, struct nft_trans_set, nft_trans)->update
>  #define nft_trans_set_timeout(trans)	\
> -	(((struct nft_trans_set *)trans->data)->timeout)
> +	container_of(trans, struct nft_trans_set, nft_trans)->timeout
>  #define nft_trans_set_gc_int(trans)	\
> -	(((struct nft_trans_set *)trans->data)->gc_int)
> +	container_of(trans, struct nft_trans_set, nft_trans)->gc_int
>  #define nft_trans_set_size(trans)	\
> -	(((struct nft_trans_set *)trans->data)->size)
> +	container_of(trans, struct nft_trans_set, nft_trans)->size
