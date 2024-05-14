Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97CF1755C;
	Tue, 14 May 2024 05:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715663380; cv=none; b=uXQKGsrdkaF+ioQc3jvwpZnL99g1oDMXy4eJpJ1j+P+W4ghpvVoBpUcKfP8zQRMh99U3im0CoMzyocXr9cSIStXN3XtR9DvxeKdiEZPb87OqDR/hmQnT7L7UYQuBktRPeUwMN94r1XBsekntDSI9rcdJqgn/hNyHM9V91BxRzeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715663380; c=relaxed/simple;
	bh=o7ny/45AD8rAZ5JiLK0CkJTz0igQRS/P8gYHN5qWrgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PrkRwUOfCZhEWAmky1245myxPqXJQpa5ZFkNjZlkLzp7SGpML2qs8Y0OQV8pRcx6a0w/n4g5SOkvLTZ0rPhk7X33KwtbJtAKWym/wNDmmj0RiTb6vMyDUGUOddx3d7KwvaIcQrgufHO8V7LrR+d258qNUjzn5W06tWKkQIPOjWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6kPq-000745-Hh; Tue, 14 May 2024 07:09:30 +0200
Date: Tue, 14 May 2024 07:09:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 16/17] selftests: netfilter: add packetdrill
 based conntrack tests
Message-ID: <20240514050930.GC17004@breakpoint.cc>
References: <20240512161436.168973-1-pablo@netfilter.org>
 <20240512161436.168973-17-pablo@netfilter.org>
 <20240513114649.6d764307@kernel.org>
 <20240513200314.GA3104@breakpoint.cc>
 <20240513144114.2ae7bf1a@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513144114.2ae7bf1a@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> Ah, makes sense. I added a local patch to the system, it should be
> applied on the next test, just to confirm.

Test is passing now, thanks!

Would you apply the patch to net-next or do you want
me to send it myself?

Either way is fine for me.
