From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH libnftables] Add support for nft_connmark
Date: Mon, 6 Jan 2014 13:41:57 +0100
Message-ID: <CAOkSjBiBuEGqxeboPWHyxk_fKwqDL5ZE0Zx5JLjkQv9M8ahM1g@mail.gmail.com>
References: <1389011367-11489-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43977 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaAFMmW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:42:22 -0500
Received: by mail-la0-f42.google.com with SMTP id ec20so9944691lab.29
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 04:42:18 -0800 (PST)
In-Reply-To: <1389011367-11489-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 January 2014 13:29, Kristian Evensen <kristian.evensen@gmail.com> =
wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
>
> This patch adds support for the connmark target.
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> +
> +/* Even though nfmask and ctmark is mutually exclusive, do not use u=
nion here.
> + * The user can provide incorrect json/xml input containing both val=
ues. */
> +struct nft_expr_connmark {
> +       uint32_t                ctmark;
> +       uint32_t                ctmask;
> +       uint32_t                nfmask;
> +       uint8_t                 mode;
> +};

Hi Kristian,

you can use the union if you want, see [0] about the situation in XML
and [1] in JSON.

Regards.

[0] http://git.netfilter.org/libnftables/tree/src/expr/meta.c?h=3Dnext-=
3.14#n236
[1] http://git.netfilter.org/libnftables/tree/src/expr/meta.c?h=3Dnext-=
3.14#n195

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
