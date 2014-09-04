From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH v4 5/5] netfilter: nft_nat: add masquerade support
Date: Thu, 4 Sep 2014 15:54:49 +0200
Message-ID: <CAOkSjBjrTZzHhJkR6XHM7d97AXmoDwUNfqQ5RmqPYs7LZw46Gw@mail.gmail.com>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120710.5971.32117.stgit@nfdev.cica.es> <20140904122150.GF29395@acer.localdomain>
 <20140904124036.GA16426@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:60005 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaIDNzL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:55:11 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so11324506lbd.41
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Sep 2014 06:55:09 -0700 (PDT)
In-Reply-To: <20140904124036.GA16426@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 September 2014 14:40, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
>
> I like the idea of the masquerade expression.

Ok, I also like the idea.

Suggestions for the name of the new expression?

I would bet for nft_masq.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
