From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/2] src: support for XML parsing
Date: Wed, 8 May 2013 12:36:19 +0200
Message-ID: <CAOkSjBj2F9Bg87_HxMenY_XRd0QmYUsG-foAysSd6=NDsy61JA@mail.gmail.com>
References: <20130429123607.26114.18073.stgit@nfdev.cica.es>
 <20130429123612.26114.46794.stgit@nfdev.cica.es> <20130503162419.GB5129@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52585 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3EHKgm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 06:36:42 -0400
Received: by mail-lb0-f171.google.com with SMTP id u10so1761306lbi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 May 2013 03:36:41 -0700 (PDT)
In-Reply-To: <20130503162419.GB5129@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/5/3 Pablo Neira Ayuso <pablo@netfilter.org>:
> Please, you have to change this to some --enable-xml-parser option vi=
a
> hen ./configure, so it's not a hard dependency on libmxml.

I need some help.

I have conditional package checking, something like this in configure.a=
c:
[...]
dnl Dependencies
PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.0])
AC_ARG_WITH([xml], AS_HELP_STRING([--with-xml-parsing], [Build with
XML parsing]))
AS_IF([test "x$with_xml_parsing" =3D "xyes"], [
   PKG_CHECK_MODULES([LIBXML], [mxml >=3D 2.6])
])
[...]

This way, mxml is only checked if configure was run like this:
$ ./configure --with-xml-parsing

Then, I think I need some way to get makefiles updated, so I could do:

[...]
#ifdef XML_PARSING
#include <mxml.h>
#endif
[...]

I think this could be achieve with
$ gcc: -DXML_PARSING [...]

Running './configure --with-xml-parsing' needs to generate some
variable or modify Makefile.am or Make_global.am so I can pass to gcc
the -DXML_PARSING option.

Please, consider this a bad explanation or even that my approach is
actually wrong.

Any idea?

Regards

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
