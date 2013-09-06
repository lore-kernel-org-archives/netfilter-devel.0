From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] netfilter: ipset: refactor hash types to use address/cidr
 arrays.
Date: Fri, 6 Sep 2013 20:00:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309061950350.14814@blackhole.kfki.hu>
References: <1378232143-27406-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <24199506.ar3DiBo0cH@gentoovm> <alpine.DEB.2.00.1309041915390.8534@blackhole.kfki.hu> <1894701.xWd9IXYenT@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:53207 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3IFSAW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:00:22 -0400
In-Reply-To: <1894701.xWd9IXYenT@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Oliver,

On Fri, 6 Sep 2013, Oliver wrote:

> Alright, I took a look at the changes - I'll wait for the extension 
> cleanup then send out a rebased version of hash:net,net since that's 
> presumably going to be the difference between having to declare struct 
> combinations for the various extensions versus not having to do it. I'm 
> very intrigued to see what you can come up with that's shorter than my 
> rework :P

There's a technical problem with your refactoring patchset (it doesn't 
prevent unaligned access to extension members), and a design issue: the 
data about the extensions (offsets) should belong to the core. There's 
still code duplication between the bitmap and hash types in it when even 
the list type is missing. The solution means an overall rearrangig and 
that's what I'm working on.
 
> On a related note - I was thinking about the impact of recursively 
> walking the CIDRs and it did occur to me that this operation is very 
> parallelisable - however, I found that when I ran ipset -T on the set, 
> the in-kernel code is running in an interrupt context (somehow, I 
> couldn't see what made it like that), which means it's not possible to 
> spin up kthreads (unless there's something that I don't know about) - 
> when testing of an ipset is called via xt_set, is that also running in 
> an interrupt context? if not, it could be parallelised quite nicely, 
> which I anticipate would give some gains on multicore systems, and 
> especially for IPv6, one would think.

How could the walking of the CIDRs be parallellized, when the lookup must 
follow the priority of the networks? (With the exception of checking 
multiple same sized networks.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
