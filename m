From: Florian Westphal <fw@strlen.de>
Subject: Re: REOUTE target extenstion
Date: Wed, 27 May 2015 13:37:46 +0200
Message-ID: <20150527113746.GA23992@breakpoint.cc>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eddi Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45629 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbbE0Lhr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:37:47 -0400
Content-Disposition: inline
In-Reply-To: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eddi Linder <eddi@guardicore.com> wrote:
> Hey,
> 
> I am planning to write a "redirection" extension that based on a match
> will copy the matched packet to other interfaces.
> The extension should work both on input chains and output chains
> (ingress and egress traffic), and will be able to copy the packet as
> egress or ingress of the selected interface.

Whats wrong with TEE target?

We also have mirred action in tc to do packet mirroring and redirects.
