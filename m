From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] list: fix prefetch dummy
Date: Wed, 26 Aug 2015 20:45:19 +0200
Message-ID: <20150826184519.GA14982@salvia>
References: <20150820104520.23066.45825.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <aborrero@cica.es>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49571 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbbHZSi5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:38:57 -0400
Content-Disposition: inline
In-Reply-To: <20150820104520.23066.45825.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 20, 2015 at 12:45:20PM +0200, Arturo Borrero Gonzalez wrote=
:
> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>=20
> [...]
>   CC       conntrack.o
> In file included from ../include/conntrack.h:4:0,
>                  from conntrack.c:41:
> conntrack.c: In function =E2=80=98findproto=E2=80=99:
> ../include/linux_list.h:385:59: warning: right-hand operand of comma =
expression has no effect [-Wunused-value]
>   for (pos =3D list_entry((head)->next, typeof(*pos), member), \
>                                                           ^
> [...]

Thanks for taking care of this, Arturo.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
