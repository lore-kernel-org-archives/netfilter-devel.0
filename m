From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Writing NF modules  October2008 edition
Date: Thu, 16 Oct 2008 14:06:28 +0200
Message-ID: <48F72E44.1030905@netfilter.org>
References: <alpine.LNX.1.10.0810152210240.28060@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52882 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754401AbYJPMGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:06:34 -0400
In-Reply-To: <alpine.LNX.1.10.0810152210240.28060@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I have updated the e-book =E2=80=9CWriting your own Netfilter modules=
=E2=80=9D to this=20
> October's version. What's new? Featurewise, the API changes that have=
=20
> gone into net-next-2.6.28 are now mentioned. The work is now availabl=
e=20
> under CC 3 too, with some extra clauses that have been suggested duri=
ng=20
> talking to you at NFWS.
>=20
> http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
> (.lyx for source)
>=20
> I would like interested parties and coreteam to give a glance over th=
is=20
> for any comments, formatting errors, spellos or disagreements with th=
e=20
> statements provided in the book. Especially section 5.6/5.7 is missin=
g=20
> checksumming which has been a hard brick even for me.

Thank you Jan, this is a nice effort since we lack of updated documenta=
tion.

BTW, just one suggestion in terms of licensing. Why not use FDL instead
for licensing? Debian cannot distribute this documentation, in case tha=
t
they want to, with the current license AFAIK. Well, licensing is
something personal, I'm also fine with CC in any case.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
