From: - <d.stussy@yahoo.com>
Subject: Re: Xtables 1.26 vs. Linux Kernel 2.6.34[.0] - Compile problem
Date: Fri, 21 May 2010 12:14:03 -0700 (PDT)
Message-ID: <798212.56589.qm@web84206.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, adobriyan@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n15.bullet.mail.mud.yahoo.com ([68.142.206.42]:37884 "HELO
	n15.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758168Ab0EUTOF convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 15:14:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Did commit a79ff731a1b277d0e92d9453bdf374e04cec717a make it into the 2.=
6.34.0 kernel release?=A0 It appears not to have, at least when I looke=
d at my source code archive....=A0 The kernel is dated 2010-05-16, yet =
I did NOT see this patch in the changelog despite its April 13 date.

--- On Fri, 5/21/10, Patrick McHardy <kaber@trash.net> wrote:
> To: "Jan Engelhardt" <jengelh@medozas.de>
> Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.o=
rg>, d.stussy@yahoo.com, adobriyan@gmail.com
> Jan Engelhardt wrote:
> > Forwarding to nf-dev for the records...
> >=20
> > Seems like we need #include <linux/kernel.h> in x_tables.h now.
>=20
>=20
> This should be fixed by commit a79ff731, "netfilter: xtables: make
> XT_ALIGN() usable in exported headers by exporting __ALIGN_KERNEL()"
> > ---------- Forwarded message ----------
> > From: - <d.stussy@yahoo.com>
> > To: jengelh@medozas.de
> >=20
> > (compiling against kernel headers - for modules):
> >=20
> > make[3]: Entering directory `/usr/src/xtables-addons-1.26/extension=
s'
> >=A0=A0=A0CC=A0 =A0=A0=A0libxt_CHAOS.oo
> > libxt_CHAOS.c:99: warning: implicit declaration of function `ALIGN'
> > libxt_CHAOS.c:99: error: initializer element is not constant
> > ...
>=20
> -----Inline Attachment Follows-----
> commit a79ff731a1b277d0e92d9453bdf374e04cec717a
> Author: Alexey Dobriyan <adobriyan@gmail.com>
> Date:=A0=A0=A0Tue Apr 13 11:21:46 2010 +0200
> ...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
