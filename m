Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D9D1EF39E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761821277; cv=none; b=E9MsYhb9pv0di0gPprj99RI1Kw+vG6R/OD2U3CV16SIWXzfdzsS/xNbXUvzIo1uzGwBprjLPI40mDo81ThVRVlWF5CuPqOI4BMgSKd6fIy4LSP2ZFPjOf2xJX+zkX1zPe8IuyN4cFr+PDcq0kyTcQbx1Ji6oSikAQJqzQH60UYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761821277; c=relaxed/simple;
	bh=IIxwYU2YP61G/Ch449FQFFjjkN/pp5I6MghqUtSothU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bob+cGK6q+Q6RYAh/r934QhVCDuGl2+ZoFY8AQSu2xjpd43i3Y76eWg/nhei806lhIA07YrzLRz3Pg78f3ReDdTFNcR/2pgrtooK2TtqbqrKCQ3uNNSkAi7JRPHMAH6KXdYfJHphY6xdvPg4RrYXTfnLgInkrc2aa/E5lDVaLe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cMpnRSXB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cMpnRSXB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JLUljABPgpcSaR+i4sa5PykGmtR1ywT7OCu/3rr0/hw=; b=cMpnRSXBUhRz9Z3npzuvObNPBr
	bnnXLue+BW8kM7eDSqlg+ynCLtlbVENRlBhFQbx64IFM8cYaiGvac+U7RHJT7ZMCEU4tUjMVT9Vzg
	eNCmvfBoz5TACI7TuRp0rFwQnD4NhsM+g0/c24jjWAWR4k8joOPeq1tegFxrnafcq+Elzx0gMNVnb
	zA/yNtOncnCfeImZRKYiS0W9kM2OpL56EsSt0Moe6yQ3ANPplaLY5bidT4gSId4aPOYLASSnPEntQ
	dOb3nSQ4ZfHz12dymKNBMllcixOylJM0u+nJNoNwsBvIMAsjg9yw9o6yomYmAQRSISI1PtoONJgSB
	bcnGvIzw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEQC9-000000002wE-1cFs;
	Thu, 30 Oct 2025 11:47:53 +0100
Date: Thu, 30 Oct 2025 11:47:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 22/28] mergesort: Linearize concatentations in
 network byte order
Message-ID: <aQNCWXxuXHhSxTDA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-23-phil@nwl.cc>
 <aQJcp6mTvWz2uWMx@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJcp6mTvWz2uWMx@calendula>

On Wed, Oct 29, 2025 at 07:27:51PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:11PM +0200, Phil Sutter wrote:
> > Results are more stable this way.
> 
> Why? Sorry, but maybe this series is oversplit? It is a bit complicate
> to follow the rationale where all this small patches are taking us.

TBH, I don't fully understand how all this works internally given that
GMP has its own way of organizing data.

> I find that a single patch with a oneliner explaination.

This change is quite unrelated to others, so folding it into another
patch might have hidden it. I get your point about reviewing 28 patches,
but there is a summary in the cover letter guiding through the series. 

The effects of this patch show in patch 23 which updates the test cases.
I can't tell for sure I didn't cause a big mess wrt. defined byteorder
of strings and dropped/changed byteorder conversions but the resulting
element ordering looks right to me.

> Question: Does tests/shell and tests/py work if I stop at any random
> patch in this series?

Certainly not! I would have to mix code changes and test case updates to
keep test suites passing after each patch. If you like to see what each
patch changes, I can provide a series which does this. I guessed it
would be easier to review if code changes were separate from "noise".

Also maybe worth mentioning explicitly: This series (and the related
libnftnl one) does not intend to contain functional changes and merely
change how libnftnl prints data, apart from two things:

* Set element ordering is changed by this patch

Since nft-test.py explicitly ignores changes in element ordering
I consider this negligible.

* libnftnl stores u32 userdata values in Big Endian

Assuming that the kernel ignores userdata and user space
stores/retrieves it using libnftnl, this should not have a practical
effect (apart from userdata becoming stable).

Cheers, Phil
