From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Tag for 1.4.3 missing
Date: Mon, 30 Mar 2009 12:03:07 +0200
Message-ID: <49D098DB.9000500@netfilter.org>
References: <alpine.LSU.2.00.0903292113270.28375@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0903292122520.28784@fbirervta.pbzchgretzou.qr> <49D091CA.4060302@netfilter.org> <alpine.LSU.2.00.0903301139020.17476@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35859 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757877AbZC3KDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:03:19 -0400
In-Reply-To: <alpine.LSU.2.00.0903301139020.17476@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-03-30 11:32, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> On Sunday 2009-03-29 21:13, Jan Engelhardt wrote:
>>>> Hi,
>>>>
>>>> the git tag for 1.4.3 is missing, so if either of you could add it=
=20
>>>> that'd be cool.
>>>>
>>> Commit in question is c9477d0dcd01af5d1ee6c95c757a8c814fb3be63.
>> It seems to be there but pointing to an uncommitted message or
>> something? This is a bit strange.
>=20
> Graphing reveals where it went:
>=20
> $ git-forest -a --sha --all
> [...]
> =E2=94=9C (Peter Volkov) libxtables: fix compile error due to incompl=
ete change=E2=94=80=E2=94=80
> =E2=94=9C (Jan Engelhardt) iptables-save: minor corrections to the ma=
npage markup
> =E2=94=82 =E2=94=8C=E2=94=80[v1.4.3]=E2=94=80=E2=94=80(Patrick McHard=
y) Bump version to 1.4.3=E2=94=80=E2=94=80(3fb2e4a)
> =E2=94=9C=E2=94=80=E2=94=98
> =E2=94=9C (Jesper Dangaard Brouer) libiptc: give credits to my self=E2=
=94=80=E2=94=80(c9477d0)
> =E2=94=9C (Jesper Dangaard Brouer) libiptc: fix whitespaces and typos=
=E2=94=80=E2=94=80(a9fe5b3)
> [...]
>=20
> There is also the missing version bump you noticed. Having the same
> author date as the 1.4.3 release I simply suspect the tag and master
> were not pushed previously.

Indeed, I suspected something like that.

> `git merge -s ours 3fb2e4a` should be solving that in the most nicest
> manner I am aware of.

That change must be on Patrick's however that may conflict with my bump
from 1.4.3-rc1 to 1.4.3.1?

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
