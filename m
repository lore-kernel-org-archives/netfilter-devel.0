From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: [Bridge] Re:  Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 16:53:58 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408051641150.1590@filer.marasystems.com>
References: <C0170D0AF1277849A4B4518034F855DD0CFC54@aiexchange.ai.aiinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Bart De Schuymer <bdschuym@pandora.be>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>, shemminger@osdl.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eble, Dan" <DanE@aiinet.com>
In-Reply-To: <C0170D0AF1277849A4B4518034F855DD0CFC54@aiexchange.ai.aiinet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 5 Aug 2004, Eble, Dan wrote:

> IMO, the driver should not bridge any packets from a device with a
> larger MTU to a device with a smaller MTU, which I suppose is almost the
> same as forbidding such a bridge to be created, but I seem to remember
> Stephen's commenting that the 802 bridge spec says it should be done the
> way it is now.

A bridge dropping large frames is plain bad imho. If such bridge exists on 
an IP network then IP won't work as the bridge kills Path-MTU discovery.

I do understand why this check exists in the bridge code to cover all 
cases, but I question the location. The check should be after all 
netfilter hooks just before the packet is given to the NIC driver, dropped 
on transmit because it can not be sent out on the target media, not 
dropped in "bridge forwarding" because it seems to be bigger than the 
intended target device.  This way the check will see the packets 
refragmented by iptables etc as applicable. This will also make it deal 
better with a number of other cases where packets is modified in netfilter 
hooks to other sizes than the original size.

> If connection tracking is coalescing ethernet packets into a size
> greater than would otherwise be received from a device, then connection
> tracking should be responsible for undoing that damage (where and when,
> I don't know), otherwise the ethernet bridge driver will become a
> monstrosity of stuff unrelated to ethernet.

This is how connection tracking works.

The issue here is that this collides with how the bridge currently is 
dropping large frames, causing the bridge code to think the frame is 
oversized even when conntrack will refragment the packet before it is sent 
out on the wire.

Regards
Henrik
