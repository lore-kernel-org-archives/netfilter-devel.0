From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] ruleset: fix erroneus call to snprintf
Date: Tue, 6 May 2014 17:53:01 +0200
Message-ID: <CAOkSjBiuZvgQrxH2rJDk2Sq593gq7Tv30nCx5RTua1BuTLg0Sw@mail.gmail.com>
References: <20140506150933.31175.48901.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53776 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaEFPxW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 11:53:22 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so472164lbd.8
        for <netfilter-devel@vger.kernel.org>; Tue, 06 May 2014 08:53:21 -0700 (PDT)
In-Reply-To: <20140506150933.31175.48901.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 May 2014 17:09, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> This snprintf call is taking an erroneus value for size.
>

Please Pablo fix the message if you apply this. erroneus -> erroneous.

thanks, regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
