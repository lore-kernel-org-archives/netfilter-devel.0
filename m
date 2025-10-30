Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEA129C33F
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 11:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761822506; cv=none; b=OlANmGb4k6uC6IJZ8HNhXMDUhgI/Z7jUMcOTZhyE/mrwRtjXNotIaITwxH8oKnRtckUc3ts0puuVcVYAvUfO+2SjsFis/pTdipKyhGxmZIIqUPlzK+O3wVawJg/dTygkGqTJnkqRo+emO6+nt8sBM+ckbkM6FnbtW32Axbqs99k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761822506; c=relaxed/simple;
	bh=dpQf+w+6jmv/OG9TevLIImYMvWgvljUixLzyhHhcJN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dj0C2cFvELVsLHw8xsLDEk2wDyqQMvneeaMu/X93L6NzQKh3okoKsU+8Bp5MV/ziF2RdTU/St+6SWulMuvGuI591ORy++iaz3vNZszLYijHu6sy/Z6yEDYnV0BXdDadfo3QMFC+sSF7BhzmQmPRr+ZLLwfMBS6o/luQ+hRa4CFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O0plCg3S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O0plCg3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aZ8i/V5U1tCOWYRxmqPOETQ+p5UwHU68ifbfklGDIyY=; b=O0plCg3SCjOPoBJgG7goRAlldA
	h5Ar7n1V3leg+2bLSoCuOJxjFBiUADR4/RI2/k+4V6xlk94h1jy9CRDcjZmPL2zJanLrKSEqeIcEU
	nor+ImJaWamkLacpFRFaoig70Ta8ykOqmaEBhr+B/TbfJg5NjLY4PpD0zasra8YW+X+4/vlZ/8hIs
	C7Z7wvfbi3+RIf0x5tlHxTTRaDgPK/x44JyyY5hk0FZXf+DmUS0d86wThEu5U3lXRZJ1r7B5Q/0pu
	w1z1faIwkq1vMCa45jOBPUWvYaXOn6LnpwD+TYwU3yNOUUfbcpEGwjtg+K5eYZY8mHb/fteBCPcL0
	hg1T2iQg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEQVy-000000004YE-3Lyf;
	Thu, 30 Oct 2025 12:08:22 +0100
Date: Thu, 30 Oct 2025 12:08:22 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 12/28] netlink: Zero nft_data_linearize objects when
 populating
Message-ID: <aQNHJhDYPIqPMXh5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-13-phil@nwl.cc>
 <aQJe44ks8cDYQcBC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJe44ks8cDYQcBC@calendula>

On Wed, Oct 29, 2025 at 07:37:23PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:01PM +0200, Phil Sutter wrote:
> > Callers of netlink_gen_{key,data}() pass an uninitialized auto-variable,
> > avoid misinterpreting garbage in fields "left blank".
> 
> Is this a safety improvement or fixing something you have observed?

Patches 19 and 20 add fields to struct nft_data_linearize ('byteorder'
and 'sizes'). Having these memset() calls in place allows for setting
(bits in) these fields only if needed, default value becomes zero when
it was random before.

One could avoid it by making sure the new fields 'byteorder' and 'sizes'
are fully initialized by called functions. Are you concerned about the
performance impact?

Cheers, Phil
