From: Sven Riedel <sr@securenet.de>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Wed, 26 Mar 2008 11:21:13 +0100
Message-ID: <47EA2399.1080201@securenet.de>
References: <47EA0DAB.7080205@securenet.de> <47EA1653.3080300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <47EA1653.3080300@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Sven Riedel wrote:
>> Hi,
>> I've run into a strange problem where large file transfers start=20
>> stalling over a NATed connection. Packet traces reveal that ACK=20
>> packets are sometimes not being passed through to the inside (NATed)=
=20
>> host, which results in a transfer stall until a tcp timeout occurrs=20
>> and the other side retransmits the ACK.
>>
>> This only seems to happen if the conntrack table on the firewall=20
>> already contains an entry for the same source and destination in=20
>> TIME_WAIT state. If no conntrack entries exist for the same source a=
nd=20
>> destination, the packets flow fine.
>>
>> The problem seems to be alevated by setting ip_conntrac_tcp_be_liber=
al=20
>> to 1, but this seems to be only a workaround not a real solution.
>>
>> Scatter gather and tcp segment offloading have been disabled in the=20
>> relevant NICs on the firewall during debugging, to make sure this=20
>> isn't a hardware issue.
>>
>> Is this issue known/is there a patch available or would further=20
>> information be needed to help debug the problem?
>=20
> 2.6.24.3 includes a patches that was supposed to fix problems
> with connections in TIME_WAIT state. Does 2.6.24.2 work better
> for you?

The firewall system in question is currently productive. I _might_ be=20
able to try the other kernel tomorrow morning. Once I am able to try it=
=20
I'll let you know.

>=20
> Please enable conntrack logging for TCP by executing:
>=20
> echo 6 >/proc/sys/net/netfilter/nf_conntrack_log_invalid
>=20
> and check whether you get any messages in the ring buffer.

Yep, lots ;)

In the following 100.100.100.100 is the external machine and=20
200.200.200.200 is the NAT IP-Address on the firewall. A 5MB file was=20
transferred via scp to 100.100.100.100 from the internal network.

The output during a "clean" run, with an empty conntrack table and no=20
stalls:
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42121
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720612 ACK=3D3828427355 WI=
NDOW=3D47880
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585E351B138AA40101050AE50974FBE5=
097A53)
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42122
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720612 ACK=3D3828427355 WI=
NDOW=3D47880
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585E361B138AA40101050AE50974FBE5=
097FAB)
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42123
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720612 ACK=3D3828427355 WI=
NDOW=3D47880
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585E361B138AA40101050AE50974FBE5=
098503)
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42124
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720612 ACK=3D3828427355 WI=
NDOW=3D47880
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585E371B138AA40101050AE50974FBE5=
098A5B)
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42125
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720612 ACK=3D3828427355 WI=
NDOW=3D47880
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585E381B138AA40101050AE50974FBE5=
098FB3)
printk: 24 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42248
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355720852 ACK=3D3828837755 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45585F911B138E140101050AE50FB2C3E5=
0FD2D3)
printk: 31 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42465
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355721284 ACK=3D3829614779 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455861861B1392E10101050AE51B935BE5=
1BB8C3)
printk: 25 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42718
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355721716 ACK=3D3830353499 WI=
NDOW=3D42408
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455863DA1B1398B70101050AE526E3ABE5=
26E903)
printk: 57 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D42976
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355722052 ACK=3D3830954051 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455865791B139CBE0101050AE52FFD8BE5=
30284B)
printk: 27 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D72 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D43306
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355722580 ACK=3D3831787163 WI=
NDOW=3D42408
RES=3D0x00 ACK URGP=3D0 OPT
(0101080A455867731B13A19501010512E53CCB53E53CD653E53CBE93E53CC3EB)
printk: 74 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D43789
DF PROTO=3DTCP SPT=3D22 DPT=3D43021 SEQ=3D355723252 ACK=3D3832978011 WI=
NDOW=3D42408
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45586A571B13A8CF0101050AE54EDEABE5=
4EE403)







During a run with stalls:

nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D80 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D44105
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160349927 ACK=3D596614326 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT
(0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81F9491E40=
A9491E5B61)

^^^^ Transfer stalled here for ~10 seconds.


printk: 22 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D72 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D44113
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160349927 ACK=3D596632110 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT
(0101080A45587D301B13D81801010512491E8751491E8CA9491E7B71491E81F9)
printk: 12 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D44114
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160349927 ACK=3D596635150 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455881B21B13E35A0101050A491E875149=
1E8CA9)
printk: 14 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D7320
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160350311 ACK=3D597280038 WI=
NDOW=3D27360
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455883D31B13E8820101050A49286E7149=
2873C9)
printk: 32 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D7451
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160350503 ACK=3D597578342 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455885161B13EBD30101050A492CEBA949=
2CF659)
printk: 35 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D7786
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160350983 ACK=3D598415558 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455887081B13F0890101050A4939B20949=
39E221)
printk: 54 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D8021
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160351319 ACK=3D598980542 WI=
NDOW=3D42408
RES=3D0x00 ACK URGP=3D0 OPT (0101080A455889151B13F5C00101050A4942510149=
425659)
printk: 43 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D8205
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160351559 ACK=3D599403254 WI=
NDOW=3D49248
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45588B011B13FA9B0101050A4948C43949=
48C991)
printk: 40 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D8531
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160352039 ACK=3D600218582 WI=
NDOW=3D45144
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45588D371B1400160101050A4955351949=
553A71)
printk: 49 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D8871
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160352519 ACK=3D601058534 WI=
NDOW=3D38304
RES=3D0x00 ACK URGP=3D0 OPT (0101080A45588F521B1405500101050A4962062949=
620B81)
printk: 45 messages suppressed.
nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=3D =
OUT=3D
SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D64 TOS=3D0x00 PREC=3D=
0x00 TTL=3D56=20
ID=3D8988
DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160352663 ACK=3D601307510 WI=
NDOW=3D41040
RES=3D0x00 ACK URGP=3D0 OPT (0101080A4558910A1B1409AB0101050A4965D2B949=
65D811)


Regards,
Sven
--=20
sven.riedel@securenet.de

SecureNet GmbH
Intranet & Internet Solutions
=46rankfurter Ring 193a
D-80807 M=FCnchen
Tel: +49 89 32133-632
=46ax: +49 89 32133-699
Zentrale: -600
www.securenet.de

Sitz der Gesellschaft: M=FCnchen
HRB M=FCnchen 118876
Gesch=E4ftsf=FChrer: Thomas Schreiber

