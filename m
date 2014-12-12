From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: src: add redirect support
Date: Fri, 12 Dec 2014 18:02:04 +0100
Message-ID: <CAOkSjBg6GomwWz1z-9GK_Lw8ELTfXwrXkDTc7XsLrCwGSTAvRQ@mail.gmail.com>
References: <20141212152929.GJ8013@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59529 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030555AbaLLRC0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:02:26 -0500
Received: by mail-lb0-f176.google.com with SMTP id p9so6131901lbv.21
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2014 09:02:25 -0800 (PST)
In-Reply-To: <20141212152929.GJ8013@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 December 2014 at 16:29, Patrick McHardy <kaber@trash.net> wrote:
> Looking at the redir bug report on netfilter-devel, I noticed some
> odd syntax for the redir statement.
>
> The changelog states:
>
>   The syntax is:
>
>   % nft add rule nat prerouting redirect [port] [nat_flags]
>
> The actual syntax though is:
>
> redir_stmt_arg          :       COLON   expr
>
> What do we need that colon for? redirect by definition redirects to
> the local host, the argument is always only a port expression.

Yes, there is a inconsistency between the commit message and the code. =
My fault.

I don't exactly remember where that syntax came from. I guess the
colon was used in consistency with other nat-like expressions.
Actually, I don't have a particular preference (the colon or not).

Do you want me to change the syntax? I can do it this weekend. Just
let me know :-)

If you are going to change it yourself, I would suggest to also update
regression tests [0], which BTW seems broken due to the
random-fully/fully-random change.

best regards.

[0] http://git.netfilter.org/nftables/tree/tests/regression/ip/redirect=
=2Et
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
