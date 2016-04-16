From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 1/1] payload: only merge if adjacent and combined size
 fits into a register
Date: Sat, 16 Apr 2016 15:17:56 +0200
Message-ID: <CAOkSjBhw32VvJewnQitmVxKzrBSG3yp=38g5cCzgsDvhmiVRZA@mail.gmail.com>
References: <1460725779-12066-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36714 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcDPNSR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Apr 2016 09:18:17 -0400
Received: by mail-wm0-f44.google.com with SMTP id v188so63710974wme.1
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Apr 2016 06:18:16 -0700 (PDT)
In-Reply-To: <1460725779-12066-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 April 2016 at 15:09, Florian Westphal <fw@strlen.de> wrote:
> add rule ip6 filter input ip6 saddr ::1/128 ip6 daddr ::1/128 fails,
> we ask to compare a 32byte immediate which is not supported:
>
>   [ payload load 32b @ network header + 8 =3D> reg 1 ]
>   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 0x000000=
00 0x00000000 0x00000000 0x02000000 ]
>
> We would need to use two cmps in this case, i.e.:
>
>   [ payload load 32b @ network header + 8 =3D> reg 1 ]
>   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
>   [ cmp eq reg 2 0x00000000 0x00000000 0x00000000 0x02000000 ]
>
> Seems however that this requires a bit more changes to how nft
> handles register allocations, we'd also need to undo the constant mer=
ge.
>
> Lets disable merging for now so that we generate
>
>   [ payload load 16b @ network header + 8 =3D> reg 1 ]
>   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
>   [ payload load 16b @ network header + 24 =3D> reg 1 ]
>   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
>
> ... if merge would bring us over the 128 bit register size.
>
> Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=3D1032
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/payload.h               |  2 +-
>  src/payload.c                   | 27 ++++++++++++++++++++-------
>  src/rule.c                      |  2 +-
>  tests/py/ip6/ip6.t              |  1 +
>  tests/py/ip6/ip6.t.payload.inet |  9 +++++++++
>  tests/py/ip6/ip6.t.payload.ip6  |  7 +++++++
>  6 files changed, 39 insertions(+), 9 deletions(-)
>

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
