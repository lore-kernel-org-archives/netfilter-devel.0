Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B629221268
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749763002; cv=none; b=hTxdmGCm4j0xSp4pIRbStnDWVC5+uG4o9baFIJDUDIM9YtX2+qeJ4pqoq3B8RsyH5vl+RN2e8SYfaa6iQN3nCauR7v9TXrVOT359swXKC6NLYVywBWTEI2rS33Wg9dHo88pwl2QTbnAK9HJJo7VhWi/z+HI9f33qWVYc75lP5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749763002; c=relaxed/simple;
	bh=PoFSoBrN9sugdYJouoIMH5ECM5cfeGvpONujMvhX2WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oob6uULlsUJUU4fBW9UX4UTDmyuZ9dEc9LYLMpr7CjsDseoKAgVzETFuEnbMiiE5CKgIpnd3s3jFAJj1CzTEKwHh8hKC0U55/Hy5l4Zc1VxQGBgv8BmVeoXOL22zQtTgP6yOdukqs3raHVlQRdXYsb2T7VpE4KZjp9/RcVXORk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BsByUgUx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BsByUgUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hyggos3fvMy0w5EdjyxGfgdK0vVPBjErTyRJREzDGGQ=; b=BsByUgUxKGL7it9tUfb7ilzlb8
	yStRec0jzAyVBvKfhfEam3/+kE8iZWJ3pT2mX/xmv7abGktVo612huB06jV7Xmo4JkVeH8qTT5oz3
	36tRavy4tZzLO1LqGq9mmf7VyMmtWy4pYMoz/RJ3w7lYbL4nS+uRXIM953/LqAekNRnHkXl3HrlFF
	LZny4Ip7eCRGGs9US1lHzragv0cHskPjISfWsuRT1gf9uYFWphFobEnq9pfgB2fY2uXBU9mcxXhd9
	Sou3s/HytEvrJZJBcWPc3rbb48vPSn1tLkIKgMNW7TUkaNCMR6Ok5bznni+h/DXhjuDVZCVU6JaF1
	Cw4KvEeQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPpHq-000000001Hh-0rZS;
	Thu, 12 Jun 2025 23:16:38 +0200
Date: Thu, 12 Jun 2025 23:16:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/7] Misc fixes
Message-ID: <aEtDtmSjcUq3Xwxr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>

On Thu, Jun 12, 2025 at 01:52:11PM +0200, Phil Sutter wrote:
> Patch 1 is the most relevant one as an upcoming kernel fix will trigger
> the bug being fixed by it.
> 
> Patches 2-5 are related to monitor testsuite, either fixing monitor
> output or adjusting the test cases.
> 
> Patch 6 adjusts the shell testsuite for use with recent kernels (having
> name-based interface hooks).
> 
> Patch 7 is an accidental discovery, probably I missed to add a needed
> .json.output file when implementing new tests.
> 
> Phil Sutter (7):
>   netlink: Fix for potential crash parsing a flowtable
>   netlink: Do not allocate a bogus flowtable priority expr
>   monitor: Correctly print flowtable updates
>   json: Dump flowtable hook spec only if present
>   tests: monitor: Fix for single flag array avoidance
>   tests: shell: Adjust to ifname-based hooks
>   tests: py: Properly fix JSON equivalents for netdev/reject.t

Series applied.
