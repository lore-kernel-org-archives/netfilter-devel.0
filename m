From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Routing decision?
Date: Thu, 18 Sep 2003 13:22:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309181320030.20799-100000@filer.marasystems.com>
References: <3F6960B5.6050303@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <dev@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F6960B5.6050303@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 18 Sep 2003, Wim Ceulemans wrote:

> Wouldn't the firewall be more predictable if the routing decision was 
> always taken after the packet travels through the OUTPUT chain, even if 
> it was a packet originating from an unbound socket? In that way the 
> diagram in the netfilter tutorial would be true in all cases, and also if
> advanced routing with the ip command is used, it would work with all 
> packets (originating from bound or unbound sockets).

The routing takes place before OUTPUT on unbound sockets as it is the 
routing table who decides the source IP address to use if the socket is 
unbound, and it is impossible to create the packet without having the 
source address.

> Of course for packets originating from unbound sockets this would lead 
> to the fact that the routing decision code is gone through twice, but 
> the first time only for determining the source address, and the second 
> time to be able to re-route the packet to another interface (based on 
> marks set in the output chain).

Yes, and this is what happens when it is needed.

The kernel uses routing before output to find the source IP address.

Then when iptables changes the packet in such manner that the routing may 
change it calls the routing again, but only if the packet is modified by 
iptables.

If there is no changes in the packet details iptables does not call 
routing again as it can be assumed the result will be the same as in the 
first call.

Regards
Henrik
