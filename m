From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Thu, 04 Nov 2004 03:53:38 +0100
Message-ID: <418999B2.3070600@trash.net>
References: <20041102210440.GA1851@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041102210440.GA1851@linuxace.com>
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

Phil Oester wrote:

>About 14 months ago, MASQUERADE target was modified to only flush conntracks
>on interface up/down if the IP address changed [1].  Unfortunately, there were
>a few problems with this change:
>
>1) ina->ifa_address was used as the IP address of the interface for
>   comparison purposes.  This works great for ethernet interfaces
>   since ifa_address and ifa_local are identical.  But on ppp interfaces
>   ifa_address is the address of the remote side, not the local side
>
>2) dev->ifindex was used to determine whether the interface which cycled
>   matches the interface the conntrack is masquerading out.  Again, this
>   works fine for ethernet (static ifindex), but not at all for ppp which
>   uses sequentially increasing interface indexes.  The ifindex associated
>   with pppX increments on each up/down cycle
>
>3) even if #2 were not true, in a scenario where multiple ppp interfaces
>   are utilized, the order in which they are cycled makes the ifindex
>   comparison haphazard
>
>The below patch addresses these issues by returning to the old behavior
>for ppp interfaces: flush all conntracks masquerading out that interface
>on device down.  I can think of no other foolproof way to ensure the proper
>conntracks get destroyed.
>  
>
I think we should revert to the old behaviour for all interfaces.
When MASQUERADE was using a route-lookup for selecting the source
there were good reasons for using MASQUERADE on devices with statically
configured adresses, and some people (like me) still do it today.
Simple adding a second IP address to an interface flushes all
MASQUERADEDED conntracks on the device, which is not very nice.
The optimization was meant for ppp devices anyway, if we can't use
it there I don't see much reason to keep it.

Opinions anyone ?

Regards
Patrick
