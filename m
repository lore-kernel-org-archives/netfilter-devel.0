From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC PATCH v2 6/6] src: add events reporting
Date: Wed, 26 Feb 2014 18:17:36 +0100
Message-ID: <CAOkSjBjFNzeHWaN5gaAeifH2rAqBbUrTJBvzNiLqE7bP4H4R4g@mail.gmail.com>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es> <20140226161015.18974.17832.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:49170 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZRR6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:17:58 -0500
Received: by mail-la0-f41.google.com with SMTP id gl10so849204lab.14
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2014 09:17:56 -0800 (PST)
In-Reply-To: <20140226161015.18974.17832.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 February 2014 17:10, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
>
> +
> +       /* XXXX */
> +       sleep(1);
> +
> +       /* only way, by now, to know set_elems (no set_elem events) *=
/
> +       if (netlink_get_setelems(&set_tmpctx, &s->handle, monh->loc, =
s) < 0)
> +               goto out;
> +

About this:

it seems that I can't query the kernel just after the set is created,
because I get an empty set.

I need help at this point.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
