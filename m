Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AA2272807
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543369; cv=none; b=FHq0c66hS9eCoUMW+s6d32MSgCXjr3wtLK/moeaFII1IBLRIu1dyCwgV8VSTuLMeD3/p3Bn1CnggF+trv7pIMDM+nh0WOqyKhUmOzOUKEltrdN6vjdY89qVZsG/ICZImdomt6ZkQWbwr/xqtfXvu2NXkzX30iMHYtwresbsRXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543369; c=relaxed/simple;
	bh=FJcs6jjvm2EwatUTRnfTbXaHEVnRVfvpnr0bm2ZyOaU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLda3K+ZKJaxf4XOwwiR7Balu1vteONiyW8UcH33CuRPiXjB8tMPS5JHWqxyEFCL/Hfhptsspq/F/dcaj/JPs9DDoHRU4IRBpIw3JO9n6nDcUqNLF2Pi1TIZSolgDv+Cg80cbLiEa8uo5FdnVvVSYsMsw1CJyO4k0yGv2ttOesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f+gERrAe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+gERrAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755543366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cYc92Ykio0Spg+RQGgcPKNiq2j06mvQf2ZlSpQKPiow=;
	b=f+gERrAeMC7deJ+VUgAdAXkvFHHBDfenZSRAqAin3ROPlrF7HbZmy1O/pp5WxlIgeXZU3T
	EHYLjl025cZZPrMblYrjEl3nt0rbmi+iyGVYrKp4TmiOsl9pew+H7+Bf+F8o+RE9bS/1wC
	Bnu6r9mtivQq4Opkn51tov8wmtkxQ3I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-G8A9Um5YOnGfcFyRbOxvhw-1; Mon, 18 Aug 2025 14:56:05 -0400
X-MC-Unique: G8A9Um5YOnGfcFyRbOxvhw-1
X-Mimecast-MFC-AGG-ID: G8A9Um5YOnGfcFyRbOxvhw_1755543364
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf2d82dso2475525f8f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755543364; x=1756148164;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cYc92Ykio0Spg+RQGgcPKNiq2j06mvQf2ZlSpQKPiow=;
        b=HekDaEX0hJ7nA+a4s+Q+KqCgCGJVQEa95XpchJ59/1ma/cQjQmWoCJdgF+Hl4LQOG/
         hl7UXmzxZiStaiwGRhIgl3x2/vPfIhUbLoOGV2SfT50Si3gdcnevRSw4nKYZt+3a+PQF
         7L8X+rsuCuQGXsTsk4Miq3ZK9U6UiVMY1b8SKg7ehZfLliijv/tccTSZp0BgK/FKm3gw
         0Di07vozcoloXMVWflKS/P9HaYy17moD8wQ/jum2U3cy4VtsRFvcn/cb/an7m3WVTHQp
         K5NyOwlQJ/kbbqRXrTh6HEqpOgF118yN3HVlVkJLGfUq7xwcxRCc5o6zIYSt++Jx9keH
         lDfQ==
X-Gm-Message-State: AOJu0YzQSa4wHLA8ePlKhDlyEwkXfJEJPAAIj+1F3MPuCzomE4eMUDAa
	A7seXgeHJpXIiY7mZOICRhtIdovAtjOvtzllU6xarU6OQXq06wRA3xytV+BLzcfb58JpPhBm0DV
	BKWZKUT+qe/7xGsBiB9stFhMhJvHt9lKct58MrkcsNksBKZeP5VKaV5i5Z8sekPRIGOlmpQ==
X-Gm-Gg: ASbGncuN4GxKzZdRUlknNWwhNmzVeaw5B1AtcOWoKpkZW4Dl2brtk7pryafTJLxc3zj
	cbdGW6Yi7KGAonnC89tCHzRRkfdoT9EN//hEyLNSsNDkx/6wJUBNzYPjGb+poHcU/424ts8R4kS
	itV+TvkVEiZdnoFJHdmHVlhbEPLpZwWwJC3kUbi51oAuQV0lqKzjHTQz8nwZBXWmQjWzCSUtuwl
	7QGvav3IPWtbZgNEe85k9hdJjt9/rdn96ChiPmRz4/SIh4Yi8qC0xt8J8SdsSpSFbMvApimK6ib
	1dSYRBsBoie4eALoi/Bn9GT5FGwqXMWqegFicY8dfLsFogeEJmIT9MY9L9pPYNf9gZmD
X-Received: by 2002:a05:6000:4304:b0:3b4:990b:9ee7 with SMTP id ffacd0b85a97d-3c07eac2e65mr314341f8f.22.1755543363983;
        Mon, 18 Aug 2025 11:56:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYF9z2BX+A/ug44JOcNs8/bUKYyAHpgXdo+oNfzjuvCPCDEukIPqhbYUYd3cB7FQBydcEjKg==
X-Received: by 2002:a05:6000:4304:b0:3b4:990b:9ee7 with SMTP id ffacd0b85a97d-3c07eac2e65mr314326f8f.22.1755543363547;
        Mon, 18 Aug 2025 11:56:03 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c57db6sm516572f8f.67.2025.08.18.11.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 11:56:02 -0700 (PDT)
Date: Mon, 18 Aug 2025 20:56:01 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_set_pipapo_avx2: split
 lookup function in two parts
Message-ID: <20250818205601.1221e06f@elisabeth>
In-Reply-To: <aKNvtcCzJD8xnF3q@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
	<20250815143702.17272-2-fw@strlen.de>
	<20250818182931.1dcaf62a@elisabeth>
	<aKNvtcCzJD8xnF3q@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Aug 2025 20:23:49 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > - * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
> > > - * @net:	Network namespace
> > > - * @set:	nftables API set representation
> > > - * @key:	nftables API element representation containing key data
> > > + * pipapo_get_avx2() - Lookup function for AVX2 implementation
> > > + * @m:		storage containing the set elements
> > > + * @data:	Key data to be matched against existing elements
> > > + * @genmask:	If set, check that element is active in given genmask
> > > + * @tstamp:	timestamp to check for expired elements  
> > 
> > Nits: Storage, Timestamp (or all lowercase, for consistency with the
> > other ones).  
> 
> Note that there is no consistency whatsoever in the kernel.
> Some use upper case, some lower, some indent on same level (like done
> here), some don't.

Yeah, I just meant for consistency with the other parameter descriptions
of this function itself ("the other ones") and of these files.

> So, I don't care anymore since it will never be right.
> 
> In case i have to mangle it anyway i will "fix" it.

Either way,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> > > +			e = f->mt[ret].e;
> > > +			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||  
> > 
> > Here's the actual concern, even if I haven't tested this: I guess you now
> > pass the timestamp to this function instead of getting it with each
> > nft_set_elem_expired() call for either correctness (it should be done at
> > the beginning of the insertion?) or as an optimisation (if BITS_PER_LONG < 64
> > the overhead isn't necessarily trivial).  
> 
> Its done because during insertion time should be frozen to avoid
> elements timing out while transaction is in progress.
> (this is unrelated to this patchset).
> 
> But in order to use this snippet from both control and data path
> this has to be passed in so it can either be 'now' or 'time at
> start of transaction'.

Ah, I see now, thanks for explaining!

> > But with 2/2, you need to call get_jiffies_64() as a result, from non-AVX2
> > code, even for sets without a timeout (without NFT_SET_EXT_TIMEOUT
> > extension).
> > 
> > Does that risk causing a regression on non-AVX2? If it's for correctness,
> > I think we shouldn't care, but if it's done as an optimisation, perhaps
> > it's not a universal one.  
> 
> Its not an optimisation.  I could pass a 'is_control_plane' or
> 'is_packetpath' but I considered it too verbose and not needed for
> correctness.

...and it wouldn't help with my potential concern either as
is_packetpath would always be set anyway on lookups, with or without
timeout. Never mind then.

-- 
Stefano

