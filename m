Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3E11AE84A;
	Thu, 26 Sep 2024 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348173; cv=none; b=GtY877dEj6d3k+2n5Ztp/mBW/KXOBwFCNm3I8JFaonoWhZIZ5idHBe8e5xoOPMradE13+uRf658ilj55kO6ufqnAmRKld30ikXPOFwFYgRWE9Ey+Jyckte+GC0EAsvD9/Vgee3OYGWEezPXpHm5L7EZ2Lq1WHUo5aKnqsBKU3tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348173; c=relaxed/simple;
	bh=Qa2jT4/2s74MI1inINDuACkzaOSvq7JFkAWjbO2SnZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I69NOSh+2fPgYsMLTt2U4rQVIPKW2Lau68zYnU61sHIGy5ZwnFnlUYVCb3YF8f8iLMPxkNsngGDvsPpXxbIfNz8TuZK57UoroddtswDGLjdPtI7ZUG1pO4+9Qp8L+7D7tfc6yBh+OLuyBw6GC7wjvUvZvUtb3mCKFu9YNCen57E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37144 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stmAH-001Qk0-TP; Thu, 26 Sep 2024 12:56:07 +0200
Date: Thu, 26 Sep 2024 12:56:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
Message-ID: <ZvU9xUdMC4Ra_9gv@calendula>
References: <20240924201401.2712-1-pablo@netfilter.org>
 <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
 <20240926103737.GA15517@breakpoint.cc>
 <ba889ffb-ba6f-450a-be9b-9fa75b20ee86@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba889ffb-ba6f-450a-be9b-9fa75b20ee86@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Sep 26, 2024 at 12:43:23PM +0200, Paolo Abeni wrote:
> On 9/26/24 12:37, Florian Westphal wrote:
> > Paolo Abeni <pabeni@redhat.com> wrote:
> > > On 9/24/24 22:13, Pablo Neira Ayuso wrote:
> > > > The following patchset contains Netfilter fixes for net:
> > > > 
> > > > Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
> > > > packets to one another, two packets of the same flow in each direction
> > > > handled by different CPUs that result in two conntrack objects in NEW
> > > > state, where reply packet loses race. Then, patch #3 adds a testcase for
> > > > this scenario. Series from Florian Westphal.
> > > 
> > > Kdoc complains against the lack of documentation for the return value in the
> > > first 2 patches: 'Returns' should be '@Return'.
> > 
> > :-(
> > 
> > Apparently this is found via
> > 
> > scripts/kernel-doc -Wall -none <file>
> > 
> > I'll run this in the future, but, I have to say, its encouraging me
> > to just not write such kdocs entries in first place, no risk of making
> > a mistake.
> > 
> > Paolo, Pablo, what should I do now?
> 
> If an updated PR could be resent soon, say within ~1h, I can wait for the CI
> to run on it, merge and delay the net PR after that.
> 
> Otherwise, if the fixes in here are urgent, I can pull the series as-is, and
> you could follow-up on nf-next/net-next.
> 
> The last resort is just drop this from today's PR.
> 
> Please LMK your preference,

I am working on this now.
