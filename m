From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: Re: [PATCH] update for ROUTE target in Netfilter-Extension HOWTO
	[ENG][FR]
Date: 20 Sep 2002 16:22:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032531751.3132.51.camel@descartes>
References: <200209201341.g8KDfp84008738@marajade.sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Richardson <mcr@sandelman.ottawa.on.ca>
In-Reply-To: <200209201341.g8KDfp84008738@marajade.sandelman.ottawa.on.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>   I want to be clear here... the ROUTE target lets me change the destinat=
ion
> of a packet to be a specific interface, right?
Right, but the target also directly routes the packet to that interface.
That is, the packet does _not_ traverse the standard linux kernel
routing table, but is sent to the interface.

ASCII art may help :

Packets matching ROUTE target go directly from PREROUTING chain
to the interface.


          Regular routed Packet
---->PRE------>[kernel routes]--->FWD------->POST------>
      |                                            ^
      |                                            |
       `-------------------------------------------'
          Packets matching ROUTE target


Note that, if the interface is a tunnel, then the packet is
encapsulated, and this encapsulated packet then goes
through the OUPUT and POSTROUTING chains.

>   Does it continue through the rest of the table?
No, once the ROUTE target applies for a packet, the packet is 'stolen'.
No further rules are consulted.

> Could I, for instance, add QoS tags, or other stuff to it?
You can always mark a packet, add QoS tags and then, use
the ROUTE target applying on the marked packets.

> Could a later rule override the ROUTE again?
See 2nd question.

>   This is ideal for future FreeSWAN use.
If you tell me what exactly the problem is, I can even
add some features to help for this ;)

>   I agree that the interaction with NAT is confusing at present.=20
The ROUTE target is now to be inserted in the mangle table.
This means that the ROUTE target applies before NAT (mangle
table has higher priority than nat table, but lower than
conntrack table).
So there is no longer interactions with the NAT.

C=E9dric
