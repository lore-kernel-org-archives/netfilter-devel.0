Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C54AECB;
	Fri, 12 Apr 2024 06:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712904816; cv=none; b=N0g6Z0ThYhz7FLNARDY9z8K1kp8jMIeZ2kqddN40nvwoEIZJUlN6cc9neYpLf5lmocGdtdMoVOPJM6qLPSZ4kpH8unHOADiq95t+7FiyzFpk170Ri8blswP6POUPd28ouZlBn0YUcIDgX5v5TdHy/+4n4Ofm4Dt+P0gb549WP0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712904816; c=relaxed/simple;
	bh=72PxMKmpVXYUq3xJ/w7enZoehUEfZdxYWo9Py65Ynto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTCRfnKf4zoGg5mE9yg9hh1eMN+KInfRYHqUS576TSJm2CYi59uEhiKypuiX3BEtMGosWm+dzIg/GxDevX8tgYgAomWi0Hc8cTiZIGIrnT4pTs07Y1SyRYTjLYsNlcMmYtCVv7mXwraJIseSb62sWXfwr429qdb4YO0sWX67CNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rvAmw-0003DW-4B; Fri, 12 Apr 2024 08:53:30 +0200
Date: Fri, 12 Apr 2024 08:53:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 00/15] selftests: move netfilter tests to net
Message-ID: <20240412065330.GG18399@breakpoint.cc>
References: <20240411233624.8129-1-fw@strlen.de>
 <20240411191651.515937b4@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411191651.515937b4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> > Passing this via net-next rather than nf-next for this reason.
> 
> Either tree works, FWIW.
> 
> I presume we should add these to the netdev CI, right?

After all scripts have been updated it would be great if you
could do that, yes.

ATM too many nf tests barf for various reasons.

> Assuming yes - I need to set up the worker manually. A bit of a chicken
> and an egg problem there. The TARGET must exist when I start it
> otherwise worker will fail :) These missed the
> net-next-2024-04-12--00-00 branch, I'll start the worker first thing in
> the morning..

Let me know how I can help.
