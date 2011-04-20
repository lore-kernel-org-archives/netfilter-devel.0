From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 20 Apr 2011 09:31:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104200926210.16821@blackhole.kfki.hu>
References: <4D9E45C2.7030805@wildgooses.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com>
 <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr> <4DA59881.1050501@wildgooses.com>
 <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr> <4DA5D346.5030303@wildgooses.com> <BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com> <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com> <4DAC67F3.3070503@wildgooses.com> <BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com>
 <BANLkTikyT1VOH9aBJ4=LmM5raL2L8Y+46w@mail.gmail.com> <4DADB406.1040606@wildgooses.com> <BANLkTi=PqPkDpKu8ej1tCkVNugpecbLHyg@mail.gmail.com> <BANLkTim9Gi-XpwNGZ0RRgtt+PaoRB+Jw0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1480190303-1303284567=:16821"
Cc: Ed W <lists@wildgooses.com>, netfilter-devel@vger.kernel.org
To: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55209 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1DTHby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:31:54 -0400
In-Reply-To: <BANLkTim9Gi-XpwNGZ0RRgtt+PaoRB+Jw0Q@mail.gmail.com>
Content-ID: <alpine.DEB.2.00.1104200930400.16821@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1480190303-1303284567=:16821
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1104200930401.16821@blackhole.kfki.hu>

On Tue, 19 Apr 2011, Maciej =AFenczykowski wrote:

> > happen? ie. there should not be any attempted loads of ip_set without
> > "iptables -m set" being called (or equivalent).
>=20
> Actually, are you sure the module is called 'ip_set'?
> Kernel iptables match and target extensions are named xt_* or ipt_* or ip=
6t_*.
> If the module is called ip_set and not ipt_set, then maybe we're
> seeing some other dependency chain?
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dbl=
ob;f=3Dnet/netfilter/xt_set.c;h=3Db3babaed7719b770e02d478091885e7692eac68a;=
hb=3D2f666bcf757cb72549f360ef6da02f03620a48b6
>=20
> contains:
>=20
>   21 MODULE_LICENSE("GPL");
>   22 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
>   23 MODULE_DESCRIPTION("Xtables: IP set match and target module");
>   24 MODULE_ALIAS("xt_SET");
>   25 MODULE_ALIAS("ipt_set");
>   26 MODULE_ALIAS("ip6t_set");
>   27 MODULE_ALIAS("ipt_SET");
>   28 MODULE_ALIAS("ip6t_SET");
> (plus the name derived from the filename which is 'xt_set')
>=20
> so I'm guessing your 'ip_set' was simply a typo and should have been 'ipt=
_set'.

The module "ip_set" is loaded in if the "ipset" program is installed and=20
invoked on that system.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1480190303-1303284567=:16821--
