Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E03635334D
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 22:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642248; cv=none; b=fUO1RywmTUce1slJYbLvQN6fKdAl4CmXC/yaJhab95WxDkdAx3Ow6JoxsaxVQERM4RmmUtfmcfhcgt2ef8vo7XQrFo0j2sceG6kd6Bx/lJL3Y8o91oJlxDJq4xYmvuR8BWwRAwiAaHNuNi4itRLJ043JKodWhlZU8jneWk505Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642248; c=relaxed/simple;
	bh=X5V3PRNEFYDb7rJI44vv9NHjWVYbXS+eUwTcdCbplxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eChTcuNVym02okXLKQWAkjx0VbUkXDTr+WQaLePglFdW4KO/P1xM2gjI7Te4qEe4bD2ozxH8m9BfAQHg8BmkslcToC1LRyhgP/9ofx6DRvVUJ3aP2tPAw0mu3VGVNVDtlJ0/Axl7F1p2NuKBqhcMOSkVEEdVG7Ko+KnGBbS5pPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qpb4YpiR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qpb4YpiR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qpb4YpiR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qpb4YpiR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D5D2E6027B; Wed, 20 Aug 2025 00:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755642241;
	bh=Nt6Ltvn2ZA+VOcq80wwmCWTdX3pf8X2M02tEzxVoAIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpb4YpiRXv3ojbRlnYxHGsIdYvr13Wq3kr6D+SxVw0XX33XQ9vhkghDpCzER1GERk
	 ZHBVlazUNQWKPU0reghrchrNEYv77IokKBidw5PBgsu8kuq8le6GdHWc4tLKceBH6k
	 Ni1stjO7L8l196C0AbaONzd5KXMClEr7+L4vRqdeG5LCqcX0mZ+cAK2KfelwGP5+9f
	 v9cygzkGJGJvKtPLGKhMKeelpZdmzQNY/6SrTp1BtAI9/6STDPwfF8zvjSqzlPdnA8
	 4tMe4UImOp12yE1CN8EtK+IvQZwbvfbZegU1+NbuyJVPVAlcq+h4lQWmy2Chvd+mhN
	 EI4TKmC7UH5Sg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1902A6027A;
	Wed, 20 Aug 2025 00:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755642241;
	bh=Nt6Ltvn2ZA+VOcq80wwmCWTdX3pf8X2M02tEzxVoAIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpb4YpiRXv3ojbRlnYxHGsIdYvr13Wq3kr6D+SxVw0XX33XQ9vhkghDpCzER1GERk
	 ZHBVlazUNQWKPU0reghrchrNEYv77IokKBidw5PBgsu8kuq8le6GdHWc4tLKceBH6k
	 Ni1stjO7L8l196C0AbaONzd5KXMClEr7+L4vRqdeG5LCqcX0mZ+cAK2KfelwGP5+9f
	 v9cygzkGJGJvKtPLGKhMKeelpZdmzQNY/6SrTp1BtAI9/6STDPwfF8zvjSqzlPdnA8
	 4tMe4UImOp12yE1CN8EtK+IvQZwbvfbZegU1+NbuyJVPVAlcq+h4lQWmy2Chvd+mhN
	 EI4TKmC7UH5Sg==
Date: Wed, 20 Aug 2025 00:23:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aKT5fjEqDmQPdFFy@calendula>
References: <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <aIikwxU686KFto35@calendula>
 <aIiyVnDlbDTMRqB-@strlen.de>
 <aIpFWePr6BfCuKgo@calendula>
 <aIpJur3wIzswyaAe@strlen.de>
 <aKTMMmGdaURKNLou@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKTMMmGdaURKNLou@strlen.de>

On Tue, Aug 19, 2025 at 09:10:42PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > > For the commit phase, I suggest to add a list of dying elements to the
> > > transaction object. After unlinking the element from the (internal)
> > > set data structure, add it to this transaction dying list so it
> > > remains reachable to be released after the rcu grace period.
> > 
> > Thats what I meant by 'stick a pointer into struct nft_set_ext'.
> > Its awkward but I should be able to get the priv pointer back
> > by doing the inverse of nft_set_elem_ext().
> > 
> > The cleaner solution would be to turn nft_elem_priv into a
> > 'nft_elem_common', place a hlist_node into that and then
> > use container_of().  But its too much code churn for my
> > liking.
> > 
> > So I'll extend each set element with a pointer and
> > add a removed_elements hlist_head to struct nft_trans_elem.
> > 
> > The transacion id isn't needed I think once that list exist:
> > it provides the needed info to undo previous operations
> > without the need to walk the set again.
> > 
> > We can probably even rework struct nft_trans_elem to always use
> > this pointer, even for inserts, and only use the 
> > 
> > struct nft_trans_one_elem       elems[]
> > 
> > member for elements that we update (no add or removal).
> > But thats something for a later time.
> 
> This doesn't work.
> NEWSETELEM cannot (re)use the same list node as DELSETELEM.
> 
> Reason is that a set flush will also flush elements
> added in the same batch.
> 
> But if NEWSETELEM uses a list (instead of priv pointer
> as we do now), then at the time of the set flush, the
> encountered element is already on a NEWSETELEM trans_elem list.
> 
> I'll try doing:
> 
>  struct nft_set_ext {
>         u8      genmask;
>         u8      offset[NFT_SET_EXT_NUM];
> +       struct llist_node trans_list_new;
> +       struct llist_node trans_list_del;
>         char    data[];
> 
> to avoid this problem.

Hm, I think this is not looking good.

I am considering it is better to take your patch by now, then postpone
explore further memory consumption reduction at a later stage.

Thanks for addressing my suggestion, let me know if you prefer this
path, I apologize for delaying your original proposal.
