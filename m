From: "Craig Box" <craig@itpartners.co.nz>
Subject: PPTP conntracking saga continued
Date: Tue, 16 Sep 2003 15:39:39 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <44AD3126A8CE26439BBD21AB2F9CC1D81286D2@commsserver.itpartners.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,

I've been trying to figure out PPTP connection tracking for some time,
and spent half a day battling with old versions of the patches and then
finally got the modules to compile, before reading that Harald has a new
version out due out any day now. =20

If I have a standard kernel.org kernel running iptables/netfilter (no
patch-o-matic patches), I can observe the following behaivour:

* I have a DNAT on the firewall machine to send all VPN traffic (1723
TCP/GRE) to an internal Windows PPTP server
* From inside my LAN I can connect out to any other Windows PPTP server
and establish a connection (the GRE replies are matched by the
connection tracking and sent back to the internal machine, not blindly
routed to the Windows server
* If I disconnect there is a 10 min time out in which I can't connect
from any other machine behind my NAT (understandably; the timeout is
counting down in /proc/net/ip_conntrack) - can someone confirm that this
problem is worked around by the PPTP conntrack patches in p-o-m?

- However -

* If I connect _outward_ to a Poptop VPN server, same network, the
initial GRE replies come back and are DNAT'd to the internal Windows
PPTP server, therefore the connection does not create

I am not sure if this is the fault of Poptop or the connection tracking.
I would assume that, because the conntracking handles Windows servers
right, that Poptop is at fault, and people on this list speak of a
connid patch to Poptop that addresses this (although I can find no other
mention of it.)

Strangely enough, reading poptop's website, their FAQ
(http://poptop.sourceforge.net/dox/qna.html) says:

"The only way to distinguish between those two clients is to filter them
by destination call ID number found in the GRE header. In order for the
client NAT firewall to correctly rewrite the PPTP server's replies,
please check Philip Craig's netfilter pptp helper module available from
the Netfilter CVS server. [..] It will be integrated in KernelMod, but
until then, you'll have to build it yourself"

Are they referring to the same thing as Harald's PPTP conntracking
patch?  Is there indeed a new version (that will compile cleanly against
2.4.22) due out soon?  Is poptop at fault, or is connection tracking?

Thanks in advance for any insight you can give me.

(Please CC me replies as I am not currently on the list)

Thanks,
Craig Box
Hamilton, New Zealand
