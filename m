From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 12:57:10 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040127103917.GC11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004, Harald Welte wrote:

> I also disagree that an ESP packet should be trated as locally
> generated (and thus iterate over OUTPUT).

I partly, but at the same time it becomes somewhat complex when making 
firewalling policies when not.

For me it is easier to grasp what is happending with the packet if it is 
viewed like the original packet is forwarded to the ipsec engine and the 
ipsec engine then generates a new packet.

This is very different from NAT as ESP/AH is a complete protocol 
transformation where the resulting packet does not resemble the original 
packet in any manner. This is also very much visible to conntrack where 
the original packets needs to be tracked as one connection while the ipsec 
gateway<->gateway traffic needs to be a separate connection.  IPSec is 
essentially a tunneling protocol, tunneling IP packets over an encrypted 
connection. The tunnel endpoints are the IPSec gateways.

Even in the Host<->Host IPSec case the tunnel view is most appropriate. As
soon as the packets enter the IPSec encapsulation they loose all the
relevant propoerties of the original connection and becomes part of the
single IPSec Host <-> IPSec Host connection all packets between these two
IPSec host is transmitted over.

What may be interesting in netfilter is to preserve some kind of
inheritance, allowing "OUTPUT" rules to know important details about the
original packet when seeing an ESP packet.

My view of where hooks should be for IPSec:

(Client) -> Gateway -> (Gateway)

  1. PREROUTING, original client packet
  2. FORWARD, original client packet. Destination the IPSec SPI
  3. POSTROUTING, original client packet. Destination the IPSec SPI
  4. OUTPUT, ESP packet. Preferably with some preserved information about 
the original packet attached.
  5. POSTROUTING, ESP packet.

If the packet is rerouted in POSTROUTING then this should include IPSec
routing. If the new route is to an IPSec SPI then it is. If not then it is
not.

(Gateway) -> Gateway -> (client)

  1. PREROUTING, ESP packet
  2. FORWARD, ESP packet. Destination the IPSec SPI
  3. POSTROUTING, ESP packet. Destination the IPSec SPI.
  4. PREROUTING, decapsulated packet. With reference to the IPSec SPI.
  5. FORWARD, decapsulated packet. With reference to the IPSec SPI.
  6. POSTROUTING, decapsulated packet. With reference to the IPSec SPI.


Host -> (Gateway)

  1. OUTPUT, original packet
  2. POSTROUTING, original packet. Destination the IPSec SPI
  3. OUTPUT, ESP packet. Preferably with some preserved information about
the original packet attached.
  4. POSTROUTING, ESP packet. Preferably with some preserved information 
about the original packet attached.

(Gateway) -> Host
  
  1. PREROUTING, ESP packet.
  2. INPUT, ESP packet.
  3. PREROUTING, Decapsulated packet, with reference to the IPSec SPI
  4. INPUT, Decapsulated packet, with reference to the IPSec SPI


Non-IPSec traffic:

  As is today. There must be no change.


These hooks fits naturally into the concepts of the netfilter hook
principles if IPSec is viewed as a tunneling method, which it in my
opinion is best viewed as. It also fits the requirements for conntrack to
be able to track the different types of connections involved, including
NAT operations on both original and ESP traffic (assuming local NAT
enabled if DNAT is required on ESP).

> generated means more something like: sent via a local userspace process
> using PF_INET sockets.  If we consider a packet after any kind of change 
> as locally-generated, we could argue doing this with NAT'ed packets,
> too.  Please try to convince me, if I'm missing some point.

A NAT:ed connection is still the same connection at the packet level. ESP
moves the packet into a new connection carrying all kinds of packets
between the two IPSec endpoints where this host is one of the endpoints.

> One of the fundamental principles behind netfilter/iptables, especially
> NAT, is it's symmetric behaviour (between incoming and outgoing packets,
> between the hooks, ...).   So with any possible solution, this should be
> kept in mind.

Granted.

> My proposal:
> From conntracks view (and thus from NAT view), there (shuld be?) two
> seperate connections for any given to-be-encapsulated packet:

Ah, we agree! ;-)

The above hook orders should match your expectations I think. Maybe we
don't agree on the use of INPUT/OUTPUT in the case of forwarded client
traffic, but I see no other clean way. These packets are deliberately
addressed to/from this host, not the client, and part of the IPSec
connection they are forwarded over between the two IPSec endpoints,
not the original connection.

I save myself from diging into exacly where the hooks need to be in the
kernel as I have not looked in detail at the 2.6 IPSec implementation, but
I take for granted that several need to be at the corresponding locations
in the IPSec protocol kernel.  I also see it likely there needs to be some 
skb extensions to add the requires SPI tracking information to 
allow rulesets a better view of what is going on (optional).

Without knowing in detail how the 2.6 IPSec policies are maintained I see
a slight risk that the 2.6 IPSec policy implementation maybe can not
easily match the routing expectations, but it should be possible to find a
way to at least give reasonable hook order I think. But there is a risk it
is not possible to reroute packets to/from an IPSec route and the DNAT
capabilities may be somewhat limited in such case until the IPSec kernel
is extended with what may be required to do this cleanly. (i.e.  slightly
more than just inserting the appropriate hooks may be required)

Regards
Henrik
