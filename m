From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: netfilter conntrack tcp lock
Date: Tue, 21 Apr 2009 21:20:00 -0700
Message-ID: <20090422042000.GC6948@linux.vnet.ibm.com>
References: <20090421210412.268fc4e7@nehalam>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <dada1@cosmosbay.com>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39722 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZDVEUC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 00:20:02 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3M49gtu029445
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2009 00:09:42 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3M4K1b0165272
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2009 00:20:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3M4K1fm020804
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2009 00:20:01 -0400
Content-Disposition: inline
In-Reply-To: <20090421210412.268fc4e7@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 21, 2009 at 09:04:12PM -0700, Stephen Hemminger wrote:
> Not sure what the performance impact would be but simply changing tcp_lock
> (in nf_conntrack_proto_tcp) to a spin_lock might get a performance boost.
> I thought I heard Paul say read_locks are way slower than spin_lock.

In -rt, read_locks are really exclusive locks.  :-/

And an uncontended read_lock is somewhat slower than a spin_lock,
but not overwhelmingly so.

> Alternatively, going to some form of bit based hash lock might work.

I have to ask the stupid question...  Can conntrack entries be hashed
or otherwise partitioned, with a lock then assigned to each partition?

						Thanx, Paul
