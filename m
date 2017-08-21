From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 5/7] src: implement shortcut for tcp mss size mangling
Date: Mon, 21 Aug 2017 16:23:30 +0200
Message-ID: <20170821142330.GA740@breakpoint.cc>
References: <20170819231413.15164-1-fw@strlen.de>
 <20170819231413.15164-6-fw@strlen.de>
 <20170821141201.GD6076@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45122 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753206AbdHUO0A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20170821141201.GD6076@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Aug 20, 2017 at 01:14:11AM +0200, Florian Westphal wrote:
> > short-hand version of tcp option maxseg size 1:
> > tcp option mss set 1
> > 
> > Reverse also prints the more compact representation.
> 
> Why not just keep with the shortcut (more compact) representation?

I am not following, what do you suggest?

