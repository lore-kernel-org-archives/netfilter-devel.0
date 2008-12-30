From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: resolve autotools suggestions
Date: Tue, 30 Dec 2008 12:27:44 +0100
Message-ID: <495A05B0.8070700@netfilter.org>
References: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34077 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbYL3MGY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:06:24 -0500
In-Reply-To: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
> commit 6fdeb9468f1bac11698b200530cd454a167e1e39
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Dec 25 20:21:36 2008 +0100
>=20
> build: resolve autotools suggestions
>=20
> libtool2 wants to put files into m4, so let it have it.

I don't quite understand this change since I'm not a autotools guru. Bu=
t
according to the manual, there's a more portable way to do this:

"In the future other Autotools will automatically check the contents of
AC_CONFIG_MACRO_DIR, but at the moment it is more portable to add the
macro directory to ACLOCAL_AMFLAGS in Makefile.am, which is where the
tools currently look. If libtoolize doesn't see AC_CONFIG_MACRO_DIR, it
too will honour the first =91-I=92 argument in ACLOCAL_AMFLAGS when cho=
osing
a directory to store libtool configuration macros in. It is perfectly
sensible to use both AC_CONFIG_MACRO_DIR and ACLOCAL_AMFLAGS, as long a=
s
they are kept in synchronisation."

I'd appreciate a more detailed clarification on what you want to do. Th=
anks.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
