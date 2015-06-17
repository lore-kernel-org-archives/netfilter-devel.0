From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: socket lookup function
 refactoring, cgroup match fixes
Date: Wed, 17 Jun 2015 12:34:09 +0200
Message-ID: <20150617103409.GB3365@salvia>
References: <1434499692-9832-1-git-send-email-daniel@zonque.org>
 <20150617010332.GA5083@salvia>
 <5581387A.2060709@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Mack <daniel@zonque.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59334 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbFQK2v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 06:28:51 -0400
Content-Disposition: inline
In-Reply-To: <5581387A.2060709@zonque.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 17, 2015 at 11:06:02AM +0200, Daniel Mack wrote:
> Hi Pablo,
> 
> Thanks a lot for the feedback!
> 
> On 06/17/2015 03:03 AM, Pablo Neira Ayuso wrote:
[...]
> 
> Yeah, right. The thing is that cgroup matching is an incredible useful
> feature. It's a pity it isn't currently usable for ingress packets.
> 
> > The possible ideas that we (Patrick and me) have discussed boil down to:
> > 
> > 1) Placing the INPUT hook at later stage, from the layer 4 protocols.
> 
> That would be great, but the consequences for other matching functions
> are beyond my current knowledge of the netfilter code.
> 
> > or
> > 
> > 2) Add a new socket hook in the path from layer 4 protocols.
> > 
> > In both cases, the idea is that we're always 100% sure that we have a
> > valid sk in place, including UDP multicast.
> 
> That sounds reasonable too. That option would at least work for nft
> then, right? Is anyone working on that yet?

Not yet, but Daniel Borkmann will likely bring up this issue during
the Netfilter Workshop that will happen the next week.
