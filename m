From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: fix expr_binary_error()-related compilation
 warnings
Date: Wed, 12 Mar 2014 17:00:06 +0100
Message-ID: <20140312160006.GA533@localhost>
References: <20140312155322.23689.60367.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51595 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaCLQAM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:00:12 -0400
Content-Disposition: inline
In-Reply-To: <20140312155322.23689.60367.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 12, 2014 at 04:53:22PM +0100, Arturo Borrero Gonzalez wrote=
:
> The commit e7b43ec0 [expr: make expr_binary_error() usable outside of=
 evaluation]
> seem to change expr_binary_error() interface.
>=20
> Later, several compilation warning appears.
>=20
> The expr_binary_error() function and expr_error() macro both expect
> `struct list_head *', so I simply changed callers to send `ctx->msgs'=
=2E
>=20
> [...]
> src/evaluate.c: In function =E2=80=98byteorder_conversion=E2=80=99:
> src/evaluate.c:166:3: warning: passing argument 1 of =E2=80=98expr_bi=
nary_error=E2=80=99 from incompatible pointer type [enabled by default]

Applied, thanks Arturo.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
