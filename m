From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: RE : RE : Apply rules to 1 UDP port but port used as a socket: possible?
Date: Wed, 11 Feb 2004 16:48:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB5D4@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

For the moment I need an UDP socket. After treatment, I want the =
following packets to be NATed. If I inspect these packets thanks to =
QUEUE target(passing to userspace, isn't it?) I don't know what will =
permit to apply NAT rules... I don't understand exactly what you mean ?

> Once a single packet of the session has gone by nat PREROUTING the=20
> destination-NAT of that session is fixed and can not be changed.
No packets arrive to my nat PREROUTING rule.

So your solution is to use libipq after a rule like this:

iptables -t mangle -A PREROUTING -p udp -s REMOTE_ADDR --sport =
REMOTE_PORT -d LOCAL_ADDR --dport 1727 -j QUEUE

Is it what you mean ?

In this way I can inspect the packet in userspace. Do you want to say I =
do the NAT in the userspace ?=20
Then I can do setVerdict() to go back to kernelspace or to drop it.

But if conntrack is already set up, packets won't arrive to mangle =
PREROUTING, isn't it ?


Thanks a lot, I hope we will continue to discuss this point.. It's still =
a bit confused for me.


-----Message d'origine-----
De : Henrik Nordstrom [mailto:hno@marasystems.com]=20
Envoy=E9 : mercredi 11 f=E9vrier 2004 12:54
=C0 : zze-Proxy GRALL O ext FTRD/SVA/LAN
Cc : netfilter-devel@lists.netfilter.org
Objet : Re: RE : Apply rules to 1 UDP port but port used as a socket: =
possible?


On Wed, 11 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> I think that receiving on the UDP socket set the table Conntrack =20
> after the packet passed into the table Filter for the hook INPUT:

The conntrack is created immediately when the packet arrives at the box.

But the destination-NAT is only set in nat PREROUTING.

Once a single packet of the session has gone by nat PREROUTING the=20
destination-NAT of that session is fixed and can not be changed.

As I said, you should be able to use QUEUE in mangle PREROUTING to =
inspect=20
the first packet before it arrives to nat PREROUTING.

Regards
Henrik
