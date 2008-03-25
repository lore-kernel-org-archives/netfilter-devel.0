From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Ebtables hook order anomaly (was: ebtables and iptables different
 behavior between 2.6.18 on fc6 and 2.6.23 on fc8)
Date: Tue, 25 Mar 2008 07:48:11 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYCYGsM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:48:12 -0400
In-Reply-To: <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-03-25 03:28, Jan Engelhardt wrote:
>
>>  None of my packets that were supposed to have that "3" mark ever ke=
pt
>>  them.  For some reason, they either never were marked or they were
>>  marked and then the mark disappeared.
>
> I can reproduce it. [...]
> Now that is indeed interesting. I had this thought, maybe the mark do=
es not=20
> disappear, maybe ebtables is run -- contrary to most graphics depicti=
ng the=20
> netfilter flow -- _after_ iptables. So I tried:
>
> 	 iptables -t mangle -A POSTROUTING -j LOG --log-prefix "[ipt] " -d
> 	 134.76.13.21
> 	 ebtables -A OUTPUT -p ipv4 --ip-destination 134.76.13.21 --log
> 	 --log-prefix "[ebt] "
>
> with the result of:
>
> 	 [214961.190130] [ipt] IN=3D OUT=3Dbr0 SRC=3D10.10.106.161 DST=3D134=
=2E76.13.21
> 	 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYP=
E=3D8 CODE=3D0
> 	 ID=3D59252 SEQ=3D1
>
> 	 [214961.190186] [ebt]  IN=3D OUT=3Dsis0 MAC source =3D 00:0a:e6:98:=
ed:d7
> 	 MAC
> 	 dest =3D 68:a8:3e:d3:d0:fb proto =3D 0x0800
>
> which means ebtables actually comes after iptables, and hence, your m=
ark 3=20
> will not show up as you expected.
>
>>  So my questions - what changed with the interaction betweem iptable=
s and
>>  ebtables?
>
> I'm going to figure out now...

I tested a 2.6.18 and experienced the same order of [ipt] and [ebt].
This means that trying to

 	$EBTABLES -t filter -A OUTPUT -o $INET_IFACE \
 	-j mark --mark-set 3 --mark-target CONTINUE

you will never see mark 3 (at least not when generated in ebt/OUTPUT)
in iptables again.


->

Altogether, this made me re-evaluate the Netfilter hook/table
ordering as to wtf is going on. The end result? I was surprised to
notice an odd order of packet flow inside Ebtables, depicted in the
updated image at http://jengelh.hopto.org/images/nf-packet-flow.png
it certainly explains things going not as expected on Greg's side.

I used -j TRACE for iptables and --log in ebtables to find=20
the actual order, and something additionally has catched my=20
eye.

This is the syslog dump on a router confused with an IP-less
br0 bridge enslaving rtl0 and vmnet1 (i.e.=A0a pure passthru bridge).

=46rom what can be observed, the ICMP Echo Reply packet (the last line
with 06:54:30, and also :31, and so on) is not hitting
TRACE:nat:POSTROUTING --- only the ICMP Echo Request is. How can this
happen?


[e-n-PR] =3D [ebtables-{nat|filter}-{PRerouting,Forward,POstrouting}]

06:54:30 [227559.984918] [e-n-PR]  IN=3Drtl0 OUT=3D MAC source =3D 00:0=
c:29:77:f2:bd MAC dest =3D 00:0c:29:a4:a5:b2 proto =3D 0x0800
06:54:30 [227559.984976] TRACE: raw:PREROUTING:policy:2 IN=3Dbr0 OUT=3D=
 PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D19=
2.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 =
ID=3D0 DF PROTO=3DICMP TY
06:54:30 [227559.985034] TRACE: mangle:PREROUTING:policy:1 IN=3Dbr0 OUT=
=3D PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D=
192.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D6=
4 ID=3D0 DF PROTO=3DICMP
06:54:30 [227559.985072] TRACE: nat:PREROUTING:policy:1 IN=3Dbr0 OUT=3D=
 PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D19=
2.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 =
ID=3D0 DF PROTO=3DICMP TY
06:54:30 [227559.985117] [e-f-F]  IN=3Drtl0 OUT=3Dvmnet1 MAC source =3D=
 00:0c:29:77:f2:bd MAC dest =3D 00:0c:29:a4:a5:b2 proto =3D 0x0800
06:54:30 [227559.985141] TRACE: mangle:FORWARD:policy:3 IN=3Dbr0 OUT=3D=
br0 PHYSIN=3Drtl0 PHYSOUT=3Dvmnet1 SRC=3D192.168.45.2 DST=3D192.168.45.=
1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYPE=3D=
8 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.985166] TRACE: filter:FORWARD:policy:5 IN=3Dbr0 OUT=3D=
br0 PHYSIN=3Drtl0 PHYSOUT=3Dvmnet1 SRC=3D192.168.45.2 DST=3D192.168.45.=
1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYPE=3D=
8 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.985188] [e-n-PO]  IN=3D OUT=3Dvmnet1 MAC source =3D 00=
:0c:29:77:f2:bd MAC dest =3D 00:0c:29:a4:a5:b2 proto =3D 0x0800
06:54:30 [227559.985211] TRACE: mangle:POSTROUTING:policy:1 IN=3D OUT=3D=
br0 PHYSIN=3Drtl0 PHYSOUT=3Dvmnet1 SRC=3D192.168.45.2 DST=3D192.168.45.=
1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYPE=3D=
8 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.985252] TRACE: nat:POSTROUTING:policy:3 IN=3D OUT=3Dbr=
0 PHYSIN=3Drtl0 PHYSOUT=3Dvmnet1 SRC=3D192.168.45.2 DST=3D192.168.45.1 =
LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROTO=3DICMP TYPE=3D=
8 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.987300] [e-n-PR]  IN=3Dvmnet1 OUT=3D MAC source =3D 00=
:0c:29:a4:a5:b2 MAC dest =3D 00:0c:29:77:f2:bd proto =3D 0x0800
06:54:30 [227559.987359] TRACE: raw:PREROUTING:policy:2 IN=3Dbr0 OUT=3D=
 PHYSIN=3Dvmnet1 MAC=3D00:0c:29:77:f2:bd:00:0c:29:a4:a5:b2:08:00 SRC=3D=
192.168.45.1 DST=3D192.168.45.2 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D6=
4 ID=3D56525 PROTO=3DICMP
06:54:30 [227559.987413] TRACE: mangle:PREROUTING:policy:1 IN=3Dbr0 OUT=
=3D PHYSIN=3Dvmnet1 MAC=3D00:0c:29:77:f2:bd:00:0c:29:a4:a5:b2:08:00 SRC=
=3D192.168.45.1 DST=3D192.168.45.2 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D=
64 ID=3D56525 PROTO=3DI
06:54:30 [227559.987455] [e-f-F]  IN=3Dvmnet1 OUT=3Drtl0 MAC source =3D=
 00:0c:29:a4:a5:b2 MAC dest =3D 00:0c:29:77:f2:bd proto =3D 0x0800
06:54:30 [227559.987479] TRACE: mangle:FORWARD:policy:3 IN=3Dbr0 OUT=3D=
br0 PHYSIN=3Dvmnet1 PHYSOUT=3Drtl0 SRC=3D192.168.45.1 DST=3D192.168.45.=
2 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D56525 PROTO=3DICMP TYPE=
=3D0 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.987504] TRACE: filter:FORWARD:policy:5 IN=3Dbr0 OUT=3D=
br0 PHYSIN=3Dvmnet1 PHYSOUT=3Drtl0 SRC=3D192.168.45.1 DST=3D192.168.45.=
2 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D56525 PROTO=3DICMP TYPE=
=3D0 CODE=3D0 ID=3D44042 SEQ=3D7=20
06:54:30 [227559.987525] [e-n-PO]  IN=3D OUT=3Drtl0 MAC source =3D 00:0=
c:29:a4:a5:b2 MAC dest =3D 00:0c:29:77:f2:bd proto =3D 0x0800
06:54:30 [227559.987548] TRACE: mangle:POSTROUTING:policy:1 IN=3D OUT=3D=
br0 PHYSIN=3Dvmnet1 PHYSOUT=3Drtl0 SRC=3D192.168.45.1 DST=3D192.168.45.=
2 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D56525 PROTO=3DICMP TYPE=
=3D0 CODE=3D0 ID=3D44042 SEQ=3D7
=2E..repeats...
06:54:31 [227560.994489] [e-n-PR]  IN=3Drtl0 OUT=3D MAC source =3D 00:0=
c:29:77:f2:bd MAC dest =3D 00:0c:29:a4:a5:b2 proto =3D 0x0800
06:54:31 [227560.994548] TRACE: raw:PREROUTING:policy:2 IN=3Dbr0 OUT=3D=
 PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D19=
2.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 =
ID=3D0 DF PROTO=3DICMP TY
06:54:31 [227560.994609] TRACE: mangle:PREROUTING:policy:1 IN=3Dbr0 OUT=
=3D PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D=
192.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D6=
4 ID=3D0 DF PROTO=3DICMP
06:54:31 [227560.994646] TRACE: nat:PREROUTING:policy:1 IN=3Dbr0 OUT=3D=
 PHYSIN=3Drtl0 MAC=3D00:0c:29:a4:a5:b2:00:0c:29:77:f2:bd:08:00 SRC=3D19=
2.168.45.2 DST=3D192.168.45.1 LEN=3D84 TOS=3D0x00 PREC=3D0x00 TTL=3D64 =
ID=3D0 DF PROTO=3DICMP TY
06:54:31 [227560.994691] [e-f-F]  IN=3Drtl0 OUT=3Dvmnet1 MAC source =3D=
 00:0c:29:77:f2:bd MAC dest =3D 00:0c:29:a4:a5:b2 proto =3D 0x0800
=2E..
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
