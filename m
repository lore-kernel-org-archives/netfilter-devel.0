Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2761A9FA4;
	Tue, 10 Feb 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737391; cv=none; b=EANHjafCGrAESAL80H3MwWutzhOMOm5WBs9F7SjyFURWO8XxfSio8hepK7VUyISEyYTqUH7OMctZIcMLC2KuQNOe9R78yykVaeIcJdN4AHK6E5Sr2kpx6pm4+bOw7X2S5cSOqYhTycjeqz5bh44KXsFzHf+7nnMsdToWhVqTmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737391; c=relaxed/simple;
	bh=2u7CQPT9HkKVz1Qpc+KJOgRSMENckq4Uv951efvx+II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vzh88vaBf/fYySpitl1k1OCADMA+bn5SRvJ2WAobc431onRCf0/b05mQtq3IwHWhYe/eyNMcI9YK4wuf3qnCUY3/eOfaxMhEu3zDhFKSKYCNaYwqNIhXv9oCNMweWXpXgOMzRij/ejSzcOyAXLFSdUiL8LSTlih4JouJAxTiiOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 12D326063D; Tue, 10 Feb 2026 16:29:41 +0100 (CET)
Date: Tue, 10 Feb 2026 16:29:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v2 net-next 11/11] netfilter: nft_set_rbtree: validate
 open interval overlap
Message-ID: <aYtO3gzm0nRSR91a@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
 <20260206153048.17570-12-fw@strlen.de>
 <4d02b8fc-ac17-4fd7-a9dd-bff35c3719e4@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d02b8fc-ac17-4fd7-a9dd-bff35c3719e4@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> On 2/6/26 4:30 PM, Florian Westphal wrote:
> > @@ -515,6 +553,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
> >  	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
> >  		return -ENOTEMPTY;
> >  
> > +	/* - start element overlaps an open interval but end element is new:
> > +	 *   partial overlap, reported as -ENOEMPTY.
> 
> AI noticed a typo above, should be: -ENOTEMPTY.
> 
> Given the timeline, a repost will land into the next cycle. I guess it's
> better to merge this as-is and eventually follow-up later.

Thanks.  Comments are for humans not machines so I think its fine.

That said, I will try to set up some form of AI code review here for
future MRs.
