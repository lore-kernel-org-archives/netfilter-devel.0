From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iptables] libxt_length: update to revision 1
Date: Sat, 24 Jul 2010 07:28:46 +0200
Message-ID: <1279949326.2451.47.camel@edumazet-laptop>
References: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0GXF2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 01:28:51 -0400
Received: by wyf19 with SMTP id 19so853462wyf.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 22:28:50 -0700 (PDT)
In-Reply-To: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le samedi 24 juillet 2010 =C3=A0 12:29 +0800, Changli Gao a =C3=A9crit =
:
> update libxt_length to revision 1 to support ipv6 jumbo frames.
>=20
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  extensions/libxt_length.c           |    1 +
>  include/linux/netfilter/xt_length.h |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
> index 96e8b6c..5d0f5e9 100644
> --- a/extensions/libxt_length.c
> +++ b/extensions/libxt_length.c
> @@ -125,6 +125,7 @@ static struct xtables_match length_match =3D {
>  	.print		=3D length_print,
>  	.save		=3D length_save,
>  	.extra_opts	=3D length_opts,
> +	.revision	=3D 1,
>  };
> =20
>  void _init(void)

Hmm... I think you missed at line 50 :


        info->max =3D cp[0] ? parse_length(cp) : 0xFFFF;

Or document the thing...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
