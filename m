From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: CONMARK and SNAT
Date: Thu, 28 Oct 2010 14:09:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010281408410.26171@obet.zrqbmnf.qr>
References: <AANLkTin8DL4gEKmFoVwD=h6v=QOSKKneSAmg=YqHV8bN@mail.gmail.com> <AANLkTimxtJ+A1FTtiU1ubCx8u7LBPA54A9JhT9p0esep@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jyotiswarup Raiturkar <jyotisr5@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37344 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0J1MJk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:09:40 -0400
In-Reply-To: <AANLkTimxtJ+A1FTtiU1ubCx8u7LBPA54A9JhT9p0esep@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-10-28 13:34, Jyotiswarup Raiturkar wrote:

>Hello
>
>I want to setup a simple generic rule=C2=A0 :
>
>If (connection has CONMARK =3D xx),=C2=A0 than set TARGET as SNAT --to=
-source xx

xx is an integer, but --to-source requires an IPv4 address instead, so=20
you cannot mix them.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
