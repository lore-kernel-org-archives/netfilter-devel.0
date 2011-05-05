From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: iptables domain match
Date: Thu, 5 May 2011 07:15:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105050712190.12502@blackhole.kfki.hu>
References: <BANLkTi=2XpuuqMZgwVggH6-RPH_XvywGyA@mail.gmail.com> <BANLkTimN31-+_7Jp3RKt78_FVfbt9wmf5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-264489633-1304572511=:12502"
Cc: netfilter-devel@vger.kernel.org
To: tingwei liu <tingw.liu@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52132 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1EEFPN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2011 01:15:13 -0400
In-Reply-To: <BANLkTimN31-+_7Jp3RKt78_FVfbt9wmf5w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-264489633-1304572511=:12502
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 5 May 2011, tingwei liu wrote:

> On Tue, May 3, 2011 at 5:08 PM, tingwei liu <tingw.liu@gmail.com> wrote:
> > I have written a netfilter match called domain.
> > Such as: iptables -A OUTPUT -m domain --domain ".google.com" -j DROP
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 T=
hen it will drop the dns query which domain like
> > "www.google.com,news.google.com,mail.google.com,..."
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -I OUTPUT -m d=
omain --domain "map.google.com" -j ACCEPT
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 T=
hen it will accept the dns query which domain is
> > "map.google.com".
> > I known this match is trival,but I want to know how to submit this patc=
h.
> >
> > Thanks for any response.
> >
> ????????

Send the patch to netfilter-devel, that's all. If it's not large, the best=
=20
form is inlined and not attached.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-264489633-1304572511=:12502--
