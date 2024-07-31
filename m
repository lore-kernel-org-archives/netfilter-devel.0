Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1116C846
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 21:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460511; cv=none; b=J2pQy6k2PJO0LZTTWafmqDnPDpsJYB1RbbyNgG5M2/OQtA8SjHFxdOax+mwsvTA1BBuMWrhtEb/fmCgMYjREMxDNTBAJ7juu/KTuZC7XzpyOW8LvyNqYRLsmX1cKE1A8QmpfD48oJHhmMTs52Bl2cPYZzUVzslvQzMmklQlrHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460511; c=relaxed/simple;
	bh=YgLg+ZXyKLXXWhYpDSke+B+d6lPNGn8W2t6KtP2v8DA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9pBnSA6MsCzHqdwLY7Ia3XMKHJ8O2AHJoH7vjn9cYBDD+SpQ5RGjnFoCYWrLDq54O1Gqa10M0hGwxojX2XKCs1GC6sD79lTLrCy0jk77Q6AYWtsx5y6F7HArrZ2SQqdXRXS1SlLfI2gf3rib0q/u82gBhKRj7pWdtPZJ50UCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=THJ4uw60; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="THJ4uw60"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xgGN6FsIyYgUgk9nSiVHz6aJPicnDuZzyj0tTW+PCqM=; b=THJ4uw60ETyi4p0SVXF5CHYrLe
	a8eGPQ7ItHiL8+IlX8VignJeIsSpln8z7tGiYKa1+SkakDUIdsrc7VI5xfkun/fvy7PV9uF6px80k
	UzbgSuHRQq5m828cr1oDEhLt2Fa84s4N2freUshhK/xikmOFXxR6ZQ5FI0XnqsMAgiZ2ZtlVwT5uB
	C37dKTZ9uXQzstYD3r0HJ6XNVP2pgjpBXDUKpx9dlcR/gCZEz9ZCrEjyPrhhjuWXz6AU5fN7j5MyK
	OLLcMHc4Fpu6vvNWVLlkKXjkGiQTUbqjfuMLboca7l3k6ZqEUN0g74RZTDsHYeHEtY+W31ShPjXSd
	71Jvkgvw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZGf4-000000002jv-08bf
	for netfilter-devel@vger.kernel.org;
	Wed, 31 Jul 2024 23:15:06 +0200
Date: Wed, 31 Jul 2024 23:15:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/14] Some fixes and trivial improvements
Message-ID: <ZqqpWgYmKz348Gnw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>

On Sat, Jul 27, 2024 at 11:36:34PM +0200, Phil Sutter wrote:
> With my fix for flushing non-existent chains I inadvertently turned
> chain flushes into nops and broke iptables-restore with input containing
> a flush early before other commands. The shell testsuite clearly
> identified all these issues, but I had tested only the problem case.
> This is fixed by patch 2 with patch 1 as basic work.
> 
> Patches 3-7 fix other issues I stumbled upon when working on some
> approach for forward-compatibility.
> 
> The remaining patches are not strictly fixes but trivial enough to just
> go along with the rest.
> 
> Phil Sutter (14):
>   nft: cache: Annotate faked base chains as such
>   nft: Fix for zeroing existent builtin chains
>   extensions: recent: Fix format string for unsigned values
>   extensions: conntrack: Use the right callbacks
>   nft: cmd: Init struct nft_cmd::head early
>   nft: Add potentially missing init_cs calls
>   arptables: Fix conditional opcode/proto-type printing
>   xshared: Do not omit all-wildcard interface spec when inverted
>   extensions: conntrack: Reuse print_state() for old state match
>   xshared: Make save_iface() static
>   xshared: Move NULL pointer check into save_iface()
>   libxtables: Debug: Slightly improve extension ordering debugging
>   arptables: Introduce print_iface()
>   ebtables: Omit all-wildcard interface specs from output

Series applied.
