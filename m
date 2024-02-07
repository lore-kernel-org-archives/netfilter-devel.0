Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34081204
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326943; cv=none; b=BJ6//nbTwhoDm7dTc6p4TP187Hm9KC/23o7mPQN5GgbAy+y8hQKq1jdmEQMfbvHXJhKy6dL0QJ0oJ5wwgdzLzGkNBdauCy1o7OvJDwBssGwq1lBQvXWn47yakQY1jX9u8pTGdM+eEAFFSPy8+1hTprnVHv8cHnrtpruVzP9zdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326943; c=relaxed/simple;
	bh=ZBDUYniJqAhQ5Bt4wcOV8yMp7J3Uu/SC+Rb3Dvmq9CI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZ35emWQxQhwZCDt5VNO5zh8ns9SE6T6hayBx8mjjRXC3IfCFTDJqzv06498f72j3FoaTI9V7Ygx2sOxjNy56Epm0jzBBg+8lpy/kKhUHfmPh4awCP5JRrL7xFfzhfp7KIjaNbRKZ4cBg3tNY2qTntsY4wm6hPL+fDUgiYxDDsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fUfARMT3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUfARMT3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707326939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kIYsmMXUOyCgvSC4c9cp5jiGL1R/A1DiSzdWuGADpHs=;
	b=fUfARMT3kKYoJUC6si3uRVdVAGMgP+9W87ZjpGTt15DoWIMSjIZh/vvRxeyVdPc+Ecam4g
	95uNjz8aZ977Ke9SrcdG9XIRU/sj69bNZ0Rpzp9vCZ5O8zStaJhGEXOrRPRc0xIuidObj6
	afd8aIWstUomT1Ucfy7gyoMPRIfjTjw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-igzjDcZ6PFycTfK_yBKMOg-1; Wed, 07 Feb 2024 12:28:58 -0500
X-MC-Unique: igzjDcZ6PFycTfK_yBKMOg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3934bc40d7so2904266b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2024 09:28:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326937; x=1707931737;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kIYsmMXUOyCgvSC4c9cp5jiGL1R/A1DiSzdWuGADpHs=;
        b=DbH/QuAhFQ0ANTE60IXKaI1dRylhOfECM6DJ8mKwgDgHwqcBj+lVLt9NhjOwcp6Sa0
         TEkBBp6pUlHU4QnX9VJ32ZIYHhnfhFx72mYHm8IktQ9L3FDgmDDjZYCW0+EJfYbLhgyP
         SHyHUqLmdlCrxL3G3jrY7alz9X8Y9Zdg2YYJj4+mtPRbST1tHkVn0SL4e4qxBPuhFZJM
         EQrxLzDKZsI1xnWvvnotIhJMYhvtF8gPoyIJou4Ltl31+EU6RRK1nv6KmPgKFtoldzuO
         7fQn0uJ73cLGJVFNqPM4cEGCpjLaa/DigGqHd0QmU6D4rMptLJEjC0qrju1pT2kY4pyJ
         0lTA==
X-Gm-Message-State: AOJu0YzG0E6ZZjTcPoeWXFCMjWGfvljAU5FHF0wukW0RI6urRE/r9Cbe
	hJq8n8RTWENMK90JWISlXGPk8Pd1AYaJqkcAlTqefyPu9fGsx3XXVL1bZcrLVA0DmPjLemv2IU7
	4X9CHP8MTfHTuhMP3nrr9Qp9+iMXQ895Mzme5wP+ScS+tRjNv3B5bsvAvgqMg5iCB00VusVnxav
	Rf
X-Received: by 2002:a17:906:63d1:b0:a38:107a:94f2 with SMTP id u17-20020a17090663d100b00a38107a94f2mr4655773ejk.6.1707326936890;
        Wed, 07 Feb 2024 09:28:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2fhgynL9pUuG8c+2UhctKxCHoAC+fb8cI0UD8qTQ7w2B7FG6omTqJlQnQXJuKzZqiiIAEpA==
X-Received: by 2002:a17:906:63d1:b0:a38:107a:94f2 with SMTP id u17-20020a17090663d100b00a38107a94f2mr4655761ejk.6.1707326936481;
        Wed, 07 Feb 2024 09:28:56 -0800 (PST)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id ps6-20020a170906bf4600b00a35a11fd795sm965227ejb.129.2024.02.07.09.28.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2024 09:28:55 -0800 (PST)
Date: Wed, 7 Feb 2024 18:27:51 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/3] netfilter: nft_set_pipapo: store index in
 scratch maps
Message-ID: <20240207182751.6ed0dd1d@elisabeth>
In-Reply-To: <20240207152328.GA11077@breakpoint.cc>
References: <20240206122531.21972-1-fw@strlen.de>
	<20240206122531.21972-2-fw@strlen.de>
	<20240207151514.790c6cf3@elisabeth>
	<20240207152328.GA11077@breakpoint.cc>
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

On Wed, 7 Feb 2024 16:23:28 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > This isn't reliable.  
> > 
> > Uh oh. In hindsight, this sounds so obvious now...  
> 
> Thats a recurring theme with a lot of bugs.
> So, no, it was not obvious.
> 
> > > There can be multiple sets and we can't be sure that the upper
> > > and lower half of all set scratch map is always in sync (lookups
> > > can be conditional), so one set might have swapped, but other might
> > > not have been queried.
> > > 
> > > Thus we need to keep the index per-set-and-cpu, just like the
> > > scratchpad.
> > > 
> > > Note that this bug fix is incomplete, there is a related issue.
> > > 
> > > avx2 and normal implementation might use slightly different areas of the
> > > map array space due to the avx2 alignment requirements, so
> > > m->scratch (generic/fallback implementation) and ->scratch_aligned
> > > (avx) may partially overlap. scratch and scratch_aligned are not distinct
> > > objects, the latter is just the aligned address of the former.
> > > 
> > > After this change, write to scratch_align->map_index may write to
> > > scratch->map, so this issue becomes more prominent, we can set to 1
> > > a bit in the supposedly-all-zero area of scratch->map[].
> > > 
> > > A followup patch will remove the scratch_aligned and makes generic and
> > > avx code use the same (aligned) area.
> > > 
> > > Its done in a separate change to ease review.
> > > 
> > > Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> > > Signed-off-by: Florian Westphal <fw@strlen.de>  
> > 
> > Minus one nit (not worth respinning) and one half-doubt below,
> > 
> > Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> > 
> > ...I'm still reviewing the rest.  
> 
> Thanks for reviewing.
> 
> > >  #ifdef NFT_PIPAPO_ALIGN
> > > -		scratch_aligned = NFT_PIPAPO_LT_ALIGN(scratch);
> > > +		scratch_aligned = NFT_PIPAPO_LT_ALIGN(&scratch->map);
> > > +		/* Need to align ->map start, not start of structure itself */
> > > +		scratch_aligned -= offsetof(struct nft_pipapo_scratch, map);  
> > 
> > This should be fine with the current version of
> > NFT_PIPAPO_ALIGN_HEADROOM, but it took me quite some pondering, reasoning
> > below if you feel like double checking.  
> 
> Good point.
> 
> > Let's say ARCH_KMALLOC_MINALIGN is 4, NFT_PIPAPO_LT_ALIGN is 32, we
> > need 100 bytes for the scratch map (existing implementation), and the
> > address, x, we get from kzalloc_node() is k + 28, with k aligned to 32
> > bytes.
> > Then, we'll ask to allocate 32 - 4 = 28 extra bytes
> > (NFT_PIPAPO_ALIGN_HEADROOM), that is, 128 bytes, and we'll start using
> > the area at x + 4 (aligned to 32 bytes), with 124 bytes in front of us.
> >
> > With this change, and the current NFT_PIPAPO_ALIGN_HEADROOM, we'll
> > allocate (usually) 4 bytes more, 132 bytes, and we'll start using the
> > area at x + 4 anyway, with 128 bytes in front of us, and we could have
> > asked to allocate less, which made me think for a moment that
> > NFT_PIPAPO_ALIGN_HEADROOM needed to be adjusted too.  
> 
> We'll allocate sizeof(long) more space (map_index), which is 4 bytes in
> your example.

Oh, right, it could be 8 bytes too. Let's stick to 4 for simplicity.

> > However, 'scratch' at k + 28 is not the worst case: k + 32 is. At that
> > point, we need anyway to ask for 28 extra bytes, because 'map_index'
> > will force us to start from x + 32.  
> 
> Wait.  k + 32 is really "k" for old code: slab gave us an aligned
> address.

Yes, I meant that for the *new* code: k + 32 mod 32 (that is, k) is the
worst case for the new code.

> In new code, k+4 is the perfect "already-aligned" address where we would
> 'no-op' the address on a ARCH_KMALLOC_MINALIGN == 4 system.

Isn't the already aligned-address k - 4, that is, k + 28? With k + 4,
we would have &scratch->map[0] at k + 8. But anyway:

> Lets assume we get address k, and that address is the worst
> possible aligned one (with minalign 4), so we align
> (k + 4) (&scratch->map[0]), then subtract the index/struct head,
> which means we store (align(k+4) - 4), which would be 28.
> 
> Worst case aligned value allocator can provide for new code
> is k or k + 32 (make no difference):
> 
> Lets say address we got from allocator is 0x4:
> 
> NFT_PIPAPO_LT_ALIGN(&scratch->map); -> aligned to 32, we store 28
> as start of struct, so ->map[0] is at address 32.
> 
> Lets say address we got from allocator is 0x20 (32):
> NFT_PIPAPO_LT_ALIGN(&scratch->map); -> aligned to 64, we store 60
> as start of struct, so ->map[0] at 64.
> 
> In both cases ALIGN() ate 28 bytes of the allocation, which we accounted
> for as NFT_PIPAPO_ALIGN_HEADROOM.
> 
> Maybe thats what you were saying.  I could try to add/expand the
> comments here for the alignment calculations.

...yes, the rest is exactly what I meant. I'm not really satisfied of
the paragraph below but maybe something on the lines of:

	/* Align &scratch->map (not the struct itself): the extra
	 * %NFT_PIPAPO_ALIGN_HEADROOM bytes passed to kzalloc_node() above
	 * guarantee we can waste up to those bytes in order to align the map
	 * field regardless of its offset within the struct.
	 */

-- 
Stefano

