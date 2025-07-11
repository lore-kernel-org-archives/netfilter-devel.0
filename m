Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FBB2AD21
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jul 2025 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752241690; cv=none; b=lM8NJkztQPJdneYzzCdVzgmD/gT5NqYozD3M/LnyqNu0MfElIMw2JE3eEw2W1FSmr0cAM2Jm5u3nD+D6G31DBu4EB2hRES0V/IkRh1NoaEC/F8JDKveb3ry+zH3xmAF7X+GiY+zAn48NPOVDJ4QQaIFUxMjvERxmKirCiNFuGKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752241690; c=relaxed/simple;
	bh=SO1AwE6jgsq3An8JK5dou1/4Zsl96BRPpvInWl9jyLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/c5WkYqsmhjgL91PuoROk3u+GvWrQS41iRl8846rXBciPtBkoN3bjIZIRyATooRVhL3umMkaVMw3Ai7N6HL2SCSyfZkjWTd5gJ0TWdFQoYZqfPRAlbx4aK17oiwYgKWMZfLhZH0Nl+laKW3Xq/j+82CsGUClnfrxQb5U69aWwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1DBDD6057E; Fri, 11 Jul 2025 15:48:06 +0200 (CEST)
Date: Fri, 11 Jul 2025 15:48:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aHEWFXSbuABv9n__@strlen.de>
References: <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
 <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
 <aG7wd6ALR7kXb1fl@calendula>
 <aHEBOFfIk3B2bxxr@orbyte.nwl.cc>
 <aHEOtz_Ekj0QV15d@strlen.de>
 <aHEU8juop6ztbVip@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHEU8juop6ztbVip@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Oh, I didn't get that. Does it work with removed interfaces? 'nft
> monitor' will notice, but fetching hooks for the removed interface won't
> return anything then, right?

Yes, it won't find the interface since its already gone.
One solution is to remember which interfaces had hooks and then just
inform the user that the interface is going away.

If a kernel implementation is small enough, then fine but I don't
really see why its needed.
