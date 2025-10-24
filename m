Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504A731A069
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761310184; cv=none; b=bneD096M/PASsLoT1Ur4GjHlzUAqJ0XoPjU7EYRtVvtessLFNwghZ1SrMe/KsZ+ZaZ+qg+Ovz81zX2OahuIMywwGJUGT8hzSg0pRTYt3m3W+2Uvk9jka6Ks4hUUwWffAYuYsuJ7mIDrA6/+hWaaHolouRkVZbrM8WtpA1qS565U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761310184; c=relaxed/simple;
	bh=KaJhAg0c1ZvpOUrnEYRTN91DOKwwl1ZicweeQvFDd5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0lcGbMevZiWAivqwjWOZxS4Gem7tIMIho+45OzrHPpBPutjasCFaZlCIKKHhkKKsiSCmYViQUNu7PpzLbIyRixfqOMmeomkO3jxb1ogAbaHQLnRvEiGEDB8CHpGPWyjdmARftuUIlB0KrXgstJB+6U9xPyvHa14KHWTz2O7lCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04D8D60308; Fri, 24 Oct 2025 14:49:39 +0200 (CEST)
Date: Fri, 24 Oct 2025 14:49:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of
 connection count
Message-ID: <aPt13hRzJvTkkK4e@strlen.de>
References: <20251023232037.3777-1-fmancera@suse.de>
 <aPtjnNZncIqh19Jl@strlen.de>
 <9d15bc0f-e41d-400b-9e3b-84f6ba1688f7@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d15bc0f-e41d-400b-9e3b-84f6ba1688f7@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/24/25 1:31 PM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> >> nft_connlimit_eval() reads priv->list->count to check if the connection
> >> limit has been exceeded. This value can be cached by the CPU while it
> >> can be decremented by a different CPU when a connection is closed. This
> >> causes a data race as the value cached might be outdated.
> >>
> >> When a new connection is established and evaluated by the connlimit
> >> expression, priv->list->count is incremented by nf_conncount_add(),
> >> triggering the CPU's cache coherency protocol and therefore refreshing
> >> the cached value before updating it.
> >>
> >> Solve this situation by reading the value using READ_ONCE().
> > 
> > Hmm, I am not sure about this.
> > 
> > Patch looks correct (we read without holding a lock),
> > but I don't see how compiler would emit different code here.
> > 
> > This patch makes no difference on my end, same code is emitted.
> > 
> > Can you show code before and after this patch on your side?
> 
> I did `make net/netfilter/nft_connlimit.s` for before and after, then I 
> diffed both files with diff -u:
> 
> I see a difference on how count is being handled.

I'd apply this patch for correctness reasons. But I see no difference:

> @@ -984,19 +984,19 @@
>   # net/netfilter/nft_connlimit.c:46: 	if 
> (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
>   	testl	%eax, %eax	# _30
>   	jne	.L65	#,
> -# net/netfilter/nft_connlimit.c:51: 	count = priv->list->count;
> -	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list, 
> MEM[(struct nft_connlimit *)expr_2(D) + 8B].list
> +# net/netfilter/nft_connlimit.c:51: 	count = READ_ONCE(priv->list->count);
> +	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list, _31
> +	movl	88(%rax), %eax	# MEM[(const volatile unsigned int *)_31 + 88B], _32

old:
movq    8(%rbx), %rax  
movl    88(%rax), %eax
cmpl    %eax, 16(%rbx) 

new:
movq    8(%rbx), %rax
movl    88(%rax), %eax
cmpl    %eax, 16(%rbx)

same instruction sequence, only comments differ.
Doesn't invalidate the patch however, we do read while not holding
any locks so this READ_ONCE annotation is needed.
