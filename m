Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A70422541C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853461; cv=none; b=K3WGFdRi6taBOTyyEhrBwYKrjM+pW+biQJ4QNcXzi5dW4vFluQOHLnPMvhjEh0QpdtwG5M8F9SF/1HUC+ylw6cmAaQho5Urt0tWaXUpQzpCm0eYn5BMoQ9B+i0vQILGfEolT3tPZ6eB35W5rDDqaOEW4xC3/Up3biIKC0qIQ86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853461; c=relaxed/simple;
	bh=VHrlrd+jXooPWlEVWGbyCexQkWg0RgZ6MyUU4Wb9tSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqa3DlhjwbxJB6ePoFf0YAJWb6PNOiU6ycExC4w5+kLBFbvWe1j9xtNSDH0CMUBDD/QuFYHLdewN6DV6/gk5hRt2aNcVg1s2Rj4z1AwZaQZkIneYzJGcC6U5YZGuESKYlDE3ex6wy/INxwXedKcsaPKpfLt1CnScrJMqtQpC7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jXgBxXmZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jXgBxXmZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7720C6026B;
	Wed, 18 Mar 2026 17:57:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773853077;
	bh=RgmrAwmbWKzBsGZytj2qatOpmuTiF0GjPWWPBxc+sRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXgBxXmZsFhnMETn97R2KiDqMO8F5kIsbuYsJ9/HU1iuJjLftBDOx2RlgC7onFqJn
	 RoN/tolJ+gTc1BseiyCKPqwxfmvnVMO0ymB7ZO6c/7G6ca957n+poNtd/zxgDDQfVE
	 R9keNKctbNFaOOXK1WjEwi5VOzRB1nSQpchZpI4UlOXNa5Z/Te5m7VGOmroZ9hLFK9
	 utJ/EwV0klHjR+k/Dgxycm+9+PVRh8UOsyOJUlfqZEMY6zbAHEr2MhQH5UO/D0WzG/
	 z9r8SZ2LL1gSefzskJtnzv9Vj0Zkq4v+bjkF204/Dw2egXGdYASQD4DmFwaRIoz2zJ
	 Ph/WwmEpQ3YHQ==
Date: Wed, 18 Mar 2026 17:57:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chris Arges <carges@cloudflare.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <abrZkrarLXbZzXEO@chamomile>
References: <20260317170721.12396-1-pablo@netfilter.org>
 <abrI8CZV3c8fi9x3@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abrI8CZV3c8fi9x3@20HS2G4>

On Wed, Mar 18, 2026 at 10:46:56AM -0500, Chris Arges wrote:
> On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> > Chris Arges reports high memory consumption with thousands of
> > containers, this patch revisits the array allocation logic.
> > 
> > For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> > Expand it by x2 until threshold of 512 slots is reached, over that
> > threshold, expand it by x1.5.
> > 
> > For non-anonymous set, start by 1024 slots in the array (which takes 16
> > Kbytes initially on x86_64). Expand it by x1.5.
> > 
> > Use set->ndeact to subtract deactivated elements when calculating the
> > number of the slots in the array, otherwise the array size array gets
> > increased artifically. Add special case shrink logic to deal with flush
> > set too.
> > 
> > The shrink logic is skipped by anonymous sets.
> > 
> > Use check_add_overflow() to calculate the new array size.
> > 
> > Add a WARN_ON_ONCE check to make sure elements fit into the new array
> > size.
> > 
> > Reported-by: Chris Arges <carges@cloudflare.com>
> > Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v4: use maybe_grow: goto tag instead of grow:
> >     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> > 
> 
> I will be able to testing this more in depth early next week. Just to confirm,
> this patch requires this to be applied first?
> https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/

Yes, it requires that fix to be applied first.
