Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB88010FF
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710952466; cv=none; b=H45ibvPp0GdiOOCyHThtdyXX5vJm5C9NWYay95c8+2+DHi41eBQbRoU0X8Z0vmpaLkJMb5xNBU8HC3zvNbYbtOLMI7hdVTeNUQbcf3GByiiKiOL4opx2yBsaKjSAmcuMcMsyqoqPSqzS7dhOGKBtCxDepi0+1N727XaluOXX2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710952466; c=relaxed/simple;
	bh=8gv6O/39cQ7s0kt4gYWhxDhQp4tFOxPXcrCsTKRaBjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1ozRsKCYf9Gbvd55vCyJ2VVQEDQIuQXKkJBhijJzRyIZhDIV5YbCcAM+cnHJaTEBqqIqmlkbLlwwARDDpry4E7AYd/rWT0HfgvzBQGoFxlnzs0Z6ixPgjs4zM6iFkKx72zMQJT6zgVfHvGt3oJhnxRmgXPJH/kmdEDza0hZTtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 17:34:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Quan Tian <tianquan23@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_tables: do not compare internal table
 flags on updates
Message-ID: <ZfsQCDssxqJkpmF_@calendula>
References: <20240314201602.5137-1-pablo@netfilter.org>
 <ZfQPooVt0Ey+fIl9@dev01>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfQPooVt0Ey+fIl9@dev01>

On Fri, Mar 15, 2024 at 09:06:42AM +0000, Quan Tian wrote:
> Hi Pablo,
> 
> On Thu, Mar 14, 2024 at 09:16:02PM +0100, Pablo Neira Ayuso wrote:
> > Restore skipping transaction if table update does not modify flags.
> > 
> > Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > This restores:
> > 
> > nft -f -<<EOF
> > add table ip t { flags dormant ; }
> > EOF
> > 
> > nft -f -<<EOF
> > add table ip t
> > add chain ip t c1 { type filter hook input priority 1; }
> > add table ip t
> > add chain ip t c2 { type filter hook input priority 2; }
> > EOF
> > 
> > after c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant
> > table state more than once") which IMO is not the real issue.
> > 
> > This provides an alternative fix for:
> > [PATCH nf] netfilter: nf_tables: fix consistent table updates being rejected
> 
> The alternative fix definitely makes sense. But I thought "[PATCH nf]
> netfilter: nf_tables: fix consistent table updates being rejected" also
> fixes the case that two individual updates updating different flags in
> a batch, for example:
> 
> * The 1st update adopts an orphan table, NFT_TABLE_F_OWNER and
> __NFT_TABLE_F_WAS_ORPHAN were turned on.
> * The 2nd update activates/inactivates it, trying to turn off/on
> NFT_TABLE_F_DORMANT, which would be rejected currently if it only
> checks if any flag is set in __NFT_TABLE_F_UPDATE, I thought it's
> not the intention according to the code comments.

NFT_TABLE_F_OWNER to pick up an orphan table is a new feature in 6.8.

You are correct this is not allowed. I am inclined not to support
NFT_TABLE_F_OWNER (on an orphan table) and NFT_TABLE_F_DORMANT in two
separated updates in the same batch, unless someone comes with a
use-case for this.

Thanks.
