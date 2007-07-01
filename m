From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Sun, 1 Jul 2007 05:01:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1366444356-1183258915=:13212"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
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

---187430788-1366444356-1183258915=:13212
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 1 Jul 2007, Krzysztof Oledzki wrote:

>
>
> On Sun, 1 Jul 2007, Krzysztof Oledzki wrote:
>
>> Hello,
>>=20
>> My colleague have just reported that he is unable to access "REGISTER HE=
RE"=20
>> page from the https://my.procurve.com/profile/index.aspx. Short debuging=
=20
>> shows that his connection was dropped by the netfilter code running on=
=20
>> fw/nat host:
> <CUT>
>> AFAIK netfilter is supposed to drop such packet (without sending a RST),=
=20
>> isn't it? So why the RST packet was sent?
>
> OK, this was easy. The RST was sent simply because the packed was not dro=
pped=20
> but instead delivered to the local IP - there was no valid tuple to chang=
e=20
> (unnat) the packed destination. Setting:
>
> iptables -I PREROUTING -m conntrack --ctstate INVALID -j DROP
>
> make no more RSTs, only retransmisions from the 216.34.143.7. And yes, I =
have=20
> a patched kernel so I'm able to filter packets in a PREROUTING chain.
>
> The rest of the question remains:
>
>> Setting net.ipv4.netfilter.ip_conntrack_tcp_be_liberal solves the proble=
m,=20
>> but this is not a right fix and now the main question is: was this ACK=
=20
>> really over the upper bound since when=20
>> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled it is possible=
 to=20
>> access this page (of course with many netfilter warnings that "ACK is ov=
er=20
>> the upper bound").

Found this:

http://groups.google.pl/group/fa.openbsd.tech/browse_frm/thread/e27c7363b2c=
636b5/01ba6e0fa873cf42

Sounds familiar - it seems that there may be a crappy OpenBSD firewall=20
lurking somewhere along the path. :(

What we can do with such packets? Maybe, when a ack is valid but a sack is=
=20
not (as it is in this situation) we are able to remove such insane sack=20
option(s) with a hope that this ACK itself may acknowledge something?

This is how this connection looks like when=20
net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled:

04:34:42.276125 IP (tos 0x0, ttl 127, id 10660, offset 0, flags [DF], proto=
: TCP (6), length: 48) 195.177.210.11.6747 > 216.34.143.7.443: S, cksum 0x4=
b25 (correct), 1809363748:1809363748(0) win 65535 <mss 1460,nop,nop,sackOK>
04:34:42.459601 IP (tos 0x0, ttl 241, id 65082, offset 0, flags [DF], proto=
: TCP (6), length: 48) 216.34.143.7.443 > 195.177.210.11.6747: S, cksum 0xa=
5a8 (correct), 3724064662:3724064662(0) ack 1809363749 win 4140 <mss 1380,n=
op,nop,sackOK>
04:34:42.459764 IP (tos 0x0, ttl 127, id 10665, offset 0, flags [DF], proto=
: TCP (6), length: 40) 195.177.210.11.6747 > 216.34.143.7.443: ., cksum 0xe=
248 (correct), ack 3724064663 win 65535
04:34:42.460215 IP (tos 0x0, ttl 127, id 10666, offset 0, flags [DF], proto=
: TCP (6), length: 142) 195.177.210.11.6747 > 216.34.143.7.443: P 180936374=
9:1809363851(102) ack 3724064663 win 65535
04:34:42.644004 IP (tos 0x0, ttl 241, id 65111, offset 0, flags [DF], proto=
: TCP (6), length: 162) 216.34.143.7.443 > 195.177.210.11.6747: P 372406466=
3:3724064785(122) ack 1809363851 win 4242
04:34:42.644766 IP (tos 0x0, ttl 127, id 10672, offset 0, flags [DF], proto=
: TCP (6), length: 83) 195.177.210.11.6747 > 216.34.143.7.443: P 1809363851=
:1809363894(43) ack 3724064785 win 65413
04:34:42.647212 IP (tos 0x0, ttl 127, id 10674, offset 0, flags [DF], proto=
: TCP (6), length: 1216) 195.177.210.11.6747 > 216.34.143.7.443: P 18093638=
94:1809365070(1176) ack 3724064785 win 65413
04:34:42.647362 IP (tos 0x0, ttl 127, id 10675, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 195.177.210.11.6747 > 216.34.143.7.443: . 18093650=
70:1809366450(1380) ack 3724064785 win 65413
04:34:42.647381 IP (tos 0x0, ttl 127, id 10676, offset 0, flags [DF], proto=
: TCP (6), length: 689) 195.177.210.11.6747 > 216.34.143.7.443: P 180936645=
0:1809367099(649) ack 3724064785 win 65413
04:34:42.831152 IP (tos 0x0, ttl 241, id 65117, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.11.6747: ., cksum 0xc=
750 (correct), ack 1809365070 win 5461
acked 1809365070, 1380 + 649 octets unacked yet (1809367099)

04:34:42.831173 IP (tos 0x0, ttl 241, id 65119, offset 0, flags [DF], proto=
: TCP (6), length: 52) 216.34.143.7.443 > 195.177.210.11.6747: ., cksum 0x7=
ee4 (correct), ack 1809365070 win 5461 <nop,nop,sack 1 {2713871907:27138725=
56}>
sacked last 649 octets

04:34:42.835709 IP (tos 0x0, ttl 241, id 65123, offset 0, flags [DF], proto=
: TCP (6), length: 52) 216.34.143.7.443 > 195.177.210.11.6747: ., cksum 0x7=
46e (correct), ack 1809367099 win 7490 <nop,nop,sack 1 {2713870527:27138725=
56}>
sacked full 2029 octets + acked everyting to 1809367099

04:34:42.841979 IP (tos 0x0, ttl 241, id 65127, offset 0, flags [DF], proto=
: TCP (6), length: 565) 216.34.143.7.443 > 195.177.210.11.6747: P 372406478=
5:3724065298(513) ack 1809367099 win 7490 <nop,nop,sack 1 {2713870527:27138=
72556}>
(redundant) sacked full 2029 octets + acked everyting to 1809367099 + sendi=
ng some data + PUSH

04:34:42.853077 IP (tos 0x0, ttl 127, id 10684, offset 0, flags [DF], proto=
: TCP (6), length: 1150) 195.177.210.11.6747 > 216.34.143.7.443: P 18093670=
99:1809368209(1110) ack 3724065298 win 64900

Bingo... :)

04:34:43.136310 IP (tos 0x0, ttl 241, id 65148, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.11.6747: ., cksum 0xa=
cc9 (correct), ack 1809368209 win 8600
04:34:43.383861 IP (tos 0x0, ttl 241, id 65264, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 216.34.143.7.443 > 195.177.210.11.6747: . 37240652=
98:3724066678(1380) ack 1809368209 win 8600
04:34:43.386285 IP (tos 0x0, ttl 241, id 65265, offset 0, flags [DF], proto=
: TCP (6), length: 120) 216.34.143.7.443 > 195.177.210.11.6747: P 372406667=
8:3724066758(80) ack 1809368209 win 8600
04:34:43.390499 IP (tos 0x0, ttl 241, id 65267, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 216.34.143.7.443 > 195.177.210.11.6747: . 37240667=
58:3724068138(1380) ack 1809368209 win 8600
04:34:43.394683 IP (tos 0x0, ttl 241, id 65270, offset 0, flags [DF], proto=
: TCP (6), length: 1420) 216.34.143.7.443 > 195.177.210.11.6747: . 37240681=
38:3724069518(1380) ack 1809368209 win 8600
04:34:43.403021 IP (tos 0x0, ttl 127, id 10695, offset 0, flags [DF], proto=
: TCP (6), length: 40) 195.177.210.11.6747 > 216.34.143.7.443: ., cksum 0xc=
8ad (correct), ack 3724066758 win 65535
(...)

There is a Windows XP host behind this NAT and is seems it is quite happy=
=20
ignoring this sack crap as the ack itself finnaly acknowledged everyting.=
=20
The transmition continues.


Additionally, creating TCPOPTSSTRIP target to allow striping specific tcp=
=20
option(s) (for example Sack-Permitted from a SYN packet) may also be=20
usable if it is possible to include this extension in a base kernel. This=
=20
may also help with a similar window scaling problem as current solution=20
requires to add a route on _all_ hosts inside a network. Working around it=
=20
on a firewall may be much faster.


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki

PS: I love to talk with myself. ;)
---187430788-1366444356-1183258915=:13212--
