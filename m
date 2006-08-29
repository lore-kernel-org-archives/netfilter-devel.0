From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Tue, 29 Aug 2006 07:23:01 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9E7@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Greg Scott" <GregScott@InfraSupportEtc.com>,
	"Patrick McHardy" <kaber@trash.net>
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

I sent this out last night but it never posted to the list.  This might
be because the output from /proc/net/ip_conntrack was so huge.  I will
cut out the parts I don't think are relevant and try posting this again.

- Greg Scott
=20

-----Original Message-----
From: Greg Scott=20
Sent: Monday, August 28, 2006 9:24 PM
To: 'Patrick McHardy'
Cc: netfilter-devel@lists.netfilter.org; Mike McRae
Subject: RE: Troubeleshooting a PPTP conversation

Here is another tcpdump trace and /proc/net/ip_conntrack.  I grabbed
this while an end user was unsuccessfully trying to establish a PPTP
connection.  Holey moley!  That ip_conntrack output is huge!
aaa.bbb.212.154 is the firewall outside IP Address.  My remote end user
is at 208.186.13.120. =20

So this picture looks like this:

---NAT--208.186.13.120 <--> Internet <--> Firewall  Win2k PPTP
  Home                               aa.bb.212.153    10.13.1.22
  Gateway

My remote user is behind his NAT home gateway.=20

Searching for that IP Address in the massive pile of output from
ip_conntrack, I see a TIME_WAIT connection and another ESTABLISHED one
from that IP Address.  I wonder if that Win2K system isn't dropping them
appropriately?  But the problem only happens to some people.  Others can
connect, drop the connection, and then connect right back up again
without problem.  But this one end user can never seem to get connected
back up again.  Very strange!

- Greg Scott
=20

[root@lakeville-fw gregs]#=20
[root@lakeville-fw gregs]# /usr/sbin/tcpdump -i eth0 host
208.186.13.120 -nn
tcpdump: verbose output suppressed, use -v or -vv for full protocol
decode
listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
20:59:23.621944 IP 208.186.13.120.60465 > aaa.bbb.212.154.1723: S
3486358872:3486358872(0) win 16384 <mss 1460,nop,nop,sackOK>

20:59:23.622067 IP aaa.bbb.212.154.1723 > 208.186.13.120.60465: S
84269208:84269208(0) ack 3486358873 win 65535 <mss 1460,nop,nop,sa
ckOK>

20:59:23.670009 IP 208.186.13.120.60465 > aaa.bbb.212.154.1723: P
1:157(156) ack 1 win 17520: pptp CTRL_MSGTYPE=3DSCCRQ PROTO_VER(1.0)
 FRAME_CAP(A) BEARER_CAP(A) MAX_CHAN(0) FIRM_REV(2600) [|pptp]

20:59:23.670266 IP aaa.bbb.212.154.1723 > 208.186.13.120.60465: P
1:157(156) ack 157 win 65379: pptp CTRL_MSGTYPE=3DSCCRP PROTO_VER(1.
0) RESULT_CODE(1) ERR_CODE(0) FRAME_CAP(S) BEARER_CAP(DA) MAX_CHAN(0)
FIRM_REV(2195) [|pptp]

20:59:23.721103 IP 208.186.13.120.60465 > aaa.bbb.212.154.1723: P
157:325(168) ack 157 win 17364: pptp CTRL_MSGTYPE=3DOCRQ CALL_ID(604
66) CALL_SER_NUM(51973) MIN_BPS(300) MAX_BPS(100000000) BEARER_TYPE(Any)
FRAME_TYPE(E) RECV_WIN(64) PROC_DELAY(0) PHONE_NO_LEN(0) [|
pptp]

20:59:23.722213 IP 10.13.1.22.1723 > 208.186.13.120.60465: P
84269365:84269397(32) ack 3486359197 win 65211: pptp CTRL_MSGTYPE=3DOCRP =

CALL_ID(33767) PEER_CALL_ID(60465) RESULT_CODE(1) ERR_CODE(0)
CAUSE_CODE(0) CONN_SPEED(14808325) RECV_WIN(16384) PROC_DELAY(0) PHY_C
HAN_ID(0)

20:59:26.045245 IP 208.186.13.120.60465 > aaa.bbb.212.154.1723: P
157:325(168) ack 157 win 17364: pptp CTRL_MSGTYPE=3DOCRQ CALL_ID(604
66) CALL_SER_NUM(51973) MIN_BPS(300) MAX_BPS(100000000) BEARER_TYPE(Any)
FRAME_TYPE(E) RECV_WIN(64) PROC_DELAY(0) PHONE_NO_LEN(0) [|
pptp]

20:59:26.045435 IP aaa.bbb.212.154.1723 > 208.186.13.120.60465: . ack
325 win 65211

20:59:26.176209 IP aaa.bbb.212.154.1723 > 208.186.13.120.60465: P
157:189(32) ack 325 win 65211: pptp CTRL_MSGTYPE=3DOCRP CALL_ID(3376
7) PEER_CALL_ID(60466) RESULT_CODE(1) ERR_CODE(0) CAUSE_CODE(0)
CONN_SPEED(14808325) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)

20:59:26.340630 IP 208.186.13.120.60465 > aaa.bbb.212.154.1723: . ack
189 win 17332

10 packets captured
20 packets received by filter
0 packets dropped by kernel
[root@lakeville-fw gregs]# cat /proc/net/ip_conntrack
tcp      6 333337 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1307
dport=3D1038 packets=3D113 bytes=3D89410 [UNREPLIED] src=3D10.17.1.1
54 dst=3D10.13.1.22 sport=3D1038 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1

.
. (lots of entries cut out)
.

tcp      6 281480 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2434
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2434 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 33 TIME_WAIT src=3D208.186.13.120 dst=3Daaa.bbb.212.154
sport=3D60462 dport=3D1723 packets=3D11 bytes=3D992 src=3D10.13.1.22 =
dst=3D208.18
6.13.120 sport=3D1723 dport=3D60462 packets=3D9 bytes=3D608 [ASSURED] =
mark=3D0
use=3D1
tcp      6 419204 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D135
dport=3D2310 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.11.1.153 ds
t=3D10.13.1.22 sport=3D2310 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1

.
. (12 entries chopped out)
.

tcp      6 407809 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D2025 packets=3D32 bytes=3D16582 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D2025 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 431997 ESTABLISHED src=3D208.186.13.120 dst=3Daaa.bbb.212.154
sport=3D60465 dport=3D1723 packets=3D8 bytes=3D856 src=3D10.13.1.22 =
dst=3D2
08.186.13.120 sport=3D1723 dport=3D60465 packets=3D7 bytes=3D512 =
[ASSURED]
mark=3D0 use=3D1
tcp      6 404467 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1108 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D1108 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1

.
. (Zillions more entries chopped out)
.

tcp      6 404447 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1107 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D1107 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404178 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2925 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D2925 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
[root@lakeville-fw gregs]#  =20

=20

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
