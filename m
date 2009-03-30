From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Tag for 1.4.3 missing
Date: Mon, 30 Mar 2009 12:20:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0903301219380.23541@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903292113270.28375@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0903292122520.28784@fbirervta.pbzchgretzou.qr> <49D091CA.4060302@netfilter.org> <alpine.LSU.2.00.0903301139020.17476@fbirervta.pbzchgretzou.qr>
 <49D098DB.9000500@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40452 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbZC3KUj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:20:39 -0400
In-Reply-To: <49D098DB.9000500@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-03-30 12:03, Pablo Neira Ayuso wrote:
>> Graphing reveals where it went:
>>=20
>> $ git-forest -a --sha --all
>> [...]
>> =E2=94=9C (Peter Volkov) libxtables: fix compile error due to incomp=
lete change=E2=94=80=E2=94=80
>> =E2=94=9C (Jan Engelhardt) iptables-save: minor corrections to the m=
anpage markup
>> =E2=94=82 =E2=94=8C=E2=94=80[v1.4.3]=E2=94=80=E2=94=80(Patrick McHar=
dy) Bump version to 1.4.3=E2=94=80=E2=94=80(3fb2e4a)
>> =E2=94=9C=E2=94=80=E2=94=98
>> =E2=94=9C (Jesper Dangaard Brouer) libiptc: give credits to my self=E2=
=94=80=E2=94=80(c9477d0)
>> =E2=94=9C (Jesper Dangaard Brouer) libiptc: fix whitespaces and typo=
s=E2=94=80=E2=94=80(a9fe5b3)
>> [...]
>>=20
>> There is also the missing version bump you noticed. Having the same
>> author date as the 1.4.3 release I simply suspect the tag and master
>> were not pushed previously.
>
>Indeed, I suspected something like that.
>
>> `git merge -s ours 3fb2e4a` should be solving that in the most nices=
t
>> manner I am aware of.
>
>That change must be on Patrick's however that may conflict with my bum=
p
>from 1.4.3-rc1 to 1.4.3.1?

Hence the "-s ours".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
