From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 6/9] tests: py: add ct helper tests
Date: Wed, 15 Mar 2017 12:46:41 +0100
Message-ID: <20170315114641.GD24366@breakpoint.cc>
References: <20170314195816.1721-1-fw@strlen.de>
 <20170314195816.1721-7-fw@strlen.de>
 <20170315103933.GA11143@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45666 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753905AbdCOLrC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 07:47:02 -0400
Content-Disposition: inline
In-Reply-To: <20170315103933.GA11143@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 14, 2017 at 08:58:13PM +0100, Florian Westphal wrote:
> > +%cthelp1 type ct helper { type \"ftp\"\; protocol tcp\; };ok
> 
> Just a minor syntax nitpick here.
> 
> Protocol should be part of the same statement, right? ie.
> 
> { type "ftp" protocol tcp ; }
> 
> It fundamental to achieve a working configuration. You can send a
> follow up patch to amend this, no problem.

No, I'll change this in patch #1 and will respin the series, thanks
Pablo.
