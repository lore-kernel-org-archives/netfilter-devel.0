From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Sun, 1 Jul 2007 17:03:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707011615081.13212@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707011550120.15758@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-768031632-1183302189=:13212"
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707011550120.15758@fbirervta.pbzchgretzou.qr>
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

---187430788-768031632-1183302189=:13212
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 1 Jul 2007, Jan Engelhardt wrote:

>
> On Jul 1 2007 05:01, Krzysztof Oledzki wrote:
>>>
>>>> Setting net.ipv4.netfilter.ip_conntrack_tcp_be_liberal solves the prob=
lem,
>>>> but this is not a right fix and now the main question is: was this ACK
>>>> really over the upper bound since when
>>>> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled it is possib=
le to
>>>> access this page (of course with many netfilter warnings that "ACK is =
over
>>>> the upper bound").
>>
>> Found this:
>>
>> http://groups.google.pl/group/fa.openbsd.tech/browse_frm/thread/e27c7363=
b2c636b5/01ba6e0fa873cf42
>>
>> Sounds familiar - it seems that there may be a crappy OpenBSD firewall l=
urking
>> somewhere along the path. :(
>
> Question... does the problem also go away if you leave
> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal as previously and instead =
set
> net.ipv4.tcp_sack =3D 0?

On the firewall/nat itself? No. But disabling sack on that workstation by=
=20
setting SackOpts=3D0 (DWORD) in the=20
"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"=20
indeed makes this problem go away as there was no sack negotiated:

16:52:43.238991 IP (tos 0x0, ttl 127, id 5645, offset 0, flags [DF], proto:=
 TCP (6), length: 44) 195.177.210.97.1058 > 216.34.143.7.443: S, cksum 0x5d=
c1 (correct), 4217846755:4217846755(0) win 65535 <mss 1460>
16:52:43.422683 IP (tos 0x0, ttl 241, id 20704, offset 0, flags [DF], proto=
: TCP (6), length: 44) 216.34.143.7.443 > 195.177.210.97.1058: S, cksum 0xa=
c20 (correct), 3439121590:3439121590(0) ack 4217846756 win 4140 <mss 1380>
No sackOK in this SYN.

16:52:43.422836 IP (tos 0x0, ttl 127, id 5650, offset 0, flags [DF], proto:=
 TCP (6), length: 40) 195.177.210.97.1058 > 216.34.143.7.443: ., cksum 0xd3=
b9 (correct), ack 3439121591 win 65535
16:52:43.423199 IP (tos 0x0, ttl 127, id 5651, offset 0, flags [DF], proto:=
 TCP (6), length: 142) 195.177.210.97.1058 > 216.34.143.7.443: P, cksum 0xf=
cd6 (correct), 4217846756:4217846858(102) ack 3439121591 win 65535
16:52:43.607074 IP (tos 0x0, ttl 241, id 20741, offset 0, flags [DF], proto=
: TCP (6), length: 162) 216.34.143.7.443 > 195.177.210.97.1058: P, cksum 0x=
d004 (correct), 3439121591:3439121713(122) ack 4217846858 win 4242
16:52:43.607737 IP (tos 0x0, ttl 127, id 5662, offset 0, flags [DF], proto:=
 TCP (6), length: 83) 195.177.210.97.1058 > 216.34.143.7.443: P, cksum 0x67=
2d (correct), 4217846858:4217846901(43) ack 3439121713 win 65413
16:52:43.608728 IP (tos 0x0, ttl 127, id 5663, offset 0, flags [DF], proto:=
 TCP (6), length: 1139) 195.177.210.97.1058 > 216.34.143.7.443: P, cksum 0x=
ad36 (correct), 4217846901:4217848000(1099) ack 3439121713 win 65413
16:52:43.608842 IP (tos 0x0, ttl 127, id 5664, offset 0, flags [DF], proto:=
 TCP (6), length: 1420) 195.177.210.97.1058 > 216.34.143.7.443: ., cksum 0x=
00c6 (correct), 4217848000:4217849380(1380) ack 3439121713 win 65413
16:52:43.608963 IP (tos 0x0, ttl 127, id 5665, offset 0, flags [DF], proto:=
 TCP (6), length: 689) 195.177.210.97.1058 > 216.34.143.7.443: P, cksum 0xc=
aad (correct), 4217849380:4217850029(649) ack 3439121713 win 65413
Last octet is 4217850029...

16:52:43.792713 IP (tos 0x0, ttl 241, id 20753, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.97.1058: ., cksum 0xb=
95b (correct), ack 4217848000 win 5384
16:52:43.792839 IP (tos 0x0, ttl 241, id 20755, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.97.1058: ., cksum 0xb=
95b (correct), ack 4217848000 win 5384
Two redundant acks for 4217848000... (?)

16:52:43.792965 IP (tos 0x0, ttl 241, id 20759, offset 0, flags [DF], proto=
: TCP (6), length: 40) 216.34.143.7.443 > 195.177.210.97.1058: ., cksum 0xa=
981 (correct), ack 4217850029 win 7413
Finally acking 4217850029

16:52:43.798334 IP (tos 0x0, ttl 241, id 20763, offset 0, flags [DF], proto=
: TCP (6), length: 553) 216.34.143.7.443 > 195.177.210.97.1058: P, cksum 0x=
9a72 (correct), 3439121713:3439122226(513) ack 4217850029 win 7413
16:52:43.799601 IP (tos 0x0, ttl 127, id 5674, offset 0, flags [DF], proto:=
 TCP (6), length: 1073) 195.177.210.97.1058 > 216.34.143.7.443: P, cksum 0x=
d49e (correct), 4217850029:4217851062(1033) ack 3439122226 win 64900

(...) :)

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-768031632-1183302189=:13212--
