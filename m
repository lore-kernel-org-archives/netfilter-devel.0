From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Speed up verdict to chain_head mapping by using binary
 search
Date: Wed, 02 Jul 2008 17:28:04 +0200
Message-ID: <486B9E84.4070403@trash.net>
References: <> <1214997482-19063-1-git-send-email-jacob@internet24.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40801 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYGBP2G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:28:06 -0400
In-Reply-To: <1214997482-19063-1-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I can't spot any bugs, so I'm going to apply it so we can get
some testing. Some minor coding style issues before I'll apply
it though:

Thomas Jacob wrote:
> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index d0f51b4..e0c44c3 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -126,6 +126,26 @@ struct chain_head
>  	unsigned int foot_offset;	/* offset in rule blob */
>  };
>  
> +/* Max. number of chain_head per offsets chunk */
> +#define OFFSETS_CHUNK_SIZE (1024)
> +
> +struct offsets_create_chunk

What does "create" stand for?

> +{
> +	struct list_head list;
> +
> +	unsigned int head_offset; /* of first entry */
> +	unsigned int foot_offset; /* of last entry */

first_offset/last_offset perhaps?

> +
> +	unsigned int num_entries; /* #entries */

This is a bit excessive, num_entries really speaks for itself.

> +	struct chain_head * entries[OFFSETS_CHUNK_SIZE]; /* order by offset */
> +};
> +
> +struct offsets_lookup_table
> +{
> +	unsigned int num_entries; /* #entries */
> +	struct offsets_create_chunk ** entries; /* order by offset */
> +};
> +
>  STRUCT_TC_HANDLE
>  {
>  	int changed;			 /* Have changes been made? */
> @@ -140,6 +160,9 @@ STRUCT_TC_HANDLE
>  	struct chain_head **chain_index;   /* array for fast chain list access*/
>  	unsigned int        chain_index_sz;/* size of chain index array */
>  
> +	struct list_head            offsets_create_list; /* array chunks created during data acquisition */
> +	struct offsets_lookup_table offsets_search;      /* final offsets search array */
> +
>  	STRUCT_GETINFO info;
>  	STRUCT_GET_ENTRIES *entries;
>  };
> @@ -568,6 +591,61 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, TC_HANDLE_T h)
>  
>  
>  /**********************************************************************
> + * iptc offsets index utility functions
> + **********************************************************************/
> +
> +/* Create offsets lookup table from the chunk list */
> +static int iptcc_offsets_index_create(TC_HANDLE_T h)
> +{
> +	struct offsets_create_chunk * chunk;
> +	unsigned int total_number=0;
> +
> +	/* First pass: count non-empty chunks and set their ranges */
> +	list_for_each_entry(chunk, &h->offsets_create_list, list) {
> +		if (chunk->num_entries>0) {
> +			total_number++;
> +			chunk->head_offset = chunk->entries[0]->head_offset;
> +			chunk->foot_offset = chunk->entries[chunk->num_entries-1]->foot_offset;
> +		}
> +	}
> +
> +	/* No chains->nothing to assign */
> +	if (total_number==0)
> +		return 1;
> +
> +	h->offsets_search.entries = malloc(sizeof(struct offsets_create_chunk *)*total_number);

Please try to stay under the 80 character limit unless it makes the
code look really strange.

> +	if (!h->offsets_search.entries)
> +		return -ENOMEM;
> +
> +	/* Second pass: fill chunk table */
> +	unsigned int i=0;

Move definitions to top of functions please (everywhere of course).

> +
> +/*
> + * Fast membership check on order arrays of inclusive intervals
> + *  ( based on http://en.wikipedia.org/wiki/Binary_search )
> + *
> + * value: value to search for
> + * array: array of struct points
> + * left: struct attribute denoting left inclusive range limiter in array items
> + * right: struct attribute denoting left inclusive range limiter in array items
> + * size: number of items in array
> + * low, high, mid: temporary int variables
> + * result: index of range that contains value, or -1 if not found
> + */
> +
> +#define binary_array_range_search(value, array, left, right, size, low, high, mid, result) \
> +	low = 0; \
> +	high = size; \
> +	result = -1; \
> +	while(low<=high) \
> +	{ \
> +		mid = (low + high) / 2; \
> +		if ((array)[mid]->left > value) \
> +			high = mid - 1; \
> +		else if ((array)[mid]->right < value) \
> +			low = mid + 1; \
> +		else { \
> +			if ((array)[mid]->left <= value && value <= (array)[mid]->right) \
> +				result = mid; \
> +			break; \
> +		} \
> +	}

Any chance to make this a bit prettier? Does it need to be a macro?

> +
> +/* Returns chain head if found, otherwise NULL. */
> +static struct chain_head *
> +iptcc_find_chain_by_offset_fast(TC_HANDLE_T handle, unsigned int offset)
> +{
> +	int low,high,mid,result;
> +
> +	if (handle->offsets_search.num_entries==0)
> +		return NULL;
> +
> +	/* find the chunk */
> +	binary_array_range_search(offset, handle->offsets_search.entries, head_offset, foot_offset,
> +			handle->offsets_search.num_entries, low, high, mid, result);
> +
> +	if (result<0)

Spaces around operators please (except ++/--).

> +		return NULL;
> +
> +	/* find chain in chunk */
> +	struct chain_head ** chunk_chains =  handle->offsets_search.entries[result]->entries;
> +	unsigned int num_entries = handle->offsets_search.entries[result]->num_entries;
> +
> +	binary_array_range_search(offset, chunk_chains, head_offset, foot_offset,
> +			num_entries, low, high, mid, result);
> +
> +	if (result<0)
> +		return NULL;
> +
> +	return chunk_chains[result];
> +}
> +
>  /* Returns chain head if found, otherwise NULL. */
>  static struct chain_head *
>  iptcc_find_label(const char *name, TC_HANDLE_T handle)
> @@ -720,6 +859,19 @@ static void iptcc_delete_rule(struct rule_head *r)
>   * RULESET PARSER (blob -> cache)
>   **********************************************************************/
>  
> +/* Allocate another offsets chunk and append it to list */
> +static int __iptcc_p_new_offsets_chunk(TC_HANDLE_T h)
> +{
> +	struct offsets_create_chunk * new_chunk = malloc(sizeof(struct offsets_create_chunk));
> +
> +	if (new_chunk) {
> +		new_chunk->num_entries=0;
> +		list_add_tail(&new_chunk->list, &h->offsets_create_list);
> +		return 1;
> +	}
> +	return -1;
> +}
> +
>  /* Delete policy rule of previous chain, since cache doesn't contain
>   * chain policy rules.
>   * WARNING: This function has ugly design and relies on a lot of context, only
> @@ -746,6 +898,19 @@ static int __iptcc_p_del_policy(TC_HANDLE_T h, unsigned int num)
>  		h->chain_iterator_cur->foot_index = num;
>  		h->chain_iterator_cur->foot_offset = pr->offset;
>  
> +		/* do we need a new offsets chunk? */
> +		if (list_empty(&h->offsets_create_list) ||
> +			list_entry(h->offsets_create_list.prev, struct offsets_create_chunk, list)->num_entries
> +			>=OFFSETS_CHUNK_SIZE)
> +			if (__iptcc_p_new_offsets_chunk(h)<0)
> +				return -1;
> +
> +		/* add next chain to the current offsets chunk */
> +		struct offsets_create_chunk * occ =
> +			list_entry(h->offsets_create_list.prev, struct offsets_create_chunk, list);
> +
> +		occ->entries[occ->num_entries++]=h->chain_iterator_cur;
> +
>  		/* delete rule from cache */
>  		iptcc_delete_rule(pr);
>  		h->chain_iterator_cur->num_rules--;
> @@ -799,13 +964,14 @@ static inline void iptc_insert_chain(TC_HANDLE_T h, struct chain_head *c)
>  
>  /* Another ugly helper function split out of cache_add_entry to make it less
>   * spaghetti code */
> -static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
> +static int __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
>  				unsigned int offset, unsigned int *num)
>  {
>  	struct list_head  *tail = h->chains.prev;
>  	struct chain_head *ctail;
>  
> -	__iptcc_p_del_policy(h, *num);
> +	if ((__iptcc_p_del_policy(h, *num))<0)
> +		return -1;
>  
>  	c->head_offset = offset;
>  	c->index = *num;
> @@ -826,6 +992,8 @@ static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
>  	}
>  
>  	h->chain_iterator_cur = c;
> +
> +	return 1;
>  }
>  
>  /* main parser function: add an entry from the blob to the cache */
> @@ -844,7 +1012,10 @@ static int cache_add_entry(STRUCT_ENTRY *e,
>  		/* This is the ERROR node at the end of the chain */
>  		DEBUGP_C("%u:%u: end of table:\n", *num, offset);
>  
> -		__iptcc_p_del_policy(h, *num);
> +		if ((__iptcc_p_del_policy(h, *num))<0) {
> +			errno = -ENOMEM;
> +			return -1;
> +		}
>  
>  		h->chain_iterator_cur = NULL;
>  		goto out_inc;
> @@ -864,8 +1035,10 @@ static int cache_add_entry(STRUCT_ENTRY *e,
>  		}
>  		h->num_chains++; /* New user defined chain */
>  
> -		__iptcc_p_add_chain(h, c, offset, num);
> -
> +		if ((__iptcc_p_add_chain(h, c, offset, num))<0) {
> +			errno = -ENOMEM;
> +			return -1;
> +		}
>  	} else if ((builtin = iptcb_ent_is_hook_entry(e, h)) != 0) {
>  		struct chain_head *c =
>  			iptcc_alloc_chain_head((char *)hooknames[builtin-1], 
> @@ -879,7 +1052,10 @@ static int cache_add_entry(STRUCT_ENTRY *e,
>  
>  		c->hooknum = builtin;
>  
> -		__iptcc_p_add_chain(h, c, offset, num);
> +		if ((__iptcc_p_add_chain(h, c, offset, num))<0) {
> +			errno = -ENOMEM;
> +			return -1;
> +		}
>  
>  		/* FIXME: this is ugly. */
>  		goto new_rule;
> @@ -955,6 +1131,10 @@ static int parse_table(TC_HANDLE_T h)
>  		return -ENOMEM;
>  	iptcc_chain_index_build(h);
>  
> +	/* Build the offsets lookup table */
> +	if ((iptcc_offsets_index_create(h)) < 0)
> +		return -ENOMEM;
> +
>  	/* Second pass: fixup parsed data from first pass */
>  	list_for_each_entry(c, &h->chains, list) {
>  		struct rule_head *r;
> @@ -966,7 +1146,7 @@ static int parse_table(TC_HANDLE_T h)
>  				continue;
>  
>  			t = (STRUCT_STANDARD_TARGET *)GET_TARGET(r->entry);
> -			lc = iptcc_find_chain_by_offset(h, t->verdict);
> +			lc = iptcc_find_chain_by_offset_fast(h, t->verdict);
>  			if (!lc)
>  				return -1;
>  			r->jump = lc;
> @@ -974,6 +1154,9 @@ static int parse_table(TC_HANDLE_T h)
>  		}
>  	}
>  
> +	/* Don't need these tables anymore after beyond point */
> +	iptcc_offsets_index_free(h);
> +
>  	/* FIXME: sort chains */
>  
>  	return 1;
> @@ -1193,6 +1376,8 @@ alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
>  	strcpy(h->entries->name, tablename);
>  	h->entries->size = size;
>  
> +	INIT_LIST_HEAD(&h->offsets_create_list);
> +
>  	return h;
>  
>  out_free_handle:

