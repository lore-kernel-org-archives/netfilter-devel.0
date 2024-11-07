Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4903821832E;
	Thu,  7 Nov 2024 21:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013678; cv=none; b=nDPhSj4rwSAiabewq9RDPeMSxzAi8cKsuO6JHCwOkRwtvFEL4ID4HrGTHGreVIPSB5X1lrOyHOj4ABaXgZBV9GNuda7iQGbtAEVLVF79r55tKzVFiAGYhGWY2NNu4ExaX5/TAN2xDF6ALurB+U3jnnbFv8GXQtLd/kCjdflBoRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013678; c=relaxed/simple;
	bh=zknLhZWayK107a+awoPzl61zGy+TZM68gVp7Kzd/vD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYrzJLv6GA8Z+3Tq3rVPtgoYWo3CpNasrcybfQGHo5b4vFmYi+HkBmG7dji2QDBRTrtC7ez4RDlc75OY/OSgm2WFxPCtCULPq8dDwAHWkc5XLhxGAnf+NdMpIlogScknZhHyxLib7rwLtMJnAqSlzyNnIS75R2RF21Bc6v7oJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t99jJ-0000KP-9Z; Thu, 07 Nov 2024 22:07:49 +0100
Date: Thu, 7 Nov 2024 22:07:49 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 00/11] Netfilter updates for net-next
Message-ID: <20241107210749.GA1050@breakpoint.cc>
References: <20241106234625.168468-1-pablo@netfilter.org>
 <20241106161939.1c628475@kernel.org>
 <20241107070834.GA8542@breakpoint.cc>
 <20241107124802.712e9746@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107124802.712e9746@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> > I tried to repro last week on net-next (not nf-next!) + v2 of these patches
> > and I did not see splats, but I'll re-run everything later today to make
> > sure they've been fixed up.
> 
> Great! I was double checking if you know of any selftest-triggered
> problems before I re-enable that config in our CI.

The only splat I saw today on re-run is in kernel/events/core.c, but
Matthieu Baerts tells me there is a fix pending for it.

> I flipped it back on few hours ago and looks like it's only hitting
> mcast routing and sctp bugs we already know about, so all good :)

Great.  It finds real bugs so its good that it can be turned on again
to catch future issues.
