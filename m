From: Unit Zero <onyx@zero.fdns.net>
Subject: Re: A question about reinjecting packets
Date: Thu, 12 Feb 2004 11:29:50 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0402121114001.845@zero.fdns.net>
References: <20040211155807.GA3146@lain.localnet> <Pine.LNX.4.56L0.0402121032040.759@zero.fdns.net>
 <402BA58D.1030907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <402BA58D.1030907@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Thu, 12 Feb 2004, Patrick McHardy wrote:

> Unit Zero wrote:
> > I actually have been wondering about reinjecting packets for some
> > time...  I've written some test code but had limited success in
> > actually getting the packets out onto the wire. My issue is this: I
> > want to steal outbound packets before they hit the net and use
> > add_timer() to schedule a callback which sends the packet out after a
> > certain delay. (To implement rate-limiting that dosen't drop packets,
> > but delays them when they exceed a certain throughput.)
> 
> This is not possible. If you rate-limit packets you have to drop them at
> some point if the input rate constantly exceeds the service rate.
> Besides, there is not much use in sending packets that have long been
> retransmitted.

Well, the idea would be to delay the next packet of a connection, and drop 
any subsequent packets in that connection that arrive before the first 
packet is finally sent.

Since tcp has flow-control (ACK), there shouldn't 
be more packets coming in until each packet is recieved and a an ACK sent 
back, so delaying a packet would hold up sending more packets while 
waiting for the ACK from the packet which has been delayed, am I wrong? 
Obviously this wouldn't work for UDP.

The effect would be like connecting over a network with really bad lag.

> Why don't you build into the qos subsystem ? It has all the
> infrastructure you need.

That had occurred to me, and I've been trying to find some time to take a 
look at QOS, as I've never actually even used it. I'll take your advice 
and check it out.

Thanks - V. M. Condino
