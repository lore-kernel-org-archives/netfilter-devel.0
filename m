From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack, suspicious RCU usage
Date: Thu, 12 Jan 2012 03:30:44 +0100
Message-ID: <20120112023044.GB12255@1984>
References: <201201111025.50994.hans.schillstrom@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hans Schillstrom <hans.schillstrom@ericsson.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2ALCau (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:30:50 -0500
Content-Disposition: inline
In-Reply-To: <201201111025.50994.hans.schillstrom@ericsson.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 11, 2012 at 10:25:50AM +0100, Hans Schillstrom wrote:
> Hello
> I got this the first time using conntrack -L when there is a lot of traffic.
> It doesn't result in any thing bad yet.
> 
> Is this a know thing ?

No, you have been the first to spot this.

> or should I dig into it..
> 
> I'm running the latest and greatest conntrack / netfilter tools and libs.
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> -------------------------------
> /home/hans/evip.git/kvm/net-next.git/include/net/netfilter/nf_conntrack_l3proto.h:92 suspicious rcu_dereference_check() usage!

We were using rcu in the table dumping time ago, but we had to replace
rcu by spinlocks.

ctnetlink_dump_tuples is used in both RCU context and spinlock
context, this seems to be the problem.

it seems I didn't enable RCU read lock verification in my kernels.
I'll do it to catch up this sort of problems.

thanks for the report.
