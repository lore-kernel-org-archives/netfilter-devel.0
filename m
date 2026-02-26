Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9711A3164;
	Thu, 26 Feb 2026 03:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077491; cv=none; b=pa+9PMey2gfw2T6MewSr8gJ+BoGfWVcsqe9YaRml7wO4IQHoHL1jjFqRigA3a6wNoc6dKRktBwCz6DoivlAmX6DDX8Zg7STgsETXjkTwPxT7inRA6dYRNRgbsC5X2+8d4eux5O9WVujhVzAeKqPbFO3wG6X8HtMSZV4dMNWEA8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077491; c=relaxed/simple;
	bh=jdQ4TlTnvlE66MsCiRDSlmmGWeSt5nVcvT0Y6fdtRyA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUT/SPi1XMPzTucRX4dZNv5XhQxF92Fytx6ux+6NzN30zQ30yB8Pv47YFRfzO53Z4qsuNM/VhDzbTtYlkljHsedOiEavjHiiIotr6A3EhST6/hFPbsA6UO96SJLTkGnuHvqZVVRp3kdnaEBoWjCx3HUIRr/lSTK4rNK7Z75mKyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/PUb+sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/PUb+sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E83C116C6;
	Thu, 26 Feb 2026 03:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772077490;
	bh=jdQ4TlTnvlE66MsCiRDSlmmGWeSt5nVcvT0Y6fdtRyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c/PUb+smhA2x0Cyyo1IRI6RY7t94X9rr0GCoOV5Q5k0sq3jvxGG64yngdjLNd1+7q
	 hLo7h80xIJw2nfH8gT2LRCEAD+gVruth+g0Ty5tXWsEG5P8zDxuEf8lo3E++/r9wzg
	 KMjJ14+DG30Ka2VCDy02/VphwMqxQG7lnpJwyPMt8RRR6IYY3Q1pBHqnhwMoKekFm+
	 o2M3GMnhAX0Ga8nCoiWWmYYIFan7aYzV+BYWrfMOenfUVt1h7+DdGKKs+tiA+4VV04
	 T8PqSL2X8Is+aTNsxpNMuLxoJ7XzeCSnBlyc20ck8ewRrSmlBqpQbj8IybBee6zboG
	 SjnRdQ3YOd70w==
Date: Wed, 25 Feb 2026 19:44:49 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [net-next,4/9] ipvs: do not keep dest_dst after dest is removed
Message-ID: <20260225194449.546cb6a1@kernel.org>
In-Reply-To: <20260226034124.1806970-1-kuba@kernel.org>
References: <20260224205048.4718-5-fw@strlen.de>
	<20260226034124.1806970-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Feb 2026 19:41:24 -0800 Jakub Kicinski wrote:
> > -			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
> > +			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
> > +			    dest->flags & IP_VS_DEST_F_AVAILABLE)
> >  				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);  
> 
> Should this be wrapped in parentheses?
> 
> In C operator precedence, the logical AND (&&) binds more tightly than
> the bitwise AND (&). The expression here parses as:
> 
>     (!rt_dev_is_down(...) && dest->flags) & IP_VS_DEST_F_AVAILABLE
> 
> This works correctly only because IP_VS_DEST_F_AVAILABLE is 0x0001, and
> the logical AND produces 0 or 1, so the bitwise AND with 0x0001 still
> produces the expected result.

Ah, should have skipped this one. It is of course bs. Chris reported 
it to the developers of the model.
