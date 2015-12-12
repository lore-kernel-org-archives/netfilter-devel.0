From: Noel Kuntze <noel@familie-kuntze.de>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type for
 socket"
Date: Sat, 12 Dec 2015 20:22:13 +0100
Message-ID: <566C73E5.4060500@familie-kuntze.de>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com>
 <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
 <566C09F5.6080606@gmail.com>
 <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
 <566C0E75.6080800@familie-kuntze.de> <20151212191019.GA10759@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?UTF-8?Q?Remzi_AKY=c3=9cZ?= <linuxliste@gmail.com>,
	=?UTF-8?Q?D=c3=a2niel_Fraga?= <fragabr@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62509 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbLLTW0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 14:22:26 -0500
In-Reply-To: <20151212191019.GA10759@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Jeff from #netfilter on Freenode says it is. You should talk
to him about that.
"Also, notice a couple other things. First, the old -m state module is =
deprecated. Now we use conntrack. This module adds a lot more to state =
tracking, as seen below:"[1]

[1] http://sfvlug.editthis.info/wiki/Things_You_Should_Know_About_Netfi=
lter
- --=20

Mit freundlichen Gr=C3=BC=C3=9Fen/Kind Regards,
Noel Kuntze

GPG Key ID: 0x63EC6658
=46ingerprint: 23CA BB60 2146 05E7 7278 6592 3839 298F 63EC 6658

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWbHPjAAoJEDg5KY9j7GZYl7MP/RNzo2m5sbEOQgjq76RpFXQk
nGz3NUBskho5WhsegE2Fj82VKjBx5d/luk4dc63+JNKpgciv4PJdd0SE/8e2npkU
sHCz+YWU+SQJpgPbvNBvxuqtZojAVazL3jcLH/tF6u2P+bPom0xze969gGO5n+3j
+/tcRkx4w4F4EyU3WqwQH3leYDpbP0q0DmJvMtri4Du1lxIGyi7EJZRR5z+qhDX3
6HPOvDJSEyQ7FfVdxoezs2Weazu1yJzJ6cIkOJmQOdLahVtq4VET7r+Hz4k+oT0n
=46DFBcRmdaMQe544xv2J2jz6x3/dC3fkLs/iICiH9i2L+TySRHyPFAAOfH5SMrxpE
70smlm7vUE8LJxdKjzLt//XT4OXm3UCnp8twN1Wodc4y/Wp8ApkDU7sInMn09eWa
VCv1uHUR7ydJrpR+V2MiLWFE5q+knlMzqf2eCPza4oAmwHNNfF+rAgM4qYqT7B8O
PHkq/LT8J7XHKedudVr///VjJexrUVri4639L3n/p5y86z6naCaaYvAfv4A1lLrt
D9F+i9ddc5/jtwAUoQ54x4+4hsRZ7h/pGkiVgH/bTlGDUsmPje0cEbOBFt3y8Myf
2rgnuqQfcTaP8QgN904nULVjIsyOA0baJApHuB/i+JFO/AkHIxcty9jMXmcPgOjk
IzhzEssDylk0v4Lakill
=3D/27T
-----END PGP SIGNATURE-----

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
