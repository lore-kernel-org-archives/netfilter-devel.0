From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: tproxy: added IPv6 support to the socket match
Date: Thu, 28 Oct 2010 20:51:43 +0200
Message-ID: <AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
References: <201010231923.o9NJNK9U013494@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Balazs Scheidler <bazsi@balabit.hu>,
	KOVACS Krisztian <hidden@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35535 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab0J1Svp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:51:45 -0400
In-Reply-To: <201010231923.o9NJNK9U013494@hera.kernel.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 23, 2010 at 21:23, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb: =C2=A0 =C2=A0 http://git.kernel.org/linus/b64c9256a9b76fc9f05=
9f71bd08ba88fb0cbba2e
> Commit: =C2=A0 =C2=A0 b64c9256a9b76fc9f059f71bd08ba88fb0cbba2e
> Parent: =C2=A0 =C2=A0 6ad7889327a5ee6ab4220bd34e4428c7d0de0f32
> Author: =C2=A0 =C2=A0 Balazs Scheidler <bazsi@balabit.hu>
> AuthorDate: Thu Oct 21 16:19:42 2010 +0200
> Committer: =C2=A0Patrick McHardy <kaber@trash.net>
> CommitDate: Thu Oct 21 16:19:42 2010 +0200
>
> =C2=A0 =C2=A0tproxy: added IPv6 support to the socket match
>
> =C2=A0 =C2=A0The ICMP extraction bits were contributed by Harry Mason=
=2E
>
> =C2=A0 =C2=A0Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
> =C2=A0 =C2=A0Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>
> =C2=A0 =C2=A0Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
> =C2=A0net/netfilter/xt_socket.c | =C2=A0165 +++++++++++++++++++++++++=
+++++++++++++++++---
> =C2=A01 files changed, 154 insertions(+), 11 deletions(-)
>
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 266faa0..2dbd4c8 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c

> +static bool
> +socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par=
)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ipv6hdr *iph =3D ipv6_hdr(skb);
> + =C2=A0 =C2=A0 =C2=A0 struct udphdr _hdr, *hp =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 struct sock *sk;
> + =C2=A0 =C2=A0 =C2=A0 struct in6_addr *daddr, *saddr;
> + =C2=A0 =C2=A0 =C2=A0 __be16 dport, sport;
> + =C2=A0 =C2=A0 =C2=A0 int thoff;
> + =C2=A0 =C2=A0 =C2=A0 u8 tproto;

tproto is unsigned...

> + =C2=A0 =C2=A0 =C2=A0 const struct xt_socket_mtinfo1 *info =3D (stru=
ct xt_socket_mtinfo1 *) par->matchinfo;
> +
> + =C2=A0 =C2=A0 =C2=A0 tproto =3D ipv6_find_hdr(skb, &thoff, -1, NULL=
);

but ipv6_find_hdr() returns int, and negative values for errors...

> + =C2=A0 =C2=A0 =C2=A0 if (tproto < 0) {

which it can never catch.

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug("unable t=
o find transport header in IPv6 packet, dropping\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NF_DROP;
> + =C2=A0 =C2=A0 =C2=A0 }

net/netfilter/xt_socket.c:256: warning: comparison is always false due
to limited range of data type

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
