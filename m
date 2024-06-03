Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589CC1272BA;
	Mon,  3 Jun 2024 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717416562; cv=none; b=FbQrwpA/x2XjCtUwPaRHxdzuSuI7Dj893jQJlE/1Ik/uTq2hORoEJzWXtWISghMBJdLyw1JlOGzXxTG2EFK9FMU2jZuXnS4iX+l7R/OdddlxKo1DKSWAxVasygoTvKus5HJiDTsuPlaFJkDfo6wJTIGUSvATANnyi5sYxFVzq5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717416562; c=relaxed/simple;
	bh=plkS0ousBNjrv17Xqd/8eT7VQ5Pas7WSNDnHEpPXCgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oj2WSpbgo8eVgqpxMDi5D/1/69NvNm2P0A+0z4ckLlqAFGcfNZgzq8VN3L+geaHxO4shBbKy75VrLSX3b/cxQycZ13aLrYJY9Id4hGYXa3RwCp7IQEvOE/ZcnigHUwUvb5Wh5b08SlzMCNOSxHJMhXzr4UzlVTXLwZ/p5snqFIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASzj+nrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASzj+nrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BABFC32789;
	Mon,  3 Jun 2024 12:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717416562;
	bh=plkS0ousBNjrv17Xqd/8eT7VQ5Pas7WSNDnHEpPXCgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ASzj+nrV2ws4WRmt65ddCIRPr1RMX0Z2L7GOuCJQmcEoWa7qtoyh0HMEH6Rp/lQro
	 hTYN6qWw9xywOHH8LqePTQc0J2Bt/Q2UPPsPQWs104eJ5rVl3jwTSRMaONFYlR/dBR
	 QeP90xAwzAyfDATYeHbcOp7Tt0XkhvMEwWYtOK6OAIBjB94Day4DqpyUZYFFImMrau
	 hwZsG23yb7nPm1r6gSODDXDCCfloi8tRXN6Onu1RgEOH636uYY/hVuDvP/KgaSng+K
	 Tkoik53zlQoUDOoJh0oG1gWxNxsYSgKmVve329KJx6CyY20Qmg46KVxerk0fSSg2wp
	 M823FWaz1KxKQ==
Date: Mon, 3 Jun 2024 13:09:17 +0100
From: Simon Horman <horms@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] netfilter: nfnetlink: convert kfree_skb to
 consume_skb
Message-ID: <20240603120917.GY491852@kernel.org>
References: <20240528103754.98985-1-donald.hunter@gmail.com>
 <20240531161410.GC491852@kernel.org>
 <m2ed9ecrj4.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ed9ecrj4.fsf@gmail.com>

On Mon, Jun 03, 2024 at 10:19:27AM +0100, Donald Hunter wrote:
> Simon Horman <horms@kernel.org> writes:
> 
> > On Tue, May 28, 2024 at 11:37:54AM +0100, Donald Hunter wrote:
> >> Use consume_skb in the batch code path to avoid generating spurious
> >> NOT_SPECIFIED skb drop reasons.
> >> 
> >> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> >
> > Hi Donald,
> >
> > I do wonder if this is the correct approach. I'm happy to stand corrected,
> > but my understanding is that consume_skb() is for situations where the skb
> > is no longer needed for reasons other than errors. But some of these
> > call-sites do appear to be error paths of sorts.
> >
> > ...
> 
> Hi Simon,
> 
> They all look to be application layer errors which are either
> communicated back to the client or cause a replay. My understanding is
> that consume_skb() should be used here since kfree_skb() now implies a
> (transport?) drop.

Hi Donald,

Thanks, that makes sense to me.
