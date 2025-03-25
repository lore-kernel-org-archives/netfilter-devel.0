Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1428C9479
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 10:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742898953; cv=none; b=W+88wH3lnslw8oUDF9pHBO29QM1fQp8VJxYe1pgGi5lf2/Kfh7kwxTzVD2k0JjyHYHntWxsxI645xNWuNPSFNYvFv9Rb7OnYryGkTnjFqjNZBE/M2PN0L091qQZKMDtfHA8DjalaJyYmFH0rrXJQZKpqJBQlbfLtKHNTdR28z+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742898953; c=relaxed/simple;
	bh=gl5XRcZ98x+WhWr9mVu3UZzIb6gIr5nYANsL87UJhSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XS1CMl43STcgnenEAp0I5nskch1SjolAGYrvs2wpDaUS4p1RUYQSsvdS3yaqRADhMRoXsIF5qgWeERH/ak7dQQMk1QfVUTjMnlAO6N7F2WwXNJ8iKen+5pGWsqsKRyblZdZ30mn7OxR5fCGcdUGllwwnzTqy97aXMH/v0SnwyNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tx1dM-0003M3-Sq; Tue, 25 Mar 2025 11:35:48 +0100
Date: Tue, 25 Mar 2025 11:35:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2] nfct: fix counter-reset without hashtable
Message-ID: <20250325103548.GC4481@breakpoint.cc>
References: <ef47491d-5535-466a-a77b-37c04a8b5d43@gmx.de>
 <20250325055651.GA4481@breakpoint.cc>
 <fb5de8d9-f106-4352-907a-461f3323ac88@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb5de8d9-f106-4352-907a-461f3323ac88@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> On 3/25/25 06:56, Florian Westphal wrote:
> > Corubba Smith <corubba@gmx.de> wrote:
> >> The dump_reset_handler will try to update the hashtable regardless of
> >> whether it is used (and thus initialized), which results in a segfault
> >> if it isn't. Instead just short-circuit the handler, and skip any
> >> further result processing because it's not used in this case anyway.
> >> All flow counters in conntrack are reset regardless of the return value
> >> of the handler/callback.
> >
> > How can this happen?
> > constructor_nfct (->start()) will return an error if ct_active table
> > cannot be allocated/is disabled?
> >
> 
> In event mode the hashtable is optional, and sending SIGUSR2 to ulogd will
> call get_ctr_zero().

Thanks, applied the patch with above sentence included in the commit
message.
