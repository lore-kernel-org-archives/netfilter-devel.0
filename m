Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F1B242D84;
	Tue,  8 Sep 2026 05:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788845416; cv=none; b=kJJ95x/vpj1Pvhnso2FTPCCsSdtO+2idcy/26EpYBX0f+k9ctACT2iRwyeTxwa3xLpE8sYS9yZKmi41/Qd/95G30+38zNkMaehfQ0J1hXMZ+ICu/1mhDphec+WGlvxZiiNY0IvrN2YBrYiHcITSMNy68B7nbRuh4W9zCMmn40gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788845416; c=relaxed/simple;
	bh=vsUv/m6hbvGfGaNk1NXnzkD4XIRMhgLdRUVY/qAB5SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bezAcVVRlHi6tAqgeq8VuH5idtuqRVZ2MKWawkvuuqMZ9m1CYLGHWV/PQjaqXKLTDnNOdKoEITwiY9O+lpasTx/D05xlV6h7It9c0/QDvyc12YSAaCXDgwtSJfXRyudeUvV05oxyjQD9AeIbjySS8SD/pzi80zsL0t+NZHY+d18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 315876025B; Tue, 08 Sep 2026 07:30:11 +0200 (CEST)
Date: Tue, 8 Sep 2026 07:30:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <ap-dYotn2QqdTVqf@strlen.de>
References: <20260904185321.30313-2-fw@strlen.de>
 <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap-ZOyOS6j_K5gmZ@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Will be used by upcoming ipset rhashtable conversion.
> > 
> > "walk rht with unlink+free" triggers LLM reject pattern:
> > "possible softirq CPU stall".
> > 
> > "walk rht with unlink+free + cond_resched" triggers
> > "possibly skipped elements".
> > 
> > Add a helper to detach current hash backend storage from the
> > rhashtable, then iterate and flush all contained elements.
> > 
> > Cc: herbert@gondor.apana.org.au
> > Cc: linux-crypto@vger.kernel.org
> > Link: https://sashiko.dev/#/patchset/20260828152256.8759-1-fw%40strlen.de
> > Assisted-by: Claude:claude-sonnet-5
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> > Herbert: If you prefer to take this via the crypto tree, please
> > let me know.
> > Otherwise, an explicit Ack would be appreciated, so this can
> > be handled via nf-next.  Thanks.
> > 
> > net/ipv6/ila/ could be converted to use this helper too.
> > 
> > include/linux/rhashtable.h |  19 ++++++
> > lib/rhashtable.c           | 127 +++++++++++++++++++++++++++++++++++++
> > 2 files changed, 146 insertions(+)
> 
> Sorry I wasn't paying attention.
> 
> So is the problem that there is no way to remove all elements for
> a given key in an rhltable?

No.  The problem is that I am too dumb to remove them without having
an LLM tell me to go fuck myself.

> If that is what's needed then we should just add it for rhltable
> since normal rhashtable's do not contain duplicate objects for a
> given key.

I don't understand this response.  This isn't about rhashtable vs.
rhltable.  This is about my incompetence to flush an rhashtable or
rhashtable.  Simple version:

        rhashtable_walk_enter();
        rhashtable_walk_start();

        while ((he = rhashtable_walk_next())) {
                if (IS_ERR(he)) {
                        if (PTR_ERR(he) != -EAGAIN) { ..  break; }
                        continue;
                }

		rhashtable_remove_fast()
		/* free */
        }

        rhashtable_walk_stop();
        rhashtable_walk_exit();

... tells that this causes softirq lockup for huge tables.

Adding a lock-break after N elements via
if (flushed > 64) {
	rhashtable_walk_stop();
	cond_resched();
	rhashtable_walk_start();
}

... tells that this will skip some elements.


... Full restart on atomic_read(->nelems) > 0 post loop
seems wrong to me too.

So, to get out of this I tried to add a 'flush all elements' helper to
the core that just replaces backend storage.

Does adding such a helper make sense or not?  Thats the only question
here.  If yes, I'll make a v2. If no, I will go back to V1.  Unless you
have a better idea.
