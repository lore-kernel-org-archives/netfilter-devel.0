From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat PATCH 2/2] ebtables-compat: add mark target extension
Date: Tue, 3 Feb 2015 16:21:46 +0100
Message-ID: <CAOkSjBhtNQrM=tkcUDnR2xT9UqwD_aN8n=ry=19H8n06N3NQZA@mail.gmail.com>
References: <20150129164433.21224.14657.stgit@nfdev.cica.es>
 <20150129164439.21224.8860.stgit@nfdev.cica.es> <20150130185155.GB23146@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:60517 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbbBCPWI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Feb 2015 10:22:08 -0500
Received: by mail-la0-f52.google.com with SMTP id ge10so52847767lab.11
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2015 07:22:06 -0800 (PST)
In-Reply-To: <20150130185155.GB23146@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 January 2015 at 19:51, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> On Thu, Jan 29, 2015 at 05:44:39PM +0100, Arturo Borrero Gonzalez wro=
te:
>> +static void brmark_final_check(unsigned int flags)
>> +{
>> +     if (!flags)
>> +             xtables_error(PARAMETER_PROBLEM,
>> +                           "You must specify some option");
>
> You can provide better error reporting by checking this flags:
>
>         if (!(flags & OPTION1 | OPTION2 | OPTION3))
>                 xtables_error(..., "you have to specify at least one =
of these: --option1, --option2, --option3");
>         if (!(flags & OPTION4))
>                 xtables_error(..., "--option4 is mandatory");
>

Actually these kind of checks are done in the parser itself. I just
can't report here nothing that weren't reported already regarding
options combination.
The only thing I can report is the absence of mark, which isn't
related to 'flags '.

Also, I discovered these final_check() functions were not being called
at all in ebt-compat.

So, sending a couple of patches...
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
