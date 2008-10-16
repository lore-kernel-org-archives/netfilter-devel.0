From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Writing NF modules  October2008 edition
Date: Thu, 16 Oct 2008 12:54:58 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810161213220.31082@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0810152210240.28060@fbirervta.pbzchgretzou.qr> <48F72E44.1030905@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37566 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYJPQzA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:55:00 -0400
In-Reply-To: <48F72E44.1030905@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-16 08:06, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> I have updated the e-book =E2=80=9CWriting your own Netfilter module=
s=E2=80=9D to this=20
>> October's version. What's new? Featurewise, the API changes that hav=
e=20
>> gone into net-next-2.6.28 are now mentioned. The work is now availab=
le=20
>> under CC 3 too, with some extra clauses that have been suggested dur=
ing=20
>> talking to you at NFWS.
>>=20
>> http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
>> (.lyx for source)
>>=20
>> I would like interested parties and coreteam to give a glance over t=
his=20
>> for any comments, formatting errors, spellos or disagreements with t=
he=20
>> statements provided in the book. Especially section 5.6/5.7 is missi=
ng=20
>> checksumming which has been a hard brick even for me.
>
>Thank you Jan, this is a nice effort since we lack of updated document=
ation.
>
>BTW, just one suggestion in terms of licensing. Why not use FDL instea=
d
>for licensing? Debian cannot distribute this documentation, in case th=
at
>they want to, with the current license AFAIK. Well, licensing is
>something personal, I'm also fine with CC in any case.

Too bad for Debian, but the NC clause I consider elementary. And I do=20
not see how that interferes with commercial use=C2=A0=E2=80=94 remember=
 Walnut Creek=20
CDROM (cdrom.com).

But it seems like Debian does not the GFDL so much either=C2=A0=E2=80=94=
 first=20
paragraph of =E2=80=9CCriticism of the GFDL=E2=80=9D on=20
http://en.wikipedia.org/wiki/GFDL
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
