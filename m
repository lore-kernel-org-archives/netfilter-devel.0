From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v10)
Date: Mon, 20 Apr 2009 14:58:27 -0700
Message-ID: <20090420215827.GK6822@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <49E72E83.50702@trash.net> <20090416.153354.170676392.davem@davemloft.net> <20090416234955.GL6924@linux.vnet.ibm.com> <20090417012812.GA25534@linux.vnet.ibm.com> <20090418094001.GA2369@ioremap.net> <20090418141455.GA7082@linux.vnet.ibm.com> <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	David Miller <davem@davemloft.net>, kaber@trash.net,
	torvalds@linux-foundation.org, jeff.chua.linux@gmail.com,
	mingo@elte.hu, laijs@cn.fujitsu.com, jengelh@medozas.de,
	r000n@r000n.net, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
To: Paul Mackerras <paulus@samba.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48637 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZDTV6c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:58:32 -0400
Content-Disposition: inline
In-Reply-To: <18924.59347.375292.102385@cargo.ozlabs.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 21, 2009 at 07:23:31AM +1000, Paul Mackerras wrote:
> Eric Dumazet writes:
> 
> > OK, but we still have a problem on machines with >= 250 cpus,
> > because calling 250 times spin_lock() is going to overflow preempt_count,
> > as each spin_lock() increases preempt_count by one.
> 
> Huh?  Each cpu has its own separate preempt_count.

But a single CPU is acquiring one lock per CPU, so all the increments
are to one CPU's preempt_count.  :-(

							Thanx, Paul
