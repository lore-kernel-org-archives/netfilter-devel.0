Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F1F1D53F
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 10:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714042145; cv=none; b=IJbUIWO+WsKOE4qwNUXXOoh6wnTtplcpCiybe55evDDkzkU/gek5/DyNcuN6A0p6QZmP7l/d1HvzUdzJm50NQJKpxdN/xK1CbW2tCTThY07Fd2Xan4is25MfMHySmcnoHZPIdFdZEpyorl8yHu8XgrfdqiuW4Dbk/Ua5+/f3xMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714042145; c=relaxed/simple;
	bh=aOMMl1lHlwRcebt1wmayedDtuyBXxxmLPmO1hpoqtbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guqLIeGZR/ISHtd7atEKU8ejPwTAe//8AlyNisLgHS414gf+n6ZBdkPvl2HFBysn9I42Fdr6JHhbKIdOFIHTucoBGVkhhHFhN/apsA5xX1iDgYIQPHltKe7oglYxGd7Ozs1jGDwkvW7+wrJsXas1Zc0u2PwFy11PoZe1YIRWfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MBaDAgMs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MBaDAgMs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=quOHDx7wpl5U4wTgT1NW5JExYkXCkYuSYiVl46vN31I=; b=MBaDAgMsyn24s71QSBF70Y1JfQ
	QqgIlAQEKKsU+yXM+nr9PpdWgGhsBZJHl5AHpG4c7NIygRAdplyd8PRF4x9ZuYnAXQHHRVTWYLSru
	3n9oOCvPL6PTAWrcwAohql6d4oRF/rSbv59KaCFu5AfVWSZxzWtRCke3Q4pIC/zSWH6Tfjdj2m89Q
	PPIvnzaSl7SbIsS7/lhKpbSwbHl1oKhDW96wpPriJK7352DClajYNhoGBkF9qpCjHeEJ6BkMurGDC
	8JxM3XjRKzEmupfxd2YsWbCgyoCyNTpKrGw3vbO6dKHZyciVJTxzIJZ52+s+lCqwgvn4+Bb5njePf
	fVe0snWw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzwex-000000004RK-2Q5P;
	Thu, 25 Apr 2024 12:48:59 +0200
Date: Thu, 25 Apr 2024 12:48:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Fix for memleak in __binop_expr_json
Message-ID: <Zio1G1lpge3YGsVm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240424215821.19169-1-phil@nwl.cc>
 <ZimD2x6aaf29ZTyJ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZimD2x6aaf29ZTyJ@calendula>

On Thu, Apr 25, 2024 at 12:12:43AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 24, 2024 at 11:58:21PM +0200, Phil Sutter wrote:
> > When merging the JSON arrays generated for LHS and RHS of nested binop
> > expressions, the emptied array objects leak if their reference is not
> > decremented.
> > 
> > Fix this and tidy up other spots which did it right already by
> > introducing a json_array_extend wrapper.
> 
> Thanks for fixing it up so quick, no more issues with tests/shell.

Thanks for verifying, patch applied.
