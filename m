From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add translation to nft
Date: Tue, 22 Dec 2015 13:40:34 +0100
Message-ID: <CAOkSjBjHyw14nM1jYJ9dCO=N5Mq8MRUHO1dBkL1xrPCqFy5Fxw@mail.gmail.com>
References: <20151221173559.GA8787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38905 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467AbbLVMky convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 07:40:54 -0500
Received: by mail-wm0-f51.google.com with SMTP id l126so109948058wml.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 04:40:54 -0800 (PST)
In-Reply-To: <20151221173559.GA8787@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 December 2015 at 18:35, Shivani Bhardwaj <shivanib134@gmail.com> =
wrote:
> Add translation for NF Logging to nftables.
>
> Examples:
>
> $ sudo iptables-translate -A OUTPUT -j NFLOG --nflog-group 30
> nft add rule ip filter OUTPUT counter log group 30
>
> $ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflo=
g-prefix "Prefix 1.0"
> nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" log =
group 32
>

Hi Shivani,

I think that rule should translate to:
 nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group=
 32

so, avoid using multiple 'log' keywords, which will load several
nftables log expressions.

>
> +static void nflog_print_xlate(const struct xt_nflog_info *info,
> +                             char *prefix, struct xt_buf *buf)
> +{
> +       if (info->prefix[0] !=3D '\0')
> +               xt_buf_add(buf, "%slog prefix \\\"%s\\\" ",
> +                          prefix, info->prefix);
> +       if (info->group)
> +               xt_buf_add(buf, "%slog group %u ", prefix, info->grou=
p);
> +       if (info->len)
> +               xt_buf_add(buf, "%slog snaplen %u ", prefix, info->le=
n);
> +       if (info->threshold !=3D XT_NFLOG_DEFAULT_THRESHOLD)
> +               xt_buf_add(buf, "%slog queue-threshold %u ",
> +                          prefix, info->threshold);
> +}
> +

You may revisit this function.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
