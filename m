Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7512928466A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748434506; cv=none; b=GO6QfA9hN+v+LyLyUqHmZaEdrrdS+qTyGiVuaMbf6mAiPWrgaHBL1Zzo6BgjyWkMTUfLo3ObhmiRSQXIpSHmW/9HzSuqXdpmJr5OthdSgFMaSps5KHCwoMdElOHLzaYyUWj1BftivQjzA8Xq9LsiyzeBcEWq1c4g8CT9ShG2miI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748434506; c=relaxed/simple;
	bh=8Oh7wttdz0IAX4siBSTE01B6Lf72fZU8VuOSvU2fL6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlO191BMgBYXwjblscnbnWExaRr6eky64u9WVrRWqmOEwFBJD915wYS0RBs+9v+lpg6/viMKC/llUj+9zovSsVMMkM8gXEkiUeT2zA+qyD0Jvjv4rSKYkR4ObX2Q4h96J48KO2hH+VNX1UQbMEzT3yH6AQ8pcp7ZkfHpNCu10Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4811F603EF; Wed, 28 May 2025 14:15:02 +0200 (CEST)
Date: Wed, 28 May 2025 14:14:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDb-G3_W6Ep19Zjp@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de>
 <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>

Yafang Shao <laoar.shao@gmail.com> wrote:
> > And I don't see how you can encounter a DNS reply before at least one
> > request has been committed to the table -- i.e., the conntrack being
> > confirmed here should not exist -- the packet should have been picked up
> > as a reply packet.
> 
> We've been able to consistently reproduce this behavior. Would you
> have any recommended debugging approaches we could try?

Can you figure out why nf_ct_resolve_clash_harder() doesn't handle the
clash?

AFAIU reply tuple is identical while original isn't.  It would be good
to confirm.  If they were the same, I'd have expected
nf_ct_resolve_clash_harder() to merge the conntracks (nf_ct_can_merge()
branch in __nf_ct_resolve_clash).

Could you also dump/show the origin and reply tuples for the existing
entry and the clashing (new) entry?
