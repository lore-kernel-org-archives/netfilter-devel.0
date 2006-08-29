From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Troubeleshooting  a  PPTP conversation
Date: Mon, 28 Aug 2006 21:24:02 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9E3@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Mike McRae <Mike_McRae@schneidermans.com>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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
tcp      6 385491 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1241 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1241 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 307762 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D4463
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D4463 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 410539 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D3154 packets=3D29 bytes=3D8154 [UNREPLIED] src=3D10.1.1.151 d
st=3D10.13.1.22 sport=3D3154 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 329330 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2484 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2484 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414096 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1625 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1625 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404178 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2918 packets=3D6 bytes=3D2290 [UNREPLIED] src=3D10.1.1.152 ds
t=3D10.13.1.22 sport=3D2918 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382746 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1160 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1160 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412594 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2090 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2090 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382819 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3055 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3055 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 397162 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D2734 packets=3D1089 bytes=3D67530 [UNREPLIED] src=3D10.2.1.20
2 dst=3D10.13.1.22 sport=3D2734 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 384922 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D1775 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D1775 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394417 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D2275 packets=3D8 bytes=3D373 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D2275 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406879 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1923 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1923 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 7 SYN_SENT src=3D10.13.1.22 dst=3D10.1.1.21 sport=3D32857 =
dport=3D135
packets=3D3 bytes=3D144 [UNREPLIED] src=3D10.1.1.21 dst=3D10.13.1.2
2 sport=3D135 dport=3D32857 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 395451 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1363 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1363 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 334035 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2772 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2772 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 394518 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1354 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1354 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399412 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1191 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.11.1.152 d
st=3D10.13.1.22 sport=3D1191 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406881 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1924 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1924 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404447 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D135
dport=3D1106 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.152 dst=3D
10.13.1.22 sport=3D1106 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419028 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1307
dport=3D2228 packets=3D118 bytes=3D118474 [UNREPLIED] src=3D10.11.1.
153 dst=3D10.13.1.22 sport=3D2228 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 396015 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1432 packets=3D32 bytes=3D16478 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1432 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414671 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3183 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D3183 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395361 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1405 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1405 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405216 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3395 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3395 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404176 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D135
dport=3D2923 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.152 dst=3D
10.13.1.22 sport=3D2923 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 389421 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D1385 packets=3D11 bytes=3D4026 [UNREPLIED] src=3D10.44.1.152
 dst=3D10.13.1.22 sport=3D1385 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 431931 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1314
dport=3D1027 packets=3D2866 bytes=3D666957 [UNREPLIED] src=3D10.1.1.25
 dst=3D10.13.1.22 sport=3D1027 dport=3D1314 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405283 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1867 packets=3D135 bytes=3D93742 [UNREPLIED] src=3D10.1.1.205
 dst=3D10.13.1.22 sport=3D1867 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392923 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1331 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1331 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 397985 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3922 packets=3D6 bytes=3D1527 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D3922 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408127 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D135
dport=3D3102 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.151 dst=3D
10.13.1.22 sport=3D3102 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405481 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1900 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1900 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404160 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D135
dport=3D2921 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.152 dst=3D
10.13.1.22 sport=3D2921 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407873 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2042 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2042 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 417936 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1074 packets=3D59 bytes=3D43810 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D1074 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395814 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.167 =
sport=3D139
dport=3D4080 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.167=20
dst=3D10.13.1.157 sport=3D4080 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 389131 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1307
dport=3D3160 packets=3D119 bytes=3D48946 [UNREPLIED] src=3D10.2.1.163
 dst=3D10.13.1.22 sport=3D3160 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 397162 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D2731 packets=3D46 bytes=3D31330 [UNREPLIED] src=3D10.2.1.202=20
dst=3D10.13.1.22 sport=3D2731 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 399814 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D2797 packets=3D43 bytes=3D12654 [UNREPLIED] src=3D10.2.1.202=20
dst=3D10.13.1.22 sport=3D2797 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 390948 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1300 packets=3D118 bytes=3D100186 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1300 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 382750 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1166 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1166 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394146 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1349 packets=3D33 bytes=3D16726 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1349 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 366568 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2350
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2350 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 384030 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D135
dport=3D1762 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.2.1.202 dst=3D
10.13.1.22 sport=3D1762 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401009 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4779 packets=3D21 bytes=3D9650 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D4779 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 19 src=3D10.13.1.11 dst=3D255.255.255.255 sport=3D4101 =
dport=3D50791
packets=3D1 bytes=3D48 [UNREPLIED] src=3D255.255.255.255 dst=3D10.1
3.1.11 sport=3D50791 dport=3D4101 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 395364 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1411 packets=3D32 bytes=3D16478 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1411 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406975 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1930 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1930 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 411415 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D4052 packets=3D7 bytes=3D1633 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D4052 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 334024 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2758 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2758 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 384030 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D135
dport=3D1764 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.2.1.202 dst=3D
10.13.1.22 sport=3D1764 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431983 ESTABLISHED src=3D10.13.1.22 dst=3D10.15.1.152 =
sport=3D32901
dport=3D139 packets=3D10 bytes=3D1429 src=3D10.15.1.152 dst=3D10.13.1
.22 sport=3D139 dport=3D32901 packets=3D8 bytes=3D1436 [ASSURED] =
mark=3D0 use=3D1
tcp      6 403808 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2302 packets=3D15 bytes=3D4598 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D2302 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 432000 ESTABLISHED src=3D66.173.97.2 dst=3Daaa.bbb.212.154
sport=3D4323 dport=3D23 packets=3D1346 bytes=3D55105 =
src=3Daaa.bbb.212.154 d
st=3D66.173.97.2 sport=3D23 dport=3D4323 packets=3D1107 bytes=3D241003 =
[ASSURED]
mark=3D0 use=3D1
tcp      6 403963 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D2899 packets=3D9 bytes=3D1446 [UNREPLIED] src=3D10.2.1.202 ds
t=3D10.13.1.22 sport=3D2899 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401880 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1720 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1720 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401880 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1722 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1722 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 386424 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D1100 packets=3D20 bytes=3D6574 [UNREPLIED] src=3D10.44.1.152
 dst=3D10.13.1.22 sport=3D1100 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406879 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1920 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1920 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 265978 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1227
dport=3D389 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10.
13.1.22 sport=3D389 dport=3D1227 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 395362 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1404 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1404 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382750 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1168 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1168 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 332140 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3543 packets=3D8 bytes=3D683 [UNREPLIED] src=3D10.1.1.164 dst
=3D10.13.1.157 sport=3D3543 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415818 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D1052 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1052 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 311713 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3741 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3741 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 416112 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1664 packets=3D44 bytes=3D28606 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1664 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401844 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4800 packets=3D9 bytes=3D3050 [UNREPLIED] src=3D10.21.1.170=20
dst=3D10.13.1.22 sport=3D4800 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 409426 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.156 =
sport=3D135
dport=3D3136 packets=3D4 bytes=3D940 [UNREPLIED] src=3D10.1.1.156 dst=3D
10.13.1.22 sport=3D3136 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407873 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D2040 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2040 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406977 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1932 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1932 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 108 src=3D10.13.1.26 dst=3D200.55.128.3 sport=3D1066 =
dport=3D53
packets=3D4 bytes=3D228 src=3D200.55.128.3 dst=3Daaa.bbb.212.154 =
sport=3D5
3 dport=3D1066 packets=3D4 bytes=3D540 [ASSURED] mark=3D0 use=3D1
tcp      6 337114 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4050 packets=3D46 bytes=3D30154 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4050 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 420365 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1132 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1132 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 267965 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1308
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1308 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 378304 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3631
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3631 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407324 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D3034 packets=3D3807 bytes=3D4881258 [UNREPLIED] src=3D10.1.1.
151 dst=3D10.13.1.22 sport=3D3034 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 409066 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D2030 packets=3D6 bytes=3D1218 [UNREPLIED] src=3D10.11.1.153=20
dst=3D10.13.1.22 sport=3D2030 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 419236 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D2314 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.11.1.153 d
st=3D10.13.1.22 sport=3D2314 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405481 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1902 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1902 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 322508 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D3878 packets=3D38 bytes=3D25462 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D3878 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 301564 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D4013
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D4013 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 371943 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3091
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3091 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394137 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1342 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1342 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431955 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D3201 packets=3D539 bytes=3D136678 [UNREPLIED] src=3D10.1.1.15
1 dst=3D10.13.1.22 sport=3D3201 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395364 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1408 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1408 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 427531 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.161 =
sport=3D1026
dport=3D1751 packets=3D39 bytes=3D5699 [UNREPLIED] src=3D10.1.1.161 d
st=3D10.13.1.22 sport=3D1751 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399814 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D2794 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D2794 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382133 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D1554 packets=3D10 bytes=3D3130 [UNREPLIED] src=3D10.2.1.202 d
st=3D10.13.1.22 sport=3D1554 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 384029 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1128
dport=3D1763 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D1763 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415818 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1054 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1054 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 418400 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.162 =
sport=3D1307
dport=3D2752 packets=3D2485 bytes=3D2255922 [UNREPLIED] src=3D10.1.1.
162 dst=3D10.13.1.22 sport=3D2752 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401004 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4774 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4774 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408130 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3104 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D3104 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399102 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1077 packets=3D19 bytes=3D3422 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1077 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 400438 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1430 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1430 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419197 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1307
dport=3D2290 packets=3D47 bytes=3D30306 [UNREPLIED] src=3D10.11.1.15
3 dst=3D10.13.1.22 sport=3D2290 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395847 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D2245 packets=3D12 bytes=3D3314 [UNREPLIED] src=3D10.2.1.202 d
st=3D10.13.1.22 sport=3D2245 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 267965 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1307
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 265012 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.158 =
sport=3D139
dport=3D4149 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.158 dst=3D1
0.13.1.22 sport=3D4149 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412477 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3458 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3458 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 266262 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1170
dport=3D1232 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.22 sport=3D1232 dport=3D1170 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 266338 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1487
dport=3D389 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10.
13.1.22 sport=3D389 dport=3D1487 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 400542 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4770 packets=3D24 bytes=3D10078 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4770 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 390151 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D4595 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4595 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 414124 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1626 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1626 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 391384 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D3025 packets=3D3 bytes=3D261 [UNREPLIED] src=3D10.21.1.151 d
st=3D10.13.1.157 sport=3D3025 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405473 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1128
dport=3D3083 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D3083 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 416377 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1047 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1047 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396013 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1426 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1426 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407808 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2018 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2018 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396015 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1429 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1429 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 328993 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3924 packets=3D6 bytes=3D1234 [UNREPLIED] src=3D10.21.1.170=20
dst=3D10.13.1.22 sport=3D3924 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395361 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1407 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1407 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317715 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D3814 packets=3D21 bytes=3D9606 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D3814 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 384029 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D1765 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D1765 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412590 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D2087 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2087 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395361 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1406 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1406 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 403809 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2310 packets=3D6 bytes=3D651 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D2310 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395278 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1403 packets=3D32 bytes=3D16478 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1403 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 408126 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3103 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D3103 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 388876 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1251 packets=3D8 bytes=3D2558 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D1251 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 414096 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1262 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D1262 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412059 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D4060 packets=3D5 bytes=3D1431 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D4060 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395451 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1361 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1361 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401880 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1719 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1719 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 393942 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4647 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4647 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396772 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.172 =
sport=3D139
dport=3D2686 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.172=20
dst=3D10.13.1.157 sport=3D2686 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 420376 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1134 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1134 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405181 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D135
dport=3D3393 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.2.1.163 dst=3D
10.13.1.22 sport=3D3393 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407875 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2043 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2043 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401004 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4775 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4775 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 397077 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.166 =
sport=3D139
dport=3D3332 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.166=20
dst=3D10.13.1.157 sport=3D3332 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 383984 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D1564 packets=3D7 bytes=3D1250 [UNREPLIED] src=3D10.2.1.202 ds
t=3D10.13.1.22 sport=3D1564 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 294064 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3423
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3423 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 331563 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2547 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2547 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 389713 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1185 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1185 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405283 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1864 packets=3D6 bytes=3D1210 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D1864 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317711 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D3808 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3808 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419949 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3983
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3983 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407787 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1524 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1524 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383558 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1200 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1200 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395174 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1394 packets=3D400 bytes=3D532338 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1394 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412477 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D135
dport=3D3457 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.2.1.163 dst=3D
10.13.1.22 sport=3D3457 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396246 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1440 packets=3D414 bytes=3D542594 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1440 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 316230 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2200 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2200 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407800 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1956 packets=3D110 bytes=3D99626 [UNREPLIED] src=3D10.1.1.205
 dst=3D10.13.1.22 sport=3D1956 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 400438 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1431 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1431 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 345600 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D4001
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D4001 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 421227 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D1146 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1146 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 329318 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2474 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2474 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 328993 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D3927 packets=3D151 bytes=3D140782 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D3927 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 399410 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1184 packets=3D6 bytes=3D2290 [UNREPLIED] src=3D10.11.1.152=20
dst=3D10.13.1.22 sport=3D1184 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412542 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3459 packets=3D8 bytes=3D1602 [UNREPLIED] src=3D10.2.1.163 ds
t=3D10.13.1.22 sport=3D3459 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 18 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 =
dport=3D1056
packets=3D32 bytes=3D6741 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
s
port=3D1056 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 398288 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1474 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1474 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 402465 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D1168 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.11.1.153 d
st=3D10.13.1.22 sport=3D1168 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 403446 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2191
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2191 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407790 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1527 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1527 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 400448 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1434 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1434 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 393672 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1313 packets=3D6 bytes=3D1242 [UNREPLIED] src=3D10.44.1.151=20
dst=3D10.13.1.22 sport=3D1313 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388813 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1272 packets=3D10 bytes=3D2650 [UNREPLIED] src=3D10.1.1.205 d
st=3D10.13.1.22 sport=3D1272 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395599 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1416 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1416 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 400535 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4765 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4765 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404465 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1105 packets=3D31 bytes=3D19162 [UNREPLIED] src=3D10.1.1.152=20
dst=3D10.13.1.22 sport=3D1105 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407808 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2021 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2021 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431956 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.161 =
sport=3D1307
dport=3D1753 packets=3D3606 bytes=3D878306 [UNREPLIED] src=3D10.1.1.1
61 dst=3D10.13.1.22 sport=3D1753 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 398181 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1406 packets=3D1338 bytes=3D1929182 [UNREPLIED] src=3D10.44.
1.151 dst=3D10.13.1.22 sport=3D1406 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 390151 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4598 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4598 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382753 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1172 packets=3D25 bytes=3D13654 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1172 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407873 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2041 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2041 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 430033 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1307
dport=3D4653 packets=3D1119 bytes=3D784998 [UNREPLIED] src=3D10.19.1
.155 dst=3D10.13.1.22 sport=3D4653 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 383466 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1208 packets=3D58 bytes=3D49118 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1208 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 410539 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3144 packets=3D6 bytes=3D766 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D3144 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390151 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4597 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4597 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395451 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1364 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1364 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404160 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2917 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D2917 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395847 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D2248 packets=3D730 bytes=3D926954 [UNREPLIED] src=3D10.2.1.20
2 dst=3D10.13.1.22 sport=3D2248 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412737 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D2102 packets=3D35 bytes=3D17330 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D2102 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 11 src=3D10.13.1.22 dst=3D10.13.1.255 sport=3D137 =
dport=3D137
packets=3D3 bytes=3D234 [UNREPLIED] src=3D10.13.1.255 dst=3D10.13.1.22 =
spo
rt=3D137 dport=3D137 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 403809 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D2314 packets=3D22 bytes=3D2978 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D2314 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317711 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3810 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3810 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398686 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3932 packets=3D8 bytes=3D3853 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D3932 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398579 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.172 =
sport=3D139
dport=3D3230 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.172=20
dst=3D10.13.1.157 sport=3D3230 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414095 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1255 packets=3D8 bytes=3D2482 [UNREPLIED] src=3D10.1.1.152 ds
t=3D10.13.1.22 sport=3D1255 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406975 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1928 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1928 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 389713 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1180 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1180 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383984 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D1567 packets=3D52 bytes=3D17262 [UNREPLIED] src=3D10.2.1.202=20
dst=3D10.13.1.22 sport=3D1567 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395455 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1365 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1365 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 413721 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1211 packets=3D12 bytes=3D1762 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1211 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412477 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1128
dport=3D3456 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3456 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412542 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1307
dport=3D3462 packets=3D153 bytes=3D93050 [UNREPLIED] src=3D10.2.1.163
 dst=3D10.13.1.22 sport=3D3462 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395653 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1419 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1419 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419700 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1026
dport=3D1047 packets=3D3 bytes=3D169 [UNREPLIED] src=3D10.17.1.154 d
st=3D10.13.1.22 sport=3D1047 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408271 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4908 packets=3D10 bytes=3D2858 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D4908 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 419028 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D2225 packets=3D6 bytes=3D1218 [UNREPLIED] src=3D10.11.1.153=20
dst=3D10.13.1.22 sport=3D2225 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 26 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 =
dport=3D1053
packets=3D10 bytes=3D1724 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
s
port=3D1053 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 272746 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1638
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1638 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395653 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1422 packets=3D115 bytes=3D113014 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1422 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 175 src=3D10.13.1.26 dst=3D64.34.165.69 sport=3D1066 =
dport=3D53
packets=3D5 bytes=3D280 src=3D64.34.165.69 dst=3Daaa.bbb.212.154 =
sport=3D5
3 dport=3D1066 packets=3D5 bytes=3D670 [ASSURED] mark=3D0 use=3D1
tcp      6 358716 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1429
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1429 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 280866 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2288
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2288 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404176 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D135
dport=3D2928 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.152 dst=3D
10.13.1.22 sport=3D2928 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390166 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4599 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4599 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 393672 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1316 packets=3D425 bytes=3D519646 [UNREPLIED] src=3D10.44.1.
151 dst=3D10.13.1.22 sport=3D1316 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 113 TIME_WAIT src=3D10.15.1.152 dst=3D10.13.1.22 sport=3D1480
dport=3D445 packets=3D17 bytes=3D5529 src=3D10.13.1.22 dst=3D10.15.1.152 =
sp
ort=3D445 dport=3D1480 packets=3D14 bytes=3D1813 [ASSURED] mark=3D0 =
use=3D1
tcp      6 334464 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2844
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2844 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 266007 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1228
dport=3D389 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10.
13.1.22 sport=3D389 dport=3D1228 packets=3D0 bytes=3D0 mark=3D0 use=3D1
udp      17 20 src=3D10.13.1.154 dst=3D255.255.255.255 sport=3D138 =
dport=3D138
packets=3D1 bytes=3D229 [UNREPLIED] src=3D255.255.255.255 dst=3D10.13
.1.154 sport=3D138 dport=3D138 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 413721 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1204 packets=3D17 bytes=3D2802 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1204 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414096 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1623 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1623 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 330440 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2537
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2537 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396246 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1437 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1437 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407790 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1530 packets=3D29 bytes=3D19338 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1530 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 415851 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3591
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3591 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385072 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1221 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1221 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394417 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D2281 packets=3D4709 bytes=3D2479966 [UNREPLIED] src=3D10.1.1.
151 dst=3D10.13.1.22 sport=3D2281 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395276 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1398 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1398 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408271 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4911 packets=3D437 bytes=3D549622 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D4911 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 419699 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1307
dport=3D1053 packets=3D759 bytes=3D990990 [UNREPLIED] src=3D10.17.1.
154 dst=3D10.13.1.22 sport=3D1053 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 390120 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4591 packets=3D70 bytes=3D56174 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4591 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 431953 ESTABLISHED src=3D10.15.1.230 dst=3D10.13.1.50 =
sport=3D17591
dport=3D23 packets=3D353 bytes=3D14382 src=3D10.13.1.50 dst=3D10.15.1
.230 sport=3D23 dport=3D17591 packets=3D302 bytes=3D63993 [ASSURED] =
mark=3D0 use=3D1
tcp      6 399410 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1188 packets=3D10 bytes=3D2330 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1188 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 384047 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D1769 packets=3D371 bytes=3D462218 [UNREPLIED] src=3D10.2.1.20
2 dst=3D10.13.1.22 sport=3D1769 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388791 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1269 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1269 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390056 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1026
dport=3D4475 packets=3D6 bytes=3D1206 [UNREPLIED] src=3D10.19.1.155=20
dst=3D10.13.1.22 sport=3D4475 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 265977 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1311
dport=3D389 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10.
13.1.22 sport=3D389 dport=3D1311 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 388791 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1271 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1271 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382818 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1307
dport=3D3058 packets=3D99 bytes=3D66290 [UNREPLIED] src=3D10.2.1.163=20
dst=3D10.13.1.22 sport=3D3058 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 301263 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3979
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3979 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390380 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1293 packets=3D1458 bytes=3D2066358 [UNREPLIED] src=3D10.44.
1.151 dst=3D10.13.1.22 sport=3D1293 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 430255 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.172 =
sport=3D1026
dport=3D4644 packets=3D5 bytes=3D630 [UNREPLIED] src=3D10.21.1.172 d
st=3D10.13.1.22 sport=3D4644 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419236 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1307
dport=3D2317 packets=3D46 bytes=3D30762 [UNREPLIED] src=3D10.11.1.15
3 dst=3D10.13.1.22 sport=3D2317 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401880 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1721 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1721 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401008 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4776 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4776 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383558 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1199 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1199 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385072 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1219 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1219 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396378 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4696 packets=3D318 bytes=3D411598 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D4696 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 394136 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1345 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1345 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404467 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1112 packets=3D12 bytes=3D2062 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D1112 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 418920 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1114 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1114 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385494 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1243 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1243 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 334582 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4006 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4006 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398852 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1483 packets=3D6 bytes=3D1210 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D1483 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 116 SYN_SENT src=3D10.13.1.22 dst=3D216.52.51.143 =
sport=3D32912
dport=3D25 packets=3D1 bytes=3D48 [UNREPLIED] src=3D216.52.51.143 =
dst=3D2
09.130.212.154 sport=3D25 dport=3D32912 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395276 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1395 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1395 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408130 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D3107 packets=3D28 bytes=3D12238 [UNREPLIED] src=3D10.1.1.151=20
dst=3D10.13.1.22 sport=3D3107 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 266007 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1310
dport=3D389 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10.
13.1.22 sport=3D389 dport=3D1310 packets=3D0 bytes=3D0 mark=3D0 use=3D1
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
tcp      6 307161 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D4433
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D4433 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394924 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1374 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1374 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383558 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1198 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1198 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390166 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4602 packets=3D26 bytes=3D10126 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4602 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414124 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1629 packets=3D79 bytes=3D72474 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1629 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 386539 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1026
dport=3D3282 packets=3D25 bytes=3D1802 [UNREPLIED] src=3D10.19.1.155
 dst=3D10.13.1.22 sport=3D3282 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401843 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4803 packets=3D32 bytes=3D11470 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4803 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404176 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D2924 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D2924 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383466 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1203 packets=3D106 bytes=3D70430 [UNREPLIED] src=3D10.1.1.205
 dst=3D10.13.1.22 sport=3D1203 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395454 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1368 packets=3D34 bytes=3D22394 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1368 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405502 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1907 packets=3D65 bytes=3D58310 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1907 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 310927 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2022 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2022 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
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
tcp      6 388791 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1268 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1268 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415828 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1055 packets=3D13 bytes=3D4870 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D1055 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 322485 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D3872 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3872 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407873 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2039 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2039 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 274192 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1727
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1727 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 400535 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4766 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4766 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 397998 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D2739 packets=3D9 bytes=3D1446 [UNREPLIED] src=3D10.2.1.202 ds
t=3D10.13.1.22 sport=3D2739 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407875 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D2046 packets=3D32 bytes=3D16582 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D2046 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407324 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3008 packets=3D229 bytes=3D158682 [UNREPLIED] src=3D10.1.1.15
1 dst=3D10.13.1.22 sport=3D3008 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388244 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1307
dport=3D1173 packets=3D606 bytes=3D80034 [UNREPLIED] src=3D10.44.1.1
52 dst=3D10.13.1.22 sport=3D1173 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 379232 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1120 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1120 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 400447 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1437 packets=3D47 bytes=3D33354 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1437 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 314782 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D1108
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D1108 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 6 src=3D10.13.1.152 dst=3D10.13.1.255 sport=3D138 =
dport=3D138
packets=3D2 bytes=3D458 [UNREPLIED] src=3D10.13.1.255 dst=3D10.13.1.152 =
sp
ort=3D138 dport=3D138 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 385491 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1242 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1242 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 376817 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1098 packets=3D10 bytes=3D3154 [UNREPLIED] src=3D10.44.1.151
 dst=3D10.13.1.22 sport=3D1098 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395276 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1399 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1399 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398181 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1403 packets=3D6 bytes=3D1242 [UNREPLIED] src=3D10.44.1.151=20
dst=3D10.13.1.22 sport=3D1403 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 100 SYN_SENT src=3D10.13.1.22 dst=3D10.10.10.10 sport=3D32900
dport=3D25 packets=3D3 bytes=3D144 [UNREPLIED] src=3D10.10.10.10 =
dst=3D10.1
3.1.22 sport=3D25 dport=3D32900 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 401457 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.156 =
sport=3D1026
dport=3D4517 packets=3D12 bytes=3D4434 [UNREPLIED] src=3D10.44.1.156
 dst=3D10.13.1.22 sport=3D4517 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 3 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 dport=3D1025
packets=3D9 bytes=3D1713 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
spo
rt=3D1025 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 413721 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1200 packets=3D11 bytes=3D3626 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1200 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 383144 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.156 =
sport=3D445
dport=3D2775 packets=3D20 bytes=3D3163 [UNREPLIED] src=3D10.1.1.156 ds
t=3D10.13.1.22 sport=3D2775 dport=3D445 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 376816 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1101 packets=3D536 bytes=3D568918 [UNREPLIED] src=3D10.44.1.
151 dst=3D10.13.1.22 sport=3D1101 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392922 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1332 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1332 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 392335 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1307
dport=3D3219 packets=3D150 bytes=3D110342 [UNREPLIED] src=3D10.2.1.16
3 dst=3D10.13.1.22 sport=3D3219 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404447 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D135
dport=3D1111 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.152 dst=3D
10.13.1.22 sport=3D1111 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407787 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1526 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1526 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401883 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1723 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1723 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 426755 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.164 =
sport=3D1026
dport=3D3841 packets=3D33 bytes=3D5797 [UNREPLIED] src=3D10.1.1.164 d
st=3D10.13.1.22 sport=3D3841 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383561 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1202 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1202 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 391369 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D3014 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.151 ds
t=3D10.13.1.167 sport=3D3014 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406976 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D4006 packets=3D6 bytes=3D1593 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D4006 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 402465 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1307
dport=3D1171 packets=3D290 bytes=3D369850 [UNREPLIED] src=3D10.11.1.
153 dst=3D10.13.1.22 sport=3D1171 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392922 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1330 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1330 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382753 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1169 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1169 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 384921 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D1778 packets=3D44 bytes=3D12814 [UNREPLIED] src=3D10.2.1.202=20
dst=3D10.13.1.22 sport=3D1778 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 334582 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4009 packets=3D155 bytes=3D147646 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D4009 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 415405 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1647 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1647 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406171 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4845 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4845 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419203 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1128
dport=3D2311 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.11.1.153 d
st=3D10.13.1.22 sport=3D2311 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398123 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1450 packets=3D467 bytes=3D554426 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1450 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 6 src=3D10.13.1.22 dst=3D10.1.1.152 sport=3D123 dport=3D123
packets=3D1 bytes=3D96 [UNREPLIED] src=3D10.1.1.152 dst=3D10.13.1.22 =
sport=3D1
23 dport=3D123 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 430582 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D3973 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D3973 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406879 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1921 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1921 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 416091 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1661 packets=3D5 bytes=3D1154 [UNREPLIED] src=3D10.44.1.151=20
dst=3D10.13.1.22 sport=3D1661 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 409066 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1307
dport=3D2033 packets=3D41 bytes=3D26118 [UNREPLIED] src=3D10.11.1.15
3 dst=3D10.13.1.22 sport=3D2033 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406975 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1929 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1929 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395599 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1418 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1418 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 30 SYN_SENT src=3D10.13.1.154 dst=3D10.1.1.25 sport=3D1336
dport=3D445 packets=3D1 bytes=3D48 [UNREPLIED] src=3D10.1.1.25 =
dst=3D10.13.1.1
54 sport=3D445 dport=3D1336 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 389712 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1188 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1188 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 413565 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.158 =
sport=3D1307
dport=3D4813 packets=3D1402 bytes=3D998078 [UNREPLIED] src=3D10.1.1.1
58 dst=3D10.13.1.22 sport=3D4813 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 322485 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D3873 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D3873 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405363 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1899 packets=3D34 bytes=3D16994 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1899 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 424438 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1026
dport=3D4650 packets=3D12 bytes=3D3151 [UNREPLIED] src=3D10.19.1.155
 dst=3D10.13.1.22 sport=3D4650 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392944 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1337 packets=3D359 bytes=3D483626 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1337 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404721 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D2187 packets=3D10 bytes=3D1806 [UNREPLIED] src=3D10.44.1.152
 dst=3D10.13.1.22 sport=3D2187 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388244 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D1170 packets=3D36 bytes=3D14150 [UNREPLIED] src=3D10.44.1.15
2 dst=3D10.13.1.22 sport=3D1170 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392944 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1334 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1334 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 419701 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1026
dport=3D1057 packets=3D19 bytes=3D1583 [UNREPLIED] src=3D10.17.1.154
 dst=3D10.13.1.22 sport=3D1057 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 415818 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1051 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1051 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 387982 ESTABLISHED src=3D10.13.1.157 dst=3D10.44.1.153 =
sport=3D139
dport=3D1027 packets=3D5 bytes=3D419 [UNREPLIED] src=3D10.44.1.153 d
st=3D10.13.1.157 sport=3D1027 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 316219 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2186 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2186 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 418401 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.162 =
sport=3D1026
dport=3D2749 packets=3D11 bytes=3D1409 [UNREPLIED] src=3D10.1.1.162 d
st=3D10.13.1.22 sport=3D2749 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 179 src=3D10.13.1.26 dst=3D206.165.6.11 sport=3D1066 =
dport=3D53
packets=3D55227 bytes=3D3367907 src=3D206.165.6.11 dst=3Daaa.bbb.212.154
 sport=3D53 dport=3D1066 packets=3D55222 bytes=3D11955351 [ASSURED] =
mark=3D0 use=3D1
tcp      6 390211 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.156 =
sport=3D1026
dport=3D2770 packets=3D8 bytes=3D1552 [UNREPLIED] src=3D10.1.1.156 ds
t=3D10.13.1.22 sport=3D2770 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 332452 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2656 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2656 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 1 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 dport=3D1052
packets=3D10 bytes=3D1925 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
sp
ort=3D1052 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 419197 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D2287 packets=3D6 bytes=3D1218 [UNREPLIED] src=3D10.11.1.153=20
dst=3D10.13.1.22 sport=3D2287 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407787 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1525 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1525 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 403159 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1480 packets=3D65 bytes=3D60194 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1480 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 394136 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1344 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1344 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407320 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1142 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.152 dst
=3D10.13.1.22 sport=3D1142 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404178 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D2929 packets=3D12 bytes=3D2062 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D2929 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407800 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1953 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1953 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399101 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1073 packets=3D15 bytes=3D5186 [UNREPLIED] src=3D10.11.1.152
 dst=3D10.13.1.22 sport=3D1073 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406171 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4848 packets=3D36 bytes=3D20858 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D4848 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414096 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1624 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1624 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 373468 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3232
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3232 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 310915 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D2000 packets=3D10 bytes=3D953 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.167 sport=3D2000 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 407318 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1139 packets=3D118 bytes=3D98646 [UNREPLIED] src=3D10.1.1.152
 dst=3D10.13.1.22 sport=3D1139 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 389712 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1189 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1189 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382746 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1163 packets=3D64 bytes=3D44566 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1163 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404721 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1307
dport=3D2190 packets=3D10 bytes=3D2570 [UNREPLIED] src=3D10.44.1.152
 dst=3D10.13.1.22 sport=3D2190 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401456 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.156 =
sport=3D1307
dport=3D4520 packets=3D4136 bytes=3D1720354 [UNREPLIED] src=3D10.44.
1.156 dst=3D10.13.1.22 sport=3D4520 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 398852 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1486 packets=3D71 bytes=3D49498 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1486 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392662 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1310 packets=3D696 bytes=3D943994 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1310 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 175 src=3D10.13.1.26 dst=3D192.41.162.30 sport=3D1066 =
dport=3D53
packets=3D5 bytes=3D280 src=3D192.41.162.30 dst=3Daaa.bbb.212.154 sport
=3D53 dport=3D1066 packets=3D5 bytes=3D670 [ASSURED] mark=3D0 use=3D1
tcp      6 419951 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1307
dport=3D1511 packets=3D2097 bytes=3D1999674 [UNREPLIED] src=3D10.44.
1.152 dst=3D10.13.1.22 sport=3D1511 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 391369 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D3011 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.151 ds
t=3D10.13.1.167 sport=3D3011 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385490 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1240 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1240 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 389712 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1186 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1186 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390425 ESTABLISHED src=3D10.44.1.156 dst=3D165.193.22.75
sport=3D4556 dport=3D80 packets=3D2 bytes=3D184 [UNREPLIED] =
src=3D165.193.22.7
5 dst=3Daaa.bbb.212.154 sport=3D80 dport=3D4556 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404694 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1128
dport=3D2184 packets=3D4 bytes=3D460 [UNREPLIED] src=3D10.44.1.152 d
st=3D10.13.1.22 sport=3D2184 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390947 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1297 packets=3D9 bytes=3D2038 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D1297 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 421227 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1145 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1145 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 400438 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1432 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1432 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398287 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1471 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1471 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396651 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.165 =
sport=3D135
dport=3D3967 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.165 ds
t=3D10.13.1.22 sport=3D3967 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 332463 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2670 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2670 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406881 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1927 packets=3D32 bytes=3D16582 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1927 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 384047 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D1766 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D1766 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 179 src=3D10.13.1.26 dst=3D206.165.6.12 sport=3D1066 =
dport=3D53
packets=3D494 bytes=3D29428 src=3D206.165.6.12 dst=3Daaa.bbb.212.154 spo
rt=3D53 dport=3D1066 packets=3D492 bytes=3D50639 [ASSURED] mark=3D0 =
use=3D1
tcp      6 337113 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4047 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4047 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399102 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1084 packets=3D679 bytes=3D33882 [UNREPLIED] src=3D10.11.1.1
52 dst=3D10.13.1.22 sport=3D1084 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 383466 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1200 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1200 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 408126 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D135
dport=3D3100 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.151 dst=3D
10.13.1.22 sport=3D3100 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394923 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1377 packets=3D497 bytes=3D682002 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1377 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 400535 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4763 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4763 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431953 ESTABLISHED src=3D10.15.1.230 dst=3D10.13.1.50 =
sport=3D17592
dport=3D23 packets=3D317 bytes=3D12950 src=3D10.13.1.50 dst=3D10.15.1
.230 sport=3D23 dport=3D17592 packets=3D262 bytes=3D31919 [ASSURED] =
mark=3D0 use=3D1
tcp      6 407809 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2022 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2022 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 340345 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3453
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3453 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412477 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D135
dport=3D3455 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.2.1.163 dst=3D
10.13.1.22 sport=3D3455 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 413721 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1207 packets=3D5 bytes=3D610 [UNREPLIED] src=3D10.11.1.152 d
st=3D10.13.1.22 sport=3D1207 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405181 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1128
dport=3D3392 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3392 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 393942 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4650 packets=3D314 bytes=3D418282 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D4650 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405503 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D3086 packets=3D10 bytes=3D2714 [UNREPLIED] src=3D10.2.1.202 d
st=3D10.13.1.22 sport=3D3086 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317711 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D3809 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D3809 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 25 src=3D10.13.1.26 dst=3D63.149.146.4 sport=3D1066 =
dport=3D53
packets=3D1 bytes=3D58 [UNREPLIED] src=3D63.149.146.4 =
dst=3Daaa.bbb.212.1
54 sport=3D53 dport=3D1066 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 415399 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1644 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1644 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 421227 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1147 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1147 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 389131 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3157 packets=3D8 bytes=3D1602 [UNREPLIED] src=3D10.2.1.163 ds
t=3D10.13.1.22 sport=3D3157 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 388613 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1270 packets=3D57 bytes=3D24706 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1270 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414095 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1266 packets=3D12 bytes=3D2062 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D1266 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 13 SYN_SENT src=3D10.13.1.26 dst=3D10.1.1.21 sport=3D4777 =
dport=3D135
packets=3D3 bytes=3D144 [UNREPLIED] src=3D10.1.1.21 dst=3D10.13.1.2
6 sport=3D135 dport=3D4777 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 400542 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4767 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4767 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 411724 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2067 packets=3D8 bytes=3D1974 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D2067 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385491 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1236 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1236 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406306 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3996 packets=3D6 bytes=3D503 [UNREPLIED] src=3D10.1.1.164 dst
=3D10.13.1.157 sport=3D3996 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396013 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1428 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1428 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 62 src=3D10.13.1.26 dst=3D195.83.221.37 sport=3D1066 =
dport=3D53
packets=3D5 bytes=3D310 src=3D195.83.221.37 dst=3Daaa.bbb.212.154 =
sport=3D
53 dport=3D1066 packets=3D5 bytes=3D655 [ASSURED] mark=3D0 use=3D1
tcp      6 405472 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D135
dport=3D3082 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.2.1.202 dst=3D
10.13.1.22 sport=3D3082 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395276 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1397 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1397 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 421233 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1152 packets=3D24 bytes=3D9882 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D1152 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 431983 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.172 =
sport=3D1307
dport=3D1116 packets=3D1725 bytes=3D280330 [UNREPLIED] src=3D10.21.1
.172 dst=3D10.13.1.22 sport=3D1116 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 162 src=3D10.15.1.152 dst=3D10.13.1.22 sport=3D137 =
dport=3D137
packets=3D2 bytes=3D335 src=3D10.13.1.22 dst=3D10.15.1.152 sport=3D137 =
dpor
t=3D137 packets=3D2 bytes=3D425 [ASSURED] mark=3D0 use=3D1
tcp      6 419701 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1307
dport=3D1063 packets=3D50 bytes=3D6860 [UNREPLIED] src=3D10.17.1.154
 dst=3D10.13.1.22 sport=3D1063 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 394136 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1343 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1343 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398122 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1447 packets=3D10 bytes=3D2786 [UNREPLIED] src=3D10.1.1.205 d
st=3D10.13.1.22 sport=3D1447 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390151 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4594 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4594 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 388613 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1267 packets=3D10 bytes=3D2794 [UNREPLIED] src=3D10.44.1.151
 dst=3D10.13.1.22 sport=3D1267 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 394145 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1346 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1346 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 410454 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D4043 packets=3D7 bytes=3D2723 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D4043 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431930 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1026
dport=3D4857 packets=3D2059 bytes=3D2362719 [UNREPLIED] src=3D10.1.1.2
5 dst=3D10.13.1.22 sport=3D4857 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 379232 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1123 packets=3D244 bytes=3D291570 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1123 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 399411 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1307
dport=3D1195 packets=3D9 bytes=3D1446 [UNREPLIED] src=3D10.11.1.152=20
dst=3D10.13.1.22 sport=3D1195 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 414670 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1307
dport=3D3186 packets=3D31 bytes=3D13138 [UNREPLIED] src=3D10.1.1.151=20
dst=3D10.13.1.22 sport=3D3186 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 415399 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1646 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1646 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405502 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1904 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1904 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 414096 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1622 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1622 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396756 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1393 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1393 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317711 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D3807 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D3807 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401635 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.165 =
sport=3D135
dport=3D3988 packets=3D4 bytes=3D940 [UNREPLIED] src=3D10.1.1.165 dst=3D
10.13.1.22 sport=3D3988 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 386424 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1307
dport=3D1108 packets=3D85 bytes=3D14074 [UNREPLIED] src=3D10.44.1.15
2 dst=3D10.13.1.22 sport=3D1108 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401882 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1726 packets=3D32 bytes=3D16582 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1726 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405363 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1896 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1896 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 417935 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1071 packets=3D7 bytes=3D1274 [UNREPLIED] src=3D10.21.1.170=20
dst=3D10.13.1.22 sport=3D1071 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412736 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2099 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2099 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 420376 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1137 packets=3D24 bytes=3D9882 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D1137 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388876 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1254 packets=3D819 bytes=3D946738 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1254 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 419203 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D135
dport=3D2312 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.11.1.153 ds
t=3D10.13.1.22 sport=3D2312 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399398 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4750 packets=3D898 bytes=3D1221798 [UNREPLIED] src=3D10.21.1
.170 dst=3D10.13.1.22 sport=3D4750 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404694 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D2186 packets=3D4 bytes=3D424 [UNREPLIED] src=3D10.44.1.152 d
st=3D10.13.1.22 sport=3D2186 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415405 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1650 packets=3D29 bytes=3D19338 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1650 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 398287 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1472 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1472 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 391369 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D3012 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.151 ds
t=3D10.13.1.167 sport=3D3012 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405216 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1307
dport=3D3398 packets=3D85 bytes=3D49970 [UNREPLIED] src=3D10.2.1.163=20
dst=3D10.13.1.22 sport=3D3398 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 419204 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.153 =
sport=3D1026
dport=3D2313 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.11.1.153 d
st=3D10.13.1.22 sport=3D2313 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 322485 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D3871 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D3871 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431082 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D25878
dport=3D389 packets=3D6 bytes=3D240 [UNREPLIED] src=3D10.1.1.25 dst=3D1
0.13.1.22 sport=3D389 dport=3D25878 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415399 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1645 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1645 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 9 src=3D10.15.1.152 dst=3D10.13.1.26 sport=3D1355 dport=3D53
packets=3D1 bytes=3D71 src=3D10.13.1.26 dst=3D10.15.1.152 sport=3D53 =
dport=3D13
55 packets=3D1 bytes=3D87 mark=3D0 use=3D1
tcp      6 407319 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1135 packets=3D10 bytes=3D3554 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D1135 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404176 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D2922 packets=3D25 bytes=3D14342 [UNREPLIED] src=3D10.1.1.152=20
dst=3D10.13.1.22 sport=3D2922 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412594 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D2093 packets=3D32 bytes=3D16558 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D2093 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 415827 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1059 packets=3D42 bytes=3D15854 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D1059 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 404694 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D135
dport=3D2183 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.152 ds
t=3D10.13.1.22 sport=3D2183 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 322485 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3874 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3874 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407807 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2020 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2020 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 401004 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D4773 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4773 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396377 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4693 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4693 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395599 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1415 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1415 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394517 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1357 packets=3D280 bytes=3D340090 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1357 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 391369 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D3010 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.151 ds
t=3D10.13.1.167 sport=3D3010 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382370 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3800 packets=3D5 bytes=3D463 [UNREPLIED] src=3D10.1.1.164 dst
=3D10.13.1.157 sport=3D3800 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398287 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1473 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1473 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396012 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1427 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1427 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385493 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1246 packets=3D33 bytes=3D16598 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1246 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 409248 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.158 =
sport=3D1026
dport=3D4810 packets=3D20 bytes=3D5067 [UNREPLIED] src=3D10.1.1.158 d
st=3D10.13.1.22 sport=3D4810 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 418920 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1117 packets=3D136 bytes=3D158758 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D1117 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 322508 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3875 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3875 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406977 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1935 packets=3D32 bytes=3D16582 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1935 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 266262 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.25 =
sport=3D1169
dport=3D1232 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.22 sport=3D1232 dport=3D1169 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 333338 ESTABLISHED src=3D10.13.1.22 dst=3D10.17.1.154 =
sport=3D1026
dport=3D1031 packets=3D12 bytes=3D3650 [UNREPLIED] src=3D10.17.1.154
 dst=3D10.13.1.22 sport=3D1031 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 409507 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2889
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2889 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407807 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D2019 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2019 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385072 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1220 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1220 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407787 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1523 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1523 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 407319 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1146 packets=3D12 bytes=3D2062 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D1146 dport=3D1307 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395451 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1128
dport=3D1362 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1362 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 430054 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1026
dport=3D3194 packets=3D8 bytes=3D1295 [UNREPLIED] src=3D10.1.1.151 ds
t=3D10.13.1.22 sport=3D3194 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 420364 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D1131 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1131 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 416377 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D1050 packets=3D70 bytes=3D42418 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D1050 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 391369 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.151 =
sport=3D139
dport=3D3013 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.151 ds
t=3D10.13.1.167 sport=3D3013 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406016 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1912 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1912 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 386537 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1307
dport=3D3284 packets=3D2277 bytes=3D376814 [UNREPLIED] src=3D10.19.1
.155 dst=3D10.13.1.22 sport=3D3284 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 401004 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D4772 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D4772 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394623 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1367 packets=3D35 bytes=3D17266 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1367 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 421227 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1148 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1148 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 422517 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.159 =
sport=3D1026
dport=3D4045 packets=3D76 bytes=3D29487 [UNREPLIED] src=3D10.44.1.15
9 dst=3D10.13.1.22 sport=3D4045 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 383558 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1201 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1201 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 395599 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1417 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1417 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396013 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1425 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1425 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415573 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D4952 packets=3D541 bytes=3D612946 [UNREPLIED] src=3D10.21.1.
170 dst=3D10.13.1.22 sport=3D4952 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 400534 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1128
dport=3D4764 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4764 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 414093 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D1259 packets=3D50 bytes=3D29638 [UNREPLIED] src=3D10.1.1.152=20
dst=3D10.13.1.22 sport=3D1259 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412589 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2088 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2088 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406975 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1931 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1931 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 403962 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D2902 packets=3D105 bytes=3D63770 [UNREPLIED] src=3D10.2.1.202
 dst=3D10.13.1.22 sport=3D2902 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 388812 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1275 packets=3D50 bytes=3D22454 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1275 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392335 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3216 packets=3D8 bytes=3D1602 [UNREPLIED] src=3D10.2.1.163 ds
t=3D10.13.1.22 sport=3D3216 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 399102 ESTABLISHED src=3D10.13.1.22 dst=3D10.11.1.152 =
sport=3D1026
dport=3D1080 packets=3D9 bytes=3D2010 [UNREPLIED] src=3D10.11.1.152=20
dst=3D10.13.1.22 sport=3D1080 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406016 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1915 packets=3D205 bytes=3D245362 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D1915 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 382229 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D1557 packets=3D775 bytes=3D1012238 [UNREPLIED] src=3D10.2.1.2
02 dst=3D10.13.1.22 sport=3D1557 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 412590 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D2086 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D2086 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 406895 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.167 =
sport=3D1026
dport=3D1510 packets=3D245 bytes=3D260862 [UNREPLIED] src=3D10.1.1.16
7 dst=3D10.13.1.22 sport=3D1510 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395174 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1391 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1391 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 418673 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.167 =
sport=3D139
dport=3D3495 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.167=20
dst=3D10.13.1.157 sport=3D3495 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 392662 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1307 packets=3D6 bytes=3D1210 [UNREPLIED] src=3D10.1.1.205 ds
t=3D10.13.1.22 sport=3D1307 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390056 ESTABLISHED src=3D10.13.1.22 dst=3D10.19.1.155 =
sport=3D1307
dport=3D4478 packets=3D226 bytes=3D225810 [UNREPLIED] src=3D10.19.1.
155 dst=3D10.13.1.22 sport=3D4478 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 389419 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1307
dport=3D1388 packets=3D13 bytes=3D3050 [UNREPLIED] src=3D10.44.1.152
 dst=3D10.13.1.22 sport=3D1388 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 422517 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.159 =
sport=3D1307
dport=3D4050 packets=3D4875 bytes=3D5025314 [UNREPLIED] src=3D10.44.
1.159 dst=3D10.13.1.22 sport=3D4050 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 397998 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D2742 packets=3D64 bytes=3D19542 [UNREPLIED] src=3D10.2.1.202=20
dst=3D10.13.1.22 sport=3D2742 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 365379 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2255
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2255 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390380 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1290 packets=3D8 bytes=3D2030 [UNREPLIED] src=3D10.44.1.151=20
dst=3D10.13.1.22 sport=3D1290 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 400149 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.172 =
sport=3D139
dport=3D3786 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.172=20
dst=3D10.13.1.157 sport=3D3786 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405472 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1026
dport=3D3085 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.2.1.202 dst
=3D10.13.1.22 sport=3D3085 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382749 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1167 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1167 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385075 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1223 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1223 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
unknown  9 528 src=3Daaa.bbb.212.153 dst=3D255.255.255.255 =
packets=3D2103
bytes=3D96738 [UNREPLIED] src=3D255.255.255.255 dst=3Daaa.bbb.212.153=20
packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 421233 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1149 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1149 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 412589 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D2089 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D2089 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 404466 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1026
dport=3D1101 packets=3D10 bytes=3D3554 [UNREPLIED] src=3D10.1.1.152 d
st=3D10.13.1.22 sport=3D1101 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 383561 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1205 packets=3D25 bytes=3D13654 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1205 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 403159 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1477 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1477 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 390119 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4588 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4588 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 413992 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.167 =
sport=3D1307
dport=3D1513 packets=3D3329 bytes=3D948810 [UNREPLIED] src=3D10.1.1.1
67 dst=3D10.13.1.22 sport=3D1513 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 406879 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1922 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1922 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 396756 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1396 packets=3D1361 bytes=3D1964538 [UNREPLIED] src=3D10.44.
1.151 dst=3D10.13.1.22 sport=3D1396 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0
use=3D1
tcp      6 400437 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1433 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1433 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 265012 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.158 =
sport=3D139
dport=3D4148 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.158 dst=3D1
0.13.1.22 sport=3D4148 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405481 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1128
dport=3D1901 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1901 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 384235 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D3831 packets=3D8 bytes=3D2763 [UNREPLIED] src=3D10.1.1.164 ds
t=3D10.13.1.157 sport=3D3831 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 420364 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D1133 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D1133 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385072 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1026
dport=3D1222 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.44.1.151 d
st=3D10.13.1.22 sport=3D1222 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 331574 ESTABLISHED src=3D10.13.1.157 dst=3D10.21.1.151 =
sport=3D139
dport=3D2557 packets=3D10 bytes=3D995 [UNREPLIED] src=3D10.21.1.151=20
dst=3D10.13.1.157 sport=3D2557 dport=3D139 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 311713 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1307
dport=3D3744 packets=3D64 bytes=3D57454 [UNREPLIED] src=3D10.21.1.17
0 dst=3D10.13.1.22 sport=3D3744 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 428834 ESTABLISHED src=3D10.15.1.158 dst=3D10.13.1.50 =
sport=3D1707
dport=3D23 packets=3D106 bytes=3D4334 src=3D10.13.1.50 dst=3D10.15.1.1
58 sport=3D23 dport=3D1707 packets=3D77 bytes=3D17691 [ASSURED] mark=3D0 =
use=3D1
tcp      6 388791 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D135
dport=3D1270 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.1.1.205 dst=3D
10.13.1.22 sport=3D1270 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 403806 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.152 =
sport=3D1307
dport=3D2306 packets=3D4418 bytes=3D6159134 [UNREPLIED] src=3D10.1.1.
152 dst=3D10.13.1.22 sport=3D2306 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 405503 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D1307
dport=3D3089 packets=3D565 bytes=3D743962 [UNREPLIED] src=3D10.2.1.20
2 dst=3D10.13.1.22 sport=3D3089 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
unknown  50 593 src=3D71.216.115.33 dst=3Daaa.bbb.212.154 =
packets=3D53892
bytes=3D9073904 src=3Daaa.bbb.212.154 dst=3D71.216.115.33 packets=3D4147
1 bytes=3D12745208 mark=3D0 use=3D1
udp      17 25 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 =
dport=3D1050
packets=3D32 bytes=3D5353 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
s
port=3D1050 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 419951 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.152 =
sport=3D1026
dport=3D1311 packets=3D119 bytes=3D43687 [UNREPLIED] src=3D10.44.1.1
52 dst=3D10.13.1.22 sport=3D1311 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 338999 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D3300
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D3300 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 389712 ESTABLISHED src=3D10.13.1.167 dst=3D10.21.1.172 =
sport=3D139
dport=3D1187 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.21.1.172 ds
t=3D10.13.1.167 sport=3D1187 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 418780 ESTABLISHED src=3D10.13.1.157 dst=3D10.1.1.164 =
sport=3D139
dport=3D4104 packets=3D8 bytes=3D683 [UNREPLIED] src=3D10.1.1.164 dst
=3D10.13.1.157 sport=3D4104 dport=3D139 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 9 src=3D10.15.1.152 dst=3D10.13.1.22 sport=3D138 dport=3D138
packets=3D1 bytes=3D209 [UNREPLIED] src=3D10.13.1.22 dst=3D10.15.1.152 =
spor
t=3D138 dport=3D138 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 405181 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D1026
dport=3D3394 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.2.1.163 dst
=3D10.13.1.22 sport=3D3394 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405481 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1903 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1903 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 317715 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D3811 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D3811 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 287165 ESTABLISHED src=3D10.13.1.26 dst=3D10.1.1.25 =
sport=3D2907
dport=3D1027 packets=3D1 bytes=3D40 [UNREPLIED] src=3D10.1.1.25 dst=3D10
.13.1.26 sport=3D1027 dport=3D2907 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 100 TIME_WAIT src=3D10.15.1.152 dst=3D10.13.1.22 sport=3D1479
dport=3D139 packets=3D20 bytes=3D2681 src=3D10.13.1.22 dst=3D10.15.1.152 =
sp
ort=3D139 dport=3D1479 packets=3D19 bytes=3D6472 [ASSURED] mark=3D0 =
use=3D1
tcp      6 415399 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1643 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1643 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415572 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4949 packets=3D13 bytes=3D4686 [UNREPLIED] src=3D10.21.1.170
 dst=3D10.13.1.22 sport=3D4949 dport=3D1026 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 420364 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1130 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1130 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
udp      17 21 src=3D10.13.1.26 dst=3D10.21.1.167 sport=3D53 =
dport=3D1054
packets=3D16 bytes=3D3282 [UNREPLIED] src=3D10.21.1.167 dst=3D10.13.1.26 =
s
port=3D1054 dport=3D53 packets=3D0 bytes=3D0 mark=3D0 use=3D1
tcp      6 398291 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D1478 packets=3D32 bytes=3D16534 [UNREPLIED] src=3D10.1.1.205=20
dst=3D10.13.1.22 sport=3D1478 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 395278 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1400 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1400 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 392922 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1333 packets=3D2 bytes=3D208 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1333 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 405472 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.202 =
sport=3D135
dport=3D3084 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.2.1.202 dst=3D
10.13.1.22 sport=3D3084 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 394623 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1364 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1364 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 398291 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1026
dport=3D1475 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.1.1.205 dst
=3D10.13.1.22 sport=3D1475 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 385075 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D1307
dport=3D1226 packets=3D25 bytes=3D13654 [UNREPLIED] src=3D10.44.1.15
1 dst=3D10.13.1.22 sport=3D1226 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
udp      17 174 src=3D10.13.1.26 dst=3D64.34.168.95 sport=3D1066 =
dport=3D53
packets=3D5 bytes=3D280 src=3D64.34.168.95 dst=3Daaa.bbb.212.154 =
sport=3D5
3 dport=3D1066 packets=3D5 bytes=3D670 [ASSURED] mark=3D0 use=3D1
tcp      6 405181 ESTABLISHED src=3D10.13.1.22 dst=3D10.2.1.163 =
sport=3D135
dport=3D3391 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.2.1.163 dst=3D
10.13.1.22 sport=3D3391 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 431946 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.164 =
sport=3D1307
dport=3D3844 packets=3D2088 bytes=3D1501998 [UNREPLIED] src=3D10.1.1.
164 dst=3D10.13.1.22 sport=3D3844 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 399398 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D1026
dport=3D4747 packets=3D4 bytes=3D570 [UNREPLIED] src=3D10.21.1.170 d
st=3D10.13.1.22 sport=3D4747 dport=3D1026 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 382749 ESTABLISHED src=3D10.13.1.22 dst=3D10.44.1.151 =
sport=3D135
dport=3D1165 packets=3D3 bytes=3D660 [UNREPLIED] src=3D10.44.1.151 ds
t=3D10.13.1.22 sport=3D1165 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 415817 ESTABLISHED src=3D10.13.1.22 dst=3D10.21.1.170 =
sport=3D135
dport=3D1053 packets=3D2 bytes=3D380 [UNREPLIED] src=3D10.21.1.170 ds
t=3D10.13.1.22 sport=3D1053 dport=3D135 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
tcp      6 411724 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.205 =
sport=3D1307
dport=3D2070 packets=3D121 bytes=3D102530 [UNREPLIED] src=3D10.1.1.20
5 dst=3D10.13.1.22 sport=3D2070 dport=3D1307 packets=3D0 bytes=3D0 =
mark=3D0 use=3D1
tcp      6 408126 ESTABLISHED src=3D10.13.1.22 dst=3D10.1.1.151 =
sport=3D1128
dport=3D3101 packets=3D2 bytes=3D220 [UNREPLIED] src=3D10.1.1.151 dst
=3D10.13.1.22 sport=3D3101 dport=3D1128 packets=3D0 bytes=3D0 mark=3D0 =
use=3D1
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
