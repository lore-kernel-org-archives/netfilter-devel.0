From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Mon, 28 Aug 2006 14:14:32 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9DB@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
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

The firewall with the RRAS server behind it is using 2.6.17.1.  I am
using 2.4.27 here at my place - one of the remote sites.  Other remote
sites use various combinations of home networking stuff - Netear,
Linksys, etc.  I can get packet traces from some of the other remote
sites if needed.

The problem might not be firewall related - it may be a messed up PPTP
server - but I don't know how PPTP conversations flow.  That packet
trace is telling me a story but I don't know how to read it yet.  I can
get some more traces if needed and I can also capture some
/proc/net/ip_conntrack output later. =20

- Greg Scott


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Monday, August 28, 2006 10:14 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org; Mike McRae
Subject: Re: Troubeleshooting a PPTP conversation

Greg Scott wrote:
> Below are all the rules.  NAT table first, then the filter table, then

> the mangle table.  Apologies in advance if the text wrapping gets=20
> butchered.  There are lots of rules - just search for "1723" and you=20
> will see the relevant ones.
>=20
> I will try another connection and post /proc/net/ip_conntrack tonight=20
> when I get back later today.
>=20
> 10.13.1.22 is a Windows 2000 Microsoft RRAS server behind the
firewall.
> Win2000 - not Win2003.  I was sniffing the Internet side. Eth0 is the=20
> Internet side, eth1 is the LAN.  eth2 is a future DMZ but right now is

> empty.
>=20
> Here is the big picture:
>=20
> My LAN----My Firewall <-Internet-> Lakeville FW --Lakeville LAN and=20
> RRAS Server
>             66.173.97.0/27     aa.bb.212.154      10.13.1.0/24
> 10.13.1.22
>=20
> I have some more data on the problem.  After rebooting both the remote

> and local firewalls, the symptoms stayed the same.  After rebooting=20
> the Microsoft RRAS server at 10.13.1.22, I was able to get a PPTP=20
> connection from my place to Lakeville.  After hanging up, I was not=20
> able to make another connection.  The Microsoft PPTP client keeps=20
> redialing.  I went off and did other stuff and let it redial - and=20
> then between 5 and 10 minutes later, it connected again.
>=20
>=20
>>18:42:15.012881 IP (tos 0x0, ttl 126, id 54977, offset 0, flags [DF],
>>proto: TCP (6), length: 72) 10.13.1.22.1723 > 66.173.97.2.2903
>>: P, cksum 0xaf0c (incorrect (-> 0x4d48), 1787486805:1787486837(32)=20
>>ack
>>1914062599 win 65211: pptp Length=3D32 CTRL-MSG Magic-Cookie=3D1 =
a2b3c4d=20
>>CTRL_MSGTYPE=3DOCRP CALL_ID(999) PEER_CALL_ID(2903)
>>RESULT_CODE(1:Connected) ERR_CODE(0:None) CAUSE_CODE(0)
>>CONN_SPEED(1480832
>>5) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)

Well, one noteable thing is that this packet from the PPtP-Server has an
incorrect checksum, and since it also doesn't have its source address
changed the checksum probably already arrived incorrect on the firewall.
The packet is send again two packets later with the correct address and
checksum, but the callids all look mixed up somehow. What kernel are you
using?
