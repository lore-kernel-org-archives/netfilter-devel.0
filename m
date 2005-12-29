From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Kernel build suspicious warnings 2.6.14-5, iptables 1.3.4,
 POM-20051227
Date: Thu, 29 Dec 2005 02:30:15 -0800 (PST)
Message-ID: <20051229.023015.107692726.davem@davemloft.net>
References: <925A849792280C4E80C5461017A4B8A26D41@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: GregScott@InfraSupportEtc.com
In-Reply-To: <925A849792280C4E80C5461017A4B8A26D41@mail733.InfraSupportEtc.com>
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

From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Date: Thu, 29 Dec 2005 00:44:02 -0600

> These are only warnings but they make me suspicious.  Should I be
> worried?  Could the warnings below be because something in the kernel
> calls the modules in question but the modules haven't been built yet?
> But why would anything in the inline kernel call an optional module
> loaded from POM?  I've run into several errors getting this far.  I'll
> try a "make mrproper" and then "make all" to build it all from scratch
> now and see what happens.  

That tarpit module, as mentioned here by myself in a posting
from last week, is broken and is depending on a symbol that
is not exported for a reason.

To reiterate: It is trying to get the ttl to use in outgoing
ipv4 frames from the sysctl, but that should instead be obtained
from the routing metrics.
