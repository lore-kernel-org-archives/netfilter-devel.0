Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7B433CE97
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601244; cv=none; b=MlzCuK43M5Y0Ogrrl18RGjJc6lSDqhxm8imlp9Qhu6gUAVPCPxhbiyBOO4E2+oSvmYwxXT9SPznJycoxKVDx0bVVWPERSGfZ7zy0lzbBMaPDGrA2koQ5WE6ToLXe3KhUVLU/KLhMNQthnpHU4CnmN4XB9uKlUbWBKAmhG7boD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601244; c=relaxed/simple;
	bh=Db3f24x4LXSns/tExkNMybqimtPp9eqWk9Da73nkvac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/3Z6HZlMncxB/6Sgo0eYkOvSWkRSmHZNPhj3WJMahmBOvK5SWWfsdA4jjbDtgu3CgRW3ex7KvSDNnR+dfxQv31UAOMo4Zcu0uQsj2iqwHyZsnVGtmZddsPbgBV6tCSIz26A3zl+2aPdol986VayLt1UHpXJn3fEvx88Sjb/3ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2732A6031F; Thu, 11 Sep 2025 16:33:59 +0200 (CEST)
Date: Thu, 11 Sep 2025 16:33:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMLdxyxGNYsSP5c2@strlen.de>
References: <20250911141503.17828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911141503.17828-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> The old code printing each field with data as u32 value is problematic
> in two ways:
> 
> A) Field values are printed in host byte order which may not be correct
>    and output for identical data will divert between machines of
>    different Endianness.
> 
> B) The actual data length is not clearly readable from given output.
> 
> This patch won't entirely fix for (A) given that data may be in host
> byte order but it solves for the common case of matching against packet
> data.

Can you provide an example diff and a diffstat for the expected fallout in
nftables?

> Fixing for (B) is crucial to see what's happening beneath the bonnet.
> The new output will show exactly what is used e.g. by a cmp expression.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This change will affect practically all stored payload dumps in nftables
> test suite. I have an alternative version which prints "full" reg fields
> as before and uses the byte-by-byte printing only for the remainder (if
> any). This would largely reduce the churn in stored payload dumps, but
> also make this less useful.

I think that if we want it then one big code-churn commit would be
better than multiple smaller ones.

The inability to see the width of the compare operation is bad
for debugging so I would prefer to change it.
