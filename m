Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193823EAC79;
	Tue, 10 Mar 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146902; cv=none; b=Zes1Pgf3W7hBL7urhSYnfvlBbZSEa1L9MoXVz6fyoa20ZmdlszPGzMlzmWlxOjgO+pKTCFf8M2yWuRK/9aqBOvj0NdVgMIBv2maVBG6RU7Lww28zYmo2RZTghE+GyAUxWaTYbK5cglC3XKIQV1uykJR4x31Ho4Kdgd1Zi9fSMuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146902; c=relaxed/simple;
	bh=qNGGCa7zSLy60uRtB/BOsU5umBjyfHQuZsyfQ9l4IHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CI0eqINuxZyjd0JTy4HzkYGFoaY+uoRC2U0Ff8q+l3P7Cnb0mQcxY63b+CK2Md8ziAjQzeHJpA8KUxnBQxJG8gwXvxHYMj2TIgvqrjo6iC8MZOUnsp+cWv2k2v+E2ojZNu/fS2bWWbrKUxgBCl+QR7CpECize30WaWUHdiaN3DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DB8D46052A; Tue, 10 Mar 2026 13:48:18 +0100 (CET)
Date: Tue, 10 Mar 2026 13:48:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <abATEzuA5yD5lAFQ@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
 <aa_4w9gXCkzQ06Nk@chamomile>
 <abAPlfmkO7gr142k@strlen.de>
 <abARZGTs_eP6yDu4@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abARZGTs_eP6yDu4@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Are sure that adding refcount bump is the way to go?

No, but I don't have a better idea at this time.

The obvious alternative is to grab a reference at expectation
creation time.

But this would pin the creating conntrack in memory.
In some cases, this will pin it forever, even if someone
runs 'conntrack -F/conntrack -D' to delete it if a helper
creates a forever-expectation.

> # git grep "nfct_help(exp->master)" net/netfilter/
> net/netfilter/nf_conntrack_expect.c:    struct nf_conn_help *master_help = nfct_help(exp->master);
> net/netfilter/nf_conntrack_expect.c:    struct nf_conn_help *master_help = nfct_help(exp->master);
> net/netfilter/nf_conntrack_helper.c:    struct nf_conn_help *help = nfct_help(exp->master);
> net/netfilter/nf_conntrack_netlink.c:   m_help = nfct_help(exp->master);
> net/netfilter/nf_conntrack_sip.c:                   nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
> 
> These callsites need auditing.

Yes, but I don't have infinite time.  I am almost working non-stop
since these things got reported.
I cannot accelerate things any further.

> Yes, I just wonder if this can be fixed without adding checks
> everywhere in the code, I would need a bit more time too.

Another option is to stop releasing exp area with kfree()
and move back to kfree_rcu.  But still, I fear thats not enough.

What if we're releasing the master conntrack (refcount already 0)
and we're in object reuse scenario?

Then, master->ext can be krealloc'd in parallel.

TL;DR: I see no alternative to these refcount dances ATM and I also
think we need to add confirmed-bit check.

I hope I can condense this later with some new helper function that
can be used so we avoid open-coding this.

If you think that its better to yank these fixes and do the slow
audit, then fine, but I don't have any evidence that its a better
approach compared to incremental fixups.
