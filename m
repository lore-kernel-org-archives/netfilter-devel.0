From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 21:28:21 +0100
Message-ID: <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es> <20140112201742.GC13545@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:51890 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaALU2n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:28:43 -0500
Received: by mail-la0-f45.google.com with SMTP id b8so2833678lan.4
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 12:28:42 -0800 (PST)
In-Reply-To: <20140112201742.GC13545@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 January 2014 21:17, Patrick McHardy <kaber@trash.net> wrote:
> On Sun, Jan 12, 2014 at 08:41:33PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Almost all shell uses the '>' character as a key for redirecting
>> stdout/stderr to a file.
>> So, using it in the syntax means that the administrator is forced to=
 scape the
>> character, or look for other workaround.
>>
>> With this patch, '=3D>' is replaced with '=3D:', thus avoiding such =
situation.
>
> I'm not opposed to this, but I like (despite the shell problematic) t=
he =3D>
> syntax better, so I'd suggest to just add an alternative syntax.
>
> As further simplification, why not simply use ':'?

Well, I also like using just ':'

But maybe we clash with IPv6 addresses in some cases:

nft add rule ip6 filter input ip6 saddr vmap { ::1 : accept , ::2 : dro=
p }
nft add rule ip6 filter input ip6 saddr vmap { ::1:accept , ::2:drop }

nft add rule ip6 filter input meta dnat set tcp dport map { 80 : ::1,
8888 : ::2 }
nft add rule ip6 filter input meta dnat set tcp dport map { 80:::1, 888=
8:::2 }

what do you think?
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
