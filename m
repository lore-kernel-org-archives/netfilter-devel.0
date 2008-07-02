From: Thomas Jacob <jacob@internet24.de>
Subject: Re: [PATCH] Speed up verdict to chain_head mapping by using binary
	search
Date: Wed, 02 Jul 2008 17:53:24 +0200
Message-ID: <1215014004.26474.45.camel@enterprise.ims-firmen.de>
References: <> <1214997482-19063-1-git-send-email-jacob@internet24.de>
	 <486B9E84.4070403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:37200 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYGBPx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:53:28 -0400
In-Reply-To: <486B9E84.4070403@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2008-07-02 at 17:28 +0200, Patrick McHardy wrote:
> I can't spot any bugs, so I'm going to apply it so we can get
> some testing. Some minor coding style issues before I'll apply
> it though:
> 
> Thomas Jacob wrote:
> > diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> > index d0f51b4..e0c44c3 100644
> > --- a/libiptc/libiptc.c
> > +++ b/libiptc/libiptc.c
> > @@ -126,6 +126,26 @@ struct chain_head
> >  	unsigned int foot_offset;	/* offset in rule blob */
> >  };
> >  
> > +/* Max. number of chain_head per offsets chunk */
> > +#define OFFSETS_CHUNK_SIZE (1024)
> > +
> > +struct offsets_create_chunk
> 
> What does "create" stand for?

Well, originally I wanted to copy those chunks into an array, 
thus the create tag, so I'll just rename it to offsets_chunk,
shall I?

> > +{
> > +	struct list_head list;
> > +
> > +	unsigned int head_offset; /* of first entry */
> > +	unsigned int foot_offset; /* of last entry */
> 
> first_offset/last_offset perhaps?

Those are the names used inside chain_head.... admittedly for the length
of a whole change, but I could change that, no problem

> > +
> > +	unsigned int num_entries; /* #entries */
> 
> This is a bit excessive, num_entries really speaks for itself.

So I'll remove the comment.

> > +	struct chain_head * entries[OFFSETS_CHUNK_SIZE]; /* order by offset */
> > +};
> > +
> > +struct offsets_lookup_table
> > +{
> > +	unsigned int num_entries; /* #entries */
> > +	struct offsets_create_chunk ** entries; /* order by offset */
> > +};
> > +
> >  STRUCT_TC_HANDLE
> >  {
> >  	int changed;			 /* Have changes been made? */
> > @@ -140,6 +160,9 @@ STRUCT_TC_HANDLE
> >  	struct chain_head **chain_index;   /* array for fast chain list access*/
> >  	unsigned int        chain_index_sz;/* size of chain index array */
> >  
> > +	struct list_head            offsets_create_list; /* array chunks created during data acquisition */
> > +	struct offsets_lookup_table offsets_search;      /* final offsets search array */
> > +
> >  	STRUCT_GETINFO info;
> >  	STRUCT_GET_ENTRIES *entries;
> >  };
> > @@ -568,6 +591,61 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, TC_HANDLE_T h)
> >  
> >  
> >  /**********************************************************************
> > + * iptc offsets index utility functions
> > + **********************************************************************/
> > +
> > +/* Create offsets lookup table from the chunk list */
> > +static int iptcc_offsets_index_create(TC_HANDLE_T h)
> > +{
> > +	struct offsets_create_chunk * chunk;
> > +	unsigned int total_number=0;
> > +
> > +	/* First pass: count non-empty chunks and set their ranges */
> > +	list_for_each_entry(chunk, &h->offsets_create_list, list) {
> > +		if (chunk->num_entries>0) {
> > +			total_number++;
> > +			chunk->head_offset = chunk->entries[0]->head_offset;
> > +			chunk->foot_offset = chunk->entries[chunk->num_entries-1]->foot_offset;
> > +		}
> > +	}
> > +
> > +	/* No chains->nothing to assign */
> > +	if (total_number==0)
> > +		return 1;
> > +
> > +	h->offsets_search.entries = malloc(sizeof(struct offsets_create_chunk *)*total_number);
> 
> Please try to stay under the 80 character limit unless it makes the
> code look really strange.

OK

> > +	if (!h->offsets_search.entries)
> > +		return -ENOMEM;
> > +
> > +	/* Second pass: fill chunk table */
> > +	unsigned int i=0;
> 
> Move definitions to top of functions please (everywhere of course).

Ditto.

> > +
> > +/*
> > + * Fast membership check on order arrays of inclusive intervals
> > + *  ( based on http://en.wikipedia.org/wiki/Binary_search )
> > + *
> > + * value: value to search for
> > + * array: array of struct points
> > + * left: struct attribute denoting left inclusive range limiter in array items
> > + * right: struct attribute denoting left inclusive range limiter in array items
> > + * size: number of items in array
> > + * low, high, mid: temporary int variables
> > + * result: index of range that contains value, or -1 if not found
> > + */
> > +
> > +#define binary_array_range_search(value, array, left, right, size, low, high, mid, result) \
> > +	low = 0; \
> > +	high = size; \
> > +	result = -1; \
> > +	while(low<=high) \
> > +	{ \
> > +		mid = (low + high) / 2; \
> > +		if ((array)[mid]->left > value) \
> > +			high = mid - 1; \
> > +		else if ((array)[mid]->right < value) \
> > +			low = mid + 1; \
> > +		else { \
> > +			if ((array)[mid]->left <= value && value <= (array)[mid]->right) \
> > +				result = mid; \
> > +			break; \
> > +		} \
> > +	}
> 
> Any chance to make this a bit prettier? Does it need to be a macro?

No, I just didn't want to write the same code twice.... that's all,
what do you suggest, doing that (writing the same code twice)?

> > +
> > +/* Returns chain head if found, otherwise NULL. */
> > +static struct chain_head *
> > +iptcc_find_chain_by_offset_fast(TC_HANDLE_T handle, unsigned int offset)
> > +{
> > +	int low,high,mid,result;
> > +
> > +	if (handle->offsets_search.num_entries==0)
> > +		return NULL;
> > +
> > +	/* find the chunk */
> > +	binary_array_range_search(offset, handle->offsets_search.entries, head_offset, foot_offset,
> > +			handle->offsets_search.num_entries, low, high, mid, result);
> > +
> > +	if (result<0)
> 
> Spaces around operators please (except ++/--).

Alright....



