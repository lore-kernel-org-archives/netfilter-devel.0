Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A5441F7E0
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784206815; cv=none; b=u7XhtjyL9frgvUVHe5tlpUgRNPu3bI0TXjWcQbqTjBNYbCQXGOhxkV/IVo06+g7Z1uCzXRqA5olu+6efTlS5JZTT/TfPL9EgL60dDtAEQFsGHk/2bdZYMn4/YVjt6Bn3Hetassz26zxStlCqwWbz0//bplAMwak/yYvoRn7a0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784206815; c=relaxed/simple;
	bh=CFUzdWPnd1NXu6zYNQ7xEEJuF/VT+EJX68Oza7BACvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuoZDBoSAnCRBnHDZnRmlATWfecEBKuOFUsRkCeZCkojtDwdqIHHRRV3H+fzoUfK7QBTgtVZHNRQhDsSqcDPiymn7DSdATXzCTkOQCp1hNkoKj5Q3xMRpYMQmV/8MRdFSBGN21K94aY0LmRZfge8SFGlAjK5xFXBnhWuWE2jCiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D43D36058F; Thu, 16 Jul 2026 15:00:09 +0200 (CEST)
Date: Thu, 16 Jul 2026 15:00:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 07/12] netfilter: ipset: add rhashtable
 boilerplate stubs
Message-ID: <aljV2QI-2gGBQpb7@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-8-fw@strlen.de>
 <8c03ba3c-f438-3dc4-f01b-f536c4c79217@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c03ba3c-f438-3dc4-f01b-f536c4c79217@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > Preparation patch.  Adds an rhashtable to the set and initialised
> > and destroys it.  No elements are ever added to this hashtable.
> > 
> > This change is supposed to be devoid of side effects and is
> > separate to reduce size of the conversion patch.
> > +/* 0 = key matches object (equal), non-zero = not equal */
> > +static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
> > +{
> > +	const struct mtype_rht_elem *e = obj;
> > +	u32 multi = 0;
> > +
> > +	return !mtype_data_equal(&e->elem,
> > +				 (const struct mtype_elem *)arg->key, &multi);
> > +}
> 
> It does not belong to this patch, but the "multi" arg of mtype_data_equal()
> is needed only for the netiface type: it supports the same ip/cidr behind
> multiple interfaces but the element can store a single interface only. The
> "multi" flag made possible to take into account multiple interfaces properly
> when growing the array in the hash.

Thanks for providing context, Jozsef.

> The interfaces should be stored in a linked list at element level and the
> "multi" arg of mtype_data_equal() can be removed, which is not needed in
> rhashtable anyway.

Great, I will do this in next version.  This should make things much
simpler.
