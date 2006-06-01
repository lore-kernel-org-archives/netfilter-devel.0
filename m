From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: [LARTC] iptables CLASSIFY and MARK not working?
Date: Thu, 1 Jun 2006 16:09:41 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB25541B@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

THANK YOU!

That solved the problem. I found the file you specified and it was
indeed enabled. After disabling it, it is now working!

=20
Eliot Gable
Certified Wireless Network Administrator (CWNA)
Certified Wireless Security Professional (CWSP)
Cisco Certified Network Associate (CCNA)
CompTIA Security+ Certified
CompTIA Network+ Certified
Network and System Engineer
Great Lakes Internet, Inc.
112 North Howard
Croswell, MI 48422
(810) 679-3395
(877) 558-8324
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Thursday, June 01, 2006 4:02 PM
To: Eliot, Wireless and Server Administrator, Great Lakes Internet
Cc: lartc@mailman.ds9a.nl; Netfilter Development Mailinglist
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> Bridged iptables (ebtables) is not enabled in the kernel and I cannot
> seem to find a variable "bridge-nf-call-iptables" to set with sysctl:
>=20
> wireless-r1 linux # sysctl -w bridge-nf-call-iptables=3D0
> error: "bridge-nf-call-iptables" is an unknown key
>=20
> There is also no /proc/sys/net/*/bridge anything. I assume that means
> this is not something I need to worry about?

Not sure yet, the problem would be created by CONFIG_BRIDGE_NETFILTER,
not ebtables itself. Check for
"/proc/sys/net/bridge/bridge-nf-call-iptables".

I'm actually pretty sure that this is indeed what's causing the problem,
bridge netfilter defers calling the IP POST_ROUTING hook until the
packet was already transmitted over the device (and before it goes
out the underlying device), which means when it hits the CLASSIFY
target it already passed through the qdisc.
