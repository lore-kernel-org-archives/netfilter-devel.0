From: "David S. Miller" <davem@davemloft.net>
Subject: Re: BUG() in ip_ct_event_cache_flush()?
Date: Fri, 07 Oct 2005 13:09:32 -0700 (PDT)
Message-ID: <20051007.130932.17714748.davem@davemloft.net>
References: <20051007040906.GC5953@rama>
	<20051006.131408.24379607.davem@davemloft.net>
	<20051007213523.GD4719@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007213523.GD4719@rama>
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
Date: Fri, 7 Oct 2005 23:35:25 +0200

> On Thu, Oct 06, 2005 at 01:14:08PM -0700, David S. Miller wrote:
> > 
> > > On Wed, Oct 05, 2005 at 11:40:46PM -0700, David S. Miller wrote:
> > > > 
> > > > I've seen an OOPS backtrace with current 2.6.x kernels
> > > > that seems to be in ip_ct_event_cache_flush().
> > > 
> > > :( do you have the oops/backtrace?
> > 
> > It's in a Fedora bug report here:
> > 
> > http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=169981
> 
> Oh, a fedora kernel.  I received some reports that fedora kernel
> changelog claims to have the event cache fix, but in reality it is not
> applied.  
> People who switched from fedora to a current git kernel have reported
> that the problem has gone away.

That was fixed.  A bug in the fedora .spec file caused the
GIT patch to not get applied, Dave Jones fixed that.

> Anyway, the bug report from the link above talks about 
> 
> Call Trace:<ffffffff88308c29>{:ip_conntrack:ip_conntrack_cleanup+20}
>        <ffffffff88306ab4>{:ip_conntrack:init_or_cleanup+676}
>        <ffffffff80157798>{sys_delete_module+490}
>        <ffffffff801118aa>{syscall_trace_enter+217>
>        <ffffffff8010eb6c>{tracesys+209}
> 
> which seesm to have no relation to the event cahce, but rather some
> module unload problem. Are you sure that bug report is the right one?

Harald, it can be related to the event cache, because ip_conntrack_cleanup()
calls ip_ct_event_cache_flush() which gcc tends to inline.

> mh, I could try that since I'm having a Turion64 notebook... but
> never had the idea to run an smp kernel on it.

Fedora doesn't even build uniprocessor amd64 kernels any longer,
it stops to make any sense these days with so many dual-core et al.
chips out there :-)
