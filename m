From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Wed, 20 Nov 2013 13:11:14 +0200
Message-ID: <528C98D2.9080204@linux.intel.com>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de> <1382280491-9921-4-git-send-email-jengelh@inai.de> <20131119202815.GC4929@localhost> <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3KTLLQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:11:16 -0500
In-Reply-To: <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan and Pablo,

I prefer this automake approach against current one, for instance:

>    CC            src/scanner.c
> <stdout>: In function =E2=80=98nft_lex=E2=80=99:
> <stdout>:1738:23: error: comparison between signed and unsigned integ=
er expressions [-Werror=3Dsign-compare]
>
> I'll overlook -Werror for now=E2=80=A6

This error could be better fixed with a Makefile.am as proposed in this=
=20
patchset, as found in=20
http://git.netfilter.org/conntrack-tools/tree/src/Makefile.am
Let's keep -Werror on all files but the crappy auto-generated bison/fle=
x=20
ones.

It's better breaking and fixing the built files now rather than after=20
linux 3.13 release.

Tomasz


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
