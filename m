From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Writing NF modules  October2008 edition
Date: Thu, 16 Oct 2008 19:08:25 +0200
Message-ID: <48F77509.6090303@netfilter.org>
References: <alpine.LNX.1.10.0810152210240.28060@fbirervta.pbzchgretzou.qr> <48F72E44.1030905@netfilter.org> <alpine.LNX.1.10.0810161213220.31082@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37149 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbYJPRIc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:08:32 -0400
In-Reply-To: <alpine.LNX.1.10.0810161213220.31082@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-10-16 08:06, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> I have updated the e-book =E2=80=9CWriting your own Netfilter modul=
es=E2=80=9D to this=20
>>> October's version. What's new? Featurewise, the API changes that ha=
ve=20
>>> gone into net-next-2.6.28 are now mentioned. The work is now availa=
ble=20
>>> under CC 3 too, with some extra clauses that have been suggested du=
ring=20
>>> talking to you at NFWS.
>>>
>>> http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
>>> (.lyx for source)
>>>
>>> I would like interested parties and coreteam to give a glance over =
this=20
>>> for any comments, formatting errors, spellos or disagreements with =
the=20
>>> statements provided in the book. Especially section 5.6/5.7 is miss=
ing=20
>>> checksumming which has been a hard brick even for me.
>> Thank you Jan, this is a nice effort since we lack of updated docume=
ntation.
>>
>> BTW, just one suggestion in terms of licensing. Why not use FDL inst=
ead
>> for licensing? Debian cannot distribute this documentation, in case =
that
>> they want to, with the current license AFAIK. Well, licensing is
>> something personal, I'm also fine with CC in any case.
>=20
> Too bad for Debian, but the NC clause I consider elementary. And I do=
=20
> not see how that interferes with commercial use =E2=80=94 remember Wa=
lnut Creek=20
> CDROM (cdrom.com).
>=20
> But it seems like Debian does not the GFDL so much either =E2=80=94 f=
irst=20
> paragraph of =E2=80=9CCriticism of the GFDL=E2=80=9D on=20
> http://en.wikipedia.org/wiki/GFDL

They finally did after one votation in 2006 IIRC. Don't put too much
trust on wikipedia ;)

[1]
http://groups.google.com.mx/group/linux.debian.announce/browse_thread/t=
hread/136fb411ba81b487/72e944886fea395f?lnk=3Draot

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
