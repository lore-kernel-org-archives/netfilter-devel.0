From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] xml: expr: fix public interface for parsing XML
Date: Fri, 26 Jul 2013 16:31:47 +0200
Message-ID: <CAOkSjBjD9b=X3MNu7NPpVDFrLTCf9AtS2hQtYcp19e=sEkzZOQ@mail.gmail.com>
References: <20130726120031.4081.51723.stgit@nfdev.cica.es> <20130726141934.GA13991@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40434 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZOcJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:32:09 -0400
Received: by mail-lb0-f170.google.com with SMTP id u10so2582347lbi.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 07:32:07 -0700 (PDT)
In-Reply-To: <20130726141934.GA13991@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 July 2013 16:19, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Arturo,
>
> On Fri, Jul 26, 2013 at 02:00:31PM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch adds a public interface for parsing expr XML.
>> Before this patch, that operation was not possible.
>
> rule parse already parses expressions.
>
> Do you need this? If so, please specify the usage. Thanks.

I don't need this.

The only motivation was all object having a way of going from str to
nft_* but expr.
As you stated, currently the only way of parsing a XML expr is if the
expr itself is nested inside a rule.

but i'm fine without it ATM.

Regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
