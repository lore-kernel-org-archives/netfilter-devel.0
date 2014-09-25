From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 17:04:16 +0200
Message-ID: <20140925150416.GC26716@breakpoint.cc>
References: <20140925113237.GC25548@breakpoint.cc>
 <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu>
 <20140925125748.GA26716@breakpoint.cc>
 <alpine.DEB.2.10.1409251535470.14369@blackhole.kfki.hu>
 <20140925141314.GB26716@breakpoint.cc>
 <alpine.DEB.2.10.1409251626160.14369@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52100 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbaIYPES (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:04:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409251626160.14369@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> Without conntrack, you don't have NAT.

Right.

> Without conntrack, you don't have a direction. So how do you controll who 
> may initiate the connection for the protocols which are covered by the 
> generic tracker? We don't have any match for that.

Fair enough,  I'll add autoprobing for the generic tracker instead.

> The generic tracker can know which protocols have an own tracker and when 
> it's not available can refuse to track that flow (like the proposed patch 
> but selectively, just in this very case).

OK.  I think this is acceptable compromise.

> Exploitable modules can be blacklisted temporarily, while the fix is not 
> available. With a generic tracker which refuses to track protocols with 
> own trackers, the current security issue is not opened up.

Right, thanks Jozsef.

> NEW and ESTABLISHED states, which means directions and thus policies.
> Those are all lost without the generic tracker.

Yes, that and loss of NAT are sound arguments.

Cheers,
Florian
