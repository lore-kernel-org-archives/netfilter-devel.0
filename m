From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Routing decision?
Date: Mon, 15 Sep 2003 18:06:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309151802300.17421-100000@filer.marasystems.com>
References: <3F65DACC.8020706@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <pieter@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F65DACC.8020706@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Sep 2003, Wim Ceulemans wrote:

> If I understand correct, if the local endpoint of the socket is not 
> bound, then:
> 1. The routing decision is taken, and the source IP address is assigned 
> to the IP address of the interface
>     through which the packet would leave the firewall.

Yes. Or to be more precise to the source IP address of the route by which 
the packet would leave the host, or interface address if no route source 
address is defined in the routing table.

> 2. The packet travels through the OUTPUT chain and does not pass the 
> routing decision anymore, because
>      the routing decision was already taken before going to the OUTPUT 
> chain.

Yes.

However on the next packet of the connection (assuming it is a TCP
connection) the situation is the reverse. The local endpoint of the socket
is now bound and there is no need for a routing decision during packet
construction as the source IP address is already know. So now routing
occurs after OUTPUT like it logically should be.

> Is there any specific reason why the packet doesn't pass the routing 
> decision the second time?

Why should it if the routing has already been called once?

iptables does route the packet a second time if you mangle or NAT the
packet.

Regards
Henrik
