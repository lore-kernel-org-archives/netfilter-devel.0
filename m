From: Krzysztof Oledzki <ole@ans.pl>
Subject: Problem accessing https://my.procurve.com/profile/index.aspx (ACK
 is over the upper bound)
Date: Sun, 1 Jul 2007 02:42:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-155162530-1183250535=:13212"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-155162530-1183250535=:13212
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

My colleague have just reported that he is unable to access "REGISTER=20
HERE" page from the https://my.procurve.com/profile/index.aspx. Short=20
debuging shows that his connection was dropped by the netfilter code=20
running on fw/nat host:

02:06:29.573031 IP (tos 0x0, ttl 127, id 43914, offset 0, flags [DF], proto=
: TCP (6), length: 48) 195.177.210.11.6347 > 216.34.143.7.443: S, cksum 0xb=
b9c (correct), 3455050277:3455050277(0) win 65535 <mss 1460,nop,nop,sackOK>
02:06:29.756857 IP (tos 0x0, ttl 241, id 41244, offset 0, flags [DF], proto=
: TCP (6), length: 48) 216.34.143.7.443 > 195.177.210.11.6347: S, cksum 0x0=
655 (correct), 1733443080:1733443080(0) ack 3455050278 win 4140 <mss 1380,n=
op,nop,sackOK>
02:06:29.757021 IP (tos 0x0, ttl 127, id 43920, offset 0, flags [DF], proto=
: TCP (6), length: 40) 195.177.210.11.6347 > 216.34.143.7.443: ., cksum 0x4=
2f5 (correct), ack 1733443081 win 65535
02:06:29.757871 IP (tos 0x0, ttl 127, id 43923, offset 0, flags [DF], proto=
: TCP (6), length: 142) 195.177.210.11.6347 > 216.34.143.7.443: P 345505027=
8:3455050380(102) ack 1733443081 win 65535
02:06:29.941610 IP (tos 0x0, ttl 241, id 41252, offset 0, flags [DF], proto=
: TCP (6), length: 162) 216.34.143.7.443 > 195.177.210.11.6347: P 173344308=
1:1733443203(122) ack 3455050380 win 4242
02:06:29.944767 IP (tos 0x0, ttl 127, id 43930, offset 0, flags [DF], proto=
: TCP (6), length: 83) 195.177.210.11.6347 > 216.34.143.7.443: P 3455050380=
:3455050423(43) ack 1733443203 win 65413
02:06:29.946115 IP (tos 0x0, ttl 127, id 43932, offset 0, flags [DF], proto=
: TCP (6), length: 1216) 195.177.210.11.6347 > 216.34.143.7.443: P 34550504=
23:3455051599(1176) ack 1733443203 win 65413
02:06:29.946221 IP (tos 0x0, ttl 127, id 43933, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 195.177.210.11.6347 > 216.34.143.7.443: . 34550515=
99:3455052979(1380) ack 1733443203 win 65413
02:06:29.946241 IP (tos 0x0, ttl 127, id 43934, offset 0, flags [DF], proto=
: TCP (6), length: 689) 195.177.210.11.6347 > 216.34.143.7.443: P 345505297=
9:3455053628(649) ack 1733443203 win 65413
02:06:30.130106 IP (tos 0x0, ttl 241, id 41259, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.11.6347: ., cksum 0x2=
7fd (correct), ack 3455051599 win 5461
02:06:30.130125 IP (tos 0x0, ttl 241, id 41261, offset 0, flags [DF], proto=
: TCP (6), length: 52) 216.34.143.7.443 > 195.177.210.11.6347: ., cksum 0x6=
cd9 (correct), ack 3455051599 win 5461 <nop,nop,sack 1 {236696358:236697007=
}>
02:06:30.134620 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], proto: TC=
P (6), length: 40) 195.177.210.11.6347 > 216.34.143.7.443: R, cksum 0xe333 =
(correct), 3455051599:3455051599(0) win 0
02:06:30.134629 IP (tos 0x0, ttl 241, id 41265, offset 0, flags [DF], proto=
: TCP (6), length: 52) 216.34.143.7.443 > 195.177.210.11.6347: ., cksum 0x6=
263 (correct), ack 3455053628 win 7490 <nop,nop,sack 1 {236694978:236697007=
}>
02:06:30.140908 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], proto: TC=
P (6), length: 40) 195.177.210.11.6347 > 216.34.143.7.443: R, cksum 0xdb46 =
(correct), 3455053628:3455053628(0) win 0
02:06:30.140929 IP (tos 0x0, ttl 241, id 41269, offset 0, flags [DF], proto=
: TCP (6), length: 565) 216.34.143.7.443 > 195.177.210.11.6347: P 173344320=
3:1733443716(513) ack 3455053628 win 7490 <nop,nop,sack 1 {236694978:236697=
007}>
02:06:30.147216 IP (tos 0x0, ttl  64, id 0, offset 0, flags [DF], proto: TC=
P (6), length: 40) 195.177.210.11.6347 > 216.34.143.7.443: R, cksum 0xdb46 =
(correct), 3455053628:3455053628(0) win 0
02:06:32.523268 IP (tos 0x0, ttl 127, id 43966, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 195.177.210.11.6347 > 216.34.143.7.443: . 34550515=
99:3455052979(1380) ack 1733443203 win 65413
02:06:32.707202 IP (tos 0x0, ttl 240, id 40250, offset 0, flags [none], pro=
to: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.11.6347: R, cksum 0=
x3dc8 (correct), 1733443203:1733443203(0) ack 3455051599 win 65413

Jul  1 02:06:30 fw1 kernel: nf_ct_tcp: ACK is over the upper bound (ACKed d=
ata not seen yet) IN=3D OUT=3D SRC=3D216.34.143.7 DST=3D195.177.210.11 LEN=
=3D52 TOS=3D0x00 PREC=3D0x00 TTL=3D241 ID=3D41261 DF PROTO=3DTCP SPT=3D443 =
DPT=3D6347 SEQ=3D1733443203 ACK=3D3455051599 WINDOW=3D5461 RES=3D0x00 ACK U=
RGP=3D0 OPT (0101050A0E1BB3260E1BB5AF)
Jul  1 02:06:30 fw1 kernel: nf_ct_tcp: ACK is over the upper bound (ACKed d=
ata not seen yet) IN=3D OUT=3D SRC=3D216.34.143.7 DST=3D195.177.210.11 LEN=
=3D52 TOS=3D0x00 PREC=3D0x00 TTL=3D241 ID=3D41265 DF PROTO=3DTCP SPT=3D443 =
DPT=3D6347 SEQ=3D1733443203 ACK=3D3455053628 WINDOW=3D7490 RES=3D0x00 ACK U=
RGP=3D0 OPT (0101050A0E1BADC20E1BB5AF)
Jul  1 02:06:30 fw1 kernel: nf_ct_tcp: ACK is over the upper bound (ACKed d=
ata not seen yet) IN=3D OUT=3D SRC=3D216.34.143.7 DST=3D195.177.210.11 LEN=
=3D565 TOS=3D0x00 PREC=3D0x00 TTL=3D241 ID=3D41269 DF PROTO=3DTCP SPT=3D443=
 DPT=3D6347 SEQ=3D1733443203 ACK=3D3455053628 WINDOW=3D7490 RES=3D0x00 ACK =
PSH URGP=3D0 OPT (0101050A0E1BADC20E1BB5AF)

AFAIK netfilter is supposed to drop such packet (without sending a RST),=20
isn't it? So why the RST packet was sent?

Setting net.ipv4.netfilter.ip_conntrack_tcp_be_liberal solves the problem,=
=20
but this is not a right fix and now the main question is: was this ACK=20
really over the upper bound since when=20
net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled it is possible=20
to access this page (of course with many netfilter warnings that "ACK is=20
over the upper bound").

root@fw1:~# uname -r
2.6.20.11

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-155162530-1183250535=:13212--
