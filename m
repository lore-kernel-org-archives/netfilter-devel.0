Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A497136673
	for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2024 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686989; cv=none; b=Y8IzgphJPAzL3E2EfLCbGYbJkrV+YvNxXltsCwLZ0gxoa5n7B/J4EYoeVlE7NPlaFtwcf78hZcRuBnmvwzgNfYQ/ldNbPxUmxgWoEsQul57kKElHle/8oWs7fIpy1D559r6afF9y5KGS/kzkYn43vyQza5tlwUalrL0wnI0PDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686989; c=relaxed/simple;
	bh=1IVNyPzVeN7Cldm28omS/DX+GMXpiCP+tcrtZA0ohRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KED52Cg+ItyColzPiQf5pxxEn+wXAT+gboNlwNkTrRqdpJS7DIwWQT8e7C+fSrypO1FjgETLBY6tyiPg2K33oJfSIWML0Ht11COhNH64YFADzNgnrzQjlkADbt8TRNjt3AErDvBU/3PTHzZn9j8UeDh8DQsygEDkQerX4qOR/Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6qYj-0000rH-Ow; Tue, 14 May 2024 13:43:05 +0200
Date: Tue, 14 May 2024 13:43:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix rcu splat on program
 exit
Message-ID: <20240514114305.GA2005@breakpoint.cc>
References: <20240514103133.2784-1-fw@strlen.de>
 <ZkNMYQ1u2zJhlviL@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkNMYQ1u2zJhlviL@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  Due to MR cloed this patch is actually vs nf-next tree.
> >  It will also conflict with the pending sctp checksum patch
> >  from Antonio Ojea (nft_queue.sh), I can resend if needed once
> >  Antonios patch is applied (conflict resulution is simple: use
> >  both changes).
> 
> I can route this through nf.git and deal with conflict resolution if
> you prefer it that way.

Yes, I think thats best, but if its too much hassle I can resend
once nf.git has been updated with post-merge net tree.

Its not an urgent fix in any case.
