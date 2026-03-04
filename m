Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877D53845AC;
	Wed,  4 Mar 2026 21:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772659579; cv=none; b=M3FP1qzGs8ssFOmmQIsBYXpQYYORmD4Jp7Moy3nsu9MJtNbxJeKTxj98WR+lFUrbejDuBkywdxtxERXYxAY/uDzzBWfLQbUAaSOw4Q4OUNK3tply3CB+zvjkM9WZcSMbArQnkPkoJUvsPqHFUgPhszpsJLPI9cc56OrSyI2goTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772659579; c=relaxed/simple;
	bh=PhMjNizqtszEaWSgFMbyxw+xTYbOwGO000UfKY+bOm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sF6IV1VwQblzP3nK4dnD8SAGEbQ0GfRJ1YwBNBkQP509fbp6G76soZ+Sfnz/PK3mTzjdc4/SKuJ8xmU+Ou+TB9tPcLQd4gFI45D4c85fd1QMp1vr3l1KgcHigWsieGmQfRXI9WaJVa1vNPOaTfdRK9DfLg0qlaRzRf9h4ufRmnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tl/ZN8h0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tl/ZN8h0"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 90F27602EC;
	Wed,  4 Mar 2026 22:26:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772659573;
	bh=TbD57Cf8HsGwolFtN68G0Af7wmRjO6opYFFt8/q/SzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tl/ZN8h0j8Xs9rFIpW2KoLzywjiMmZcPvMWhS8E6rdxuEXPpNamaClJccM4HwHMZc
	 vEzl66kak2gqQtmO2b2X24sC37WddqXChBU7OsXh4zr+yQzfxFConft4P8nqDHwL4J
	 9WQ0iqFJXMwK8AIprugBcXOMUhCv/2XYAihIKe21RVGek0pgAQ0zZYW6vAHyIZ8C2I
	 uJlM4DdNX+nqykA3aCi7yvsngQIrFNLlUQeQCYkS9gBB51dmoxemT5/BdSHHQmIZRg
	 YTUAa3FTo9inbTqw8WMudCyNOhr7D65x7pZfvzxY+mS7QRqh/dyyfAVFGfsQ+3CtsO
	 3zL7VSMijYZvA==
Date: Wed, 4 Mar 2026 22:26:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: 2026022652-lyricist-washtub-eeb4@gregkh
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lwn@lwn.net,
	jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aaijcrM5Ke5-Zabx@chamomile>
References: <aahw_h5DdmYZeeqw@20HS2G4>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aahw_h5DdmYZeeqw@20HS2G4>

Hi,

On Wed, Mar 04, 2026 at 11:50:54AM -0600, Chris Arges wrote:
> Hello,
> 
> We've noticed significant slab unreclaimable memory increase after upgrading
> from 6.18.12 to 6.18.15. Other memory values look fairly close, but in my
> testing slab unreclaimable goes from 1.7 GB to 4.9 GB on machines.

From where are you collecting these memory consumption numbers?

> Our use case is having nft rules like below, but adding them to 1000s of
> network namespaces. This is essentially running `nft -f` for all these
> namespaces every minute.

Those numbers for only 1000? That is too little number of entries for
such increase in memory usage that you report.

> ```
> table inet service_1234567 {
> }
> delete table inet service_1234567
> table inet service_1234567 {
> 	chain input {
> 		type filter hook prerouting priority filter; policy accept;
> 		ip saddr @account.ip_list drop
> 	}
> 	set account.ip_list {
> 		type ipv4_addr
> 		flags interval
> 		auto-merge
> 	}
> }
> add element inet service_1234567 account.ip_list { /* add 1000s of CIDRs here */ }
> ```
> 
> I suspect this is related to:
> - 36ed9b6e3961 (upstream 7e43e0a1141deec651a60109dab3690854107298)
> - netfilter: nft_set_rbtree: translate rbtree to array for binary search

More memory consumption is expected indeed, but not so much as you are
reporting.

> I'm still digging into this, and plan on reverting commits and seeing if memory
> usage goes back to nominal in production. I don't have a trivial
> reproducer unfortunately.

The extra memory comes from the array allocation, the relevant code
is here:

#define NFT_ARRAY_EXTRA_SIZE    10240 
 
/* Similar to nft_rbtree_{u,k}size to hide details to userspace, but consider
 * packed representation coming from userspace for anonymous sets too.
 */     
static u32 nft_array_elems(const struct nft_set *set)

> Happy to run some additional tests, and I can easily apply patches on top of
> linux-6.18.y to run in a test environment.

I would need need more info to propose a patch, I don't know where you
are pulling such numbers. You also mention you have no reproducer.

> We are using userspace nftables 1.1.3, but had to apply the patch mentioned
> in this thread: https://lore.kernel.org/all/e6b43861cda6953cc7f8c259e663b890e53d7785.camel@sapience.com/
> In order to solve the other regression we encountered.

Yes, there are plans to revert a kernel patch that went in -stable to
address this.
