Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A511DFD9;
	Fri, 12 Apr 2024 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712929130; cv=none; b=n1GWAtQ7OeXlVm6xWIFLxAgnQwT1u+YGOh/bKMW1efXNeh6sgv93F76LKNcaLuH5osGYCr3Ea/IUoQ5nIN1t55f7SuSYRn87susLjP2DZEZGd+ake1545AWq9mTJWwqIYGuN4w7D3WRga68HqAcGeRBQIRdEAp9jFZ/Qzrxc5lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712929130; c=relaxed/simple;
	bh=ycRBUlPrru++9tWRcRNHdUS0tmnppsq+w1/92znAR4g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brnJb1dyZTV16EhGLurCX2BMST+zTrLmxx8Pv0tVAY1wgZ1P0fPAiO2VMBUCZo14/JEOJ/EfGa0xQ9jQ5Nf9DAvayVzWjbsvBCPkuAHaeznzu3031gssAZ8SqZg9Q0PYL8L0ZsaTcoe1mRzutj2TsjFF9LeD35BTJZeveJESwAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQoa0DEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQoa0DEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3208C113CC;
	Fri, 12 Apr 2024 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712929130;
	bh=ycRBUlPrru++9tWRcRNHdUS0tmnppsq+w1/92znAR4g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lQoa0DEZbUzok7AlBydDndD6eW6pUGbUicJ21zChZpfw4M5BbSSgKF0Ul1JzFP4Hf
	 Iht7cDmfqY95nphXVY+1NMucdcruHlJBwZYtCq3YMbkIcPiLs4kVWG2xONj1hIN3Xa
	 bTXT2og/cj3pKdNcy5hBKMWP23y1e1TUHNbn/378fn+X/6mz08WYBP9O/D4q0w/gf9
	 lNgRicDd1iV/wgckycSeGpTq3e68+K/6m8JaBblCDDz7OfbEn9N7TTRmp5Sja3za6f
	 1vlObc85zVJwbRi8YVQyxdu/uKGF5LBirsgk/MWMRG2R9G6InUnUpYhMUnUNQkno/J
	 jdtPgTIjIjKkw==
Date: Fri, 12 Apr 2024 06:38:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 00/15] selftests: move netfilter tests to net
Message-ID: <20240412063848.11b3bc51@kernel.org>
In-Reply-To: <20240412065330.GG18399@breakpoint.cc>
References: <20240411233624.8129-1-fw@strlen.de>
	<20240411191651.515937b4@kernel.org>
	<20240412065330.GG18399@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 08:53:30 +0200 Florian Westphal wrote:
> > Either tree works, FWIW.
> > 
> > I presume we should add these to the netdev CI, right?  
> 
> After all scripts have been updated it would be great if you
> could do that, yes.
> 
> ATM too many nf tests barf for various reasons.
> 
> > Assuming yes - I need to set up the worker manually. A bit of a chicken
> > and an egg problem there. The TARGET must exist when I start it
> > otherwise worker will fail :) These missed the
> > net-next-2024-04-12--00-00 branch, I'll start the worker first thing in
> > the morning..  
> 
> Let me know how I can help.

Alright, the workers are churning. For now I excluded this target from
patchwork reporting, but they are running and showing up on the status
page (in the ignored section).

Looks like most of the tests skip:
https://netdev.bots.linux.dev/contest.html?branch=net-next-2024-04-12--12-00&executor=vmksft-nf

I looked at a few, they all said:
# mnl_socket_open: Protocol not supported

The resulting kernel config is here:
https://netdev-3.bots.linux.dev/vmksft-nf/results/548802/config
