Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E813B6C1E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774020106; cv=none; b=AwZsjT/7KUTCA+hSz3fgKXvTq7A2duF4YCPdsNv6MZPckKKbMYAEeBxInBWGgPpATzPow9Xjsp55wKtRkmTpQOQel+bJj76JPYstEDT86ejQ0mIbJ7rT6I/RPP2KnwVE41McakBrfTmgoRIkv6o56uAxQZSxLvMDk6QG7bQ1IuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774020106; c=relaxed/simple;
	bh=H/5renSS02MSsQJ7VHNwg3XXN6qtPPJGCiZqLF/oKc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfvxkgsLl+WPjgAln4tnaqAA/yDg+cyYMtZe2X7suhiANDd1tO8Qi29D6s16dk6kS+ExppSDSoX7i004qvujQ2cnUTFR0h2J7dDHCC2woyaBLg6voeG7GIpI9/UAQF+VHDk43FzFnQjZ5JPbEhJMdGbY8fBLNGtyGbuBfYHiCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 470A86080C; Fri, 20 Mar 2026 16:21:42 +0100 (CET)
Date: Fri, 20 Mar 2026 16:21:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: Fix ordering of hooks in 'list hooks' output
Message-ID: <ab1mBgSjDyCs5aZC@strlen.de>
References: <20260320151625.5318-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320151625.5318-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Hooks with same family, basehook and priority were inadvertently
> inserted into the list in reverse ordering, fix that.

Right, just push this out.
