From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 19:59:20 +0200
Message-ID: <20170510175920.GG16263@breakpoint.cc>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
 <20170510115748.GE16263@breakpoint.cc>
 <20170510143946.GX20805@orbyte.nwl.cc>
 <20170510145437.GA17305@breakpoint.cc>
 <20170510151131.GY20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48798 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753683AbdEJR7v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 13:59:51 -0400
Content-Disposition: inline
In-Reply-To: <20170510151131.GY20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> > I don't find it ugly, but alternatively we could add a new type of info
> > sent at the beginning of the commit phase (before all the table/rule etc
> > updates) and include it there.
> 
> You mean as a separate netlink message? Then we would have to map that
> message to the actual notification, no? Or do you think it's sufficient
> to cache the last PID/name received and use it for the monitor messages
> until an update to them comes in?

I didn't check yet but all the notifications should contain the current
generation id and we also send a genid update after a transaction is
done so I suspect its enough to emit the name once per transaction.
