From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Mon, 08 Aug 2005 09:59:23 +0900 (JST)
Message-ID: <200508080059.j780xOAE028374@toshiba.co.jp>
References: <42F342B8.7010001@trash.net>
	<20050805130803.GI4245@rama.de.gnumonks.org>
	<42F4C820.7020209@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42F4C820.7020209@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 06 Aug 2005 16:24:32 +0200

> Harald Welte wrote:
> > On Fri, Aug 05, 2005 at 12:43:04PM +0200, Patrick McHardy wrote:
> > 
> >>Pablo Neira wrote:
> >>
> >>>OK, my question is: why do we need to increase the master conntrack
> >>>refcount for expectations, if they are always killed first? Actually I
> >>>think that the master conntrack refcount should be increased once the
> >>>expectation is confirmed but not in ip_conntrack_expect_alloc.
> >>
> >>Only outstanding expectations are removed by remove_expectations().
> >>The fullfilled ones need the reference for stuff like
> >>ip_nat_follow_master.
> > 
> > So Pablo's argument stil upholds... in theory it would be sufficient to
> > increase the master refcount when expectation is fulfilled(confirmed)
> > instead of allocation time.  Or am I missing something?
> 
> No, it is possible, but we do take a reference in expect_alloc, and I
> don't see the point of obscuring the reference counting by increasing
> the count at a later point in time.

This refcounts handling has other issue of deadlock.
ip_conntrack_expect_put() is called while holding nf_conntrack_lock
by ip_conntrack_expect_related() and ip_conntrack_helper_unregister().
In logical, this may result in deadlock in destroy_conntrack() destroying
master of expectation.

I cannot find the case that refcounts of conntrack become 0 by
ip_conntrack_expect_put() because expectations seems to be destroyed
earlier than conntrack. But Pablo and Harald idea will solve this issue if
deadlock is really possible.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
