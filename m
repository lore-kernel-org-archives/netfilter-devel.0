Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EFD374179;
	Thu, 26 Feb 2026 03:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772078197; cv=none; b=tOPq5DXHTeH4F+i5TEvZA1FDSdUUBP7Bnh9DcD401jww2MLhzxORRvgRNI0woXL13yxRW19vjts/LWh+vxKJAoYJ8109U/Ieo69sFYmbrlyRSOcQfX49Gonu+pOiiXVM+md8gZ1w71SuRDp5zLzGjA2OZMYhaKY4WlHltZdfz3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772078197; c=relaxed/simple;
	bh=ke5ENIBnaxIX4/dyRyrHjIfdMRzU+L/so66Dykvkkuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1fGDEt2w4/nh1KnfPmF0Pt0OC+idNt3OkPttWNpg5GpKlvLbjXqctPJqPlOqwrGhX2TLcjUAqd5MeNByNrkjS27BS9uZ13fTZrVF3dZj3cuZTClNnv20tBBaVjxc8sxMqjKLvvDqnaXvtdkNpiJ9n3xwD8JX88aRt3PgdI5X6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCMcLdLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCMcLdLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310A3C19424;
	Thu, 26 Feb 2026 03:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772078196;
	bh=ke5ENIBnaxIX4/dyRyrHjIfdMRzU+L/so66Dykvkkuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCMcLdLJFgpQV0ObhIqSsbh4ry1cIgOYSiL2WKmStrRIUysdb+KFss+oPUjZta9ei
	 Lv6iNipYacrECUKaoG6YP0DOfMurq4KwhcgdKgqDTEw/dVp32fwlSNCAZCOCca+RBR
	 wyQZH9ojv6blB7IpiGa7wQwoAl9pFSVMzS0mowaXmPtIepygBkrxwZBZW7Uqwu/aPd
	 OJWM+3IMQQPuFEMRF88PisDIlOc5s5R31pZh5NjyoXXv4V8JoDOpejBi9Q3ij8rjb0
	 9s8tJ6sSwnx0VknCyveXXYRZJRGz9egQa4JN0LLlzN52gttr2HVl6GBifl33UKo8Pl
	 egpqJbJ+CkigQ==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	edumazet@google.com,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	davem@davemloft.net,
	netdev@vger.kernel.org
Subject: Re: [net,2/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Wed, 25 Feb 2026 19:56:28 -0800
Message-ID: <20260226035628.1827287-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225130619.1248-3-fw@strlen.de>
References: <20260225130619.1248-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "Is this legit?"

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
netfilter: nf_tables: unconditionally bump set->nelems before insertion

This commit addresses a race condition where a new element gets published
then removed without waiting for the RCU grace period when the set is full.
The fix moves the nelems increment before insertion and adds cleanup logic
using the abort path to safely unwind the set.

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0c5a4855b97d..834736237b09 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	struct nft_data_desc desc;
>  	enum nft_registers dreg;
>  	struct nft_trans *trans;
> +	bool set_full = false;
>  	u64 expiration;
>  	u64 timeout;
>  	int err, i;
> @@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	if (err < 0)
>  		goto err_elem_free;
>
> +	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> +		unsigned int max = nft_set_maxsize(set), nelems;
> +
> +		nelems = atomic_inc_return(&set->nelems);
> +		if (nelems > max)
> +			set_full = true;
> +	}
> +
>  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
>  	if (trans == NULL) {
>  		err = -ENOMEM;
> -		goto err_elem_free;
> +		goto err_set_size;
>  	}
>
>  	ext->genmask = nft_genmask_cur(ctx->net);
> @@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>
>  					ue->priv = elem_priv;
>  					nft_trans_commit_list_add_elem(ctx->net, trans);
> -					goto err_elem_free;
> +					goto err_set_size;
>  				}
>  			}
>  		}
> @@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  		goto err_element_clash;
>  	}
>
> -	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
> -		unsigned int max = nft_set_maxsize(set);
> -
> -		if (!atomic_add_unless(&set->nelems, 1, max)) {
> -			err = -ENFILE;
> -			goto err_set_full;
> -		}
> -	}
> -
>  	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
>  	nft_trans_commit_list_add_elem(ctx->net, trans);
> -	return 0;
>
> -err_set_full:
> -	nft_setelem_remove(ctx->net, set, elem.priv);
> +	return set_full ? -ENFILE : 0;
> +
>  err_element_clash:
>  	kfree(trans);
> +err_set_size:
> +	if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
> +		atomic_dec(&set->nelems);

Does this properly handle the element update path when the set is full?

When updating an existing element on a full set (NLM_F_EXCL not set,
timeout changes), the code reaches line 7526 and jumps to err_set_size with
the transaction already added to the commit list via
nft_trans_commit_list_add_elem(). The function then returns 0 (success).

On commit, nft_trans_elem_update() is called, but it doesn't touch nelems.
On abort, nft_trans_elems_new_abort() skips the atomic_dec for updates:

if (te->elems[i].update != NULL) {
    ...
    continue;  // skips atomic_dec
}

Since set_full is true, the !set_full condition at err_set_size prevents the
decrement here. Result: nelems is permanently inflated by 1 for each update
operation performed when the set is full.

Over time, this progressively reduces the effective maximum set size. Can the
update path decrement nelems when set_full is true, or should the abort path
handle updates differently?


What happens when nft_setelem_insert() fails with -EEXIST on a full set?

When the set is at maximum capacity (set_full==true after atomic_inc_return)
and nft_setelem_insert() then fails with -EEXIST due to a duplicate element,
the code jumps to err_element_clash:

err_element_clash:
    kfree(trans);
err_set_size:
    if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
        atomic_dec(&set->nelems);

Since set_full is true, the !set_full condition prevents the atomic_dec. But
the transaction was freed via kfree(trans) and never added to the commit list,
so the abort path (nft_trans_elems_new_abort) will never see this element and
cannot correct the counter.

The nelems counter is permanently inflated by 1 with no corresponding element
in the set. Repeated occurrences accumulate, progressively reducing the
effective maximum set size. Should atomic_dec be called unconditionally, or
should the condition be adjusted for this case?


Can insertion failures on a full set leak nelems increments?

The patch moves atomic_inc_return(&set->nelems) to before
nft_setelem_insert(). When the set is at capacity (set_full==true) and
subsequent insertion fails (e.g., -EEXIST duplicate, -ENOTEMPTY overlap), the
error path reaches err_set_size where the decrement is guarded by !set_full:

err_set_size:
    if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
        atomic_dec(&set->nelems);

Since set_full is true, the decrement is skipped. The transaction was freed at
err_element_clash and never added to the commit list, so the abort path cannot
correct the counter either.

Each such operation permanently inflates set->nelems by 1. Over time, this
causes nft_dynset_new() in the packet-processing data path to always see a
full set (atomic_add_unless fails against set->size), rejecting all new
dynamic element insertions.

In the old code, atomic_add_unless(&set->nelems, 1, max) was placed AFTER
nft_setelem_insert(), so insertion failures never incremented nelems. Should
the decrement at err_set_size account for these failure cases?

>  err_elem_free:
>  	nf_tables_set_elem_destroy(ctx, set, elem.priv);
>  err_parse_data:
