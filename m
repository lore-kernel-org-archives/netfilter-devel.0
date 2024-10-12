Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63A5FEE4
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728753902; cv=none; b=SD7zNxfSSxC5XSL5fsTMYTPCP5E1HiqL/ntIexrlQ92IJ+sQxKui36fCYu6s+mB2HvbD5yVUVdiz7b8CJ8rPB1jRviyeQs5zr1bqr54rduHNRMpT8aZU+RnX1KsMuolawzrGtIxT5TvDn8NZM5k0Vtedd356Ow9RjWfd9Mb/nDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728753902; c=relaxed/simple;
	bh=Lq5ek6hbCvi89zAIHebtTh8mMbZlv9rBejPU4a+9Akw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLt5GDQyw9GYG347LGhPCkbpBQPaZKnINwac58gCuIQwoZYku1fDMfO78tSHVWPJBlXKavvQ5Ky6SEwoLlYNr31vtX+HRG6pIPcU62NMKKlcJrkDAKer4sOxDzYnifqgo3CVI3FBX+r0Iisa8gL7wZo5qSPxi3Zge4AiIS8KDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38342 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szfrL-001f82-GN; Sat, 12 Oct 2024 19:24:57 +0200
Date: Sat, 12 Oct 2024 19:24:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] netfilter: nf_tables: reduce set element
 transaction size
Message-ID: <Zwqw5jghI10XgpIl@calendula>
References: <20241011003315.5017-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241011003315.5017-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Fri, Oct 11, 2024 at 02:32:58AM +0200, Florian Westphal wrote:
> v2: only change is in patch 3, and by extension, the last one:
> During transaction abort, we need to handle an aggregate container to
> contain both new set elements and updates.  The latter must be
> skipped, else we remove element that already existed at start of the
> transaction.
> 
> original cover letter:
> 
> When doing a flush on a set or mass adding/removing elements from a
> set, each element needs to allocate 96 bytes to hold the transactional
> state.
> 
> In such cases, virtually all the information in struct nft_trans_elem
> is the same.
> 
> Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
> can hold multiple set element pointers.
> 
> The number of elements that can be stored in one nft_trans_elem is limited
> by the slab allocator, this series limits the compaction to at most 62
> elements as it caps the reallocation to 2048 bytes of memory.

Applied to nf-next, thanks Florian
