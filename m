From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types
 instead of rwlock per set
Date: Thu, 27 Nov 2014 09:23:12 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411270921450.15541@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu> <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu> <20141126131434.GA1671@salvia> <alpine.DEB.2.10.1411261538080.9422@blackhole.kfki.hu> <20141126154113.GD24801@breakpoint.cc>
 <alpine.DEB.2.10.1411261659030.9422@blackhole.kfki.hu> <20141126171808.GC3585@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41649 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaK0IWT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:22:19 -0500
In-Reply-To: <20141126171808.GC3585@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 26 Nov 2014, Pablo Neira Ayuso wrote:

> > Hm, you are both right - I clean up this part as it's totally unnecessary, 
> > these are not pointers, even indirectly.
> 
> Thanks.
> 
> Please, I'd appreciate if you send smaller batches for nf-next for
> easier review. So instead of large batches, more frequent pull
> requests if possible.

Sure! I'll split up the RCU patch into multiple parts too when resending 
the patchset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
