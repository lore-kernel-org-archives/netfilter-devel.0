From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RE : RE : RE : RE : Apply rules to 1 UDP port but port used as
 a socket: possible?
Date: Fri, 13 Feb 2004 09:49:14 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402130942150.1845-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E8011CBAA3@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E8011CBAA3@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 13 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> Maybe I wasn't clear at the beginning...
> 
> -I have an UDP socket listening on port 1727.

Ok, sort of.

> -I must receive some (5 to 10) proprietary UDP packets from a Nated client (it's for VoIP...).

Ok.

> -These packets contains an ID that permits me to know the destination (and so the NAT rule to apply) which must be another Nated client.

Ok.
 
> -When I've received the packets from the 2 Nated clients (they are behind a Router), I can apply the NAT rules SNAT+DNAT).

Ok.
 
> -Next packets are RTP or RTCP packets...

Are these also UDP packets with the same source/destination including 
port? If it is then the first packets must be intercepted before they 
reaches nat PREROUTING. As soon as a single packet have passed nat 
PREROUTING it is too late to change the NAT mappings of this session until 
it expires from conntrack.
 
> -My problem was that the rules wasn't applied... And so the socket receives all RTP/RTCP packets.
> 
> Thanks to you :
> 
> -Now I can apply a new rule (mangle table PREROUTING -> QUEUE) after the NAT rules.

mangle is before NAT which is the whole point. By intercepting the packets 
via QUEUE in mangle you can grab the packet before NAT sees the session.

> -I'm building a NetLink socket to receive the packet

Ok.

> -You said last time that the packet (coming from QUEUE) will go to NAT table and will apply my NAT rules.

Yes.

> Maybe I haven't well understood what you said. I wonder wether I shouldn't 
> -not use socket on port 1727,

You have no use of this socket, unless the two traffic streams are 
different in which case none of what we have discussed applies.

> -only intercept the packet with QUEUE target and my handler,

Yes.

> -finally reenter packet in the nat table.

Yes.

> ... That's what you meant maybe ?

Yes.

Regards
Henrik
