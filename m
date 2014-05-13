From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 2/2] examples: use new nft_*_build_msg() functions
Date: Tue, 13 May 2014 10:18:58 +0200
Message-ID: <CAOkSjBhjrHSDQa=+mCJnaVEWDJbvD2tWyWjCei9jAXtLorTVMA@mail.gmail.com>
References: <20140506201936.18158.83354.stgit@nfdev.cica.es>
 <20140506201941.18158.46054.stgit@nfdev.cica.es> <20140512161508.GB13099@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:35687 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbaEMITV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 04:19:21 -0400
Received: by mail-la0-f45.google.com with SMTP id gl10so2827751lab.32
        for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2014 01:19:20 -0700 (PDT)
In-Reply-To: <20140512161508.GB13099@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 May 2014 18:15, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Is this the only potential user of this new _build_ function? If so,
> I'd prefer to keep this back until we have more clients, I don't want
> to prematurely increase the size of the library with code that we
> don't need yet.
>

We can make use of these functions in nft and nft-sync as well.

I think this is kind of the first step to get higher level functions.
A second step would be to add _delete() and _add() functions to
libnftnl or other, higher level, library.

You know, src/mnl.c is repeating over and over almost the same code.

Let me know your thoughts.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
