From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 10:17:12 +0200
Message-ID: <CAOkSjBg9uQpAe2VpBFy6jcAk+87+qapC7inwGaG7fjZ+Mx6Ucw@mail.gmail.com>
References: <20160530194748.GA25328@sonyv> <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
 <20160531072239.GA26590@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35998 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbcEaIRe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 04:17:34 -0400
Received: by mail-wm0-f48.google.com with SMTP id n129so117966283wmn.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 01:17:33 -0700 (PDT)
In-Reply-To: <20160531072239.GA26590@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 May 2016 at 09:22, Laura Garcia <nevola@gmail.com> wrote:
>> > +
>> > +       for (i =3D 0; i < multiinfo->count; i++) {
>> > +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->=
ports[i]);
>> > +               if (i && multiinfo->invert)
>> > +                       return 0;
>>
>> This return here could mean that we build an incomplete nftables rul=
e
>> (ie, missing '}')
>>
>
> Such condition cares that there is no translation in nftables for:
>
> tcp dport !=3D { 80,88 }
>
> So the closed } doesn't even matter.
>

Then, at the start of the xlate function, I would suggest to do an
early return if we are about to translate an unsupported rule.

No need to keep checking if we are in the inversion case

>> > +       if (multiinfo->count > 1 && !multiinfo->invert)
>> > +               xt_xlate_add(xl, "}");
>> > +

like here
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
