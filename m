Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCD078F29
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 18:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741804123; cv=none; b=T/CoBBL9oABTni1x/1sbU3pRhIzrmWsd+PFP90Xkyntfuuf+7Ye4RkiteiCVOKlJ9G7tiHg8eGIkYYBLrwfpo9lk++wpwMxjZkvm+Jt6bfycHtUh5rKPFbj0ffwaq/8YLpb5XYsXlJd2l+oWVzimi4oUNPDUeIk6gJlny/my30Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741804123; c=relaxed/simple;
	bh=aoPuRyFNr9hISECHH2MM0JMUxX/JiNMq92HRcboItdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MN1XTP3uuMXcQ/7WNykTo6VaYGmCStOn8ZtsdOJQHhkckUH0XKPObXYcZYr3qIBWgF77CGS7iwk/M38md1J9VgbhSMot7VzvGaRYpH/5GOOh48UIm3p38e64oI/JR/8mkMIK8Us/HVwd9i0YVVw5g97uUyXk2/JLeJggGH15gTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsQoo-0000sP-HD; Wed, 12 Mar 2025 19:28:38 +0100
Date: Wed, 12 Mar 2025 19:28:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: speed up reads from
 nf_conntrack proc file
Message-ID: <20250312182838.GB3007@breakpoint.cc>
References: <20250211130313.31433-1-fw@strlen.de>
 <Z9G8TcHOTdn7LBsj@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9G8TcHOTdn7LBsj@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > -	struct ct_iter_state *st = seq->private;
> > +		hlist_nulls_for_each_entry(h, n, &st->hash[i], hnnode) {
> 
>                 hlist_nulls_for_each_entry_rcu ?

Yes.

> > -		if (likely(get_nulls_value(head) == st->bucket)) {
> > -			if (++st->bucket >= st->htable_size)
> > -				return NULL;
> > +			++skip;
> >  		}
> > -		head = rcu_dereference(
> > -			hlist_nulls_first_rcu(&st->hash[st->bucket]));
> 
> This does not rewind if get_nulls_value(head) != st->bucket),
> not needed anymore?

There are only two choices:
1. rewind and (possibly) dump entries more than once
2. skip to next and miss an entry

I'm not sure whats worse/better.
