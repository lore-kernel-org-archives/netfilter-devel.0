From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: remove timer from ecache
 extension
Date: Tue, 10 Jun 2014 16:57:17 +0200
Message-ID: <20140610145717.GA12398@localhost>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
 <1400751788-7923-3-git-send-email-fw@strlen.de>
 <20140605142549.GA24216@localhost>
 <20140605145640.GC23367@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35157 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaFJO5W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:57:22 -0400
Content-Disposition: inline
In-Reply-To: <20140605145640.GC23367@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

I already told you, your patchset works in my testbed here.

My only doubt still here is the need for the extra bit. I don't find
the scenario that will trigger the problem yet. Some comments:

On Thu, Jun 05, 2014 at 04:56:40PM +0200, Florian Westphal wrote:
> Yes, its recycling.
> IPS_DYING_BIT unset would either mean:
> 
> a) 'This conntrack is dead and redelivery failed.  Resend event, then
> destroy this conntrack'.

OK. In this case the conntrack in located in the dying list.

> OR it can mean
> 
> b) 'This conntrack is being allocated/setup as new connection, the
> flag field was already cleared'.

In this case, the conntrack is placed in the unconfirmed list or the
hashes.

> In the 2nd case, the conntrack_put would be fatal since the work queue
> doesn't own the conntrack (plus the tuple is not dying after all...).

The workqueue operates with conntracks that are placed in the dying
list. If another CPU holds a reference, the use counter is 2, one for
the dying list and another for the reference. The conntrack_put will
either a) release the entry whose event was already delivered or b)
decrement the use counter.

> I've found no way to tell these two conditions apart except via new bit.

I believe the rule: "all dead conntracks have the dying bit set"
always fulfills.

I must be overlooking something... let me know, thanks!
