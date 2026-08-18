Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB2C2F5A36
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 10:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048059; cv=none; b=pao9vFNjI6IiJymv/TDgwMQBJwWoQUrIShF7wmNW53ZLJ9pa9Zann5gowMRZjl9kau5xs3z0LfvAveOnek0xwYr0SenR/oAcGOB25TvO6XUMrDAatBrsTRAvZySnVVshWq8IdWp0Pdi9dgXtilX/wZCFEPkju+sn+MpZBu0Lvjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048059; c=relaxed/simple;
	bh=DuUp030BM77KArw7KQxU/KBt+qlLCFehGB9SVZJpoZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xup18DBqIOEKTyU83Oall4encW1suTDgl6nzasXIEo6JVz7PWrOGf6xDJ+tgEBsAohnCPWrNOymspdT1Lk/iDWbGClmOzKihOG5IaA3dy184ldHiQFYToLMz+La1gPD1vAp/q47tPmd1gStebD7f7LvBManrf+3f/9psxCS2lrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8EE7B6051B; Tue, 18 Aug 2026 12:14:14 +0200 (CEST)
Date: Tue, 18 Aug 2026 12:14:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, luciano.coelho@nokia.com,
	kaber@trash.net, quic_manojbm@quicinc.com,
	quic_subashab@quicinc.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_IDLETIMER: validate label before
 debug logging in checkentry
Message-ID: <aoQwbtJ9vHfFb8Fx@strlen.de>
References: <cover.1786933680.git.rakukuip@gmail.com>
 <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>

Ren Wei <weir@nebusec.ai> wrote:
> Fix this by moving the pr_debug() calls after idletimer_tg_helper() has
> successfully validated the label string.

I think it would be better to just zap this pr_debug, I don't think it
provides any benefit to have it.
