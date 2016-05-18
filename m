From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrack-tools PATCH] conntrackd: add support for NTA_(S|D)NAT_IPV6
Date: Wed, 18 May 2016 19:20:29 +0200
Message-ID: <CAOkSjBgFEozR4xWMH_2SbcxfnxoHbLdC3+uuMfEOBZDx+oBNVA@mail.gmail.com>
References: <146359111275.1329.5525714829523602554.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32999 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbcERRUv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2016 13:20:51 -0400
Received: by mail-wm0-f66.google.com with SMTP id r12so14568146wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2016 10:20:50 -0700 (PDT)
In-Reply-To: <146359111275.1329.5525714829523602554.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 May 2016 at 19:05, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> So we can properly sync NATed IPv6 connections.
>
> Thanks to Florian Westphal for originally ponting me to this lack of
> support in conntrackd, which saved me a lot of time.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
>  include/network.h |    2 ++
>  src/build.c       |   33 ++++++++++++++++++++++++++++-----
>  src/parse.c       |   17 +++++++++++++++++
>  3 files changed, 47 insertions(+), 5 deletions(-)
>

I tested this patch in a 2 node cluster with nftables doing IPv6 NAT,
with several configuration combinations according to my network &
systems setups.

It would be nice If someone can give a bit more of testing.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
