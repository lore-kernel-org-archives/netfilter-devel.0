From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 07/10] tests: add ip reject with tcp and check for
 mark too
Date: Tue, 16 May 2017 12:40:11 +0200
Message-ID: <20170516104011.GC16290@breakpoint.cc>
References: <20170509155122.26356-1-fw@strlen.de>
 <20170509155122.26356-8-fw@strlen.de>
 <20170516102935.GC19858@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41534 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750795AbdEPKkt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 06:40:49 -0400
Content-Disposition: inline
In-Reply-To: <20170516102935.GC19858@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, May 09, 2017 at 05:51:19PM +0200, Florian Westphal wrote:
> > ... to avoid resetting e.g. the ssh session to the vm that runs
> > nft-test.py.
> 
> Oh, this is breaking your testbed, right? OK, that's fine.

Yes, the ssh session gets re-set during these tests.
