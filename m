Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F96D43B4BB;
	Wed,  2 Sep 2026 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390851; cv=none; b=RUaMdf/31CVMlZbrMQ606n5+nAxEn7u6de2AjimilFaJzGrMRNR6Rbf3KkhPOAnDucq+LTaP6npultoa560JtCNbGlnVHbJRv+4Y9wwPnA/uQfIpHiNL7SDkOhU2BlxjXiqrboRaz55883M1fvDhpcs+g6s+F+6jnWZ8BhheOuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390851; c=relaxed/simple;
	bh=VNvCBzAdKDH9qZMvUV09Vzxv4qAFzytLHlgOD3Eef98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c46EnPsa0FVH1IISGYOi/jBYZrLvRB3RCOaZ7R0aWOWRFi6DFJSbtiY5aSuACusohWI/TK+xs4ksSPiAbebXh+teindmeo1Slpehq8sJ78SHYX1vwvoSMUt8ROZ9Hf9jXUyzfZ6YNScPFfGF+oHoYBd2zih53/4LmlE0ochy4ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P7iU7TXy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P7iU7TXy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788390846;
	bh=ba4osfL9JAMV/sf7Mybazvhbt9hXutQ8n1IRh9XYtLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7iU7TXyOZKHwTRk22VWy1RU3hbreXAU0JZZhlzuQqKAeefzyf7vcC7VjIymns9zU
	 lTJrlOtG+T/CMn3j66ptbIvWoDMq1I+aTPP57UG7sbj8cXjeA74v7XWJJl7tmIVOlk
	 0yw3DkVD9KvxkD3+pMgAgbdKHOG9lc4WW9It9M6Oq8gOY40jRsdtfHCd8L/QZFGdJa
	 TslrmmSbpqVncRjXsqWgz4YYpqzqrezIuwlPPtHBUweEes/jgGYcSRcxBF4aLqGPK6
	 8ILUhgzdc7FshNE5OhERD99ZkxcfTPImAU3gh3T8USeXN13hEzhfb6eCPivso9zHFu
	 DhBAFzHx8kZUA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 236C260056;
	Thu,  3 Sep 2026 01:14:06 +0200 (CEST)
Date: Thu, 3 Sep 2026 01:14:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mukul Sikka <mukul.sikka@broadcom.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>,
	Bin Lan <lanbincn@139.com>, XiaoHua Wang <561399680@139.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: restore cloned
 mapping table memcg accounting
Message-ID: <apitu8BYUvG-WJt2@chamomile>
References: <20260831194905.45045-1-kmehltretter@gmail.com>
 <20260902-daily-reply-0014-pipapo-fixes-tag-ack@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260902-daily-reply-0014-pipapo-fixes-tag-ack@kernel.org>

On Wed, Sep 02, 2026 at 06:14:13PM -0400, Sasha Levin wrote:
> > Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> > Fixes: 32bad10de347 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> >
> > This two Fixes: tag do not make any sense to me.
> 
> > The two Fixes tags are for the two stable branches:
> >
> > - a4983e89e3b1 is the 6.1.y backport
> > - 32bad10de347 is the 6.6.y backport
> >
> > I am not sure what the usual preference is here: one common patch with
> > both Fixes tags, or separate patches for each tree. Which do you prefer?
> 
> Whatever Pablo prefers :)

I am fine either way. I just got confused with the double Fixes: tag
that point to the -stable tree commit hash (if I understood correctly
after Karl's explaination).
