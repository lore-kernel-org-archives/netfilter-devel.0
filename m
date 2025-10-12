Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24118BC3B
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 16:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760287625; cv=none; b=tw2pev4Ju+r4lfAjQowjJW5QdrFCEMO1+e/ETy6p+bDx9g3FW3mqxsefE8YNClRfcgDNXpCb1GX/q9bmujfXEV/lHHYBNz5M23pkq/cWR0mGKFScE728ZDI0gYIjRP/HoVKJ4a7HlrG5CoS51uE5tpOa++g8Gil056Tc9Pl8WU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760287625; c=relaxed/simple;
	bh=MNErUi96tKSbHFaKNycN2N/zV5lFcGNeVslZSD7EeFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+/krg8lEvhepmENOLUBgAWFpDT0w62oScPWVGOxN2P1CJ5sEz5h1K12uV15zP6f71yUfogMhMgZsDC6ZVqHwtDG31yYPrHEZT/VNp+ALmJ4b2zcN0ooA6ehJc54WpyKEnEARo9MJ04cGI40AHgD3hxCUHI7ewHcjtJ3onP7KUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F5E760329; Sun, 12 Oct 2025 18:46:52 +0200 (CEST)
Date: Sun, 12 Oct 2025 18:46:51 +0200
From: Florian Westphal <fw@strlen.de>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables: zero dereference parsing bitwise operations
Message-ID: <aOvbe_ljSWP7ruJc@strlen.de>
References: <s5LZtLzqFmQhlD4mtmgcKbrgkfQ-X7k7vvg7s7XnXHekGJSKOMyOdmoiONo7MzuLVqYTFPntt74igf8Q0ERSPy5R9f8L1EfwrhOZbs_nhO8=@protonmail.com>
 <aOpigXfhOrj02Qa5@strlen.de>
 <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>

Remy D. Farley <one-d-wide@protonmail.com> wrote:
> > > While messing around with manually encoding nftables expressions, I noticed
> > > that iptables binary v1.8.11 segfaults with -L and -D <chain> options, if
> > > there's a rule containing a bitwise operation of a type other than
> > > mask-and-xor. As I understand, iptables and nft tools only generate rules with
> > > mask-xor, though the kernel seems to happily accept other types as well.
> > 
> > 
> > No, nftables supports this, but iptables does not.
> 
> 
> Hmm, when I run `nft list ruleset` it terminates successfully, but it does
> report some errors at the end if the rule from the example is present.

That just means nft dissector can't make sense of whatever your program
is doing.

> > netlink: Error: Invalid source register 0

Hmm, I am not sure why kernel accepted this in first place,
or maybe a different bug in libnftnl.

> Sure. I think it's fine for now to just check for the operation type and
> error with something like "unsupported bitwise operation", like seems to be the
> case with nft tool, since this issue appears to be extremely uncommon, if it
> hasn't been spotted before.

Yes.

You can also extend nft_is_expr_compatible() so it will exit right away.
