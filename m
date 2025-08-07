Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC10225417
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754571914; cv=none; b=bYlmIV1tEGshg9el0+fFhbpq0uUzijxC3XJ6ygqFBtqxCU4cA1cv5yw1mkCYGcFGI3RNw5y7sSsF6n4w+Kjdc+s5/a9xvF/jrjaZUpszDjYzo9TPkjAfp66fE4EnjP+QOFugXFbWWVliCvt85kPOtAggttP7Kho7sl0ZSP34Mkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754571914; c=relaxed/simple;
	bh=MnLWyAF3FBfwr7MubOHkmhxEHwKd7vgC15He/lRWKg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1L122ZZaM9owfoDEZEMmYD9qNRM8fSfMcLss7vMgS2wDwwjJyNImMZRl//drVzTm3nDnnE3rZPtyFrm5nHvnsRfjMEKBYTeEi/rZa+MzJcIym2DVHeDdq79WVFpMpMMKU1ZgwZmjrnzA3gzH40IWpMg8TEv1C6CJI4/c6VysfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4FEA960532; Thu,  7 Aug 2025 15:05:09 +0200 (CEST)
Date: Thu, 7 Aug 2025 15:05:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next] netfilter: nf_tables: remove element flush
 allocation
Message-ID: <aJSkhXthAzpaghqP@strlen.de>
References: <20250731154352.10098-1-fw@strlen.de>
 <aJSUvdpLyFS75wj5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSUvdpLyFS75wj5@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Not signed off as I don't see this as more elegant as v1 here:
> > https://lore.kernel.org/netfilter-devel/20250704123024.59099-1-fw@strlen.de/
> 
> Not very elegant, maybe it is just incomplete.

Its complete (both the sleepable-iter linked above and this RFC).
The RFC omits conversion of NETSETELEM however.
I did not spend time on that because I'm not sure I'm following your
suggestion in the first place.

> > Both DEL/NEWSETELEM would be changed to first peek the transaction list
> > tail to see if a compatible transaction exists and re-use that instead
> > of allocating a new one.
> 
> Right. Would all this provide even more memory savings?

Yes.  The memory saving would come from no-need for elems[], except for
update case.

Atm we can store 124 elements in one nft_trans structure.  Each
nft_trans_elem has 2k size, to hold the pointers to the elements
added/removed.

But with list based approach you need one nft_trans struct only (96
byte) in ideal conditions (same op on same set, e.g. flush case).

So its in the 96 byte vs. 163840 bytes range for 10.000 elem del/add.

The downside is the permanent 8-byte per element increase.
But, the truckload of temporary trans objects will be gone.

> > Pablo, please let me know if you prefer this direction compared to v1.
> > If so, I would also work on removing the trailing dynamically sized
> > array from nft_trans_elem structure in a followup patch.
> 
> I don't remember when precisely, but time ago, you mentioned something
> like "this transaction infrastructure creates myriad of temporary
> objects". Your dynamic array infrastructure made it better.
> 
> Maybe it is time to integrate transaction infrastrcture more tightly
> into the existing infrastructure, so there is not need to allocate so
> many ancilliary objects for large sets?
> 
> There is a trade-off in all this.

Yes, there is.  If you agree I will try to extend the RFC patchset:
- add one patch to convert NEWSETELEM case
- add one patch to get rid of elems[].
  Unless you think there is a use case for update from userspace
  that makes a mass update of a set, such as modifying the timeout
  of 1k elements, then it would be better to keep elems[] and use it
  only for update case.  Let me know what you think -- I don't think
  its a scenario worth optimizing for.
