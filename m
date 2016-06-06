From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Add translation to nft
Date: Mon, 6 Jun 2016 10:37:50 +0200
Message-ID: <CAOkSjBjTaVNkoD99K_OihjH1uNdJN37sy1KVnRRm_+MAKUO_Wg@mail.gmail.com>
References: <1465044150-13229-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35658 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbcFFIiL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 04:38:11 -0400
Received: by mail-wm0-f65.google.com with SMTP id k184so8145069wme.2
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2016 01:38:10 -0700 (PDT)
In-Reply-To: <1465044150-13229-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 June 2016 at 14:42,  <rodanber@gmail.com> wrote:
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Add translation for the MARK target to nftables.
>
> Examples:
>
> $ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MA=
RK
> --set-mark 64
> nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set 0x40
>
> $ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MA=
RK
> --set-xmark 64
> nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set 0x40
>
> $ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MA=
RK
> --or-mark 64
> nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark=
 or 0x40
>
> $ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MA=
RK --and-mark
> 64
> nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark=
 and 0x40
>
> $ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MA=
RK
> --xor-mark 64
>
> nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark=
 xor 0x40
>

I miss some examples on working with masks. I would like to see how do
you translate for example '--set-xmark value/mask' and '--set-mark
value/mask'.

Perhaps you could delete the '-p tcp --dport 22' thing, so we are
short and to the point with the examples.

> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_MARK.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
> index 556dbde..9383f64 100644
> --- a/extensions/libxt_MARK.c
> +++ b/extensions/libxt_MARK.c
> @@ -245,6 +245,26 @@ static void mark_tg_save(const void *ip, const s=
truct xt_entry_target *target)
>         printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
>  }
>
> +static int mark_tg_xlate(const void *ip, const struct xt_entry_targe=
t *target,
> +                        struct xt_xlate *xl, int numeric)
> +{
> +       const struct xt_mark_tginfo2 *info =3D (const void *)target->=
data;
> +
> +       if (info->mark =3D=3D 0)
> +               xt_xlate_add(xl, "meta mark set mark and 0x%x",
> +                            (unsigned int)(uint32_t)~info->mask);

This double casting seems very weird to me. I would try to have only
one casting at most. Did you try it? Probably no cast is even
required, actually (I don't know)

> +       else if (info->mark =3D=3D info->mask)
> +               xt_xlate_add(xl, "meta mark set mark or 0x%x", info->=
mark);
> +       else if (info->mask =3D=3D 0)
> +               xt_xlate_add(xl, "meta mark set mark xor 0x%x", info-=
>mark);
> +       else if (info->mask =3D=3D 0xffffffffU)
> +               xt_xlate_add(xl, "meta mark set 0x%x", info->mark);
> +       else
> +               xt_xlate_add(xl, "meta mark xset 0x%x/0x%x", info->ma=
rk, info->mask);

'meta mark xset' ? Probably you can print 'meta mark set'
unconditionally so you avoid this kind of errors.

> +
> +       return 1;
> +}

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
