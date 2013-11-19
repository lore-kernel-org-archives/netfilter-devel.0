From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nftables PATCH] listing: only display wanted chain
Date: Tue, 19 Nov 2013 10:26:02 +0100
Message-ID: <CAOkSjBim5j=bfuu8NdzXA6ctMpE-Q6w90dB3Ltj0+wJjBX1AAg@mail.gmail.com>
References: <1384760421-4238-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:63175 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3KSJ0Y convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:26:24 -0500
Received: by mail-la0-f50.google.com with SMTP id el20so5765458lab.23
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2013 01:26:23 -0800 (PST)
In-Reply-To: <1384760421-4238-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 November 2013 08:40, Eric Leblond <eric@regit.org> wrote:
> When specifying a chain to list, all created chains were displayed
> with a void content:
>
>  # nft list chain filter
>  table ip filter {
>         chain input {
>         }
>
>         chain new {
>                  counter packets 17971 bytes 2380637 accept
>                  counter packets 0 bytes 0 accept
>         }
>   }
>
> With the attached patch, only the asked chain is displayed:
>
>   # nft list chain filter
>   table ip filter {
>         chain new {
>                  counter packets 17971 bytes 2380637 accept # handle =
36
>                  counter packets 0 bytes 0 accept # handle 40
>         }
>   }
>
> Signed-off-by: Eric Leblond <eric@regit.org>

Hi all,

I've been testing this patch and works fine for me.
I think the old behaviour was a bit odd.

Thanks Eric.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
