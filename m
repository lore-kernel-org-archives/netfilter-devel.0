Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A41754E
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707808824; cv=none; b=IoG53hZThnX8gYleq+bR4BCEsTiBPyL5grWo6ZvT9ltU3F6JFf5Mvy/Xvi2cY3Mtacelhb/JSeyFQB78Xjqt3LbqEmnEyGmZrVXPcgKT8g1yPUiT+4klCyvQVxg0krbI7iiRjUSLO8dvcyr9WtwjgLIXy6qLwvpDmftfymmYrFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707808824; c=relaxed/simple;
	bh=Y98PSboWhd+gJ24PVIHu5j49ze7t87j4B9uj890jqhc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvD1ZQ+J6l68OKVSymQ20WeQ28F/UREiYvER9akhkCqrBEFjNckZhngzvgVrCmBQxJAZiqatQh1iavD/AMjxqEfBw3gKAYo1yDtqAsm2TWHLgfbgh9PO2vYNuEx5UyJprt3JgbiEQZ98rMQkgxDganULj2y4ruYftNypB5S2s2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMUStfm/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMUStfm/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707808821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6az7SdaRCoYqmzgB4iAfzkdBV9K3Zwy/KM5SIsujaE=;
	b=bMUStfm/jpKzJ1PaDR+TH8wQGfcWh3LqY8LLaeUBtFVCTS2VtycXckl7wRY4/9Lsi1L4VW
	52lD5WRhWWWb6g6S/8cogvDrTdrKmzPheBRmsiLfFR00ppyFGjtW/MwbQUSD0B9RCqi4dE
	9pKpGhoyo03pteoIlFE3iYN6yPtyWfY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-RLKOZN8nMSqT4_6kTGY1wA-1; Tue, 13 Feb 2024 02:20:19 -0500
X-MC-Unique: RLKOZN8nMSqT4_6kTGY1wA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3c8585790fso90763866b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Feb 2024 23:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707808818; x=1708413618;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U6az7SdaRCoYqmzgB4iAfzkdBV9K3Zwy/KM5SIsujaE=;
        b=SmjETn/HcDtO6+4EW4TtKhdupRmQ+2OkgcHJQOLu6kwa6g/cYSdwtShZ5jm5rVS9md
         1tlTOhse/5MO2YA19Its5/B8kbrFJt3xxmZenUrMMKzSHuJ5/8oQ3uFX/oT/+BPWUVPN
         FmBQF5iOAsRg6JbJ7jSGzVvtO6v4yO9/gVOfkb2zg4jhcfPRZISqZqkmlHmCiQj2uQU4
         bSN7+QP99+Y72wOEm+9vUAUmRpOcaxsup4bphvZDI17CntK1C+Hg5uDRK3NBRI/SP/Xw
         rrmEozphE2l3hnWCt7u/kvN5SsPDK3WDMH87BsoyBpYdi6MqdC6UriXsQGFA5X6Sr09I
         PiEg==
X-Gm-Message-State: AOJu0Yx87siTo84ZH+iLHqo9dNxdmf8LCcv3FHFAaTcno+e1pl3oPkd7
	nt/BcbwLF9yUds8arsQ/yUMt/Cp7TWlYtiGCDalLc+nKKIOW1zaOCUPFjFRAyfB+rzip/jAp8Zs
	TgAnZEqh2sTIr1FB8/QaIsMweA37eBH9ukRLrHnnXOGdiHu2BnFDvsVaxDxUxzWcJww==
X-Received: by 2002:a17:906:470e:b0:a3c:7b82:187f with SMTP id y14-20020a170906470e00b00a3c7b82187fmr4055484ejq.20.1707808817899;
        Mon, 12 Feb 2024 23:20:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFyk/iyEWj8x+6N2Cd2BGXfd3g1UBtx4ZV3kogaYCeLdMLzLYVXPJ/9SqI6kLpmRLtXLzQT9A==
X-Received: by 2002:a17:906:470e:b0:a3c:7b82:187f with SMTP id y14-20020a170906470e00b00a3c7b82187fmr4055471ejq.20.1707808817525;
        Mon, 12 Feb 2024 23:20:17 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id gv20-20020a170906f11400b00a3c9bd8e1c9sm987648ejb.76.2024.02.12.23.20.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Feb 2024 23:20:16 -0800 (PST)
Date: Tue, 13 Feb 2024 08:19:29 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 1/4] netfilter: nft_set_pipapo: constify lookup
 fn args where possible
Message-ID: <20240213081929.218433a2@elisabeth>
In-Reply-To: <20240212100202.10116-2-fw@strlen.de>
References: <20240212100202.10116-1-fw@strlen.de>
	<20240212100202.10116-2-fw@strlen.de>
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

Nits only:

On Mon, 12 Feb 2024 11:01:50 +0100
Florian Westphal <fw@strlen.de> wrote:

> Those get called from packet path, content must not be modified.
> No functional changes intended.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c      | 16 ++++++++--------
>  net/netfilter/nft_set_pipapo.h      |  6 +++---
>  net/netfilter/nft_set_pipapo_avx2.c | 26 +++++++++++++-------------
>  3 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index ed243edaa6a0..395420fa71e5 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -360,7 +360,7 @@
>   * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
>   */
>  int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
> -		  union nft_pipapo_map_bucket *mt, bool match_only)
> +		  const union nft_pipapo_map_bucket *mt, bool match_only)
>  {
>  	unsigned long bitset;
>  	int k, ret = -1;
> @@ -412,9 +412,9 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
>  	struct nft_pipapo_scratch *scratch;
>  	unsigned long *res_map, *fill_map;
>  	u8 genmask = nft_genmask_cur(net);
> +	const struct nft_pipapo_match *m;
> +	const struct nft_pipapo_field *f;
>  	const u8 *rp = (const u8 *)key;
> -	struct nft_pipapo_match *m;
> -	struct nft_pipapo_field *f;
>  	bool map_index;
>  	int i;
>  
> @@ -521,9 +521,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
>  {
>  	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
>  	struct nft_pipapo *priv = nft_set_priv(set);
> -	struct nft_pipapo_match *m = priv->clone;
> +	const struct nft_pipapo_match *m = priv->clone;

This should go one line below now and have a separate initialiser
(reverse Christmas tree).

>  	unsigned long *res_map, *fill_map = NULL;
> -	struct nft_pipapo_field *f;
> +	const struct nft_pipapo_field *f;
>  	int i;
>  
>  	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> @@ -1599,7 +1599,7 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
>  
>  	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
>  		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
> -		struct nft_pipapo_field *f;
> +		const struct nft_pipapo_field *f;
>  		int i, start, rules_fx;
>  
>  		start = first_rule;
> @@ -2041,8 +2041,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
>  {
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct net *net = read_pnet(&set->net);
> -	struct nft_pipapo_match *m;
> -	struct nft_pipapo_field *f;
> +	const struct nft_pipapo_match *m;
> +	const struct nft_pipapo_field *f;
>  	int i, r;
>  
>  	rcu_read_lock();
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
> index f59a0cd81105..90d22d691afc 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -187,7 +187,7 @@ struct nft_pipapo_elem {
>  };
>  
>  int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
> -		  union nft_pipapo_map_bucket *mt, bool match_only);
> +		  const union nft_pipapo_map_bucket *mt, bool match_only);
>  
>  /**
>   * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
> @@ -195,7 +195,7 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
>   * @dst:	Area to store result
>   * @data:	Input data selecting table buckets
>   */
> -static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
> +static inline void pipapo_and_field_buckets_4bit(const struct nft_pipapo_field *f,
>  						 unsigned long *dst,
>  						 const u8 *data)
>  {
> @@ -223,7 +223,7 @@ static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
>   * @dst:	Area to store result
>   * @data:	Input data selecting table buckets
>   */
> -static inline void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
> +static inline void pipapo_and_field_buckets_8bit(const struct nft_pipapo_field *f,
>  						 unsigned long *dst,
>  						 const u8 *data)
>  {
> diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
> index 208e9d577347..d7bea311165f 100644
> --- a/net/netfilter/nft_set_pipapo_avx2.c
> +++ b/net/netfilter/nft_set_pipapo_avx2.c
> @@ -212,7 +212,7 @@ static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,

This and all the changed declarations below exceed 80 columns but,
unlike the ones above, we could simply turn them into:

static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
				       const struct nft_pipapo_field *f,
				       int offset, const u8 *pkt,
				       bool first, bool last)

and so on.

>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -274,7 +274,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -350,7 +350,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	u8 pg[8] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
> @@ -445,7 +445,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
> -				        struct nft_pipapo_field *f, int offset,
> +					const struct nft_pipapo_field *f, int offset,
>  				        const u8 *pkt, bool first, bool last)
>  {
>  	u8 pg[12] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
> @@ -534,7 +534,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
> -					struct nft_pipapo_field *f, int offset,
> +					const struct nft_pipapo_field *f, int offset,
>  					const u8 *pkt, bool first, bool last)
>  {
>  	u8 pg[32] = {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf,
> @@ -669,7 +669,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -726,7 +726,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -790,7 +790,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -865,7 +865,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
> -				       struct nft_pipapo_field *f, int offset,
> +				       const struct nft_pipapo_field *f, int offset,
>  				       const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -950,7 +950,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
> -					struct nft_pipapo_field *f, int offset,
> +					const struct nft_pipapo_field *f, int offset,
>  					const u8 *pkt, bool first, bool last)
>  {
>  	int i, ret = -1, m256_size = f->bsize / NFT_PIPAPO_LONGS_PER_M256, b;
> @@ -1042,7 +1042,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
>   * word index to be checked next (i.e. first filled word).
>   */
>  static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
> -					struct nft_pipapo_field *f, int offset,
> +					const struct nft_pipapo_field *f, int offset,
>  					const u8 *pkt, bool first, bool last)
>  {
>  	unsigned long bsize = f->bsize;
> @@ -1119,9 +1119,9 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
>  	struct nft_pipapo *priv = nft_set_priv(set);
>  	struct nft_pipapo_scratch *scratch;
>  	u8 genmask = nft_genmask_cur(net);
> +	const struct nft_pipapo_match *m;
> +	const struct nft_pipapo_field *f;
>  	const u8 *rp = (const u8 *)key;
> -	struct nft_pipapo_match *m;
> -	struct nft_pipapo_field *f;
>  	unsigned long *res, *fill;
>  	bool map_index;
>  	int i, ret = 0;

-- 
Stefano

