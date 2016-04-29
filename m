From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: init all_locks to avoid debug
 warning
Date: Fri, 29 Apr 2016 11:31:08 +0200
Message-ID: <20160429093108.GO17538@breakpoint.cc>
References: <1461453434-4271-1-git-send-email-fw@strlen.de>
 <20160429092307.GA13111@salvia>
 <20160429092742.GA14700@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42939 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbcD2JbL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:31:11 -0400
Content-Disposition: inline
In-Reply-To: <20160429092742.GA14700@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Apr 29, 2016 at 11:23:07AM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Apr 24, 2016 at 01:17:14AM +0200, Florian Westphal wrote:
> > > Else we get 'BUG: spinlock bad magic on CPU#' on resize when
> > > spin lock debugging is enabled.
> > 
> > Applied, thanks Florian.
> 
> Wait, probably better this?

I have no preference, either patch works for me.
