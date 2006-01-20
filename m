From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x_tables: fix alignment on [at least] ppc32
Date: Thu, 19 Jan 2006 16:56:35 -0800 (PST)
Message-ID: <20060119.165635.104653932.davem@davemloft.net>
References: <17358.19458.555996.684819@alkaid.it.uu.se>
	<20060118150158.GL4603@sunbeam.de.gnumonks.org>
	<20060120004512.GT4603@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, mikpe@user.it.uu.se
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060120004512.GT4603@sunbeam.de.gnumonks.org>
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
Date: Fri, 20 Jan 2006 01:45:12 +0100

> [NETFILTER] x_tables: Fix XT_ALIGN() macro on [at least] ppc32
> 
> To keep backwards compatibility with old iptables userspace programs,
> the new XT_ALIGN macro always has to return the same value as IPT_ALIGN,
> IP6T_ALIGN or ARPT_ALIGN in previous kernels.
> 
> However, in those kernels the macro was defined in dependency to the
> respective layer3 specifi data structures, which we can no longer do with
> x_tables.
> 
> The fix is an ugly kludge, but it has been tested to solve the problem. Yet
> another reason to move away from the current {ip,ip6,arp,eb}tables like
> data structures.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Harald, I'm going to modify this to just use u_int64_t as that
should be totally sufficient.

It is the largest type, and will produce the desired results without
the silly structure.

Some malloc() implementations use "long double" to figure out the
largest type size and alignment requirements any C type might have
on the machine.  But there is no reason to use that here.
