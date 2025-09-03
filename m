Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21292EAD0B;
	Wed,  3 Sep 2025 22:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756939951; cv=none; b=sjF6gYMgOUyTR0OYyKQGXkOBlYYkoFVsuMwB10rnDYZEQyyJygRI23dOS6YX6ZVX/kM5amKgILETa7JLDFClKvSeCdtr13K2BwLRS3kMizpP98qaFcFpOobYrlqiBB0Lx7eeFk0kdl8UcEuWFJA62VMb1Y1GxhU+pFlcF0i0AZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756939951; c=relaxed/simple;
	bh=W/hGK7wH2sOlg9PNlFLnQc3PUa4FpPzF/E6XIXr3xb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfcbNC4e5MsOn/jB/ma0cucCjY4DztqIKmTnKq1JLKKoTP0qQptCEj0o2mASyq04N5m745pr6aq7HKN2CpRXkwjCUxeXOcjYP1XOurC71i8Vi4cXjZrHw0yNNxQVehv3+j0RH0Mt06ngnZkgz0YYYOMbPEczoNxyDHxkfU/UOwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 984996046B; Thu,  4 Sep 2025 00:52:20 +0200 (CEST)
Date: Thu, 4 Sep 2025 00:52:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 1/2] selftests: netfilter: fix udpclash tool hang
Message-ID: <aLjFWzreiLM8nWgL@strlen.de>
References: <20250902185855.25919-1-fw@strlen.de>
 <20250902185855.25919-2-fw@strlen.de>
 <20250903151554.5c72661e@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250903151554.5c72661e@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue,  2 Sep 2025 20:58:54 +0200 Florian Westphal wrote:
> > Yi Chen reports that 'udpclash' loops forever depending on compiler
> > (and optimization level used); while (x == 1) gets optimized into
> > for (;;).  Switch to stdatomic to prevent this.
> 
> gcc version 15.1.1 (F42) w/ whatever flags kselftests use appear to be
> unaware of this macro:
> 
> udpclash.c:33:26: error: implicit declaration of function ‘ATOMIC_VAR_INIT’; did you mean ‘ATOMIC_FLAG_INIT’? [-Wimplicit-function-declaration]
>    33 | static atomic_int wait = ATOMIC_VAR_INIT(1);
>       |                          ^~~~~~~~~~~~~~~
>       |                          ATOMIC_FLAG_INIT
> udpclash.c:33:26: error: initializer element is not constant
> Could you perhaps use volatile instead?

That works too.  I'll send a new PR tomorrow, its late here.
