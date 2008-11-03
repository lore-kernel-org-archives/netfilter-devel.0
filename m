From: Patrick McHardy <kaber@trash.net>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Mon, 03 Nov 2008 13:42:32 +0100
Message-ID: <490EF1B8.2060308@trash.net>
References: <rlujt5-k63.ln1@tux.abusar.org.br>	<49074E81.6010207@trash.net>	<49075276.2686460a.0b00.ffff9f09@mx.google.com>	<4907564D.5090103@trash.net>	<49094b22.0f87460a.09d2.55b6@mx.google.com>	<49095F02.7040104@trash.net> <490a671a.0687460a.3af5.40a2@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	=?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYKCMmi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2008 07:42:38 -0500
In-Reply-To: <490a671a.0687460a.3af5.40a2@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

D=E2niel Fraga wrote:
> On Thu, 30 Oct 2008 08:15:14 +0100
> Patrick McHardy <kaber@trash.net> wrote:
>=20
>> One thing you need is to specify the amount of bytes you want transf=
ered
>> to userspace:
>>
>> iptables ... -j NFLOG --nflog-range 65535
>=20
> 	Another one (now with --nflog-range 65535 as requested):
>=20
> 	1) using LOG:
>=20
> Oct 30 23:14:34 tux vmunix: :d0:87:60:0SC6.3.310DT121812LN4 O=3Dx0PE=3D=
x0TL4 D0POOTPST8 P=3D94 IDW0RS00 C S RP0
> Oct 30 23:14:34 tux vmunix: 6DO NU:I=3Dt0OT A=3D01:3e:79:01:fe:b2:80 =
R=3D3267.9 S=3D9.6.. E=3D0TS00 RC00 T=3D4I=3D RT=3DC P=3D0DT585WNO=3D E=
=3Dx0AKRTUG=3D=20
>=20
> 	2) using NFLOG (syslog emul):
>=20
> Oct 30 23:14:34 tux DROP INPUT:  IN=3Deth0 OUT=3D MAC=3D00:18:f3:e4:4=
7:9f:00:1d:0f:e8:7b:26:08:00 SRC=3D63.236.73.190 DST=3D192.168.1.2 LEN=3D=
40 TOS=3D00 PREC=3D0x00 TTL=3D44 ID=3D0 PROTO=3DTCP SPT=3D80 DPT=3D5984=
5 SEQ=3D0 ACK=3D2739255566 WINDOW=3D0 ACK RST URGP=3D0 MARK=3D0=20
>=20
> Oct 30 23:14:34 tux DROP INPUT:  IN=3Deth0 OUT=3D MAC=3D00:18:f3:e4:4=
7:9f:00:1d:0f:e8:7b:26:08:00 SRC=3D63.236.73.190 DST=3D192.168.1.2 LEN=3D=
40 TOS=3D00 PREC=3D0x00 TTL=3D44 ID=3D0 PROTO=3DTCP SPT=3D80 DPT=3D5984=
5 SEQ=3D0 ACK=3D2739255566 WINDOW=3D0 ACK RST URGP=3D0 MARK=3D0=20
>=20
> Oct 30 23:14:34 tux DROP INPUT:  IN=3Deth0 OUT=3D MAC=3D00:18:f3:e4:4=
7:9f:00:1d:0f:e8:7b:26:08:00 SRC=3D63.236.73.190 DST=3D192.168.1.2 LEN=3D=
40 TOS=3D00 PREC=3D0x00 TTL=3D44 ID=3D0 PROTO=3DTCP SPT=3D80 DPT=3D5984=
5 SEQ=3D0 ACK=3D2739255566 WINDOW=3D0 ACK RST URGP=3D0 MARK=3D0=20
>=20
> Oct 30 23:14:34 tux DROP INPUT:  IN=3Deth0 OUT=3D MAC=3D00:18:f3:e4:4=
7:9f:00:1d:0f:e8:7b:26:08:00 SRC=3D63.236.73.190 DST=3D192.168.1.2 LEN=3D=
40 TOS=3D00 PREC=3D0x00 TTL=3D44 ID=3D0 PROTO=3DTCP SPT=3D80 DPT=3D5984=
5 SEQ=3D0 ACK=3D2739255567 WINDOW=3D0 ACK RST URGP=3D0 MARK=3D0=20
>=20
> 	It's interesting to note that NFLOG always give the double of the en=
tries of the "wrong" LOG entries.
>=20
> 	3) and the attached pcap log file.
>=20
> 	I hope that it will give you some hint. Thanks!

It doesn't explain why the LOG output is corrupted, but it seems
the hanging connections are caused by RST packets that are considered
INVALID.

Please enable conntrack debugging by executing:

echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

so we can see why these packets are considered invalid.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
