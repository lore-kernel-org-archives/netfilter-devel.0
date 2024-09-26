Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CFE101EE;
	Thu, 26 Sep 2024 10:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347126; cv=none; b=jn2MJLqWDHZMsqA0MAQWqHBaWCwsXVMf7MAvqLCwU/BsFBBcgsl6vZd1l0hpChiDQg0REGtarUTBZhSu3eEhf9FFXtbQbTdfAUDOK9/umBWHyC4hm54k5SqKKN7FJdDIXULq0uGTCwZ8X59pWr24HXt3U6aVCzsehGY12/Ng//I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347126; c=relaxed/simple;
	bh=9n8LWPUfwGJ3zXZl9q2c9OhFdJSoP99OoJZfoCd95Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MM3GCfjX/j1nQMv61LAwkivFD3NaWoXSMIZR1gtfgRjG0Fw7LzUYKv8TwIOpeUqY9zaGhrmc+GV4cd7py+0qzthru82fDG/akNgNgp6ghaltByT+bEv2Fr5PyF+DbMq8oKqbNMbe3x3DbrZAyDT5526dOWYIziHbuUo+F1FQAO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48932 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stltP-001PhR-4O; Thu, 26 Sep 2024 12:38:41 +0200
Date: Thu, 26 Sep 2024 12:38:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
Message-ID: <ZvU5rhGYpmGV_FVx@calendula>
References: <20240924201401.2712-1-pablo@netfilter.org>
 <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
 <20240926103737.GA15517@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240926103737.GA15517@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 26, 2024 at 12:37:37PM +0200, Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
> > On 9/24/24 22:13, Pablo Neira Ayuso wrote:
> > > The following patchset contains Netfilter fixes for net:
> > > 
> > > Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
> > > packets to one another, two packets of the same flow in each direction
> > > handled by different CPUs that result in two conntrack objects in NEW
> > > state, where reply packet loses race. Then, patch #3 adds a testcase for
> > > this scenario. Series from Florian Westphal.
> > 
> > Kdoc complains against the lack of documentation for the return value in the
> > first 2 patches: 'Returns' should be '@Return'.
> 
> :-(
> 
> Apparently this is found via
> 
> scripts/kernel-doc -Wall -none <file>
> 
> I'll run this in the future, but, I have to say, its encouraging me
> to just not write such kdocs entries in first place, no risk of making
> a mistake.
> 
> Paolo, Pablo, what should I do now?

I am going to fix it and resubmit PR.
