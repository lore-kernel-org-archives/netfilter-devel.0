From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add translation to nft
Date: Tue, 22 Dec 2015 13:47:57 +0100
Message-ID: <CAOkSjBiJ+wWWyt+4ewjEJyMN79C6Navd19Av6n6LVo0tfyd-Ow@mail.gmail.com>
References: <20151221173559.GA8787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34944 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbbLVMsR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 07:48:17 -0500
Received: by mail-wm0-f53.google.com with SMTP id l126so108899177wml.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 04:48:17 -0800 (PST)
In-Reply-To: <20151221173559.GA8787@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 December 2015 at 18:35, Shivani Bhardwaj <shivanib134@gmail.com> =
wrote:
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

if info->group is not set, you should probably default to 0, since
this group info is mandatory in nftables to consider this logging the
same type of NFLOG (ie, use nfnetlink_log).

=46or reference, see:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/ne=
t/netfilter/nft_log.c#n67

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
