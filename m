From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2] src: add low-level ruleset API
Date: Tue, 1 Oct 2013 11:46:38 +0200
Message-ID: <CAOkSjBjZ7hKJxGfdhD_y9CUGJZzdKjAEnBVoqPAQUcTevhVahg@mail.gmail.com>
References: <20130930223246.12985.64667.stgit@nfdev.cica.es> <20131001093813.GA7452@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:54783 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3JAJq7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:46:59 -0400
Received: by mail-lb0-f177.google.com with SMTP id w7so5583440lbi.22
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Oct 2013 02:46:58 -0700 (PDT)
In-Reply-To: <20131001093813.GA7452@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 October 2013 11:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 01, 2013 at 12:33:18AM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch adds a low level ruleset API for libnftables.
>
> Applied, thanks Arturo.
>
> BTW, any plan to send me example files?

It seem I can't dump sets with af NFPROTO_UNSPEC.

I'm looking nf_tables_api.c wondering how difficult is to implement it.

In nf_tables_dump_sets_all(), I think we need to iterate afs  like in
dump_tables(), ie:

list_for_each_entry(afi, &net->nft.af_info, list) {
  if (family !=3D NFPROTO_UNSPEC && family !=3D afi->family)
    continue;
[...]


--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
