From: "Daniel Beckham" <danbeck-netfilter-devel@dealnews.com>
Subject: Netfilter won't forward if tcp packets contain large payloads
Date: Fri, 7 Mar 2003 11:38:38 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <02d301c2e4d0$69fd65a0$0a02010a@danbeck>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_02CC_01C2E49E.188A7CD0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter Devel" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_02CC_01C2E49E.188A7CD0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I'm sending this in html format hoping the tcpdump lines won't wrap.  If =
that's a problem for anyone, please let me know and I will resend in =
text only.

I'm encountering a strange issue with my firewall configuration whereas =
tcp packets with large payloads just disappear into the ether.  I've =
gone over my configuration with everyone in the Netfilter User mailing =
list and it appears that my configuration is correct as far as I can =
tell for what I'm trying to do.  I'm wondering if I could be =
encountering a bug of some sort.

To explain my network situation, I'm connecting two private subnets =
through an OpenVPN tunnel.  My local subnet here is 10.1.2.0 and the =
remote private subnet is 10.1.1.0.  The local subnet is behind a =
netfilter firewall providing DNAT/SNAT to the outside world and also =
providing routing through the tunnel.  A abridged version of my firewall =
configuration looks like this:

eth0: public interface to the internet
eth1: private interface to local subnet
tun0: OpenVPN tunnel to remote private subnet

iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -i tap+ -j ACCEPT
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A PREROUTING -d 129.41.69.137 -p all -j DNAT =
--to-destination 10.1.1.7

iptables -t nat -A POSTROUTING -s 10.1.1.7 -p tcp -j SNAT --to =
129.41.69.137
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source =
207.111.175.68

The firewall machine is a RH 7.3 install with kernel 2.4.18.

The problem is that for internal reasons (laptops, administration, =
etc.), I need all traffic headed to our public mail server =
(129.41.69.137) to be routed through the tunnel instead of the public =
interface eth0.

I've attempted handle this by DNAT'ing traffic destined for =
129.41.69.137 to 10.1.1.7 which will be routed to the tunnel and then =
SNAT'ing the traffic back from 10.1.1.7 to 129.41.69.137 after it come =
back from the tunnel.

This appears to work just fine, except that certain protocols were =
failing.  I.e. checking mail over IMAP worked fine, but sending an email =
would die.  Getting directory listings from ftp would work fine, but =
uploading a file would die.

To try to discern the problem, I dumped three interfaces, the local eth1 =
interface where the traffic originated, the tun0 interface on the local =
firewall here and the tun0 interface on the remote VPN endpoint.  Below =
is the output.  =20

>From the data below, it's obvious that any outgoing packets with a full =
payload (the payload size is 1460)
=20
i.e. 09:29:05.797718 10.1.2.10.3969 > 129.41.69.137.smtp: . =
165:1625(1460) ack 125 win 64116 (DF)

never make it to the local tun0 tunnel interface.   This is why incoming =
imap appears to work just fine, but sending mail doesn't.
=20
Again, this seems a bit crazy as my FORWARD chain specifically allows =
any traffic to and from eth1 and tun0 and I'm not even aware of an easy =
way to tell the firewall to drop packets of varying sizes.
=20
Is this a bug?  If not, what on earth is going on?
=20
Thank you,

Daniel Beckham
dealnews.com, Inc.

=20
Tcpdump of an email being sent: =20
 =20
Local side eth1 (private network) interface:
=20
09:29:04.986096 10.1.2.10.3969 > 129.41.69.137.smtp: S =
266730469:266730469(0) win 64240 <mss 1460,nop,nop,sackOK> (DF)
09:29:05.031723 129.41.69.137.smtp > 10.1.2.10.3969: S =
361700781:361700781(0) ack 266730470 win 5840 <mss 1460,nop,nop,sackOK> =
(DF)
09:29:05.032012 10.1.2.10.3969 > 129.41.69.137.smtp: . ack 1 win 64240 =
(DF)
09:29:05.070351 129.41.69.137.smtp > 10.1.2.10.3969: P 1:30(29) ack 1 =
win 5840 (DF)
09:29:05.071015 10.1.2.10.3969 > 129.41.69.137.smtp: P 1:15(14) ack 30 =
win 64211 (DF)
09:29:05.116376 129.41.69.137.smtp > 10.1.2.10.3969: . ack 15 win 5840 =
(DF)
09:29:05.117139 129.41.69.137.smtp > 10.1.2.10.3969: P 30:53(23) ack 15 =
win 5840 (DF)
09:29:05.122880 10.1.2.10.3969 > 129.41.69.137.smtp: P 15:50(35) ack 53 =
win 64188 (DF)
09:29:05.158861 129.41.69.137.smtp > 10.1.2.10.3969: P 53:61(8) ack 50 =
win 5840 (DF)
09:29:05.159354 10.1.2.10.3969 > 129.41.69.137.smtp: P 50:81(31) ack 61 =
win 64180 (DF)
09:29:05.199376 129.41.69.137.smtp > 10.1.2.10.3969: P 61:69(8) ack 81 =
win 5840 (DF)
09:29:05.217234 10.1.2.10.3969 > 129.41.69.137.smtp: P 81:87(6) ack 69 =
win 64172 (DF)
09:29:05.253760 129.41.69.137.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 =
win 5840 (DF)
09:29:05.461468 10.1.2.10.3969 > 129.41.69.137.smtp: . ack 82 win 64159 =
(DF)
09:29:05.489124 129.41.69.137.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 =
win 5840 (DF)
09:29:05.489289 10.1.2.10.3969 > 129.41.69.137.smtp: . ack 82 win 64159 =
(DF)
09:29:05.637796 10.1.2.10.3969 > 129.41.69.137.smtp: P 87:93(6) ack 82 =
win 64159 (DF)
09:29:05.674856 129.41.69.137.smtp > 10.1.2.10.3969: P 82:95(13) ack 93 =
win 5840 (DF)
09:29:05.675104 10.1.2.10.3969 > 129.41.69.137.smtp: P 93:128(35) ack 95 =
win 64146 (DF)
09:29:05.711681 129.41.69.137.smtp > 10.1.2.10.3969: P 95:103(8) ack 128 =
win 5840 (DF)
09:29:05.712122 10.1.2.10.3969 > 129.41.69.137.smtp: P 128:159(31) ack =
103 win 64138 (DF)
09:29:05.760198 129.41.69.137.smtp > 10.1.2.10.3969: P 103:111(8) ack =
159 win 5840 (DF)
09:29:05.760453 10.1.2.10.3969 > 129.41.69.137.smtp: P 159:165(6) ack =
111 win 64130 (DF)
09:29:05.796963 129.41.69.137.smtp > 10.1.2.10.3969: P 111:125(14) ack =
165 win 5840 (DF)
*** the packet size changes here once the email data is being sent to =
the mail server ***
09:29:05.797718 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:05.797843 10.1.2.10.3969 > 129.41.69.137.smtp: . 1625:3085(1460) =
ack 125 win 64116 (DF)
09:29:05.797966 10.1.2.10.3969 > 129.41.69.137.smtp: . 3085:4545(1460) =
ack 125 win 64116 (DF)
09:29:05.797994 10.1.2.10.3969 > 129.41.69.137.smtp: P 4545:4763(218) =
ack 125 win 64116 (DF)
09:29:05.798031 10.1.2.10.3969 > 129.41.69.137.smtp: P 4763:4768(5) ack =
125 win 64116 (DF)
09:29:05.834387 129.41.69.137.smtp > 10.1.2.10.3969: . ack 165 win 5840 =
<nop,nop,sack sack 1 {4545:4763} > (DF)
09:29:05.846822 129.41.69.137.smtp > 10.1.2.10.3969: . ack 165 win 5840 =
<nop,nop,sack sack 1 {4545:4768} > (DF)
09:29:05.847323 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:05.847445 10.1.2.10.3969 > 129.41.69.137.smtp: . 1625:3085(1460) =
ack 125 win 64116 (DF)
09:29:05.847568 10.1.2.10.3969 > 129.41.69.137.smtp: . 3085:4545(1460) =
ack 125 win 64116 (DF)
09:29:06.555338 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:08.195721 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:11.367205 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:17.819496 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)
09:29:30.614817 10.1.2.10.3969 > 129.41.69.137.smtp: . 165:1625(1460) =
ack 125 win 64116 (DF)

=20
Firewall on the local side of the tunnel: (tun0)
=20
09:29:04.986164 10.1.2.10.3969 > 10.1.1.7.smtp: S 266730469:266730469(0) =
win 64240 <mss 1460,nop,nop,sackOK> (DF)
09:29:05.031684 10.1.1.7.smtp > 10.1.2.10.3969: S 361700781:361700781(0) =
ack 266730470 win 5840 <mss 1460,nop,nop,sackOK> (DF)
09:29:05.032048 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 1 win 64240 (DF)
09:29:05.070314 10.1.1.7.smtp > 10.1.2.10.3969: P 1:30(29) ack 1 win =
5840 (DF)
09:29:05.071048 10.1.2.10.3969 > 10.1.1.7.smtp: P 1:15(14) ack 30 win =
64211 (DF)
09:29:05.116340 10.1.1.7.smtp > 10.1.2.10.3969: . ack 15 win 5840 (DF)
09:29:05.117105 10.1.1.7.smtp > 10.1.2.10.3969: P 30:53(23) ack 15 win =
5840 (DF)
09:29:05.122915 10.1.2.10.3969 > 10.1.1.7.smtp: P 15:50(35) ack 53 win =
64188 (DF)
09:29:05.158822 10.1.1.7.smtp > 10.1.2.10.3969: P 53:61(8) ack 50 win =
5840 (DF)
09:29:05.159389 10.1.2.10.3969 > 10.1.1.7.smtp: P 50:81(31) ack 61 win =
64180 (DF)
09:29:05.199339 10.1.1.7.smtp > 10.1.2.10.3969: P 61:69(8) ack 81 win =
5840 (DF)
09:29:05.217269 10.1.2.10.3969 > 10.1.1.7.smtp: P 81:87(6) ack 69 win =
64172 (DF)
09:29:05.253722 10.1.1.7.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 win =
5840 (DF)
09:29:05.461527 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 82 win 64159 (DF)
09:29:05.489089 10.1.1.7.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 win =
5840 (DF)
09:29:05.489324 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 82 win 64159 (DF)
09:29:05.637836 10.1.2.10.3969 > 10.1.1.7.smtp: P 87:93(6) ack 82 win =
64159 (DF)
09:29:05.674820 10.1.1.7.smtp > 10.1.2.10.3969: P 82:95(13) ack 93 win =
5840 (DF)
09:29:05.675137 10.1.2.10.3969 > 10.1.1.7.smtp: P 93:128(35) ack 95 win =
64146 (DF)
09:29:05.711645 10.1.1.7.smtp > 10.1.2.10.3969: P 95:103(8) ack 128 win =
5840 (DF)
09:29:05.712153 10.1.2.10.3969 > 10.1.1.7.smtp: P 128:159(31) ack 103 =
win 64138 (DF)
09:29:05.760162 10.1.1.7.smtp > 10.1.2.10.3969: P 103:111(8) ack 159 win =
5840 (DF)
09:29:05.760485 10.1.2.10.3969 > 10.1.1.7.smtp: P 159:165(6) ack 111 win =
64130 (DF)
09:29:05.796928 10.1.1.7.smtp > 10.1.2.10.3969: P 111:125(14) ack 165 =
win 5840 (DF)
09:29:05.798040 10.1.2.10.3969 > 10.1.1.7.smtp: P 4545:4763(218) ack 125 =
win 64116 (DF)
09:29:05.798086 10.1.2.10.3969 > 10.1.1.7.smtp: P 4763:4768(5) ack 125 =
win 64116 (DF)
09:29:05.834350 10.1.1.7.smtp > 10.1.2.10.3969: . ack 165 win 5840 =
<nop,nop,sack sack 1 {4545:4763} > (DF)
09:29:05.846786 10.1.1.7.smtp > 10.1.2.10.3969: . ack 165 win 5840 =
<nop,nop,sack sack 1 {4545:4768} > (DF)


Remote side of the tunnel: (tun0)
=20
12:08:10.673521 10.1.2.10.3969 > 10.1.1.7.smtp: S 266730469:266730469(0) =
win 64240 <mss 1460,nop,nop,sackOK> (DF)
12:08:10.674685 10.1.1.7.smtp > 10.1.2.10.3969: S 361700781:361700781(0) =
ack 266730470 win 5840 <mss 1460,nop,nop,sackOK> (DF)
12:08:10.718701 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 1 win 64240 (DF)
12:08:10.722990 10.1.1.7.smtp > 10.1.2.10.3969: P 1:30(29) ack 1 win =
5840 (DF)
12:08:10.761777 10.1.2.10.3969 > 10.1.1.7.smtp: P 1:15(14) ack 30 win =
64211 (DF)
12:08:10.762026 10.1.1.7.smtp > 10.1.2.10.3969: . ack 15 win 5840 (DF)
12:08:10.762144 10.1.1.7.smtp > 10.1.2.10.3969: P 30:53(23) ack 15 win =
5840 (DF)
12:08:10.809779 10.1.2.10.3969 > 10.1.1.7.smtp: P 15:50(35) ack 53 win =
64188 (DF)
12:08:10.810126 10.1.1.7.smtp > 10.1.2.10.3969: P 53:61(8) ack 50 win =
5840 (DF)
12:08:10.846437 10.1.2.10.3969 > 10.1.1.7.smtp: P 50:81(31) ack 61 win =
64180 (DF)
12:08:10.851162 10.1.1.7.smtp > 10.1.2.10.3969: P 61:69(8) ack 81 win =
5840 (DF)
12:08:10.905777 10.1.2.10.3969 > 10.1.1.7.smtp: P 81:87(6) ack 69 win =
64172 (DF)
12:08:10.906068 10.1.1.7.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 win =
5840 (DF)
12:08:11.139331 10.1.1.7.smtp > 10.1.2.10.3969: P 69:82(13) ack 87 win =
5840 (DF)
12:08:11.148104 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 82 win 64159 (DF)
12:08:11.177095 10.1.2.10.3969 > 10.1.1.7.smtp: . ack 82 win 64159 (DF)
12:08:11.324853 10.1.2.10.3969 > 10.1.1.7.smtp: P 87:93(6) ack 82 win =
64159 (DF)
12:08:11.325240 10.1.1.7.smtp > 10.1.2.10.3969: P 82:95(13) ack 93 win =
5840 (DF)
12:08:11.363484 10.1.2.10.3969 > 10.1.1.7.smtp: P 93:128(35) ack 95 win =
64146 (DF)
12:08:11.363818 10.1.1.7.smtp > 10.1.2.10.3969: P 95:103(8) ack 128 win =
5840 (DF)
12:08:11.412066 10.1.2.10.3969 > 10.1.1.7.smtp: P 128:159(31) ack 103 =
win 64138 (DF)
12:08:11.412477 10.1.1.7.smtp > 10.1.2.10.3969: P 103:111(8) ack 159 win =
5840 (DF)
12:08:11.447083 10.1.2.10.3969 > 10.1.1.7.smtp: P 159:165(6) ack 111 win =
64130 (DF)
12:08:11.449412 10.1.1.7.smtp > 10.1.2.10.3969: P 111:125(14) ack 165 =
win 5840 (DF)
12:08:11.486836 10.1.2.10.3969 > 10.1.1.7.smtp: P 4545:4763(218) ack 125 =
win 64116 (DF)
=20



------=_NextPart_000_02CC_01C2E49E.188A7CD0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2723.2500" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2>I'm sending this in html format hoping =
the tcpdump=20
lines won't wrap.&nbsp; If that's a problem for anyone, please let me =
know and I=20
will resend in text only.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I'm encountering a strange issue with =
my firewall=20
configuration whereas tcp packets with large payloads just disappear =
into the=20
ether.&nbsp; I've gone over my configuration with everyone in the =
Netfilter User=20
mailing list and it appears that my configuration is correct as far as I =
can=20
tell for what I'm trying to do.&nbsp; I'm wondering if I could be =
encountering a=20
bug of some sort.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>To explain my network situation, I'm =
connecting two=20
private subnets through an OpenVPN tunnel.&nbsp; My local subnet here is =

10.1.2.0 and the remote private subnet is 10.1.1.0.&nbsp; The local =
subnet is=20
behind a netfilter firewall providing DNAT/SNAT to the outside world and =
also=20
providing routing through the tunnel.&nbsp; A abridged version of my =
firewall=20
configuration looks like this:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>eth0: public interface to the =
internet<BR>eth1:=20
private interface to local subnet<BR>tun0: OpenVPN tunnel to remote =
private=20
subnet</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -A FORWARD -i tun+ -j =
ACCEPT<BR>iptables=20
-A FORWARD -i tap+ -j ACCEPT<BR>iptables -A FORWARD -i eth1 -j=20
ACCEPT<BR>iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j=20
ACCEPT</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -t nat -A PREROUTING -d =
129.41.69.137 -p=20
all -j DNAT --to-destination 10.1.1.7</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -t nat -A POSTROUTING -s =
10.1.1.7 -p tcp=20
-j SNAT --to 129.41.69.137<BR>iptables -t nat -A POSTROUTING -o eth0 -j =
SNAT=20
--to-source 207.111.175.68</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The firewall machine is a RH 7.3 =
install with=20
kernel 2.4.18.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The problem is that for internal =
reasons (laptops,=20
administration, etc.), I need all traffic headed to our public mail =
server=20
(129.41.69.137) to be routed through the tunnel instead of the public =
interface=20
eth0.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I've attempted handle this by DNAT'ing =
traffic=20
destined for 129.41.69.137 to 10.1.1.7 which will be routed to the =
tunnel and=20
then SNAT'ing the traffic back from 10.1.1.7 to 129.41.69.137 after it =
come back=20
from the tunnel.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>This appears to work just fine, except =
that certain=20
protocols were failing.&nbsp; I.e. checking mail over IMAP worked fine, =
but=20
sending an email would die.&nbsp; Getting directory listings from ftp =
would work=20
fine, but uploading a file would die.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>To try to discern the problem, I dumped =
three=20
interfaces, the local eth1 interface where the traffic originated, the =
tun0=20
interface on the local firewall here and the tun0 interface on the =
remote VPN=20
endpoint.&nbsp; Below is the output.&nbsp;&nbsp; </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>From the data below, it's obvious that =
any outgoing=20
packets with a full payload (the payload size is 1460)<BR>&nbsp;<BR>i.e. =

09:29:05.797718 10.1.2.10.3969 &gt; 129.41.69.137.smtp: . 165:1625(1460) =
ack 125=20
win 64116 (DF)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>never make it to the local tun0 tunnel=20
interface.&nbsp;&nbsp; This is why incoming imap appears to work just =
fine, but=20
sending mail doesn't.<BR>&nbsp;<BR>Again, this seems a bit crazy as my =
FORWARD=20
chain specifically allows any traffic to and from eth1 and tun0 and I'm =
not even=20
aware of an easy way to tell the firewall to drop packets of varying=20
sizes.<BR>&nbsp;<BR>Is this a bug?&nbsp; If not, what on earth is going=20
on?<BR>&nbsp;<BR>Thank you,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Daniel Beckham<BR>dealnews.com, =
Inc.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;<BR>Tcpdump of an email being =
sent:&nbsp;=20
<BR>&nbsp; <BR>Local side eth1 (private network)=20
interface:<BR>&nbsp;<BR>09:29:04.986096 10.1.2.10.3969 &gt; =
129.41.69.137.smtp:=20
S 266730469:266730469(0) win 64240 &lt;mss 1460,nop,nop,sackOK&gt;=20
(DF)<BR>09:29:05.031723 129.41.69.137.smtp &gt; 10.1.2.10.3969: S=20
361700781:361700781(0) ack 266730470 win 5840 &lt;mss =
1460,nop,nop,sackOK&gt;=20
(DF)<BR>09:29:05.032012 10.1.2.10.3969 &gt; 129.41.69.137.smtp: . ack 1 =
win=20
64240 (DF)<BR>09:29:05.070351 129.41.69.137.smtp &gt; 10.1.2.10.3969: P =
1:30(29)=20
ack 1 win 5840 (DF)<BR>09:29:05.071015 10.1.2.10.3969 &gt; =
129.41.69.137.smtp: P=20
1:15(14) ack 30 win 64211 (DF)<BR>09:29:05.116376 129.41.69.137.smtp =
&gt;=20
10.1.2.10.3969: . ack 15 win 5840 (DF)<BR>09:29:05.117139 =
129.41.69.137.smtp=20
&gt; 10.1.2.10.3969: P 30:53(23) ack 15 win 5840 (DF)<BR>09:29:05.122880 =

10.1.2.10.3969 &gt; 129.41.69.137.smtp: P 15:50(35) ack 53 win 64188=20
(DF)<BR>09:29:05.158861 129.41.69.137.smtp &gt; 10.1.2.10.3969: P =
53:61(8) ack=20
50 win 5840 (DF)<BR>09:29:05.159354 10.1.2.10.3969 &gt; =
129.41.69.137.smtp: P=20
50:81(31) ack 61 win 64180 (DF)<BR>09:29:05.199376 129.41.69.137.smtp =
&gt;=20
10.1.2.10.3969: P 61:69(8) ack 81 win 5840 (DF)<BR>09:29:05.217234=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: P 81:87(6) ack 69 win 64172=20
(DF)<BR>09:29:05.253760 129.41.69.137.smtp &gt; 10.1.2.10.3969: P =
69:82(13) ack=20
87 win 5840 (DF)<BR>09:29:05.461468 10.1.2.10.3969 &gt; =
129.41.69.137.smtp: .=20
ack 82 win 64159 (DF)<BR>09:29:05.489124 129.41.69.137.smtp &gt; =
10.1.2.10.3969:=20
P 69:82(13) ack 87 win 5840 (DF)<BR>09:29:05.489289 10.1.2.10.3969 &gt;=20
129.41.69.137.smtp: . ack 82 win 64159 (DF)<BR>09:29:05.637796 =
10.1.2.10.3969=20
&gt; 129.41.69.137.smtp: P 87:93(6) ack 82 win 64159 =
(DF)<BR>09:29:05.674856=20
129.41.69.137.smtp &gt; 10.1.2.10.3969: P 82:95(13) ack 93 win 5840=20
(DF)<BR>09:29:05.675104 10.1.2.10.3969 &gt; 129.41.69.137.smtp: P =
93:128(35) ack=20
95 win 64146 (DF)<BR>09:29:05.711681 129.41.69.137.smtp &gt; =
10.1.2.10.3969: P=20
95:103(8) ack 128 win 5840 (DF)<BR>09:29:05.712122 10.1.2.10.3969 &gt;=20
129.41.69.137.smtp: P 128:159(31) ack 103 win 64138 =
(DF)<BR>09:29:05.760198=20
129.41.69.137.smtp &gt; 10.1.2.10.3969: P 103:111(8) ack 159 win 5840=20
(DF)<BR>09:29:05.760453 10.1.2.10.3969 &gt; 129.41.69.137.smtp: P =
159:165(6) ack=20
111 win 64130 (DF)<BR>09:29:05.796963 129.41.69.137.smtp &gt; =
10.1.2.10.3969: P=20
111:125(14) ack 165 win 5840 (DF)<BR>*** the packet size changes here =
once the=20
email data is being sent to the mail server ***<BR>09:29:05.797718=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: . 165:1625(1460) ack 125 win =
64116=20
(DF)<BR>09:29:05.797843 10.1.2.10.3969 &gt; 129.41.69.137.smtp: .=20
1625:3085(1460) ack 125 win 64116 (DF)<BR>09:29:05.797966 10.1.2.10.3969 =
&gt;=20
129.41.69.137.smtp: . 3085:4545(1460) ack 125 win 64116 =
(DF)<BR>09:29:05.797994=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: P 4545:4763(218) ack 125 win =
64116=20
(DF)<BR>09:29:05.798031 10.1.2.10.3969 &gt; 129.41.69.137.smtp: P =
4763:4768(5)=20
ack 125 win 64116 (DF)<BR>09:29:05.834387 129.41.69.137.smtp &gt;=20
10.1.2.10.3969: . ack 165 win 5840 &lt;nop,nop,sack sack 1 {4545:4763} =
&gt;=20
(DF)<BR>09:29:05.846822 129.41.69.137.smtp &gt; 10.1.2.10.3969: . ack =
165 win=20
5840 &lt;nop,nop,sack sack 1 {4545:4768} &gt; (DF)<BR>09:29:05.847323=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: . 165:1625(1460) ack 125 win =
64116=20
(DF)<BR>09:29:05.847445 10.1.2.10.3969 &gt; 129.41.69.137.smtp: .=20
1625:3085(1460) ack 125 win 64116 (DF)<BR>09:29:05.847568 10.1.2.10.3969 =
&gt;=20
129.41.69.137.smtp: . 3085:4545(1460) ack 125 win 64116 =
(DF)<BR>09:29:06.555338=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: . 165:1625(1460) ack 125 win =
64116=20
(DF)<BR>09:29:08.195721 10.1.2.10.3969 &gt; 129.41.69.137.smtp: . =
165:1625(1460)=20
ack 125 win 64116 (DF)<BR>09:29:11.367205 10.1.2.10.3969 &gt;=20
129.41.69.137.smtp: . 165:1625(1460) ack 125 win 64116 =
(DF)<BR>09:29:17.819496=20
10.1.2.10.3969 &gt; 129.41.69.137.smtp: . 165:1625(1460) ack 125 win =
64116=20
(DF)<BR>09:29:30.614817 10.1.2.10.3969 &gt; 129.41.69.137.smtp: . =
165:1625(1460)=20
ack 125 win 64116 (DF)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;<BR>Firewall on the local side of =
the tunnel:=20
(tun0)<BR>&nbsp;<BR>09:29:04.986164 10.1.2.10.3969 &gt; 10.1.1.7.smtp: S =

266730469:266730469(0) win 64240 &lt;mss 1460,nop,nop,sackOK&gt;=20
(DF)<BR>09:29:05.031684 10.1.1.7.smtp &gt; 10.1.2.10.3969: S=20
361700781:361700781(0) ack 266730470 win 5840 &lt;mss =
1460,nop,nop,sackOK&gt;=20
(DF)<BR>09:29:05.032048 10.1.2.10.3969 &gt; 10.1.1.7.smtp: . ack 1 win =
64240=20
(DF)<BR>09:29:05.070314 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 1:30(29) =
ack 1 win=20
5840 (DF)<BR>09:29:05.071048 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
1:15(14) ack=20
30 win 64211 (DF)<BR>09:29:05.116340 10.1.1.7.smtp &gt; 10.1.2.10.3969: =
. ack 15=20
win 5840 (DF)<BR>09:29:05.117105 10.1.1.7.smtp &gt; 10.1.2.10.3969: P =
30:53(23)=20
ack 15 win 5840 (DF)<BR>09:29:05.122915 10.1.2.10.3969 &gt; =
10.1.1.7.smtp: P=20
15:50(35) ack 53 win 64188 (DF)<BR>09:29:05.158822 10.1.1.7.smtp &gt;=20
10.1.2.10.3969: P 53:61(8) ack 50 win 5840 (DF)<BR>09:29:05.159389=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 50:81(31) ack 61 win 64180=20
(DF)<BR>09:29:05.199339 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 61:69(8) =
ack 81 win=20
5840 (DF)<BR>09:29:05.217269 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
81:87(6) ack=20
69 win 64172 (DF)<BR>09:29:05.253722 10.1.1.7.smtp &gt; 10.1.2.10.3969: =
P=20
69:82(13) ack 87 win 5840 (DF)<BR>09:29:05.461527 10.1.2.10.3969 &gt;=20
10.1.1.7.smtp: . ack 82 win 64159 (DF)<BR>09:29:05.489089 10.1.1.7.smtp =
&gt;=20
10.1.2.10.3969: P 69:82(13) ack 87 win 5840 (DF)<BR>09:29:05.489324=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: . ack 82 win 64159 =
(DF)<BR>09:29:05.637836=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 87:93(6) ack 82 win 64159=20
(DF)<BR>09:29:05.674820 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 82:95(13) =
ack 93=20
win 5840 (DF)<BR>09:29:05.675137 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
93:128(35)=20
ack 95 win 64146 (DF)<BR>09:29:05.711645 10.1.1.7.smtp &gt; =
10.1.2.10.3969: P=20
95:103(8) ack 128 win 5840 (DF)<BR>09:29:05.712153 10.1.2.10.3969 &gt;=20
10.1.1.7.smtp: P 128:159(31) ack 103 win 64138 (DF)<BR>09:29:05.760162=20
10.1.1.7.smtp &gt; 10.1.2.10.3969: P 103:111(8) ack 159 win 5840=20
(DF)<BR>09:29:05.760485 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 159:165(6) =
ack 111=20
win 64130 (DF)<BR>09:29:05.796928 10.1.1.7.smtp &gt; 10.1.2.10.3969: P=20
111:125(14) ack 165 win 5840 (DF)<BR>09:29:05.798040 10.1.2.10.3969 &gt; =

10.1.1.7.smtp: P 4545:4763(218) ack 125 win 64116 =
(DF)<BR>09:29:05.798086=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 4763:4768(5) ack 125 win 64116=20
(DF)<BR>09:29:05.834350 10.1.1.7.smtp &gt; 10.1.2.10.3969: . ack 165 win =
5840=20
&lt;nop,nop,sack sack 1 {4545:4763} &gt; (DF)<BR>09:29:05.846786 =
10.1.1.7.smtp=20
&gt; 10.1.2.10.3969: . ack 165 win 5840 &lt;nop,nop,sack sack 1 =
{4545:4768} &gt;=20
(DF)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><BR><FONT face=3DArial size=3D2>Remote side of the tunnel:=20
(tun0)<BR>&nbsp;<BR>12:08:10.673521 10.1.2.10.3969 &gt; 10.1.1.7.smtp: S =

266730469:266730469(0) win 64240 &lt;mss 1460,nop,nop,sackOK&gt;=20
(DF)<BR>12:08:10.674685 10.1.1.7.smtp &gt; 10.1.2.10.3969: S=20
361700781:361700781(0) ack 266730470 win 5840 &lt;mss =
1460,nop,nop,sackOK&gt;=20
(DF)<BR>12:08:10.718701 10.1.2.10.3969 &gt; 10.1.1.7.smtp: . ack 1 win =
64240=20
(DF)<BR>12:08:10.722990 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 1:30(29) =
ack 1 win=20
5840 (DF)<BR>12:08:10.761777 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
1:15(14) ack=20
30 win 64211 (DF)<BR>12:08:10.762026 10.1.1.7.smtp &gt; 10.1.2.10.3969: =
. ack 15=20
win 5840 (DF)<BR>12:08:10.762144 10.1.1.7.smtp &gt; 10.1.2.10.3969: P =
30:53(23)=20
ack 15 win 5840 (DF)<BR>12:08:10.809779 10.1.2.10.3969 &gt; =
10.1.1.7.smtp: P=20
15:50(35) ack 53 win 64188 (DF)<BR>12:08:10.810126 10.1.1.7.smtp &gt;=20
10.1.2.10.3969: P 53:61(8) ack 50 win 5840 (DF)<BR>12:08:10.846437=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 50:81(31) ack 61 win 64180=20
(DF)<BR>12:08:10.851162 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 61:69(8) =
ack 81 win=20
5840 (DF)<BR>12:08:10.905777 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
81:87(6) ack=20
69 win 64172 (DF)<BR>12:08:10.906068 10.1.1.7.smtp &gt; 10.1.2.10.3969: =
P=20
69:82(13) ack 87 win 5840 (DF)<BR>12:08:11.139331 10.1.1.7.smtp &gt;=20
10.1.2.10.3969: P 69:82(13) ack 87 win 5840 (DF)<BR>12:08:11.148104=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: . ack 82 win 64159 =
(DF)<BR>12:08:11.177095=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: . ack 82 win 64159 =
(DF)<BR>12:08:11.324853=20
10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 87:93(6) ack 82 win 64159=20
(DF)<BR>12:08:11.325240 10.1.1.7.smtp &gt; 10.1.2.10.3969: P 82:95(13) =
ack 93=20
win 5840 (DF)<BR>12:08:11.363484 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P =
93:128(35)=20
ack 95 win 64146 (DF)<BR>12:08:11.363818 10.1.1.7.smtp &gt; =
10.1.2.10.3969: P=20
95:103(8) ack 128 win 5840 (DF)<BR>12:08:11.412066 10.1.2.10.3969 &gt;=20
10.1.1.7.smtp: P 128:159(31) ack 103 win 64138 (DF)<BR>12:08:11.412477=20
10.1.1.7.smtp &gt; 10.1.2.10.3969: P 103:111(8) ack 159 win 5840=20
(DF)<BR>12:08:11.447083 10.1.2.10.3969 &gt; 10.1.1.7.smtp: P 159:165(6) =
ack 111=20
win 64130 (DF)<BR>12:08:11.449412 10.1.1.7.smtp &gt; 10.1.2.10.3969: P=20
111:125(14) ack 165 win 5840 (DF)<BR>12:08:11.486836 10.1.2.10.3969 &gt; =

10.1.1.7.smtp: P 4545:4763(218) ack 125 win 64116=20
(DF)<BR>&nbsp;<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_02CC_01C2E49E.188A7CD0--
