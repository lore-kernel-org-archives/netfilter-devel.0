From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft RFC PATCH 3/6] netlink: add netlink_delinearize_set() func
Date: Tue, 18 Feb 2014 10:11:52 +0100
Message-ID: <CAOkSjBgWGqsG9FdSfp=R6joP_us3FSRRcFdU0cjobDLexvY4vw@mail.gmail.com>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231822.19943.3523.stgit@nfdev.cica.es> <20140218015641.GF12893@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55528 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaBRJMO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:12:14 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so12313127lbi.28
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2014 01:12:12 -0800 (PST)
In-Reply-To: <20140218015641.GF12893@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 February 2014 02:56, Patrick McHardy <kaber@trash.net> wrote:
>> +extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>> +                                        struct nft_set *nls);
>
> Actually delinarization so far refers to the act of converting a line=
ar
> instruction stream into an abstract syntax tree. This is not really a
> good term for sets, which are still pretty much linear.
>
> I don't have a good suggestion right now though.

At first, I used something like 'nls2set', but this delinearize thing
sounded more 'serious' :)

In think in all cases, we are converting netlink objects to the
internal nft object. We need a name for that, no?

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
