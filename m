From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Fri, 24 Sep 2004 15:40:32 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040924154032.5a0c32e1.davem@redhat.com>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net>
	<20040921171857.2c720c8e.davem@redhat.com>
	<4150D880.70108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4150D880.70108@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004 03:42:24 +0200
Patrick McHardy <kaber@trash.net> wrote:

> The existing scheme has one problem, it takes files->file_lock
> in a BH, but the patch doesn't mean to fix this. Besides
> this, it works fine. The patch extends the owner match so it
> can also be used in the input path, where skb->sk isn't set.
> This is quite useful for filtering input traffic based on user
> etc., unfortunately it can't be done without exporting
> {tcp,udp}_v4_lookup. Do you see an alternative to dropping the
> patch ?

I think the scheme is a bit illogical.

Until the actual TCP socket lookup call, you cannot say for sure
what that lookup would result in.

For example, let's say that between where the ipt_owner match
is invoked on input, and the actual call to tcp_v4_rcv(), some
filtering or other packet mangling scheme changes the IP address
or ports.  You're going to get different results in ipt_owner()
than TCP was going to achieve.

It sounds like we want some kind of socket resolution policy check.
It's starting to get rediculious, as we have two filters _already_
in that code path, one for the per-socket BPF style filtering, and
the other for IPSEC.

The IPSEC check is available on output too.

I don't see how it's avoidable to add another condition there.
So what if we had something like:

	NF_SK_HOOK(PF_INET, NF_TCP_IN, sk, skb, skb->dev, NULL,
		   tcp_v4_rcv_finish)

or something along those lines?  Perhaps you can simplify the
argument set even further.
