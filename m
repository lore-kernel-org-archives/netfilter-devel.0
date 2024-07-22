Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034D644C9B
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2024 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721684053; cv=none; b=BdJFZQ13g04POmsC9TqtZI3MrRZcRI0qI9qEJOqHtgc2wijFeOThI3QDPznq55fLgPDHY4r+tJftOR1RfYsyTiClcW/UDCHSlPDjZkACyVmoSFVOYoY6PLhr+BXdVEugrrMR7WUpiQfnm3p3Gbw8/fXOb91llv7hGCLySOyYKwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721684053; c=relaxed/simple;
	bh=SUq26pd9VNw39bjsKWmbzCxmT6stVAGtYg5MHJQnvSM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dj5Y4maFNF19AjJ+nGBRt9AHGtRqyViFmCB/Ui9pUnzQWIqm32JbWRuSvJ4HW/avG9w2YNSPkXPtgPpp6vKut8CWh6VnoKHN2KTvFoTGZ/Ad9/fwx+IAKgkStneb/5EN/YuB5n4fS/8E1zbPLopC4SPz4ZRPSu4z6i6+fGPL/DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.212.173] (port=7556 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sW0fT-00HHsA-T4; Mon, 22 Jul 2024 23:34:06 +0200
Date: Mon, 22 Jul 2024 23:34:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp7QSXcMHt9a8Hm7@calendula>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zp7FqL_YK3p_dQ8B@egarver-mac>
X-Spam-Score: -1.9 (-)

On Mon, Jul 22, 2024 at 04:48:40PM -0400, Eric Garver wrote:
> On Tue, May 28, 2024 at 05:28:17PM +0200, Pablo Neira Ayuso wrote:
> > Cache tracking has improved over time by incrementally adding/deleting
> > objects when evaluating commands that are going to be sent to the kernel.
> > 
> > nft_cache_is_complete() already checks that the cache contains objects
> > that are required to handle this batch of commands by comparing cache
> > flags.
> > 
> > Infer from the current generation ID if no other transaction has
> > invalidated the existing cache, this allows to skip unnecessary cache
> > flush then refill situations which slow down incremental updates.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: no changes
> 
> Hi Pablo,
> 
> This patch introduced a regression with the index keyword. It seems to
> be triggered by adding a rule with "insert", then referencing the new
> rule with by "add"-ing another rule using index.
> 
> https://github.com/firewalld/firewalld/issues/1366#issuecomment-2243772215

I can reproduce it:

# nft -i
nft> add table inet foo
nft> add chain inet foo bar { type filter hook input priority filter; }
nft> add rule inet foo bar accept
nft> insert rule inet foo bar index 0 accept
nft> add rule inet foo bar index 0 accept
Error: Could not process rule: No such file or directory
add rule inet foo bar index 0 accept
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cache woes. Maybe a bug in

commit e5382c0d08e3c6d8246afa95b7380f0d6b8c1826
Author: Phil Sutter <phil@nwl.cc>
Date:   Fri Jun 7 19:21:21 2019 +0200

    src: Support intra-transaction rule references

that uncover now that cache is not flushed and sync with kernel so often?
