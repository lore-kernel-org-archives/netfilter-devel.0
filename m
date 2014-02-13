From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Thu, 13 Feb 2014 13:13:39 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402131311150.17323@blackhole.kfki.hu>
References: <1392291659-27444-1-git-send-email-fw@strlen.de> <20140213114725.GA8016@localhost> <20140213115126.GH25153@breakpoint.cc> <20140213115543.GA8226@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:33198 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbaBMMNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:13:46 -0500
In-Reply-To: <20140213115543.GA8226@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Feb 2014, Pablo Neira Ayuso wrote:

> On Thu, Feb 13, 2014 at 12:51:26PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Thu, Feb 13, 2014 at 12:40:59PM +0100, Florian Westphal wrote:
> > > > commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)
> > > 
> > > I don't find that commit in the tree:
> > > 
> > > $ git show 2dfb973c0dcc6d2211
> > > fatal: ambiguous argument '2dfb973c0dcc6d2211': unknown revision or
> > > path not in the working tree.
> > > Use '--' to separate paths from revisions
> > 
> > its in ipset.git, not in kernel.  Sorry if that was not clear.
> 
> Ah, I see.
> 
> > I did not find any references to MARKMASK in nf-next.git.
> 
> I think this is still in Jozsef's tree.

Yes, it's there - I'll submit the patches after Josh's forceadd patch is 
incorporated.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
