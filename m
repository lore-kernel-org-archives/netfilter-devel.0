From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Tue, 27 Nov 2012 14:09:04 +0100
Message-ID: <20121127130904.GB14156@breakpoint.cc>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50042 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab2K0NJH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:09:07 -0500
Content-Disposition: inline
In-Reply-To: <20121127123149.GA2351@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > For the update case, I think we'll have to iterate over the mask and
> > > use xchg to update words, thus, we avoid any interference ongoing bit
> > > testing.
> > 
> > Could you elaborate?
> > Why is memcpy not good enough here?
> 
> while updating the connlabel via memcpy, some test_bit on the
> connlabel may be already happening. I was suggesting some way to avoid
> racing with it.

I don't understand why its racing.

Is there a case where we update a word, and test_bit can return
"bit is set", even if the bit in the word is neither currently
set nor about to be set?

If not, then I don't see the race; either the test happens
before we copied the word, or afterwards; regardless of copy vs.
xchg?
