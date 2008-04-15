From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: iptables updates
Date: Tue, 15 Apr 2008 12:33:18 +0200
Message-ID: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34590 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYDOKd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


=46ollowing are:

=E2=95=9F Resolve warnings on 64-bit compile=E2=94=80=E2=94=80(0e15210)

Wanted.

=E2=95=9F Wrap dlopen code into NO_SHARED_LIBS=E2=94=80=E2=94=80(2727db=
d)

Needed for --enable-static.

=E2=95=9F Remove support for compilation of conditional extensions=E2=94=
=80=E2=94=80(bfc4434)

As before; header files for SET got added.

=E2=95=9F Resolve libipt_set warnings=E2=94=80=E2=94=80(17a9554)

=E2=95=9F Update documentation about building the package=E2=94=80=E2=94=
=80(d1acf22)

All those new configure options

=E2=95=9F configure.ac: AC_SUBST must be separate=E2=94=80=E2=94=80(06a=
71a3)

=E2=95=9F Dynamically create xtables.h.in with version=E2=94=80=E2=94=80=
(f29980f)

External modules need this in xtables.h.

=E2=95=9F Remove old functions, constants=E2=94=80=E2=94=80(7c7d0eb)

Switches to XTABLES_VERSION, removed the  "register_match" wrapper
that wrapped xtables_register_match, and exchanges IPT_ALIGN/IP6T_ALIGN
to XT_ALIGN (since the former two are just an indirect #define).

=E2=95=9F Move libipt_recent to libxt_recent=E2=94=80=E2=94=80(5b015b7)

It's just the rename - no features, please consider applying.

=E2=95=9F libxt_recent: add missing --rsource,--rdest options to manpag=
e=E2=94=80=E2=94=80(a9299b7)

A manpage fix ontop of the rename.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
