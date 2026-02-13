Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128821B85F8
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770982550; cv=none; b=J/WX/adsiNb5agOkruh8BP71U2kogNOjH4luH1Vez60Bc5nvJCrF5CgFtX5kySjppLp8ZM00CX5cDIbV6nXct8oKQKGRmqHhy3RiuOzRVdpNkHwCErClHEeIyDdrlgodHj+YuzgpgCvcIce01HC4kpCWkNB0ZuM8/Ady9Zdj5RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770982550; c=relaxed/simple;
	bh=sdX/wvw4wVNQrjHWPT9Cb7w5hysFWvPF64wS6zXPUi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCGJL+Zih4iERP3ynEhIujcR/nvIjORy5cb6Ut+i2JrP8Efjd0/g50VVqFULP+gc3XbsGiVJkAWWxpFQOaJo9lFVA/fWCS37q2JTtbl3uWJWBlncWEbdEt9EczeMgaVi5kgbmuxIB0TMwyOu8hgRWN2VD+JF9IkFg5OoupCqDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5CA5D608AD; Fri, 13 Feb 2026 12:35:47 +0100 (CET)
Date: Fri, 13 Feb 2026 12:35:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4] configure: Implement --enable-profiling option
Message-ID: <aY8Mk5eCymlbN8UA@strlen.de>
References: <20260212205023.32010-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212205023.32010-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> This will set compiler flag --coverage so code coverage may be inspected
> using gcov.
> 
> In order to successfully profile processes which are killed or
> interrupted as well, add a signal handler for those cases which calls
> exit(). This is relevant for test cases invoking nft monitor.

LGTM, thanks Phil.  Feel free to push this out.
