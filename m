From: bdschuym@pandora.be
Subject: Re:  Any way of knowing a packet's been defragmented
Date: Thu, 05 Aug 2004 11:30:22 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <W5101410375481091705422@asteria.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: shemminger@osdl.org,
	"netfilter-devel" <netfilter-devel@lists.netfilter.org>,
	"bridge" <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>,
	"Bart De Schuymer" <bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>Van
: Henrik Nordstrom [mailto:hno@marasystems.com]
>Verzonden
: donderdag
, augustus
 5, 2004 07:55 AM
>Aan
: 'Bart De Schuymer'

>The question on why the bridge needs to drop oversized fragments instead=
 
>of simply letting iptables fragment them remains...

As Stephen explained, bridge ports of the same bridge device no longer ne=
ed to have the same mtu. So the bridge code needs to drop packets (ARP, I=
P, whatever) that will be too long for the output port.
The whole idea behind the new flag is giving the bridge code enough infor=
mation so it doesn't drop to-be-fragmented packets.

cheers,
Bart
