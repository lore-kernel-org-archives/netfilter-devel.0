Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46318BC33
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729103660; cv=none; b=FzC7Sdc3d9w2iHOIaHkAgp2YCOxGcLQ9uFslPKVAUYlnOMZwDODGJM+nXDquHxgNGl7xGMNjqcWi948/2F1rf/h9A6oD5hHpkHjYi69zhYX9tLWMBCfL7AfigfR6jhlJuZkKUQ1iihVETaSPbzEunPbxMGJWTS6MYKmbGOqGLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729103660; c=relaxed/simple;
	bh=Kz9u8vRouLI3ZZUMWLkZt4mnTDfQkhZuRmXLw3xhPIY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bN+Bhvg9Bcb/0jd/j1y2wcp7azHPfSEyaYbTS+LNeK6TOBbuNzH9GJl/p6u0w7FkYfUhsTbio/c2EVD8SKqOehZnIBEmFeGvllMcJhT89wgtGlZGR29Kg0MLiXGU/UeI8QbMdYAmEvtMu+8Fv7qcnoDJUdukZSAnIhszWvGG6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57258 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t18qa-00Cj3G-MC; Wed, 16 Oct 2024 20:34:14 +0200
Date: Wed, 16 Oct 2024 20:34:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of
 unsupported netlink attributes
Message-ID: <ZxAHJO_amh8cIDaR@calendula>
References: <20241007094943.7544-1-fw@strlen.de>
 <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Oct 16, 2024 at 07:07:24PM +0200, Phil Sutter wrote:
> On Mon, Oct 07, 2024 at 11:49:33AM +0200, Florian Westphal wrote:
> [...]
> > Extend libnftnl to also make an annotation when a known expression has
> > an unknown attribute included in the dump, then extend nftables to also
> > display this to the user.
> 
> We must be careful with this and LIBVERSION updates. I'm looking at
> libnftnl-1.2.0 which gained support for NFTA_TABLE_OWNER,
> NFTA_SOCKET_LEVEL, etc. but did not update LIBVERSION at all - OK,
> that's probably a bug. But there is also libnftnl-1.1.9 with similar
> additions (NFTA_{DYNSET,SET,SET_ELEM}_EXPRESSIONS) and a LIBVERSION
> update in the compatible range (15:0:4 -> 16:0:5).

LIBVERSION talks about libnftnl API, not netlink attributes?
Probably 1.1.9 got any API update while 1.20 did not?

> We may increase incomplete marker correctness by treating support for
> any new attribute an incompatible update. Given that we often have
> dependencies between libnftnl and nftables for other things, it may not
> be too much of a downside though.

15:0:4 -> 16:0:5 means new API is available while older are still
supported, so old nftables can use this library binary safely.

You mean, we should reset age, considering c:0:a?

> > Debug out out will include the [incomplete] tag for each affected
> > expression.
> 
> Looking at the impact this series has for such situations, I want to
> make the iptables-nft compat extension stuff depend on it for better
> detection of incompatible rule content.
> 
> Thanks, Phil
> 
