Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5E423EB4
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210864; cv=none; b=nQEMnAgth8vqh5F+XqQUp795nZUOZFW50lOrLU1xupz57wynOxyMUnfJpJ0EmcNpx8cXkRh1YViOpmm3Uq5u+/EpzosWR4f5i/uFOBymY+ytMLYQ40DDtmRj8SFt3GOr2xNYgyu1EtFr1eD3yg/ZRt0QJWi58bgIHabz/cFXz4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210864; c=relaxed/simple;
	bh=wcotZh8N2xEm6M/cFimuaITCcP1PSbQeggVJ7Ygw3Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzBnMxuduKZMRtDeXvflKWkUTF87VOKhKHuKXiPSCbcd3Gt5hDCaTWnSk1jEgvXpLKsfj3dCu25VoqaSuTs7YjeY5IyO725/b4gO0X7HJBYRfschGXHwRNZBeQBff+mzEkyJQK20UBSO3RVk2F7sTZuzLMMLEdGvM8IdrXKGGe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7602E60337; Thu, 16 Jul 2026 16:07:40 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:07:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 10/12] netfilter: ipset: use correct lockdep
 annotation in ipset_dereference
Message-ID: <aljlrC8ApVJLiGr8@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-11-fw@strlen.de>
 <dd822f91-400e-418a-d148-46c9b489af36@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd822f91-400e-418a-d148-46c9b489af36@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > ip_set_comment_free() is problematic: called from different contexts,
> > some hold set->lock spinlock (safe), some do not hold a lock but have other
> > means of mutual exclusion (e.g., entire set torn down).
> 
> Wouldn't something like the following be sufficient?
> 
> - Add a bool "deleted" element to struct ip_set.
> - The set-specific destroy function would set it true before
>   doing anything else.
> - Then it'd be safe to use

> #define ipset_dereference_locked(p, set)	\
> 	rcu_dereference_protected(p, lockdep_is_held(&set->lock) || \
> 				     set->deleted))

Yes, that would work.  I'll add this to my todo list.

> > Other callers need investigation: ip_set_comment_free() alters
> > set->ext_size in a non-atomic way.  I don't see how this is safe except
> > for "entire set is destroyed" case: parallel usage would be a bug.
> 
> Maybe we should convert ext_size to atomic64_t?

I was wondering that too.  It would be simpler and avoid these
new helpers -> less code churn.
