From: Florian Westphal <fw@strlen.de>
Subject: Re: A conntrack, which is added via ctnetlink, can provoke a race
 condition
Date: Tue, 7 Jan 2014 13:32:00 +0100
Message-ID: <20140107123200.GE9894@breakpoint.cc>
References: <CANaxB-wntm+Vu5z0k9bRYLvPX3ezFZSEQkGPGH3AVYDT5DrOKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>, vvs@openvz.org,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Florian Westphal <fw@strlen.de>
To: Andrey Wagin <avagin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55160 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaAGMcE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:32:04 -0500
Content-Disposition: inline
In-Reply-To: <CANaxB-wntm+Vu5z0k9bRYLvPX3ezFZSEQkGPGH3AVYDT5DrOKw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andrey Wagin <avagin@gmail.com> wrote:
> When a conntrack is created  by kernel, it is initialized (sets
> IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
> is added in hashes (__nf_conntrack_hash_insert), so one conntract
> can't be initialized from a few threads concurrently.
> 
> ctnetlink can add an uninitialized conntrack (w/o
> IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
> this conntrack and start initialize it concurrently. It's dangerous,
> because BUG can be triggered from  nf_nat_setup_info.

Good catch.

I don't see a good solution at the moment.

We can force null bindings if no nat transformation is specified
from userspace.  But this would mean that rules specified in the nat
table are not evaluated anymore when the first packet arrives.

The only other solution is see is full serialization
via ct->lock.
