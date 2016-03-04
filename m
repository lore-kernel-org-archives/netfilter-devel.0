From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] rule: simplify ("rule: delete extra space in sets printing")
Date: Fri, 4 Mar 2016 10:55:18 +0100
Message-ID: <CAOkSjBh5aR9Ac7Y+T-Y0TLK=sDQGODUzEoFj26n-mW5U-a1T6g@mail.gmail.com>
References: <1457083532-1595-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33780 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbcCDJzj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2016 04:55:39 -0500
Received: by mail-wm0-f66.google.com with SMTP id n186so3313680wmn.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Mar 2016 01:55:38 -0800 (PST)
In-Reply-To: <1457083532-1595-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 March 2016 at 10:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> This simplifies bd23f7628570 ("rule: delete extra space in sets print=
ing")
> by passing the whitespace from set_print_plain() called from the moni=
toring
> path.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
