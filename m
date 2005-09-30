From: Amin Azez <azez@ufomechanic.net>
Subject: Re: snat bridge routes reply packets
Date: Fri, 30 Sep 2005 10:56:40 +0100
Message-ID: <433D0BD8.2060601@ufomechanic.net>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>
	<Pine.LNX.4.61.0509291616520.2673@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0509291616520.2673@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> If you do not reroute DNAT:ed packets then the bridge would deliver the
> packet to the original destination MAC, not to the local host.
> 
> Same applies if you DNAT within the local subnet.

I probably didn't make clear that I was looking at changing kernel
behaviour, not looking for iptables rules.

Oh; well that was the bit I was going to change. One of the bridgeing
code output functions (whose name I forget for now) was the trick;

>>> Yes, in MASQUERADE type flows where the firewall SNATs flows to it's own
>>> address it might be possible in certain cases to remember the original
>>> "client" MAC address, and avoid the ARP:ing on return traffic. But this
>>> is on the assumption that the client network is symmetric. It is
>>> possible the traffic was received via an assymetric route where return
>>> traffic should go to another MAC address and ARP is required to figure
>>> this out.
>>
>>
>> Yes, this is a strong assumption, we would only do this when snat-ing
>> bridged traffic. There may be assymetric bridging which would break, but
>> then snat is already broken for bridging.
> 
> 
> I would not agree. Both SNAT and DNAT works just fine in bridgeing
> assuming the IP level is properly set up to support the addresses used.

I agree, but pure bridging also works without this assumption and it
could work with snat bridging.

> You can not SNAT to an otherwise non-existing IP as there then is no MAC
> address for the receiving host to sent the replies to (no ARP answer
> when the receiving host wants to send reply packets, so it can't).

This is the problem I intend to solve

>   - Don't reroute the packet at all. All MAC addressing is preserved
> as-is on each packet. (relevant to both normal IP level iptables and
> bridgeing)
> 
>   - Track the initiating source MAC address, and reroute at MAC level
> all packets in the reply direction to this address. (only relevant to
> bridgeing). But route packets in the forward direction. **

I did say in my first post that my conntrack mods are already tracking
the mac address and phsedv of the originating packet; this is what I was
planning to do.

> 
>   - Reroute all NAT:ed packets. (the default, what we have today).
> 
> One drawback of the proposed solution is that conntrack needs to be
> extended with MAC addressing in each direction.

already got it, and afact nf_netfilter already does much in this
direction anway.

Sam
