From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/2] src: support for XML parsing
Date: Wed, 8 May 2013 13:26:17 +0200
Message-ID: <CAOkSjBhhjaehLspO2i3oUjUm7Otv9=Ks6-GKT9RpKUq-8a+dLw@mail.gmail.com>
References: <20130429123607.26114.18073.stgit@nfdev.cica.es>
 <20130429123612.26114.46794.stgit@nfdev.cica.es> <20130503162419.GB5129@localhost>
 <CAOkSjBj2F9Bg87_HxMenY_XRd0QmYUsG-foAysSd6=NDsy61JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48170 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3EHL0k convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 07:26:40 -0400
Received: by mail-lb0-f173.google.com with SMTP id t10so1810089lbi.4
        for <netfilter-devel@vger.kernel.org>; Wed, 08 May 2013 04:26:38 -0700 (PDT)
In-Reply-To: <CAOkSjBj2F9Bg87_HxMenY_XRd0QmYUsG-foAysSd6=NDsy61JA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/5/8 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> Running './configure --with-xml-parsing' needs to generate some
> variable or modify Makefile.am or Make_global.am so I can pass to gcc
> the -DXML_PARSING option.
>

Ok, I did this:

[...]
regular_CPPFLAGS=3D"-D_FILE_OFFSET_BITS=3D64 -D_REENTRANT"
AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
        regular_CPPFLAGS=3D"$regular_CPPFLAGS -DXML_PARSING"
])
[...]

that seems to work.

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
