Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DD93009E2
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210653; cv=none; b=c7041XsCrVFGM8WYdakcYqGgcLogTvGoMG8yfqxFzgTIoV7ceKjbX56FuEYOlLERQTMzV6jw2se7Yq2Fi9X+lwiKNukWZB957O2b0MX1VzXfNEmo9z9FbAJocsEDD5a6qw/Y1yKoIMThMdhxmIVV9phRhs1Gtw4kIhDe/hkiBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210653; c=relaxed/simple;
	bh=IEqFiQlzsZHZww7S3ALubiK2oBsuxC/BdH08zxhDibY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boA5Ue4QnYXGxGyMzgqpVx82yzqsnkMUmBIkcJaYpLQ6NqzIG/SPpDwfDLgVfm3XxDkGbQmKXOFa3EF36brUBQv3O3DjddCIyb05FRU2M0NjXDBbq+Mte4eeWbprdpS8EiLJ5ETACOxedE0ELk0hHnsSTy85StCK6jEcrp3dSdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E009B6058F; Thu, 16 Jul 2026 16:04:08 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:04:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 08/12] netfilter: ipset: replace internal
 hash table with rhashtable
Message-ID: <aljk2Hwp-kPtOhGW@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-9-fw@strlen.de>
 <2d64a463-286c-f640-b57c-97eb5a650143@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d64a463-286c-f640-b57c-97eb5a650143@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> >   This adds full set->lock serialization, meaning no parallel
> >   insertion for elements with comment extension.
> 
> The comment extension is restricted to add from userspace which is
> serialized by the mutex anyway.

Ah.  I was worried wrt. FORCEADD and the like evicting this and
messing the counter up.

I will look at this again, maybe this accounting can be switched
to atomic_add/sub to avoid the lock.

> > 	struct net_prefixes __rcu *rnets[IPSET_NET_COUNT]; /* cidr prefixes */
> > 	struct htable_gc gc;	/* gc workqueue */
> > -	u32 maxelem;		/* max elements in the hash */
> > -	u32 initval;		/* random jhash init value */
> 
> Please do not remove initval: the sole reason to keep it is to maintain full
> userspace compatibility. The "ipset" tool supports to specify initval and
> when listing/saving a set, initval is included in the output. Already
> existing setups may specify the value and we must be able to return it.

Fair, I will keep it to dump the value back to userspace.

> > +			pr_warn("Set %s is full, maxelem %u reached\n",
> > +				set->name, h->maxelem);
> > +		mtype_data_next(&h->next, d);
> 
> Why the mtype_data_next() call is needed here?

It's not, merge gone wrong during rebase :-/
Plan was this:

Call mtype_data_next under if (0) guard so compiler does not
complain.

Then figure out if we can remove it together with .resize callback.
But I forgot about that which is why its not mentioned in the commit
message.

Is that feasible?  (removal I mean).

> > -	if (tb[IPSET_ATTR_INITVAL])
> > -		h->initval = ntohl(nla_get_be32(tb[IPSET_ATTR_INITVAL]));
> > -	else
> > -		get_random_bytes(&h->initval, sizeof(h->initval));
> 
> When initval restored, the else branch is still not needed anymore.

Ok, thanks Jozsef, I was about to ask.  I restored the h->initval =
line.
