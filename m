Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F856388E4D;
	Wed,  4 Mar 2026 21:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772659670; cv=none; b=AxzNQFqC44mwCokFFB77HlzKtepQL1E5MOtKe5iDlYBveG40JEGn8mT736UxVipEK6NSyzc8ya+NnDotxn01pEEMFo4ZLMNyDzshj8OJ/eHt1q7RIpUvTdjJz0cVK3SvXrMcK2ksKQXcrcAcBFMHxAjZCx89j8GlvwMlbMMneaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772659670; c=relaxed/simple;
	bh=oOM7Zk18wbpy+KVhSL25XNQql+cWoWEbIZLCb70VY9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2luMs8HpF+HC1zMpL5Wf1fdC+0sBxwwAP+DhR44kyRBJlY9psVFncrgEZPSxMq+iyOt088LlQzhYzoHCjsRJUZse9NvDrnpZdzYkxWo7j7l84XN6gNsD6DxGRKCS+JBTXM7WEOp+rV+YPk9vR/7CA/HOHbyhn3iDiOASuX8pGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PBkJMvxI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PBkJMvxI"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 645366034C;
	Wed,  4 Mar 2026 22:27:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772659667;
	bh=g/MEdPmEoeWbHEJ9LIOvPo0bFSjkMYv54FYTIKY4j18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBkJMvxIQEdFp76/Q1Uzgb9reBH8jQC4B26LVVJ433p1aB0p8piWoZAlGZUfuMhlU
	 VNOgAsIaT19XgwNTk4/LexHtHvKMcAwkCn/HXs/4/Qbl5BYh+DlsfOUg328/MnEJxC
	 z4ypRqtH5b48RfXgWUCEmtgUjn48z55Ar2lU6X4djlsWT0GK29detVmo6FXhVk4bHy
	 /jwwMFB5IF35wJtTPzkgRjCeFLIb9B5MTMfx4OACsHBZtME5NY/e6ZKQr5yTGUGL6o
	 xzuK4PdjlfsRSYIP40DpOdOyeLN2YHCG9O1eIeuHT0iYTufLsBvh6Y8QHiuLbedRrl
	 d8o4ij93kihLA==
Date: Wed, 4 Mar 2026 22:27:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Chris Arges <carges@cloudflare.com>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lwn@lwn.net,
	jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aaij0XAgYRN40QdD@chamomile>
References: <aahw_h5DdmYZeeqw@20HS2G4>
 <aaijcrM5Ke5-Zabx@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaijcrM5Ke5-Zabx@chamomile>

Resending, your Reply-To: is botched.

-o-

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
