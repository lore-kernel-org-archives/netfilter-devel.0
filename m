Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6ED191F66;
	Thu, 27 Nov 2025 21:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764280273; cv=none; b=ow41VEZ+FXxagDihXSSD38qQY39KkkWy7rzmawMIU4fib8PUNTchi+pSt7OVR4/aP7lAncXKrc67pC2soxwefhVskV6BhJ6Xic+F2Avg7ww3iwDv7pV5US8kIJxgpcZgYoLn/mSdjWkuDWL+346A3YvArK7ajWtm+2w5Hhko8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764280273; c=relaxed/simple;
	bh=W/kabGlylqx9n5kVhQ1TI8IjFCAXVFbhiiSn2q42TNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CWXMw3IUekR5iOTEWOijWhSoqCLscbk6TzIj04dfgf7pLzJk/ArQLTtTyTmVxHI0PGw7BHraMk9JyvhQ7htpEir0oPWz1A97Hs/AegbNsjHKozCzLgFc8zuVjpM1Bh8suhbzkhxWRX7qeWZKpkN8uLC37PQwj++BsQ8+aDtf1Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 063FB6042D; Thu, 27 Nov 2025 22:51:07 +0100 (CET)
Date: Thu, 27 Nov 2025 22:51:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	horms@kernel.org
Subject: Re: [PATCH net-next,v2 00/16] Netfilter updates for net-next
Message-ID: <aSjHx34ENi4THN56@strlen.de>
References: <20251126205611.1284486-1-pablo@netfilter.org>
 <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>
 <fb6e4953-a706-49e5-9026-3cc190414984@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb6e4953-a706-49e5-9026-3cc190414984@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Patch 12 - I think that should be fine, nf_conncount_tree_skb() which 
> calls count_tree() should called with RCU read lock. This patch didn't 
> modify that behavior.

It would be better to add a READ_ONCE() however, since there can be
a concurrent update.

Not caused by your patch, so future fixup is fine.

> Patch 13 - as we are holding the commit mutex I thought that it wasn't 
> needed. Anyway, if that is needed, there are other places where we have 
> similar issues that would require a fix too. I can follow up on nf tree.

It would be better to add WRITE_ONCE() for both, given we could also be
interrupted on same cpu here.

Yes, the various .update callbacks have similar problematic patterns,
they all should be fixed up if possible.
