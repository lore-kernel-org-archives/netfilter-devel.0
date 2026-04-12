Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0C43147;
	Sun, 12 Apr 2026 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776033116; cv=none; b=EjhG/8NCqWdiCXrk2l4Djn0c44FD7XYmtlv/HiiiNOetK9GaI/kyyBa9snOrQaDQ2P9q7y1HpAOywsELuw95HO/EDfS2FuZAE3k+fQH2udS9ofGppjDO3k9ej6Mc8PQc0kyBpHXDntXQ6eypyZmxJqTnR6t9mst7q6LCGzq/uHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776033116; c=relaxed/simple;
	bh=VQ0E2CPHBAKyPinm9SCfzHRTKJ0Or0lZ8hhPAVGSE4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUaxzral1olVn2uwJejoaMq2YCiwZE9S6vJpjRpwn9j8Jgd5W/XtdLgAG7YYMpQRYzxShHvHR/1Vl7rOULDzA+Kvg0XGo7d/KP1bS0d8YMRl8ACJnB+EW+GT+CHQuM0wYcyjhuLT1Y4610h7K9rlvp/IHxm1LEnJtGqOO2bDgI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E057F60491; Mon, 13 Apr 2026 00:31:51 +0200 (CEST)
Date: Mon, 13 Apr 2026 00:31:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Marko Jevtic <marko.jevtic@codereflect.io>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, phil@nwl.cc,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: nft_set_rbtree: fix use count leak on
 transaction abort
Message-ID: <adwdV0qGeRhSNLuz@strlen.de>
References: <20260412222801.34965-1-marko.jevtic@codereflect.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412222801.34965-1-marko.jevtic@codereflect.io>

Marko Jevtic <marko.jevtic@codereflect.io> wrote:
> nft_rbtree_abort() does not handle elements moved to the expired list
> by inline GC during __nft_rbtree_insert(). When inline GC encounters
> expired elements during overlap detection, it calls
> nft_rbtree_gc_elem_move() which deactivates element data (decrementing
> chain/object use counts), removes the element from the rbtree, and
> queues it for deferred freeing. On commit, these elements are freed
> via nft_rbtree_gc_queue(). On abort, however, the expired list is
> ignored entirely.
> 
> This leaves use counts permanently decremented after abort.

I have not seen a reason/answer why this needs to be rolled back.
GC is an implementation detail, its not part of the transaction.

It could also be done from work queue, for example, not just from insert
or commit.

I see no reason to change the existing approach.
