Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853D47607C;
	Thu,  8 Oct 2026 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791450311; cv=none; b=paZZwko/an8sE744qO95jAoWIBy6xPJetU8xjoHyHEUUqONZ7J8yixo2W9HYvDUj+UhnMrSgA3h2cXuqC4ldo2yKR2EHDjF7cRDgDwUKMEyq967mwZKUaJo/fXc6aHJukRmtFbco0v5iAkF68/k/tMjI4uP83wQ/OxK6xYNdRbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791450311; c=relaxed/simple;
	bh=o846A3aEfYjIYwhhrtrqA4K6bTUGVTLzyn2skpbqSVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8djUP3QaeTQlpUc/pkMaZa0RlgcuaGaPLvhGiiDeU1a0+5MYGogVCsjQ2GYUXbvS/M0ew6RkTDXi/MRMo9xa7KdpOV2T6xr2DvCTOsQbY5tm9lwSOPesR8YQdlBKICX1OhOLjhdEaJglMvyJce4LiJQweuvN6CjLEQ9bWfVLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EE279602F5; Thu, 08 Oct 2026 11:05:05 +0200 (CEST)
Date: Thu, 8 Oct 2026 11:05:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Bui Viet Dung <dungvn2345@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_pipapo: skip transaction elements
 during GC
Message-ID: <asdcwQRmKVA6rVyZ@strlen.de>
References: <20261007182057.332512-1-dungvn2345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007182057.332512-1-dungvn2345@gmail.com>

Bui Viet Dung <dungvn2345@gmail.com> wrote:
> Since nft_set_commit_update() runs set commit callbacks before processing
> NEWSETELEM transactions, pipapo_gc_scan() can observe elements added by
> the transaction being committed.
> 
> The scan evaluates elements in priv->clone without checking the element's
> transaction state. Expired elements are deactivated, dropped from
> priv->clone, and queued for GC reclaim via pipapo_gc_queue().
> 
> When the transaction loop in nf_tables_commit() subsequently processes
> NFT_MSG_NEWSETELEM, it calls nft_setelem_activate() on an element pointer
> that has already been handed off to GC reclaim, causing a
> slab-use-after-free.

Can you send a reproducer?  I don't understand how we can add
already-expired elements, it should not be permitted?
