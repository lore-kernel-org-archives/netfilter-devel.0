From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft 0/7] listing command updates
Date: Fri, 9 Oct 2015 09:09:10 +0200
Message-ID: <CAOkSjBi-3aQyS3oBSLBbYNbC-Cqtgd=dy9EBvdZsX=2uFCdoUw@mail.gmail.com>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37722 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbbJIHJb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 03:09:31 -0400
Received: by wicfx3 with SMTP id fx3so53973300wic.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2015 00:09:30 -0700 (PDT)
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 October 2015 at 22:49, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> Hi,
>
> This patchset is following up after:
>
> http://www.spinics.net/lists/netfilter-devel/msg38491.html
>
> In a nutshell, what I'm proposing is that:
>
> * `list {tables,chains,sets}' only display the object declaration, no=
t its
>   definition (ie. content). Moreover, if no family is specified, then=
 they
>   show all families to get this aligned with `list ruleset'.
>
> * If you want to obtain the objects definition, then you use the
>   `list {table,chain,set}' variant.
>
> * We always provide an output that doesn't break `nft -f'.
>
> Let me know if you have any comment,

I agree with the changes :-)

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
