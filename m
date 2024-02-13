Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1639542078
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707830285; cv=none; b=oGRAwXb3pQLZtz8fOAVT3jBgb0sg5fd16bTZdWc+LRv9w5OC/ExOwytwPteW4p6i/bHLXatEoJa6UbKDMJ+uoUh/jQ78JU3lBQg+SJGMSg7t1VKlHcr2r9JJ/HwVb333NRnMYgtXHXbvvSRCjq0EhS1ubL6SWGNwT9jMqEBStlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707830285; c=relaxed/simple;
	bh=00W49zo7qKXIpoXTcgZTgRBuQX1OXkk2BJehKUw1P+I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESmL0B0VuDO5iMpGUbky/fRby2ZIbtI8r8Z4TnBU8RRDv701LZO29k9GeMOo4a/kkRPA8nmwa6tCki3hmW+o8oWuuGxYdf5fq3oy09h0R5VMQsCtetUC5IyNz/UWjp7pYrpdS/zgDjsxgswks0H/kLYy0Z/dHOo849aDWMZ4ouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TdAwnPtu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdAwnPtu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707830281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YeL772qGrHUkv6NJ1RgwDenFXaXdB6cp9bPZsAZsx4A=;
	b=TdAwnPtu2KviQcnDK2Owx0mR8p0qjtEbZAjIehH9ab0J2IL8ojcsn+ASFMiUCvU7AHlHmE
	0ra2a1x4+pmzHVONoxLA/3y1ZAGtlCk4oHuEf9nAhskQazIF0Dwh1f72OGx26QqLfHPf3t
	WR5E7ZO2fNKGWt3zIO6D8ik2hTFOzuA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-uJ7OgFyDPW-ukcpwMA07jw-1; Tue, 13 Feb 2024 08:18:00 -0500
X-MC-Unique: uJ7OgFyDPW-ukcpwMA07jw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d0f26547easo24424851fa.3
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 05:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707830278; x=1708435078;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YeL772qGrHUkv6NJ1RgwDenFXaXdB6cp9bPZsAZsx4A=;
        b=uC5rQeFLqX628XQX/oZL2L0s+rzCRAZQnUo/DRx95Mje5aJmdNsZ0ATyePIVOEpA9p
         HT97SwH57hadruye/7tDAYplto9RPyOGfu8ApgM1gFe6qMHpxLL/Bl7FWM++6HKIN8FW
         d1vNl0KAgbZowRxtvnSUxNL8hK4fvFMPuj/dJSOtnFmtafb1cO52pLae6PUt/GDJfjDm
         x+FpMNtNhONqSGLYIbVprOM2KD82+ZN2oq4iAs09Wzc2zy/0ZiFpfGa8EI1Jg6vpv1au
         14YKh79LoA2LTNbCUSfn5OlPo5JPEdnVoM1yRfVNrEtlwbEqK9E+077XKkSJCuk6ZnRb
         c/Iw==
X-Gm-Message-State: AOJu0YxEqm93XBlfeKD3K8TZZjnJSxNn7LFos5X/S4KakozhRb0o6krP
	OB8Z8iSzF9qGZ5lt95KJRmyWDt7tr8GSSJvmvcBUPpEgK/O+00au6oPo0MbqdJ+1Bwe2OISd7Db
	GWk57nL+JWHV0GfNtalES27++AZ4GRV38kSeHbZhVYETaaQ2dK5pE0OZemWDhT3NsJQIuIfa81+
	dj
X-Received: by 2002:ac2:4c07:0:b0:511:5569:680d with SMTP id t7-20020ac24c07000000b005115569680dmr6812465lfq.22.1707830278013;
        Tue, 13 Feb 2024 05:17:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvWXSohCg6f8LbNcfESHZAQTqxqR/lBKiN1klHpT85R9mtwD4ujMgUMH/FcJwWMGGITiICOQ==
X-Received: by 2002:ac2:4c07:0:b0:511:5569:680d with SMTP id t7-20020ac24c07000000b005115569680dmr6812450lfq.22.1707830277549;
        Tue, 13 Feb 2024 05:17:57 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id hu13-20020a170907a08d00b00a3d201e67dcsm130310ejc.175.2024.02.13.05.17.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Feb 2024 05:17:56 -0800 (PST)
Date: Tue, 13 Feb 2024 14:17:02 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 3/4] netfilter: nft_set_pipapo: shrink data
 structures
Message-ID: <20240213141702.6c55e57d@elisabeth>
In-Reply-To: <20240212100202.10116-4-fw@strlen.de>
References: <20240212100202.10116-1-fw@strlen.de>
	<20240212100202.10116-4-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Feb 2024 11:01:52 +0100
Florian Westphal <fw@strlen.de> wrote:

> The set uses a mix of 'int', 'unsigned int', and size_t.
> 
> The rule count limit is NFT_PIPAPO_RULE0_MAX, which cannot
> exceed INT_MAX (a few helpers use 'int' as return type).
> 
> Add a compile-time assertion for this.
> 
> Replace size_t usage in structs with unsigned int or u8 where
> the stored values are smaller.
> 
> Replace signed-int arguments for lengths with 'unsigned int'
> where possible.
> 
> Last, remove lt_aligned member: its set but never read.
> 
> struct nft_pipapo_match 40 bytes -> 32 bytes
> struct nft_pipapo_field 56 bytes -> 32 bytes
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 60 ++++++++++++++++++++++------------
>  net/netfilter/nft_set_pipapo.h | 29 ++++++----------
>  2 files changed, 49 insertions(+), 40 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 6a79ec98de86..a0ddf24a8052 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -359,11 +359,13 @@
>   *
>   * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
>   */
> -int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
> +int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
> +		  unsigned long *dst,
>  		  const union nft_pipapo_map_bucket *mt, bool match_only)
>  {
>  	unsigned long bitset;
> -	int k, ret = -1;
> +	unsigned int k;
> +	int ret = -1;
>  
>  	for (k = 0; k < len; k++) {
>  		bitset = map[k];
> @@ -632,13 +634,16 @@ nft_pipapo_get(const struct net *net, const struct nft_set *set,
>   *
>   * Return: 0 on success, -ENOMEM on allocation failure.
>   */
> -static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
> +static int pipapo_resize(struct nft_pipapo_field *f, unsigned int old_rules, unsigned int rules)

Nit:

static int pipapo_resize(struct nft_pipapo_field *f,
			 unsigned int old_rules, unsigned int rules)

without losing readability.

>  {
>  	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
>  	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
> -	size_t new_bucket_size, copy;
> +	unsigned int new_bucket_size, copy;
>  	int group, bucket;
>  
> +	if (rules >= NFT_PIPAPO_RULE0_MAX)
> +		return -ENOSPC;
> +
>  	new_bucket_size = DIV_ROUND_UP(rules, BITS_PER_LONG);
>  #ifdef NFT_PIPAPO_ALIGN
>  	new_bucket_size = roundup(new_bucket_size,
> @@ -691,7 +696,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
>  
>  	if (new_lt) {
>  		f->bsize = new_bucket_size;
> -		NFT_PIPAPO_LT_ASSIGN(f, new_lt);
> +		f->lt = new_lt;
>  		kvfree(old_lt);
>  	}
>  
> @@ -848,8 +853,8 @@ static void pipapo_lt_8b_to_4b(int old_groups, int bsize,
>   */
>  static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  {
> +	unsigned int groups, bb;
>  	unsigned long *new_lt;
> -	int groups, bb;
>  	size_t lt_size;
>  
>  	lt_size = f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
> @@ -899,7 +904,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  	f->groups = groups;
>  	f->bb = bb;
>  	kvfree(f->lt);
> -	NFT_PIPAPO_LT_ASSIGN(f, new_lt);
> +	f->lt = new_lt;
>  }
>  
>  /**
> @@ -916,7 +921,7 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
>  			 int mask_bits)
>  {
> -	int rule = f->rules, group, ret, bit_offset = 0;
> +	unsigned int rule = f->rules, group, ret, bit_offset = 0;
>  
>  	ret = pipapo_resize(f, f->rules, f->rules + 1);
>  	if (ret)
> @@ -1256,8 +1261,14 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  	/* Validate */
>  	start_p = start;
>  	end_p = end;
> +
> +	/* some helpers return -1, or 0 >= for valid rule pos,
> +	 * so we cannot support more than INT_MAX rules at this time.
> +	 */
> +	BUILD_BUG_ON(NFT_PIPAPO_RULE0_MAX > INT_MAX);
> +
>  	nft_pipapo_for_each_field(f, i, m) {
> -		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
> +		if (f->rules >= NFT_PIPAPO_RULE0_MAX)
>  			return -ENOSPC;
>  
>  		if (memcmp(start_p, end_p,
> @@ -1363,7 +1374,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>  		if (!new_lt)
>  			goto out_lt;
>  
> -		NFT_PIPAPO_LT_ASSIGN(dst, new_lt);
> +		dst->lt = new_lt;
>  
>  		memcpy(NFT_PIPAPO_LT_ALIGN(new_lt),
>  		       NFT_PIPAPO_LT_ALIGN(src->lt),
> @@ -1433,10 +1444,10 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
>   *
>   * Return: Number of rules that originated from the same entry as @first.
>   */
> -static int pipapo_rules_same_key(struct nft_pipapo_field *f, int first)
> +static unsigned int pipapo_rules_same_key(struct nft_pipapo_field *f, unsigned int first)
>  {
>  	struct nft_pipapo_elem *e = NULL; /* Keep gcc happy */
> -	int r;
> +	unsigned int r;
>  
>  	for (r = first; r < f->rules; r++) {
>  		if (r != first && e != f->mt[r].e)
> @@ -1489,8 +1500,8 @@ static int pipapo_rules_same_key(struct nft_pipapo_field *f, int first)
>   *                        0      1      2
>   *  element pointers:  0x42   0x42   0x44
>   */
> -static void pipapo_unmap(union nft_pipapo_map_bucket *mt, int rules,
> -			 int start, int n, int to_offset, bool is_last)
> +static void pipapo_unmap(union nft_pipapo_map_bucket *mt, unsigned int rules,
> +			 unsigned int start, unsigned int n, unsigned int to_offset, bool is_last)

Same here,

static void pipapo_unmap(union nft_pipapo_map_bucket *mt, unsigned int rules,
			 unsigned int start, unsigned int n,
			 unsigned int to_offset, bool is_last)

?

>  {
>  	int i;
>  
> @@ -1596,8 +1607,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct net *net = read_pnet(&set->net);
> +	unsigned int rules_f0, first_rule = 0;
>  	u64 tstamp = nft_net_tstamp(net);
> -	int rules_f0, first_rule = 0;
>  	struct nft_pipapo_elem *e;
>  	struct nft_trans_gc *gc;
>  
> @@ -1608,7 +1619,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
>  		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
>  		const struct nft_pipapo_field *f;
> -		int i, start, rules_fx;
> +		unsigned int i, start, rules_fx;
>  
>  		start = first_rule;
>  		rules_fx = rules_f0;
> @@ -1986,7 +1997,7 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_match *m = priv->clone;
> -	int rules_f0, first_rule = 0;
> +	unsigned int rules_f0, first_rule = 0;
>  	struct nft_pipapo_elem *e;
>  	const u8 *data;
>  
> @@ -2051,7 +2062,7 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
>  	struct net *net = read_pnet(&set->net);
>  	const struct nft_pipapo_match *m;
>  	const struct nft_pipapo_field *f;
> -	int i, r;
> +	unsigned int i, r;
>  
>  	rcu_read_lock();
>  	if (iter->genmask == nft_genmask_cur(net))
> @@ -2155,6 +2166,9 @@ static int nft_pipapo_init(const struct nft_set *set,
>  
>  	field_count = desc->field_count ? : 1;
>  
> +	BUILD_BUG_ON(NFT_PIPAPO_MAX_FIELDS > 255);
> +	BUILD_BUG_ON(NFT_PIPAPO_MAX_FIELDS != NFT_REG32_COUNT);
> +
>  	if (field_count > NFT_PIPAPO_MAX_FIELDS)
>  		return -EINVAL;
>  
> @@ -2176,7 +2190,11 @@ static int nft_pipapo_init(const struct nft_set *set,
>  	rcu_head_init(&m->rcu);
>  
>  	nft_pipapo_for_each_field(f, i, m) {
> -		int len = desc->field_len[i] ? : set->klen;
> +		unsigned int len = desc->field_len[i] ? : set->klen;
> +
> +		/* f->groups is u8 */
> +		BUILD_BUG_ON((NFT_PIPAPO_MAX_BYTES *
> +			      BITS_PER_BYTE / NFT_PIPAPO_GROUP_BITS_LARGE_SET) >= 256);
>  
>  		f->bb = NFT_PIPAPO_GROUP_BITS_INIT;
>  		f->groups = len * NFT_PIPAPO_GROUPS_PER_BYTE(f);
> @@ -2185,7 +2203,7 @@ static int nft_pipapo_init(const struct nft_set *set,
>  
>  		f->bsize = 0;
>  		f->rules = 0;
> -		NFT_PIPAPO_LT_ASSIGN(f, NULL);
> +		f->lt = NULL;
>  		f->mt = NULL;
>  	}
>  
> @@ -2221,7 +2239,7 @@ static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
>  					 struct nft_pipapo_match *m)
>  {
>  	struct nft_pipapo_field *f;
> -	int i, r;
> +	unsigned int i, r;
>  
>  	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
>  		;
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index 90d22d691afc..8d9486ae0c01 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -70,15 +70,9 @@
>  #define NFT_PIPAPO_ALIGN_HEADROOM					\
>  	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
>  #define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
> -#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
> -	do {								\
> -		(field)->lt_aligned = NFT_PIPAPO_LT_ALIGN(x);		\
> -		(field)->lt = (x);					\
> -	} while (0)
>  #else
>  #define NFT_PIPAPO_ALIGN_HEADROOM	0
>  #define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
> -#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt = (x))
>  #endif /* NFT_PIPAPO_ALIGN */
>  
>  #define nft_pipapo_for_each_field(field, index, match)		\
> @@ -110,22 +104,18 @@ union nft_pipapo_map_bucket {
>  
>  /**
>   * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
> - * @groups:	Amount of bit groups
>   * @rules:	Number of inserted rules
>   * @bsize:	Size of each bucket in lookup table, in longs
> + * @groups:	Amount of bit groups
>   * @bb:		Number of bits grouped together in lookup table buckets
>   * @lt:		Lookup table: 'groups' rows of buckets
> - * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
>   * @mt:		Mapping table: one bucket per rule
>   */
>  struct nft_pipapo_field {
> -	int groups;
> -	unsigned long rules;
> -	size_t bsize;
> -	int bb;
> -#ifdef NFT_PIPAPO_ALIGN
> -	unsigned long *lt_aligned;
> -#endif
> +	unsigned int rules;
> +	unsigned int bsize;
> +	u8 groups;
> +	u8 bb;
>  	unsigned long *lt;
>  	union nft_pipapo_map_bucket *mt;
>  };
> @@ -145,15 +135,15 @@ struct nft_pipapo_scratch {
>  /**
>   * struct nft_pipapo_match - Data used for lookup and matching
>   * @field_count		Amount of fields in set
> - * @scratch:		Preallocated per-CPU maps for partial matching results
>   * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
> + * @scratch:		Preallocated per-CPU maps for partial matching results
>   * @rcu			Matching data is swapped on commits
>   * @f:			Fields, with lookup and mapping tables
>   */
>  struct nft_pipapo_match {
> -	int field_count;
> +	u8 field_count;
> +	unsigned int bsize_max;
>  	struct nft_pipapo_scratch * __percpu *scratch;
> -	size_t bsize_max;
>  	struct rcu_head rcu;
>  	struct nft_pipapo_field f[] __counted_by(field_count);
>  };
> @@ -186,7 +176,8 @@ struct nft_pipapo_elem {
>  	struct nft_set_ext	ext;
>  };
>  
> -int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
> +int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
> +		  unsigned long *dst,
>  		  const union nft_pipapo_map_bucket *mt, bool match_only);
>  
>  /**

-- 
Stefano

