From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 18:16:53 +0100
Message-ID: <49999F85.2040405@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <alpine.LSU.2.00.0902161804550.26651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63616 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZBPRQz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:16:55 -0500
In-Reply-To: <alpine.LSU.2.00.0902161804550.26651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>>> Unrelated to this patch, but maybe the target would also be
>>> better named "NAT" instead of the much more generic term "mangle".
>>> Why is it using lower case letters btw?
>> No idea who has done this,
>=20
> Lowercasing targets was the original author's (Bart De Schuymer's)
> deed ;-)
>=20
> I have nothing against lowercase targets, in fact, many a user seems
> to so not get case-sensitity right =E2=80=94 =E2=80=9CINPUT=E2=80=9D =
vs. =E2=80=9Cinput=E2=80=9D (built-in
> chain names), =E2=80=9CMASQUERADE=E2=80=9D vs. =E2=80=9Cmasquerade=E2=
=80=9D (targets), to name some =E2=80=94
> that I would support lowercasing all targets...=E2=80=94 if it were n=
ot for
> the clash between MARK (target) and mark (match), for example.
> Though, calling one of them =E2=80=9Cmark_m=E2=80=9D or underscore-so=
mething to avoid
> the clash however, is what I dislike in favor of uppercasing target
> names.

Its actually just exposing an implementation detail of how match
and target modules are located on the filesystem. The meaning
(match or target) can be deduced from "-j" and "-m".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
