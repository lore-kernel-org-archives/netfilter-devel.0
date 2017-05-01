From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/3] netfilter: speed up netns cleanup
Date: Mon, 1 May 2017 21:37:25 +0200
Message-ID: <20170501193725.GA24460@breakpoint.cc>
References: <20170424133741.2707-1-fw@strlen.de>
 <20170501092036.GA3476@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43710 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751316AbdEAThk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 15:37:40 -0400
Content-Disposition: inline
In-Reply-To: <20170501092036.GA3476@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Apr 24, 2017 at 03:37:38PM +0200, Florian Westphal wrote:
> > low hanging fruits to speed up netns cleanup in netfilter.
> > We're way too happy to issue expensive synchronize_rcu() all
> > over the place.
> > 
> > On my test vm 8 processes doing 32 unshare each finish in ~3 minutes,
> > with these patches it gets down to 40 seconds.
> 
> If this is a script, can we place this somewhere to keep an eye on
> this?

It was based on Andreys sample program but this is enough actually
to show the difference:

time for x in $(seq 1 100); do unshare -n /bin/true;done
