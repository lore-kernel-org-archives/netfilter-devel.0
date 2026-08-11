Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD6B43A7F6;
	Tue, 11 Aug 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786467080; cv=none; b=pZE8ws7oYBIr0qOsySNBgMV8RMPKcoWQVYrSf95Pl4KTj1dRKQBhoeHixx3e00aeJCxi2XeEnoxi+y0Q51StN/2VlO2uJV7zUMZtDUrYE302zEZfYxiNPJL7f3v6WKhbCbd540tIBWt/+09dLgU3eJISj3h4Uq3Zn6UDc4565bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786467080; c=relaxed/simple;
	bh=69+/ZHGaDdL78N+hcf6DDcX0TaaoP7qcAI/+G/iQa10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYndZAqXdziZ1Ui8CrsgfD/LjAhAZp+Ks+Csvau43IBJ7tx8VXvqM5nHdl9HCrs6Kudvf8qDFBbxsyvSCqwi/maQad1xnppsi9YIooms4x+hqsxowwbKGkqG251wMM59o1PU/1H/wHlMA8+Y2mh5hV53udBzsfReztkCrNGxeMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=utMBsQuO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="utMBsQuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786467076;
	bh=0GD3LIfJJQQAA8U/BgXJdNFQ3Kg5LyHM66cvG8TX1j0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utMBsQuOdNJm1yBLI+S0YvGTs/2nfOAWAiHbM5mapgkmJYgNS/+ZIL2ilAIL7Tj6q
	 rEPA0EFGexf4cWuNCcc/F+2znAH65vsNspmyfHvf4tdoltAg7qTpSYkciTdHGzGF+8
	 BcfIYeKEx92G3nef1ut+swW0ZB+5ZDSGQmdn6clSr57Ks7WmhgO1x7rjTSWIitBcXn
	 jTzxsxSBb7srN9Gy+7nKAfCbxrmvdKQ5dXdF/ezm9YzhwHJwtL6+1tUrGL4TqT0qW3
	 EvPuRLk/MkjldVlkbru7cbupnCGZxRaM3c6EFcZmfMYlBtclsR/EH3Wx5ei78NCdcg
	 eN1DKjLhDutMg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D655260060;
	Tue, 11 Aug 2026 18:51:15 +0200 (CEST)
Date: Tue, 11 Aug 2026 18:51:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Wei Fang <void0red@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	k.chen@smail.nju.edu.cn
Subject: Re: [nf_tables] rbtree interval set: in one batch, re-adding element
 E0 makes deleting an unrelated interval E1 fail with -ENOENT
Message-ID: <antTASZYV9q81Ucc@chamomile>
References: <CANE+tVpU7gL3ZJ9ro4oNKsqdN01mDMBpUou0ABakiO2WrT5gSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANE+tVpU7gL3ZJ9ro4oNKsqdN01mDMBpUou0ABakiO2WrT5gSw@mail.gmail.com>

On Tue, Aug 11, 2026 at 05:22:01PM +0800, Wei Fang wrote:
[...]
> Problem
> -------
> On an interval set that already contains two intervals, one batch
> that does both of the following fails on the second operation:
> 
> 1. re-add element E0 without NLM_F_EXCL (update semantics);
> 2. delete a different interval E1.
> 
> The delete returns -ENOENT.  Sending the same two operations in
> separate messages succeeds.  A transaction must not change what an
> operation does: batched and unbatched execution must behave the same.
> 
> Steps to reproduce
> ------------------
> One batch on an ipv4_addr INTERVAL set with two existing intervals:
> 
> 1. re-add E0 = [10.0.1.0..10.0.2.0) without NLM_F_EXCL;
> 2. delete E1 = [10.0.2.0..10.0.3.0).
> 
> Raw netlink is required: the nft CLI re-sorts interval elements and
> hides the ordering.

What do you mean by "hides the ordering"? It sounds negative, actually
what is does is to pass a list of elements to the kernel that make
sense when interpreting the interval?

Ordering is paramount in this loose interface, your program does:

        ...
        put_interval_elem(&q, 0, E1_END, 1);
        put_interval_elem(&q, 1, E1, 0);

Deleting E1_END element before E1, makes no sense, the interval
representation is reversed.
