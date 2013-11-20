From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Wed, 20 Nov 2013 14:54:58 +0100
Message-ID: <20131120135458.GA6206@localhost>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
 <1382280491-9921-4-git-send-email-jengelh@inai.de>
 <20131119202815.GC4929@localhost>
 <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
 <528C98D2.9080204@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40240 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab3KTNzI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:55:08 -0500
Content-Disposition: inline
In-Reply-To: <528C98D2.9080204@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 20, 2013 at 01:11:14PM +0200, Tomasz Bursztyka wrote:
> Hi Jan and Pablo,
>=20
> I prefer this automake approach against current one, for instance:
>=20
> >   CC            src/scanner.c
> ><stdout>: In function =E2=80=98nft_lex=E2=80=99:
> ><stdout>:1738:23: error: comparison between signed and unsigned inte=
ger expressions [-Werror=3Dsign-compare]
> >
> >I'll overlook -Werror for now=E2=80=A6
>=20
> This error could be better fixed with a Makefile.am as proposed in
> this patchset, as found in
> http://git.netfilter.org/conntrack-tools/tree/src/Makefile.am
> Let's keep -Werror on all files but the crappy auto-generated
> bison/flex ones.

I used to have -Werror in conntrack-tools for long time, it was
breaking easily with stupid warnings with different gcc compiler
versions and platforms. People were manually removing it to get things
working.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
