From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: do not install ip{,6}tables.h
Date: Wed, 30 Jul 2008 08:35:18 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807291551530.21011@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807281851030.15902@fbirervta.pbzchgretzou.qr> <488F0598.40202@netfilter.org> <488F1C08.1090403@netfilter.org> <alpine.LNX.1.10.0807291137150.21011@fbirervta.pbzchgretzou.qr> <488F4E11.8020106@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48233 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYG3MfT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:35:19 -0400
In-Reply-To: <488F4E11.8020106@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-07-29 13:06, Pablo Neira Ayuso wrote:
>
>xtables.h also requires libiptc/libxtc.h which is, AFAIK, a header of
>the internal iptables' library - not initially intended for external u=
se.

Right, that's because the code is ugly too (patches follow).

>Well, after all, it's ugly but it's not that bad as it only allows
>people use the extension plugin API. I have committed your patch.

But in a strange way -- you did not have to create a new branch just fo=
r
that.

=E2=94=8C=E2=94=80[HEAD]=E2=94=80=E2=94=80[master]=E2=94=80=E2=94=80[re=
motes/origin/HEAD]=E2=94=80=E2=94=80[remotes/origin/master]=E2=94=80=E2=
=94=80Merge branch
=E2=94=9C=E2=94=80=E2=94=90
=E2=94=9C =E2=94=82 build: do not install ip{,6}tables.h=E2=94=80=E2=94=
=80(72ed4ff)
=E2=94=82 =E2=94=9C=E2=94=80[v1.4.2-rc1]=E2=94=80=E2=94=80v1.4.2-rc1=E2=
=94=80=E2=94=80(675e30f)
=E2=94=82 =E2=94=9C xt_string: string extension case insensitive matchi=
ng=E2=94=80=E2=94=80(78d2d14)

>BTW, do we support C++ extensions for iptables? Hm, really?

We are not explicitly trying to go against them, like some linux
kernel APIs.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
