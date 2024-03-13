Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F279F1426C
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710341762; cv=none; b=rbEiXiDppLxemNl9QMiak9xpWSa52SFflcBW/PGBPgG+cCo/FPvJyt+00sS0k1dUzfPDukkNCunvxv9wKfEhNih31pdSX6ZZydEeeUj9IkO/R7bU8TICkLZRE8V/h+zyfunM5Tgf57gpiAfrR2apavWfoMtwTSU7EEK2erCB3RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710341762; c=relaxed/simple;
	bh=+xpgpNiB8YmH4N6op2GTeLgz8fiBSuudE073cBmf+Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iT/vXxpBQ26fXQ13890UYVQa8jP6dC9seguLK3Vt7E91QIuvZ26hKQljhxCSq9aU0eD1+qnNpi2F913KYBBCVh+NUiy4JohgpE3CYOd2sO2OgtFm6Gc6IE5HvzVllbRhi1yjrRIwHetw0Ri7NVkLDUlbi/C5XDjcObgTBu1kKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rkQ1N-0008LE-Sz; Wed, 13 Mar 2024 15:55:57 +0100
Date: Wed, 13 Mar 2024 15:55:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <20240313145557.GD2899@breakpoint.cc>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> I have a race condition problem in the flowtable and could
> use some hint where to start debugging.
> 
> Every now and then a TCP FIN is closing the flowtable with a call
> to flow_offload_teardown.

I don't understand why this is done.  It seems buggy to do this.

The skb has not been seen by conntrack yet, so any reply packet coming
in between the flow_offload_teardown() call and the conntrack actually
moving to close state ...

> Right after another packet from the reply direction is readding
> the connection to the flowtable just before the FIN is actually
> transitioning the state from ESTABLISHED to FIN WAIT.

.. will re-add.

> Any idea why the state is deleted right away?

No idea, but it was intentional, see
b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")
