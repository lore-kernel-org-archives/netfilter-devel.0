Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145B928C5DA
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 09:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364685; cv=none; b=JbytIkrUZmaQvQSrS4EoxotVucrlox7iX9b04L+PYRG1MBQGiTXCu3bLYogGGrjhig6X6daQiYdux8gDMx4ye5SkVlLR0vYj6E2o/Q56ENpP/DxLsfUEhn2fGSWcnh6Z7IAjjJfL9M/BGkaKCq6KTq1dQaq/hLXtMJC490kt4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364685; c=relaxed/simple;
	bh=Ua/qohmgBkQDNOi5LNnTA9wVbA3fjMfsKLKHjQTLcVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XkKwMQMTONBB5HZdLBNZCdBKwHaLD63UVvRG/n5Uu0dzTZYhBcbojpOKoP3YdJmHa8Z7PZbz6BNyeBkKrZHvhUFyTEF/hpT+AlYbBQvAygdYwhy/CtWfx15zYN6nKVlRYm6CvdrY2O3zQTNRUx2zZbY5hBLdhFXp3iM2SO5+khY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H+IJxsfF; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H+IJxsfF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H+IJxsfF";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H+IJxsfF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B6C8360630; Fri, 11 Apr 2025 11:44:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744364672;
	bh=17Llz9EBPLrdJGcEqtHo0eYjTDvb/z14bAjGbH9sk+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+IJxsfFf2gg1YscNs5Uum91swd9CkFfU3WeMHcYA48jejus35ipMrdH7U1zztrnh
	 ZqRlzNAMJ8B4lRiPHBGi9Rcc0vwOGdw2ZH6J/NeiW65sITLJaUraN9VUE6pCP/qYcF
	 7CeQTSP2pZ6KJ88SovcgsrcAVa4xuf0YKexFPaHwYiqrqGDGiSfiLg8E1XS5nypXrP
	 adG3Cfi9+/P2ZeCoIQD//UnGMEGGmY6HNxJhs8gRXEkA0bqS/lBLN/nTlGWsYi9J6H
	 japMZeBynv7oJ9OObznjVs/AfauSsvMKA2y20CdOwBZFCNsTj8pSbfhIe9CpQXGFtR
	 +Eyqd/9P29C4Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0973A60630;
	Fri, 11 Apr 2025 11:44:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744364672;
	bh=17Llz9EBPLrdJGcEqtHo0eYjTDvb/z14bAjGbH9sk+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+IJxsfFf2gg1YscNs5Uum91swd9CkFfU3WeMHcYA48jejus35ipMrdH7U1zztrnh
	 ZqRlzNAMJ8B4lRiPHBGi9Rcc0vwOGdw2ZH6J/NeiW65sITLJaUraN9VUE6pCP/qYcF
	 7CeQTSP2pZ6KJ88SovcgsrcAVa4xuf0YKexFPaHwYiqrqGDGiSfiLg8E1XS5nypXrP
	 adG3Cfi9+/P2ZeCoIQD//UnGMEGGmY6HNxJhs8gRXEkA0bqS/lBLN/nTlGWsYi9J6H
	 japMZeBynv7oJ9OObznjVs/AfauSsvMKA2y20CdOwBZFCNsTj8pSbfhIe9CpQXGFtR
	 +Eyqd/9P29C4Q==
Date: Fri, 11 Apr 2025 11:44:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restrict allowed subtypes of
 concatenations
Message-ID: <Z_jkfafmlGedPQ-H@calendula>
References: <20250402145045.4637-1-fw@strlen.de>
 <20250402145045.4637-2-fw@strlen.de>
 <Z_hLLgRswOjXUKMa@calendula>
 <20250411055201.GA17742@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250411055201.GA17742@breakpoint.cc>

On Fri, Apr 11, 2025 at 07:52:01AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Not related, but if goal is to provide context then I also need more
> > explicit context hints for bitfield payload and bitwise expressions
> > where the evaluation needs to be different depending on where the
> > expression is located (not the same if the expression is either used
> > as selector or as lhs/rhs of assignment).
> > 
> > I don't know yet how such new context enum to modify evaluation
> > behaviour will look, so we can just use recursion.list by now, I don't
> > want to block this fix.
>
> OK.  Yes, it would also work if there was some different "where am I"
> indicator, e.g. if (ctx->expr_side == CTX_EXPR_LHS) or whatever.

Exactly, something like this.

> This fix isn't urgent, we can keep it back and come back to this
> if you prefer to first work on the ctx hint extensions.

I am in the need for such a context for payload/meta statements.

        meta mark set ip dscp map ...
                      ^^^^^^^

in this case, ip dscp needs to be evaluated as a key for lookups,
shift can probably be removed for implicit maps.

While in this case:

        meta mark set ip dscp
                      ^^^^^^^

in this case, ip dscp needs the shift.

Then, there is:

        ip dscp set meta mark
        ^^^^^^^

(note: this is not yet supported)

where ip dscp needs to expand to 16-bit because of the kernel
checksum routine requirements.

They are all payload expressions, but evaluation needs to be slightly
different depending on how the expression is used.

This context should help disentangle evaluation, evaluation is making
assumption based on subtle hints, I think there is a need for more
explicit hints.

We can revisit in a few weeks, otherwise take this.
