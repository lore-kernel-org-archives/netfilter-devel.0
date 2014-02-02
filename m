From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: A conntrack, which is added via ctnetlink, can provoke a race
 condition
Date: Mon, 3 Feb 2014 00:41:55 +0100
Message-ID: <20140202234155.GA6616@localhost>
References: <CANaxB-wntm+Vu5z0k9bRYLvPX3ezFZSEQkGPGH3AVYDT5DrOKw@mail.gmail.com>
 <20140107123200.GE9894@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Wagin <avagin@gmail.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, vvs@openvz.org,
	Cyrill Gorcunov <gorcunov@openvz.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47128 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaBBXmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Feb 2014 18:42:01 -0500
Content-Disposition: inline
In-Reply-To: <20140107123200.GE9894@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 07, 2014 at 01:32:00PM +0100, Florian Westphal wrote:
> Andrey Wagin <avagin@gmail.com> wrote:
> > When a conntrack is created  by kernel, it is initialized (sets
> > IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
> > is added in hashes (__nf_conntrack_hash_insert), so one conntract
> > can't be initialized from a few threads concurrently.
> > 
> > ctnetlink can add an uninitialized conntrack (w/o
> > IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
> > this conntrack and start initialize it concurrently. It's dangerous,
> > because BUG can be triggered from  nf_nat_setup_info.
> 
> Good catch.
> 
> I don't see a good solution at the moment.
> 
> We can force null bindings if no nat transformation is specified
> from userspace.  But this would mean that rules specified in the nat
> table are not evaluated anymore when the first packet arrives.

conntracks that are added via ctnetlink should already include the nat
information (if any) at creation time, this is how it works with
state-sync via conntrackd when nat is present. I think attaching the
null binding seems like the easier solution to me.
