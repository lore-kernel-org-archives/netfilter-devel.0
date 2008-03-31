From: Sven Riedel <sr@securenet.de>
Subject: Re: Transfer stalls with NAT under 2.6.24.3
Date: Mon, 31 Mar 2008 08:53:06 +0200
Message-ID: <47F08A52.9070802@securenet.de>
References: <47EA0DAB.7080205@securenet.de> <47EA1653.3080300@trash.net> <47EA2399.1080201@securenet.de> <47EA7023.3000405@trash.net> <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
we had a minor emergency here last week, so I wasn't able to test the=20
old kernel. I'll see that I'll try that tomorrow.

Jozsef Kadlecsik wrote:
> On Wed, 26 Mar 2008, Patrick McHardy wrote:
>=20
>>> During a run with stalls:
>>>
>>> nf_ct_tcp: ACK is over the upper bound (ACKed data not seen yet) IN=
=3D OUT=3D
>>> SRC=3D100.100.100.100 DST=3D200.200.200.200 LEN=3D80 TOS=3D0x00 PRE=
C=3D0x00 TTL=3D56
>>> ID=3D44105
>>> DF PROTO=3DTCP SPT=3D22 DPT=3D35858 SEQ=3D4160349927 ACK=3D59661432=
6 WINDOW=3D49248
>>> RES=3D0x00 ACK URGP=3D0 OPT
>>> (0101080A4558793C1B13CE350101051A491E8751491E8CA9491E7B71491E81F949=
1E40A9491E5B61)
>>>
>> Thanks, can you send a binary tcpdump (... -w file) of a connection
>> that triggers these messages please?
>=20
> Yes, a tcpdump of a full session which is stalled could help a lot.
Ok, I'll send one along later today.

> But it almost look like as a SACK related problem: isn't there a (new=
)
> device between the communicating parties which performs ISN randomiza=
tion
> and fails to adjust SACK?

There are at least two devices between the communication partners: a DS=
L=20
modem and a firewall on the remote end (outside of my control). Both=20
devices have been there already and didn't create any problems with the=
=20
old iptables setup. The only thing that changed on that communication=20
path is the firewall hardware, the NIC on the firewall and the=20
netfilter/iptables version used by the firewall.

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

