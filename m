From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Ottawa and slow hash-table resize
Date: Mon, 23 Feb 2015 13:52:49 -0800
Message-ID: <20150223215248.GA15405@linux.vnet.ibm.com>
References: <20150223184904.GA24955@linux.vnet.ibm.com>
 <20150223191201.GA4355@cloud>
 <20150223210358.GB806@casper.infradead.org>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: josh@joshtriplett.org, alexei.starovoitov@gmail.com,
	herbert@gondor.apana.org.au, kaber@trash.net, davem@davemloft.net,
	ying.xue@windriver.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:50845 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBWVw4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2015 16:52:56 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Mon, 23 Feb 2015 14:52:56 -0700
Content-Disposition: inline
In-Reply-To: <20150223210358.GB806@casper.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 23, 2015 at 09:03:58PM +0000, Thomas Graf wrote:
> On 02/23/15 at 11:12am, josh@joshtriplett.org wrote:
> > In theory, resizes should only take the locks for the buckets they're
> > currently unzipping, and adds should take those same locks.  Neither one
> > should take a whole-table lock, other than resize excluding concurrent
> > resizes.  Is that still insufficient?
> 
> Correct, this is what happens. The problem is basically that
> if we insert from atomic context we cannot slow down inserts
> and the table may not grow quickly enough.
> 
> > Yeah, the add/remove statistics used for tracking would need some
> > special handling to avoid being a table-wide bottleneck.
> 
> Daniel is working on a patch to do per-cpu element counting
> with a batched update cycle.

One approach is simply to count only when a resize operation is in
flight.  Another is to keep a per-bucket count, which can be summed
at the beginning of the next resize operation.

							Thanx, Paul

