From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set
 resize
Date: Sun, 24 Feb 2013 20:52:09 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com> <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu> <51254FA8.3050407@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:46262 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab3BXTwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Feb 2013 14:52:12 -0500
In-Reply-To: <51254FA8.3050407@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 20 Feb 2013, Josh Hunt wrote:

> On 02/20/2013 03:44 PM, Jozsef Kadlecsik wrote:
> > 
> > That's a good catch and perfect patch.
> > 
> > I'm just at the checking phase of the next release, which required a
> > fairly large rewriting of the types - and which, as a side effect, fixed
> > this bug. If I won't be able to release the rewritten version by the
> > weekend, I'm going to apply your patch and release an interim version.
> 
> Is there a git tree I could check out to look at the new changes? I'd be
> interested in seeing what you've done.

It's on my devel laptop only :-)

> Also, what was the motivation behind the large changes you're doing?

The support of the extensions attached to the set members required a 
reorganization. Until now just the timeout as extension existed. The new 
extension to be introduced is the packet and bytes counters per elements. 
It was mandatory to rewrite the handling of the extensions and the 
generation of the variants of a set type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
