From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Troubeleshooting  a  PPTP conversation
Date: Sat, 26 Aug 2006 19:13:41 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F9CF@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Hello -=20
=20
I have a firewall with kernel 2.6.17.1 and iptables 1.3.5.  Behind it is
a Win2000 server with MS RRAS.  I am using ip_nat_pptp and
ip_conntrack_pptp and trying to setup a PPTP VPN connection from my
place to this target server. I have appropriate NAT and filtering rules
set up for tcp 1723 and GRE.  It all works great when I do it the first
time but began failing for some people after multiple connections or
connections from different PCs behind the same remote NAT gateway.  Now
it is behaving badly for me.  I had a PPTP connection from my place to
the target site last night and then it dropped unexpectedly for some
reason.  Today I am not able to establish it again.  It's almost as if
the firewall thinks the old connnection is still alive and it won't get
rid of a leftover bogus conntrack entry to start a new one. =20

Below is some tcpdump output and I am trying to understand what it is
telling me:  I did a little bit of formatting to hopefully make it
readable.  66.173.97.0/27 is my place.  The target site is
aaa.bbb.212.154. =20

Would anyone help me make sense of this conversation? =20

Thanks

- Greg Scott

=20
[root@lakeville-fw firewall-scripts]# /usr/sbin/tcpdump -i eth0 net
66.173.97.0/27 and port not telnet and port not 3389 -nn -vv
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96
bytes
=20
18:42:14.935320 IP (tos 0x0, ttl 118, id 35927, offset 0, flags [DF],
proto: TCP (6), length: 48) 66.173.97.2.2903 > aaa.bbb.212.154
.1723: S, cksum 0x6f68 (correct), 1914062274:1914062274(0) win 65535
<mss 1460,nop,nop,sackOK>
=20
18:42:14.936354 IP (tos 0x0, ttl 126, id 54975, offset 0, flags [DF],
proto: TCP (6), length: 48) aaa.bbb.212.154.1723 > 66.173.97.2
.2903: S, cksum 0x2314 (correct), 1787486648:1787486648(0) ack
1914062275 win 65535 <mss 1460,nop,nop,sackOK>
=20
18:42:14.972937 IP (tos 0x0, ttl 118, id 35928, offset 0, flags [DF],
proto: TCP (6), length: 196) 66.173.97.2.2903 > aaa.bbb.212.15
4.1723: P 1:157(156) ack 1 win 65535: pptp Length=3D156 CTRL-MSG
Magic-Cookie=3D1a2b3c4d CTRL_MSGTYPE=3DSCCRQ PROTO_VER(1.0) FRAME_CAP(A) =

BEARER_CAP(A) MAX_CHAN(0) FIRM_REV(2600) [|pptp]
=20
18:42:14.973814 IP (tos 0x0, ttl 126, id 54976, offset 0, flags [DF],
proto: TCP (6), length: 196) aaa.bbb.212.154.1723 > 66.173.97.
2.2903: P 1:157(156) ack 157 win 65379: pptp Length=3D156 CTRL-MSG
Magic-Cookie=3D1a2b3c4d CTRL_MSGTYPE=3DSCCRP PROTO_VER(1.0) RESULT_CODE
(1:Successful channel establishment) ERR_CODE(0:None) FRAME_CAP(S)
BEARER_CAP(DA) MAX_CHAN(0) FIRM_REV(2195) [|pptp]
=20
18:42:15.009843 IP (tos 0x0, ttl 118, id 35929, offset 0, flags [DF],
proto: TCP (6), length: 208) 66.173.97.2.2903 > aaa.bbb.212.15
4.1723: P 157:325(168) ack 157 win 65379: pptp Length=3D168 CTRL-MSG
Magic-Cookie=3D1a2b3c4d CTRL_MSGTYPE=3DOCRQ CALL_ID(256) CALL_SER_NUM
(49096) MIN_BPS(300) MAX_BPS(100000000) BEARER_TYPE(Any) FRAME_TYPE(E)
RECV_WIN(64) PROC_DELAY(0) PHONE_NO_LEN(0) [|pptp]
=20
18:42:15.012881 IP (tos 0x0, ttl 126, id 54977, offset 0, flags [DF],
proto: TCP (6), length: 72) 10.13.1.22.1723 > 66.173.97.2.2903
: P, cksum 0xaf0c (incorrect (-> 0x4d48), 1787486805:1787486837(32) ack
1914062599 win 65211: pptp Length=3D32 CTRL-MSG Magic-Cookie=3D1
a2b3c4d CTRL_MSGTYPE=3DOCRP CALL_ID(999) PEER_CALL_ID(2903)
RESULT_CODE(1:Connected) ERR_CODE(0:None) CAUSE_CODE(0)
CONN_SPEED(1480832
5) RECV_WIN(16384) PROC_DELAY(0) PHY_CHAN_ID(0)
=20
18:42:17.490606 IP (tos 0x0, ttl 118, id 35933, offset 0, flags [DF],
proto: TCP (6), length: 208) 66.173.97.2.2903 > aaa.bbb.212.15
4.1723: P 157:325(168) ack 157 win 65379: pptp Length=3D168 CTRL-MSG
Magic-Cookie=3D1a2b3c4d CTRL_MSGTYPE=3DOCRQ CALL_ID(512) CALL_SER_NUM
(49096) MIN_BPS(300) MAX_BPS(100000000) BEARER_TYPE(Any) FRAME_TYPE(E)
RECV_WIN(64) PROC_DELAY(0) PHONE_NO_LEN(0) [|pptp]
18:42:17.491668 IP (tos 0x0, ttl 126, id 55081, offset 0, flags [DF],
proto: TCP (6), length: 40) aaa.bbb.212.154.1723 > 66.173.97.2
.2903: ., cksum 0x4f1c (correct), 189:189(0) ack 325 win 65211
=20
18:42:17.604154 IP (tos 0x0, ttl 126, id 55082, offset 0, flags [DF],
proto: TCP (6), length: 72) aaa.bbb.212.154.1723 > 66.173.97.2
.2903: P, cksum 0xbba4 (correct), 157:189(32) ack 325 win 65211: pptp
Length=3D32 CTRL-MSG Magic-Cookie=3D1a2b3c4d CTRL_MSGTYPE=3DOCRP CAL
L_ID(999) PEER_CALL_ID(512) RESULT_CODE(1:Connected) ERR_CODE(0:None)
CAUSE_CODE(0) CONN_SPEED(14808325) RECV_WIN(16384) PROC_DELAY(
0) PHY_CHAN_ID(0)
=20
18:42:17.788927 IP (tos 0x0, ttl 118, id 35935, offset 0, flags [DF],
proto: TCP (6), length: 40) 66.173.97.2.2903 > aaa.bbb.212.154
.1723: ., cksum 0x4e94 (correct), 325:325(0) ack 189 win 65347
