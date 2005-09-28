From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: snat bridge routes reply packets
Date: Wed, 28 Sep 2005 21:56:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>
References: <dhef0t$mj3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <dhef0t$mj3$1@sea.gmane.org>
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

On Wed, 28 Sep 2005, Amin Azez wrote:

> I have a bridge setup snat'ing some IP's that aren't actually on the
> bridge subnet.
>
> That works fine except that the nat code doesn't know what to do with
> the de-snat'd packets and tries to send them to the default gateway.
>
> This makes sense, but it's routing, not bridging.

As soon as you NAT a packet in bridge-netfilter it is intercepted and 
given to routing, no longer bridged. This to allow REDIRECT and a number 
of other highly interesting applications of NAT.

Yes, this causes a bit of headache if your bridge does not have correct 
routing, but it's a fairly small price to pay for a wealth of interesting 
functionality which would not be possible if the bridge did not reroute 
packets after applying NAT.

At a first glance one could think that SNAT would not need to do this, but 
then you realize that by SNAT:in you break the IP-MAC relation of the 
traffic flow, especially in the return direction which is a DNAT 
operation.  Doing DNAT without rerouting does not make much sense as the 
packets would then still be delivered to the same destination MAC, and 
things like REDIRECT would not be possible.

> 1) Am I nuts?

No. Just on a different angle than how the bridge-netfilter integration is 
designed wrt NAT.

Regards
Henrik
