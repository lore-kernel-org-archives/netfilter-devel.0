From: Patrick McHardy <kaber@trash.net>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Thu, 11 Aug 2005 16:40:32 +0200
Message-ID: <42FB6360.9010003@trash.net>
References: <200508100111.j7A1Bok9010084@toshiba.co.jp>
	<20050811133545.GI4130@rama.de.gnumonks.org>
	<20050811135135.GJ4130@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050811135135.GJ4130@rama.de.gnumonks.org>
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

Harald Welte wrote:
> Looking at it again, and doing some tests: The current code works,
> /proc/slabinfo shows me there is no expectation leak.
> 
> This is because the reference count is also put two times:  in
> unlink_expect, and in expectation_timed_out().  Almost all over the
> place, first unlink_expect() drops the first refcount, and
> ip_conntrack_espect_put() is called explicitly to drop the second.
> 
> So yes, one count seems to be for the timer, the second one for
> ip_conntrack_expect_list.  Two references.

Correct.

> I think it would be possible to remove the second atomic_inc() and all
> the ip_conntrack_put() that immediately follow ulink_expect() - but
> would it be worth the effort?  Isn't it an over-optimization that is
> likely to cause bugs later on?

There is one spot where it isn't possible, in find_expectation
the timer reference isn't dropped but returned to the caller.
Changing it would either require a special version of unlink_expect
or an additional atomic_inc in this function. I don't think its
worth the trouble, we do take two references so this seems the
cleanest way to me.
