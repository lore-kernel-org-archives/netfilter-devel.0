From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 15:21:47 +0100
Message-ID: <CAOkSjBjrvhQ-AUwhXzydN-x4YrCNoDq3--dkG8MwzZYSgWzZZA@mail.gmail.com>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231837.19943.77406.stgit@nfdev.cica.es> <20140218011007.GA4456@localhost>
 <20140218020354.GG12893@macbook.localnet> <20140218092811.GA3880@localhost>
 <20140218093311.GA11507@macbook.localnet> <20140218094320.GA4009@localhost>
 <20140218095209.GA12005@macbook.localnet> <20140218095829.GA4173@localhost> <20140218101259.GC12496@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:62280 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbaBROWJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:22:09 -0500
Received: by mail-lb0-f176.google.com with SMTP id w7so12133512lbi.21
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2014 06:22:07 -0800 (PST)
In-Reply-To: <20140218101259.GC12496@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 February 2014 11:12, Patrick McHardy <kaber@trash.net> wrote:
>
> I'm actually not sure nft really could fail if the expression returne=
d
> from the kernel makes any sense at all.

I did a fast&small test.

What to do in the event reporting if this situation is reached?
Non-sense rule added to the kernel:

ip filter input 0 0
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 2b @ transport header + 1 =3D> reg 2 ]
  [ counter pkts 0 bytes 0 ]
  [ cmp eq reg 1 0x00001600 ]

% nft list table filter
table ip filter {
 [...]
}
netlink: Error: Relational expression has no left hand side


netlink: Error: Relational expression size mismatch

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
