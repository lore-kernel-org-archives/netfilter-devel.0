Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6503367B77;
	Tue,  8 Sep 2026 09:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861380; cv=none; b=UsyIQN+ehTUCzUdD2zNSU6RdJictAjaURdOkUS/0S6frESPKid1k6OQG80BtIZbbDZ8i5XwU2Sj1xR2SOfbNk8oHKg5jak8nrv9kj1h3SvhgCF+Ry+3YM/pGrMWUO8ZRPfrGhNX6z4zY9yRMXnU00PyQh3T1yCM/ntrWxY6mIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861380; c=relaxed/simple;
	bh=kmVAJWpPn3OjxRB26B2qYZikxz09dpme0e7H2+5JLM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIxZVnUhP//clDYcUuPZ+iZchind0zn+ngn9N2XskQ2IAeQv7PFVB1iJ/ElgIXPPgtiArrxfWtMMLsIkaIAv6IRVCvTSqH7Bwtzrsy+CxEviWBdmOKz5lY81vjB0YcMDBc86xP6UjlHKJSvYHNN8EZ41Xjw5l87BaYIm/zh1GSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C61D560405; Tue, 08 Sep 2026 11:56:09 +0200 (CEST)
Date: Tue, 8 Sep 2026 11:56:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <ap_budC8D-k4k67v@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
 <ap-dYotn2QqdTVqf@strlen.de>
 <ap_PlDqTNOnB0Y83@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_PlDqTNOnB0Y83@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > I don't understand this response.  This isn't about rhashtable vs.
> > rhltable.  This is about my incompetence to flush an rhashtable or
> > rhashtable.  Simple version:
> > 
> >         rhashtable_walk_enter();
> >         rhashtable_walk_start();
> 
> You should never use rhashtable_walk for real work.  It was only ever
> intended for the very limited case of netlink dumping where stability
> or accuracy was not a requirement.
> 
> >         while ((he = rhashtable_walk_next())) {
> >                 if (IS_ERR(he)) {
> >                         if (PTR_ERR(he) != -EAGAIN) { ..  break; }
> >                         continue;
> >                 }
> > 
> > 		rhashtable_remove_fast()
> 
> So you want to free the entire table, right?

No, remove all elements. Concurrent insertion is not disabled.

> We already have rhashtable_free_and_destroy, any reason why it
> doesn't work?

It requires userspace or kernel don't add new elements.

AFAICS I can't "destroy, then re-init" without some external
mutex.  What I could do is add another indirection, i.e.

 struct htype {
-       struct rhashtable ht;   /* the hash table */
+       struct rhashtable *ht;   /* the hash table */
        struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
 };

... and then alloc+init an new ht + free old one.
But its not nice either.
