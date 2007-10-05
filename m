From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Fri, 5 Oct 2007 22:06:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
 <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-8327972-1191614797=:11803"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:34149 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106AbXJEUGu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:06:50 -0400
In-Reply-To: <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-8327972-1191614797=:11803
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 4 Oct 2007, Jozsef Kadlecsik wrote:

> On Thu, 4 Oct 2007, Patrick McHardy wrote:
>
>> Right, I didn't express myself correctly. What I meant to say is that
>> skb_network_offset is always 0 while we're inside the IP(v6) layer.
>
> Then what I sent is a NOOP, I'm sorry for the noise.
>
> Krzysztof, could you send us tcpdump recording as Patrick suggested?

Si.

--- example #1 begin ---
Connections from 192.168.150.12:38485

21:44:59.822546 IP (tos 0x0, ttl 1, id 42330, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.12.38485 > 192.168.50.21.80: S, cksum 0x4a98=
 (correct), 3235584816:3235584816(0) win 5840 <mss 1460,sackOK,timestamp 18=
12577898 0,nop,wscale 7>
21:44:59.822643 IP (tos 0x0, ttl 128, id 13168, offset 0, flags [none], pro=
to TCP (6), length 64) 192.168.50.21.80 > 192.168.150.12.38485: S, cksum 0x=
272e (correct), 2584049816:2584049816(0) ack 3235584817 win 16384 <mss 1460=
,nop,wscale 0,nop,nop,timestamp 0 0,nop,nop,sackOK>
21:44:59.822677 IP (tos 0x0, ttl 1, id 42331, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.12.38485 > 192.168.50.21.80: ., cksum 0x7d57=
 (correct), ack 2584049817 win 46 <nop,nop,timestamp 1812577898 0>
21:44:59.822703 IP (tos 0x0, ttl 1, id 42332, offset 0, flags [DF], proto T=
CP (6), length 935) 192.168.150.12.38485 > 192.168.50.21.80: P 3235584817:3=
235585700(883) ack 2584049817 win 46 <nop,nop,timestamp 1812577898 0>
21:44:59.822992 IP (tos 0x0, ttl 128, id 13169, offset 0, flags [DF], proto=
 TCP (6), length 308) 192.168.50.21.80 > 192.168.150.12.38485: FP 258404981=
7:2584050073(256) ack 3235585700 win 64652 <nop,nop,timestamp 32205200 1812=
577898>
21:44:59.862142 IP (tos 0x0, ttl 1, id 42333, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.12.38485 > 192.168.50.21.80: ., cksum 0x0d38=
 (correct), ack 2584050074 win 54 <nop,nop,timestamp 1812577938 32205200>
21:44:59.870913 IP (tos 0x0, ttl 1, id 42334, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.12.38485 > 192.168.50.21.80: F, cksum 0x0d2f=
 (correct), 3235585700:3235585700(0) ack 2584050074 win 54 <nop,nop,timesta=
mp 1812577946 32205200>
21:44:59.870998 IP (tos 0x0, ttl 128, id 13216, offset 0, flags [DF], proto=
 TCP (6), length 52) 192.168.50.21.80 > 192.168.150.12.38485: ., cksum 0x10=
d7 (correct), ack 3235585701 win 64652 <nop,nop,timestamp 32205201 18125779=
46>

21:45:03.379006 IP (tos 0x0, ttl 1, id 63436, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.12.38485 > 192.168.50.21.80: S, cksum 0x4896=
 (correct), 2494249856:2494249856(0) win 5840 <mss 1460,sackOK,timestamp 18=
12581452 0,nop,wscale 7>
21:45:06.380974 IP (tos 0x0, ttl 1, id 63437, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.12.38485 > 192.168.50.21.80: S, cksum 0x3cdc=
 (correct), 2494249856:2494249856(0) win 5840 <mss 1460,sackOK,timestamp 18=
12584454 0,nop,wscale 7>

Oct  5 21:45:03 fw1 kernel: nf_ct_tcp: invalid SYNIN=3D OUT=3D SRC=3D192.16=
8.150.12 DST=3D192.168.50.21 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D=
63436 DF PROTO=3DTCP SPT=3D38485 DPT=3D80 SEQ=3D2494249856 ACK=3D0 WINDOW=
=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A6C09CC4C00000000010303=
07) UID=3D451
Oct  5 21:45:06 fw1 kernel: nf_ct_tcp: invalid SYNIN=3D OUT=3D SRC=3D192.16=
8.150.12 DST=3D192.168.50.21 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D=
63437 DF PROTO=3DTCP SPT=3D38485 DPT=3D80 SEQ=3D2494249856 ACK=3D0 WINDOW=
=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A6C09D80600000000010303=
07) UID=3D451
--- example #1 end ---

--- example #1 begin ---
Connections from 192.168.150.13:60522

21:39:44.134429 IP (tos 0x0, ttl 1, id 49813, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.13.60522 > 192.168.50.51.80: S, cksum 0x3234=
 (correct), 1066479575:1066479575(0) win 5840 <mss 1460,sackOK,timestamp 18=
12262210 0,nop,wscale 7>
21:39:44.134526 IP (tos 0x0, ttl 128, id 29436, offset 0, flags [none], pro=
to TCP (6), length 64) 192.168.50.51.80 > 192.168.150.13.60522: S, cksum 0x=
da9c (correct), 2447238080:2447238080(0) ack 1066479576 win 16384 <mss 1460=
,nop,wscale 0,nop,nop,timestamp 0 0,nop,nop,sackOK>
21:39:44.134559 IP (tos 0x0, ttl 1, id 49814, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.51.80: ., cksum 0x01f3=
 (correct), ack 2447238081 win 46 <nop,nop,timestamp 1812262210 0>
21:39:44.134585 IP (tos 0x0, ttl 1, id 49815, offset 0, flags [DF], proto T=
CP (6), length 475) 192.168.150.13.60522 > 192.168.50.51.80: P 1066479576:1=
066479999(423) ack 2447238081 win 46 <nop,nop,timestamp 1812262210 0>
21:39:44.134826 IP (tos 0x0, ttl 128, id 29437, offset 0, flags [DF], proto=
 TCP (6), length 164) 192.168.50.51.80 > 192.168.150.13.60522: FP 244723808=
1:2447238193(112) ack 1066479999 win 65112 <nop,nop,timestamp 12462265 1812=
262210>
21:39:44.152045 IP (tos 0x0, ttl 1, id 49816, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.51.80: F, cksum 0xd651=
 (correct), 1066479999:1066479999(0) ack 2447238194 win 46 <nop,nop,timesta=
mp 1812262227 12462265>
21:39:44.152247 IP (tos 0x0, ttl 128, id 29444, offset 0, flags [DF], proto=
 TCP (6), length 52) 192.168.50.51.80 > 192.168.150.13.60522: ., cksum 0xd8=
26 (correct), ack 1066480000 win 65112 <nop,nop,timestamp 12462265 18122622=
27>

21:44:12.884700 IP (tos 0x0, ttl 1, id 34935, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.13.60522 > 192.168.50.61.80: S, cksum 0x258d=
 (correct), 3536555879:3536555879(0) win 5840 <mss 1460,sackOK,timestamp 18=
12530960 0,nop,wscale 7>
21:44:12.884856 IP (tos 0x0, ttl 128, id 7132, offset 0, flags [none], prot=
o TCP (6), length 64) 192.168.50.61.80 > 192.168.150.13.60522: S, cksum 0x9=
3b0 (correct), 2820415897:2820415897(0) ack 3536555880 win 16384 <mss 1460,=
nop,wscale 0,nop,nop,timestamp 0 0,nop,nop,sackOK>
21:44:12.884889 IP (tos 0x0, ttl 1, id 34936, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.61.80: ., cksum 0xa134=
 (correct), ack 2820415898 win 46 <nop,nop,timestamp 1812530960 0>
21:44:12.884914 IP (tos 0x0, ttl 1, id 34937, offset 0, flags [DF], proto T=
CP (6), length 354) 192.168.150.13.60522 > 192.168.50.61.80: P 3536555880:3=
536556182(302) ack 2820415898 win 46 <nop,nop,timestamp 1812530960 0>
21:44:12.885855 IP (tos 0x0, ttl 128, id 32768, offset 0, flags [none], pro=
to TCP (6), length 430) 192.168.50.61.80 > 192.168.150.13.60522: P 28204158=
98:2820416276(378) ack 3536556182 win 65535 <nop,nop,timestamp 32197611 181=
2530960>
21:44:12.885880 IP (tos 0x0, ttl 1, id 34938, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.61.80: ., cksum 0x50ad=
 (correct), ack 2820416276 win 54 <nop,nop,timestamp 1812530961 32197611>
21:44:12.885888 IP (tos 0x0, ttl 128, id 32769, offset 0, flags [none], pro=
to TCP (6), length 52) 192.168.50.61.80 > 192.168.150.13.60522: F, cksum 0x=
50e3 (correct), 2820416276:2820416276(0) ack 3536556182 win 65535 <nop,nop,=
timestamp 32197611 1812530960>
21:44:12.925141 IP (tos 0x0, ttl 1, id 34939, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.61.80: ., cksum 0x5084=
 (correct), ack 2820416277 win 54 <nop,nop,timestamp 1812531001 32197611>
21:44:12.943021 IP (tos 0x0, ttl 1, id 34940, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.61.80: F, cksum 0x5072=
 (correct), 3536556182:3536556182(0) ack 2820416277 win 54 <nop,nop,timesta=
mp 1812531018 32197611>
21:44:12.943142 IP (tos 0x0, ttl 128, id 32770, offset 0, flags [none], pro=
to TCP (6), length 52) 192.168.50.61.80 > 192.168.150.13.60522: ., cksum 0x=
5037 (correct), ack 3536556183 win 65534 <nop,nop,timestamp 32197725 181253=
1018>

21:44:21.462090 IP (tos 0x0, ttl 1, id 60902, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.13.60522 > 192.168.50.61.80: S, cksum 0xcef7=
 (correct), 3521103209:3521103209(0) win 5840 <mss 1460,sackOK,timestamp 18=
12539535 0,nop,wscale 7>
21:44:24.461155 IP (tos 0x0, ttl 1, id 60903, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.13.60522 > 192.168.50.61.80: S, cksum 0xc33d=
 (correct), 3521103209:3521103209(0) win 5840 <mss 1460,sackOK,timestamp 18=
12542537 0,nop,wscale 7>

Oct  5 21:44:21 fw1 kernel: nf_ct_tcp: invalid SYNIN=3D OUT=3D SRC=3D192.16=
8.150.13 DST=3D192.168.50.61 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D=
60902 DF PROTO=3DTCP SPT=3D60522 DPT=3D80 SEQ=3D3521103209 ACK=3D0 WINDOW=
=3D5840 RES=3D0x00 SYN URGP=3D0 OPT (020405B40402080A6C09288F00000000010303=
07) UID=3D451
--- example #2 end---

Please let me know if you need more tcpdumps, etc. If that may help I can=
=20
also provide "conntrack -E" output.

> Adding '#define DEBUG' to the front of nf_conntrack_proto_tcp.c could hel=
p
> a lot too, as we could see what conntrack thinks about the packets.

This has to wait one week - I do not want to do it remotely. I will do it=
=20
ASAP when I come back from Greece.

Thank you.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-8327972-1191614797=:11803--
