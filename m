From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: RE: LAND check: 2.4.20
Date: Tue, 15 Mar 2005 19:29:03 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A26DE@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Content-class: urn:content-classes:message
To: "Cedric Blancher" <blancher@cartel-securite.fr>,
	"Martijn Lievaart" <m@rtij.nl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Cedric/ Martin,

Thanks for the reply. There are a few things you may be missing:-

1. They cannot be in the rule set, unless we can put a rule which says =
for any Source-IP/ Port if destination will be the same value then drop. =
You cannot put the value of every possible IP/port in your rule set. =
Besides as you yourself mentioned the solution you state it may not work =
for all scenarios.

2. The source and destination address may be routed, though the same. So =
from a machine X I could send a packet with source and Destination IP of =
Y.

3. I am not sure which routing code checks for Source IP Address? Can =
you point me to some code (destroy it as a packet with local IP as =
source must be received on loopback)?

The solution as done by most firewalls is to add a simple check in the =
check_tcp and check_udp. I think we need to add this to the iptables =
code.

Thanks,
Vishwas
-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org =
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Cedric =
Blancher
Sent: Tuesday, March 15, 2005 10:23 PM
To: Martijn Lievaart
Cc: netfilter-devel@lists.netfilter.org; Vishwas Manral
Subject: RE: LAND check: 2.4.20

Le mardi 15 mars 2005 =E0 17:42 +0100, Martijn Lievaart a =E9crit :
> They should be in your ruleset or you can use the Linux built in =
routing
> checks.

There are 2 major cases :

	. Packet is seen by a filtering box, then rp_filter should
	  destroy the packet as source is not routed through receiving
	  interface.
	. Packet is received by destination, then routing code will
	  destroy it as a packet with local IP as source must be
	  received on loopback.

I don't think there's a real security issue that implies hardcoding.


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: =
FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
