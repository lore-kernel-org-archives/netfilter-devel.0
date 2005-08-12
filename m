From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Fri, 12 Aug 2005 10:19:40 +0900 (JST)
Message-ID: <200508120119.j7C1Jfw5012364@toshiba.co.jp>
References: <20050811135135.GJ4130@rama.de.gnumonks.org>
	<42FB6360.9010003@trash.net>
	<20050811192050.GH5353@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050811192050.GH5353@rama.de.gnumonks.org>
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


Hi,

Thanks for clarification.

From: Harald Welte <laforge@netfilter.org>
Date: Thu, 11 Aug 2005 21:20:50 +0200

> On Thu, Aug 11, 2005 at 04:40:32PM +0200, Patrick McHardy wrote:
> 
> > >I think it would be possible to remove the second atomic_inc() and all
> > >the ip_conntrack_put() that immediately follow ulink_expect() - but
> > >would it be worth the effort?  Isn't it an over-optimization that is
> > >likely to cause bugs later on?

Their counters are for timer, and we cannot remove them. But
ip_conntrack_expect_put() 'in' unlink_expect() is for expectation list,
I think we can remove is only it.

> > There is one spot where it isn't possible, in find_expectation
> > the timer reference isn't dropped but returned to the caller.
> > Changing it would either require a special version of unlink_expect
> > or an additional atomic_inc in this function. I don't think its
> > worth the trouble, we do take two references so this seems the
> > cleanest way to me.

Well, I'm afraid of possibility of deadlock because unlink_expect() may
cause to call nf_conntrack_put() while holding ip_conntrack_lock,
in logical. Then I want to remove ip_conntrack_expect_put() in unlink_expect().

Of cause we need to take care of the order of unlink_expect() and
ip_conntrack_expect_put(), to avoid destroying expectation in list.

> I think I'll add some comment to the code explaining why we need to get
> two references.  

If we can avoid deadlock without removing ip_conntrack_put(), I think this is
the cleanet way.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
