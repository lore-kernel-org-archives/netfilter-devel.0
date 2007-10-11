From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question (fwd)
Date: Thu, 11 Oct 2007 23:17:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710112314380.31931@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-187430788-1409080373-1192136361=:29814"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:40833 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbXJKVRX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:17:23 -0400
Received: from bizon.gios.gov.pl (ole@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.1/8.14.1) with ESMTP id l9BLHIGg032077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Oct 2007 23:17:20 +0200
Received: from localhost (ole@localhost)
	by bizon.gios.gov.pl (8.14.1/8.14.1/Submit) with ESMTP id l9BLHHLg032074
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Oct 2007 23:17:18 +0200
Content-ID: <Pine.LNX.4.64.0710112314381.31931@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1409080373-1192136361=:29814
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0710112314382.31931@bizon.gios.gov.pl>

Hello,

It seems that vger is little to restrictive:

<netfilter-devel@vger.kernel.org>
     (reason: 550 5.7.1 Content-Policy reject msg: The message contains HTM=
L subpart, therefore we consider it SPAM orOutlook Virus.  TEXT/PLAIN is ac=
cepted.! BF:<H 2.08683e-12>; S1755231AbXJKU7g)

Forwared with questione parts removed...

---------- Forwarded message ----------
Date: Thu, 11 Oct 2007 22:59:21 +0200 (CEST)
From: Krzysztof Oledzki <ole@ans.pl>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
     Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=3D" - a patch and a question

Hello,

Something is still wrong in this area. With the recent fix there are no mor=
e=20
"invalid SYNIN=3D" messages, but with unsuccessful request simulated with=
=20
"echo|nc" next connections are not possible. I included full log & tcpdump =
for=20
the simulation, but I also marked IMHO the most interesting part with "***=
=20
Here:".

Thank you.

--- cut here ---
sysctl net.ipv4.ip_local_port_range=3D"50000 50003"
sysctl net.netfilter.nf_conntrack_log_invalid=3D255

while true ; do echo|nc -w 1 wp.pl 80 2>/dev/null >/dev/null; echo -ne "HEA=
D /=20
HTTP/1.0\r\nHost: www.wp.pl\r\n\r\n"|nc -w 2 wp.pl 80 ; sleep 1 ; done
--- cut here ---

<CUT>

wp.pl [212.77.100.101] 80 (http) : Connection timed out
wp.pl [212.77.100.101] 80 (http) : Connection timed out


--- syslog ---
Oct 11 22:36:32 wrestler kernel: nf_ct_tcp: invalid packed ignored IN=3D OU=
T=3D=20
SRC=3D195.177.210.7 DST=3D212.77.100.101 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TT=
L=3D64 ID=3D27043=20
DF PROTO=3DTCP SPT=3D50002 DPT=3D80 SEQ=3D687369841 ACK=3D0 WINDOW=3D5840 R=
ES=3D0x00 SYN=20
URGP=3D0 OPT (020405B40402080A023107D20000000001030306) UID=3D0
Oct 11 22:36:32 wrestler kernel: nf_ct_tcp: killing out of sync session IN=
=3D=20
OUT=3D SRC=3D212.77.100.101 DST=3D195.177.210.7 LEN=3D60 TOS=3D0x00 PREC=3D=
0x00 TTL=3D57 ID=3D0=20
DF PROTO=3DTCP SPT=3D80 DPT=3D50002 SEQ=3D453422905 ACK=3D687369842 WINDOW=
=3D5792 RES=3D0x00=20
ACK SYN URGP=3D0 OPT (020405B40402080A6BC6D918023107D201030302)
Oct 11 22:36:37 wrestler kernel: nf_ct_tcp: invalid packed ignored IN=3D OU=
T=3D=20
SRC=3D195.177.210.7 DST=3D212.77.100.101 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TT=
L=3D64 ID=3D5495=20
DF PROTO=3DTCP SPT=3D50001 DPT=3D80 SEQ=3D1412107783 ACK=3D0 WINDOW=3D5840 =
RES=3D0x00 SYN=20
URGP=3D0 OPT (020405B40402080A02311B700000000001030306) UID=3D0
Oct 11 22:36:37 wrestler kernel: nf_ct_tcp: killing out of sync session IN=
=3D=20
OUT=3D SRC=3D212.77.100.101 DST=3D195.177.210.7 LEN=3D60 TOS=3D0x00 PREC=3D=
0x00 TTL=3D57 ID=3D0=20
DF PROTO=3DTCP SPT=3D80 DPT=3D50001 SEQ=3D2215777897 ACK=3D1412107784 WINDO=
W=3D5792=20
RES=3D0x00 ACK SYN URGP=3D0 OPT (020405B40402080A0DDF22ED02311B7001030302)
Oct 11 22:36:40 wrestler kernel: nf_ct_tcp: invalid packed ignored IN=3D OU=
T=3D=20
SRC=3D212.77.100.101 DST=3D195.177.210.7 LEN=3D52 TOS=3D0x00 PREC=3D0x00 TT=
L=3D57 ID=3D0 DF=20
PROTO=3DTCP SPT=3D80 DPT=3D50002 SEQ=3D453422906 ACK=3D687369842 WINDOW=3D5=
792 RES=3D0x00 ACK=20
URGP=3D0 OPT (0101080A6BC6F873023107D2)

*** Here:
Oct 11 22:36:41 wrestler kernel: nf_ct_tcp: invalid packed ignored IN=3D OU=
T=3D=20
SRC=3D195.177.210.7 DST=3D212.77.100.101 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TT=
L=3D64 ID=3D39200=20
DF PROTO=3DTCP SPT=3D50000 DPT=3D80 SEQ=3D1115992631 ACK=3D0 WINDOW=3D5840 =
RES=3D0x00 SYN=20
URGP=3D0 OPT (020405B40402080A02312B170000000001030306) UID=3D0
Oct 11 22:36:41 wrestler kernel: nf_ct_tcp: killing out of sync session IN=
=3D=20
OUT=3D SRC=3D212.77.100.101 DST=3D195.177.210.7 LEN=3D60 TOS=3D0x00 PREC=3D=
0x00 TTL=3D57 ID=3D0=20
DF PROTO=3DTCP SPT=3D80 DPT=3D50000 SEQ=3D9811630 ACK=3D1115992632 WINDOW=
=3D5792 RES=3D0x00=20
ACK SYN URGP=3D0 OPT (020405B40402080A1DD1B5B002312B1701030302)

--- tcpdump ---
22:36:27.218445 IP (tos 0x0, ttl 64, id 31236, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50002 > 212.77.100.101.80: S, cksum 0x40f4=20
(correct), 3779627100:3779627100(0) win 5840 <mss 1460,sackOK,timestamp=20
36762200 0,nop,wscale 6>
22:36:27.232643 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50002: S, cksum 0x2b69 (correc=
t),=20
2211613225:2211613225(0) ack 3779627101 win 5792 <mss 1460,sackOK,timestamp=
=20
232716755 36762200,nop,wscale 2>
22:36:27.232678 IP (tos 0x0, ttl 64, id 31237, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50002 > 212.77.100.101.80: ., cksum 0x7066=20
(correct), ack 2211613226 win 92 <nop,nop,timestamp 36762214 232716755>
22:36:27.232765 IP (tos 0x0, ttl 64, id 31238, offset 0, flags [DF], proto =
TCP=20
(6), length 53) 195.177.210.7.50002 > 212.77.100.101.80: P, cksum 0x665d=20
(correct), 3779627101:3779627102(1) ack 2211613226 win 92 <nop,nop,timestam=
p=20
36762214 232716755>
22:36:27.246675 IP (tos 0x0, ttl 57, id 29640, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50002: ., cksum 0x6b0a=20
(correct), ack 3779627102 win 1448 <nop,nop,timestamp 232716770 36762214>
22:36:29.232026 IP (tos 0x0, ttl 64, id 31239, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50002 > 212.77.100.101.80: F, cksum 0x6885=20
(correct), 3779627102:3779627102(0) ack 2211613226 win 92 <nop,nop,timestam=
p=20
36764214 232716770>
22:36:29.235128 IP (tos 0x0, ttl 64, id 5494, offset 0, flags [DF], proto T=
CP=20
(6), length 60) 195.177.210.7.50000 > 212.77.100.101.80: S, cksum 0x5a95=20
(correct), 1490415439:1490415439(0) win 5840 <mss 1460,sackOK,timestamp=20
36764217 0,nop,wscale 6>
22:36:29.246360 IP (tos 0x0, ttl 57, id 29642, offset 0, flags [DF], proto =
TCP=20
(6), length 467) 212.77.100.101.80 > 195.177.210.7.50002: P=20
2211613226:2211613641(415) ack 3779627103 win 1448 <nop,nop,timestamp 23271=
8770=20
36764214>
22:36:29.246398 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 40) 195.177.210.7.50002 > 212.77.100.101.80: R, cksum 0xb429 (correc=
t),=20
3779627103:3779627103(0) win 0
22:36:29.249318 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0x72f7 (correc=
t),=20
451450258:451450258(0) ack 1490415440 win 5792 <mss 1460,sackOK,timestamp=
=20
1808190335 36764217,nop,wscale 2>
22:36:29.249344 IP (tos 0x0, ttl 64, id 5495, offset 0, flags [DF], proto T=
CP=20
(6), length 52) 195.177.210.7.50000 > 212.77.100.101.80: ., cksum 0xb7f4=20
(correct), ack 451450259 win 92 <nop,nop,timestamp 36764231 1808190335>
22:36:29.249443 IP (tos 0x0, ttl 64, id 5496, offset 0, flags [DF], proto T=
CP=20
(6), length 88) 195.177.210.7.50000 > 212.77.100.101.80: P=20
1490415440:1490415476(36) ack 451450259 win 92 <nop,nop,timestamp 36764231=
=20
1808190335>
22:36:29.263244 IP (tos 0x0, ttl 57, id 24094, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50000: ., cksum 0xb276=20
(correct), ack 1490415476 win 1448 <nop,nop,timestamp 1808190349 36764231>
22:36:29.479692 IP (tos 0x0, ttl 57, id 24096, offset 0, flags [DF], proto =
TCP=20
(6), length 716) 212.77.100.101.80 > 195.177.210.7.50000: P=20
451450259:451450923(664) ack 1490415476 win 1448 <nop,nop,timestamp 1808190=
565=20
36764231>
22:36:29.479713 IP (tos 0x0, ttl 64, id 5497, offset 0, flags [DF], proto T=
CP=20
(6), length 52) 195.177.210.7.50000 > 212.77.100.101.80: ., cksum 0xb358=20
(correct), ack 451450923 win 112 <nop,nop,timestamp 36764461 1808190565>
22:36:29.694193 IP (tos 0x0, ttl 57, id 24098, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50000: F, cksum 0xad49=20
(correct), 451450923:451450923(0) ack 1490415476 win 1448 <nop,nop,timestam=
p=20
1808190779 36764461>
22:36:29.694255 IP (tos 0x0, ttl 64, id 5498, offset 0, flags [DF], proto T=
CP=20
(6), length 52) 195.177.210.7.50000 > 212.77.100.101.80: F, cksum 0xb1a9=20
(correct), 1490415476:1490415476(0) ack 451450924 win 112 <nop,nop,timestam=
p=20
36764676 1808190779>
22:36:29.708172 IP (tos 0x0, ttl 57, id 24100, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50000: ., cksum 0xac63=20
(correct), ack 1490415477 win 1448 <nop,nop,timestamp 1808190793 36764676>
22:36:30.699067 IP (tos 0x0, ttl 64, id 50929, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50001 > 212.77.100.101.80: S, cksum 0xb365=20
(correct), 2962962688:2962962688(0) win 5840 <mss 1460,sackOK,timestamp=20
36765681 0,nop,wscale 6>
22:36:30.712621 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50001: S, cksum 0x8dca (correc=
t),=20
8944860:8944860(0) ack 2962962689 win 5792 <mss 1460,sackOK,timestamp 50027=
1752=20
36765681,nop,wscale 2>
22:36:30.712663 IP (tos 0x0, ttl 64, id 50930, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50001 > 212.77.100.101.80: ., cksum 0xd2c8=20
(correct), ack 8944861 win 92 <nop,nop,timestamp 36765694 500271752>
22:36:30.712715 IP (tos 0x0, ttl 64, id 50931, offset 0, flags [DF], proto =
TCP=20
(6), length 53) 195.177.210.7.50001 > 212.77.100.101.80: P, cksum 0xc8bf=20
(correct), 2962962689:2962962690(1) ack 8944861 win 92 <nop,nop,timestamp=
=20
36765694 500271752>
22:36:30.726652 IP (tos 0x0, ttl 57, id 63048, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50001: ., cksum 0xcd6d=20
(correct), ack 2962962690 win 1448 <nop,nop,timestamp 500271766 36765694>
22:36:32.713026 IP (tos 0x0, ttl 64, id 50932, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50001 > 212.77.100.101.80: F, cksum 0xcae7=20
(correct), 2962962690:2962962690(0) ack 8944861 win 92 <nop,nop,timestamp=
=20
36767695 500271766>
22:36:32.716284 IP (tos 0x0, ttl 64, id 27043, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50002 > 212.77.100.101.80: S, cksum 0xfdb5=20
(correct), 687369841:687369841(0) win 5840 <mss 1460,sackOK,timestamp 36767=
698=20
0,nop,wscale 6>
22:36:32.727982 IP (tos 0x0, ttl 57, id 63050, offset 0, flags [DF], proto =
TCP=20
(6), length 467) 212.77.100.101.80 > 195.177.210.7.50001: P=20
8944861:8945276(415) ack 2962962691 win 1448 <nop,nop,timestamp 500273767=
=20
36767695>
22:36:32.728033 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 40) 195.177.210.7.50001 > 212.77.100.101.80: R, cksum 0x3434 (correc=
t),=20
2962962691:2962962691(0) win 0
22:36:32.730494 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50002: S, cksum 0xeeb9 (correc=
t),=20
453422905:453422905(0) ack 687369842 win 5792 <mss 1460,sackOK,timestamp=20
1808193816 36767698,nop,wscale 2>
22:36:35.720402 IP (tos 0x0, ttl 64, id 18462, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50000 > 212.77.100.101.80: S, cksum 0x5271=20
(correct), 3680721808:3680721808(0) win 5840 <mss 1460,sackOK,timestamp=20
36770702 0,nop,wscale 6>
22:36:35.734360 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0x1838 (correc=
t),=20
2586062097:2586062097(0) ack 3680721809 win 5792 <mss 1460,sackOK,timestamp=
=20
1923088518 36770702,nop,wscale 2>
22:36:35.734406 IP (tos 0x0, ttl 64, id 18463, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50000 > 212.77.100.101.80: ., cksum 0x5d35=20
(correct), ack 2586062098 win 92 <nop,nop,timestamp 36770716 1923088518>
22:36:35.734451 IP (tos 0x0, ttl 64, id 18464, offset 0, flags [DF], proto =
TCP=20
(6), length 53) 195.177.210.7.50000 > 212.77.100.101.80: P, cksum 0x532c=20
(correct), 3680721809:3680721810(1) ack 2586062098 win 92 <nop,nop,timestam=
p=20
36770716 1923088518>
22:36:35.748134 IP (tos 0x0, ttl 57, id 11654, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 212.77.100.101.80 > 195.177.210.7.50000: ., cksum 0x57da=20
(correct), ack 3680721810 win 1448 <nop,nop,timestamp 1923088532 36770716>
22:36:37.298306 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50002: S, cksum 0xdce0 (correc=
t),=20
453422905:453422905(0) ack 687369842 win 5792 <mss 1460,sackOK,timestamp=20
1808198385 36767698,nop,wscale 2>
22:36:37.735036 IP (tos 0x0, ttl 64, id 18465, offset 0, flags [DF], proto =
TCP=20
(6), length 52) 195.177.210.7.50000 > 212.77.100.101.80: F, cksum 0x5554=20
(correct), 3680721810:3680721810(0) ack 2586062098 win 92 <nop,nop,timestam=
p=20
36772717 1923088532>
22:36:37.738312 IP (tos 0x0, ttl 64, id 5495, offset 0, flags [DF], proto T=
CP=20
(6), length 60) 195.177.210.7.50001 > 212.77.100.101.80: S, cksum 0x1f50=20
(correct), 1412107783:1412107783(0) win 5840 <mss 1460,sackOK,timestamp=20
36772720 0,nop,wscale 6>
22:36:37.750598 IP (tos 0x0, ttl 57, id 11656, offset 0, flags [DF], proto =
TCP=20
(6), length 467) 212.77.100.101.80 > 195.177.210.7.50000: P=20
2586062098:2586062513(415) ack 3680721811 win 1448 <nop,nop,timestamp=20
1923090534 36772717>
22:36:37.750647 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 40) 195.177.210.7.50000 > 212.77.100.101.80: R, cksum 0xe6dc (correc=
t),=20
3680721811:3680721811(0) win 0
22:36:37.752345 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50001: S, cksum 0x542b (correc=
t),=20
2215777897:2215777897(0) ack 1412107784 win 5792 <mss 1460,sackOK,timestamp=
=20
232727277 36772720,nop,wscale 2>
22:36:40.742395 IP (tos 0x0, ttl 64, id 34924, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50002 > 212.77.100.101.80: S, cksum 0xbf25=20
(correct), 123711296:123711296(0) win 5840 <mss 1460,sackOK,timestamp 36775=
724=20
0,nop,wscale 6>
22:36:40.756251 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 52) 212.77.100.101.80 > 195.177.210.7.50002: ., cksum 0xfe25 (correc=
t),=20
ack 687369842 win 5792 <nop,nop,timestamp 1808201843 36767698>
22:36:40.756388 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 40) 195.177.210.7.50002 > 212.77.100.101.80: R, cksum 0x8667 (correc=
t),=20
687369842:687369842(0) win 0
22:36:41.176923 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50001: S, cksum 0x46ca (correc=
t),=20
2215777897:2215777897(0) ack 1412107784 win 5792 <mss 1460,sackOK,timestamp=
=20
232730702 36772720,nop,wscale 2>

**Here:
22:36:41.745795 IP (tos 0x0, ttl 64, id 39200, offset 0, flags [DF], proto =
TCP=20
(6), length 60) 195.177.210.7.50000 > 212.77.100.101.80: S, cksum 0x7d20=20
(correct), 1115992631:1115992631(0) win 5840 <mss 1460,sackOK,timestamp=20
36776727 0,nop,wscale 6>
22:36:41.759701 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0xf27d (correc=
t),=20
9811630:9811630(0) ack 1115992632 win 5792 <mss 1460,sackOK,timestamp 50028=
2800=20
36776727,nop,wscale 2>

22:36:46.087537 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0xe194 (correc=
t),=20
9811630:9811630(0) ack 1115992632 win 5792 <mss 1460,sackOK,timestamp 50028=
7129=20
36776727,nop,wscale 2>
22:36:47.175467 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50001: S, cksum 0x2f5a (correc=
t),=20
2215777897:2215777897(0) ack 1412107784 win 5792 <mss 1460,sackOK,timestamp=
=20
232736702 36772720,nop,wscale 2>
22:36:52.085064 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0xca24 (correc=
t),=20
9811630:9811630(0) ack 1115992632 win 5792 <mss 1460,sackOK,timestamp 50029=
3129=20
36776727,nop,wscale 2>
22:36:59.174262 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50001: S, cksum 0x0079 (correc=
t),=20
2215777897:2215777897(0) ack 1412107784 win 5792 <mss 1460,sackOK,timestamp=
=20
232748703 36772720,nop,wscale 2>
22:37:04.084185 IP (tos 0x0, ttl 57, id 0, offset 0, flags [DF], proto TCP =
(6),=20
length 60) 212.77.100.101.80 > 195.177.210.7.50000: S, cksum 0x9b44 (correc=
t),=20
9811630:9811630(0) ack 1115992632 win 5792 <mss 1460,sackOK,timestamp 50030=
5129=20
36776727,nop,wscale 2>
22:37:13.256208 IP (tos 0x0, ttl 248, id 0, offset 0, flags [none], proto T=
CP=20
(6), length 40) 212.77.100.101.80 > 195.177.210.7.50000: R, cksum 0x1dd4=20
(correct), 0:0(0) win 0

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1409080373-1192136361=:29814--
