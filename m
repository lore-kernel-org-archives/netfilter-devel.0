From: "dravya" <dravya@magma.ca>
Subject: icmp packets going over wrong link for Local traffic!!!
Date: Wed, 27 Oct 2004 16:51:25 -0400 (EDT)
Sender: netfilter-bounces@lists.netfilter.org
Message-ID: <200410272051.i9RKpPoW018624@webmail2.magma.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Netfilter mailing list <netfilter@lists.netfilter.org>,
	<netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi all,

I have applied the Masquerade patch suggested by Rusty (and now Herbert) and everything
works just fine. All packets are masqueraded correctly even when there are multiple
interfaces.

However, there are icmp dest unreachable messages that still go over the wrong link. i.e.
source addr of the wrong link. Since it is local traffic, it will not go through the
masquerading code as the socket would exist ( (*pskb)->sk ) will exist, thereby returning
with NF_ACCEPT and bypassing the masquerade code. 

Therefore the problem lies someplace else.... has anyone encountered this problem
before??? I know there was a similar issue with arp requests but don't know what came out
of that.

Any tips or suggestions are welcome.

Thanks

Dravya
