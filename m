Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C41429DB88;
	Wed, 13 Aug 2025 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755067434; cv=none; b=Ii+j/GVarFAzcshqA0FUzmTZfJkO1YC/MHPTTsTLFkuAOsdE4Qnx4bIuOOzQBmqOF4Z4h4mubVKnd8ByfgJ1dRNRXHMP+I7PfZo4upFzkwlcKM9olm+Y5p66vstkSFdHpXCfogGThRE2+Ay4Wdv3cYnNaxvIi7wKxHiA3x1pq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755067434; c=relaxed/simple;
	bh=2VW5vfoRpqyVM5a0EIlgZ9KilF5KukMU+o76cWK9MIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWQJxBju64+nRyCpAtCYHCSFcrH5twsLmzXlt9W4ynd2TExmUYQsH8mWeFBUqghviNAcA4bAHOvjLhYLRMDA178yJ3slKgSyTwlVt0L1Tm7f3eB+awkuh1P/C7ugQbThc+KKT0Wq7K/igNsTW6dliGp5bPFm6QkmcSeW8KegitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3A48F605CE; Wed, 13 Aug 2025 08:43:50 +0200 (CEST)
Date: Wed, 13 Aug 2025 08:43:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ayush.sawal@chelsio.com,
	andrew+netdev@lunn.ch, gregkh@linuxfoundation.org, horms@kernel.org,
	dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
	steffen.klassert@secunet.com, mhal@rbox.co,
	abhishektamboli9@gmail.com, linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear
 dst_entry
Message-ID: <aJwzvtadECk8OAR9@strlen.de>
References: <20250812155245.507012-1-sdf@fomichev.me>
 <20250812155245.507012-4-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812155245.507012-4-sdf@fomichev.me>

Stanislav Fomichev <sdf@fomichev.me> wrote:
> Going forward skb_dst_set will assert that skb dst_entry
> is empty during skb_dst_set. skb_dst_reset is added to reset
> existing entry without doing refcnt. Switch to skb_dst_reset
> in ip[6]_route_me_harder and add a comment on why it's safe
> to skip skb_dst_restore.

Acked-by: Florian Westphal <fw@strlen.de>
