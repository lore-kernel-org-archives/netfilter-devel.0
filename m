From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] examples: add nft-ruleset-get
Date: Mon, 6 Jan 2014 12:53:24 +0100
Message-ID: <CAOkSjBjneHWTth=u+4mf9xXPyQ4+GCVq+WcyZiBwYean8N6GhQ@mail.gmail.com>
References: <20131223141507.6481.39666.stgit@nfdev.cica.es> <20140104005303.GA5037@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:50371 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaAFLxq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:53:46 -0500
Received: by mail-la0-f46.google.com with SMTP id eh20so9833493lab.33
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 03:53:45 -0800 (PST)
In-Reply-To: <20140104005303.GA5037@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 January 2014 01:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Dec 23, 2013 at 03:18:22PM +0100, Arturo Borrero Gonzalez wro=
te:
>> This example prints the ruleset, using the ruleset API of nftables.
>>
>> The kernel patch [b63108a] (netfilter: nf_tables: allow to dump sets=
 with
>> NFPROTO_UNSPEC) is required.
>
> Updated this to point to c9c8e48 ("netfilter: nf_tables: dump sets in
> all existing families").
>
> Applied to -next, thanks Arturo.

I don't see the kernel patch applied [0].

Have you applied it, or have plans to do so? If applied, please, could
you point me to the right tree?

[0] http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/log/
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
