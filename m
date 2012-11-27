From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 15:13:17 +0100
Message-ID: <20121127141317.GB9089@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab2K0ON2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:13:28 -0500
Content-Disposition: inline
In-Reply-To: <20121127130904.GB14156@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 02:09:04PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > For the update case, I think we'll have to iterate over the mask and
> > > > use xchg to update words, thus, we avoid any interference ongoing bit
> > > > testing.
> > > 
> > > Could you elaborate?
> > > Why is memcpy not good enough here?
> > 
> > while updating the connlabel via memcpy, some test_bit on the
> > connlabel may be already happening. I was suggesting some way to avoid
> > racing with it.
> 
> I don't understand why its racing.
> 
> Is there a case where we update a word, and test_bit can return
> "bit is set", even if the bit in the word is neither currently
> set nor about to be set?
> 
> If not, then I don't see the race; either the test happens
> before we copied the word, or afterwards; regardless of copy vs.
> xchg?

I was thinking on the case in which we are setting bits via the
connlabel extension and modifying this from ctnetlink at the same
time.

But I don't see any way to make it any better, I think your approach
is fine for the update case.
