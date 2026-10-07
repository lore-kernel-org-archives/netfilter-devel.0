Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85C242589D;
	Wed,  7 Oct 2026 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369211; cv=none; b=lHJrFOwG9mLJwNMZ4s/cCH8Edpq9jDQVswQJiUt8dhvNeMFAfUN/frcWFPwklrzGKBgR9eTmgwGW4LOVU6eMl4f3rj/XtKAipaxTLN/i/mvVxPMmpm017zF6IaDadO2L85job0U5CU9tRHYQEXZgDmEiM/oQAm5ZYTC2kEY+uec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369211; c=relaxed/simple;
	bh=Oss9FQselWLXErgny9aGNjfvdLJxM9GTn3sJgeEE2DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBCLK2FupP9MEp/94ZUJb1m30hxcudwqL9+GB1mEijgVns+vfeLfl2K5UVvm5piz2qT3VYuEw9r46vKO51Ld+pPbwjE7nEk+wZ2mzlro7JfCH+Q/ihAaV/jsKTdy69kI+5+nLwK7rxDaSZs5sQmlB7uq9am+7f1KPcyFx69mGPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eguR0bk8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eguR0bk8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791369179;
	bh=1tCyT26DD3gNFqw8L0p1xFXxnJ6kCxscpDlQYUxpprQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eguR0bk8CaqoNFPhya3ITqbYSWuG5BRcg6UM83XYuTRFeDY3NozAa4eH8ByirKpjs
	 fNq1ZGuUNOd630hSbDLl8JqgdAenZD3OmqrJDjdyuy/d7l8g1cvTtvisjZ1F6MiYoj
	 MkgwpIc9U+YeWwvI8penaqAA9i6JG9lyIX5lnNllM/yenuIkwiMzBZK9Dzw+cjv+du
	 RSIHkmZwL46C+7iT8S5NGMwm1HW5V0uhi69iV2yDAcRguo8vV0Ka0FTTL19W7zUvFw
	 LryTQVRsffKlaA5RtsqZyxPqH2dcAC3qK9RPahIGrGdrmIP1GrNqNlhxy4WqqiyZdn
	 e6gUyA/NQqPfg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D33F060058;
	Wed,  7 Oct 2026 12:32:59 +0200 (CEST)
Date: Wed, 7 Oct 2026 12:32:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Daehyeon Ko <4ncienth@gmail.com>, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <asYf2b03D78kWdkZ@chamomile>
References: <20261007014802.2615503-1-4ncienth@gmail.com>
 <asYHaUFdxo0flpAe@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <asYHaUFdxo0flpAe@strlen.de>

On Wed, Oct 07, 2026 at 10:48:48AM +0200, Florian Westphal wrote:
> Daehyeon Ko <4ncienth@gmail.com> wrote:
> > A conntrack holds a reference to its master. Userspace can build an
> > unbounded acyclic chain through ctnetlink. Expectation producers can do the
> > same: an nft ct expectation can attach its helper to an unconfirmed
> > expected child and arm the next expectation with that child as master. The
> > H.323 Q.931 helper can also propagate itself through call-forwarding
> > expectations.
> > 
> > When only child-held references remain, destroying the leaf calls
> > nf_ct_put() on its master. If that was the final reference, nf_ct_put()
> > recurses into nf_ct_destroy(). Repeating this at each level exhausts the
> > task stack and panics.
> > 
> > Nested expectations are existing helper semantics, and CTA_TUPLE_MASTER
> > was introduced for conntrackd state replication. Avoid per-producer
> > restrictions. Decrement the master's refcount directly, then free the
> > current conntrack. If the refcount reached zero, continue destroying the
> > master in the same invocation. This preserves existing constructors while
> > bounding stack use.
> > 
> > Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
> > Cc: stable@vger.kernel.org
> > Link: https://patch.msgid.link/179127347858.434549.11821822167265441355@kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> 
> Acked-by: Florian Westphal <fw@strlen.de>
> 
> That said, ignoring the source of the problem is not good.
> 
> I see no point whatsoever for a expected connection to have a
> non-control connection as its master.

I would prefer if chain length is limited too, ie. tighten this
interface based on the LLM feedback.
