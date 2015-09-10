From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] evaluate: use existing table object from evaluation context
Date: Thu, 10 Sep 2015 08:31:25 +0200
Message-ID: <CAOkSjBiXNzmiM5hWfEpn1_y0OiAV-6E-WpYwzRDWe-mMnpqAug@mail.gmail.com>
References: <1441843168-5632-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:35686 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbbIJGbr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 02:31:47 -0400
Received: by lagj9 with SMTP id j9so21532657lag.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2015 23:31:45 -0700 (PDT)
In-Reply-To: <1441843168-5632-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 September 2015 at 01:59, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
> Skip table object lookup if we are in the context of table declaratio=
n already,
> ctx->table already points to the right table we have to use during th=
e
> evalution. Otherwise, a list corruption occurs when using the wrong t=
able
> object when it already exists in the kernel.
>
> http://marc.info/?l=3Dnetfilter-devel&m=3D144179814209295&w=3D2
>
> Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/evaluate.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>

I can't reproduce the issue with this patch, thanks.

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
