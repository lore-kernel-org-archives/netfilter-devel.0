From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] include: add stdint.h to common.h
Date: Tue, 21 Jan 2014 13:26:16 +0100
Message-ID: <20140121122616.GA23738@localhost>
References: <20140121120832.18045.30403.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbaAUM0W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:26:22 -0500
Content-Disposition: inline
In-Reply-To: <20140121120832.18045.30403.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 01:08:32PM +0100, Arturo Borrero Gonzalez wrote=
:
> Avoid:
>=20
> /usr/local/include/libnftnl/common.h:25:49: error: unknown type name =
=E2=80=98uint16_t=E2=80=99
> /usr/local/include/libnftnl/common.h:25:63: error: unknown type name =
=E2=80=98uint16_t=E2=80=99
> /usr/local/include/libnftnl/common.h:26:10: error: unknown type name =
=E2=80=98uint16_t=E2=80=99
> /usr/local/include/libnftnl/common.h:26:25: error: unknown type name =
=E2=80=98uint32_t'

Applied, thanks Arturo.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
