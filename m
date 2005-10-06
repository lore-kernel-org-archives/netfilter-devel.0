From: "David S. Miller" <davem@davemloft.net>
Subject: Re: BUG() in ip_ct_event_cache_flush()?
Date: Thu, 06 Oct 2005 13:14:08 -0700 (PDT)
Message-ID: <20051006.131408.24379607.davem@davemloft.net>
References: <20051005.234046.88863607.davem@davemloft.net>
	<20051007040906.GC5953@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007040906.GC5953@rama>
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

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 7 Oct 2005 06:09:06 +0200

> On Wed, Oct 05, 2005 at 11:40:46PM -0700, David S. Miller wrote:
> > 
> > I've seen an OOPS backtrace with current 2.6.x kernels
> > that seems to be in ip_ct_event_cache_flush().
> 
> :( do you have the oops/backtrace?

It's in a Fedora bug report here:

http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=169981

> Mh, but what happens if we take offline a cpu?  Let's say the event
> cache is used on four cpus, but then one cpu goes offline.  Ideally, we
> would still flush the event cache for that cpu that now has become
> offline, since otherwise we loose the event.

Right.

> According to the documentation in include/cpumask.h, "for_each_cpu"
> actually iterates over 'num_possible_map'.  So how would we end up with
> a "non-possible" cpu, according to your comment?

Good point.  I'm just throwing out ideas :-)

The reporter is running an SMP AMD64 kernel on a laptop, FWIW.
