Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0312C190
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824393; cv=none; b=d3AA3coLiApyODTo/Qy7dNJWr+w9aVS6TITc3N6wcIzK+oEzVEvly5Cy/od1ytnW0JzpTvv0QnSZWUL6h+88fKbVGfbceOlxZb4em2gvmCvcbiBQNRGG5S+tBeRPv4pe6WMKcPPc/ANh2yZybaW+JhoTEHva/LwsFawZc+MXvZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824393; c=relaxed/simple;
	bh=Cyv9tDd7sTlGalDvcO+2rB0qtBkrtxY1wssxjdNbXl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6suAeW6RqXrB6/TgnnehOXl7BVc0BBUeEAXWZhnUbvYTgrLVoGZNbJWKf+OwGgIiTrOkNZLtHHLcu8ZIbcXhOy2jT5HNgHK1jxArMgvRb0yERUVAXIJdUmIVkCKWHscG/PTgN6TjDeSQFvQ2drC09lF5oZlK+g9sFt0ZhYu5oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8MUO-0002YF-Ox; Tue, 05 Nov 2024 17:33:08 +0100
Date: Tue, 5 Nov 2024 17:33:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241105163308.GA9779@breakpoint.cc>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZypHs3XO4J2QKGJ-@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > It will help for SEEN_REPLY.  But I don't see how it will avoid this
> > patch.
> 
> Not current time from ctnetlink, but use the ecache extension to store
> the timestamp when the conntrack is allocated, ecache is already
> initialized from init_conntrack() path.

OK, so we do ktime_get_real() twice.
I think its way worse than this proposal, but okay.

I'll work on this.
