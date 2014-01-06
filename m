From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] src: new error reporting approach for
 XML/JSON parsers
Date: Mon, 6 Jan 2014 13:23:44 +0100
Message-ID: <20140106122344.GA7589@localhost>
References: <20140105235114.3752.26544.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53580 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaAFMXu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:23:50 -0500
Content-Disposition: inline
In-Reply-To: <20140105235114.3752.26544.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 12:51:14AM +0100, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> I have added a new structure for reporting some errors in parser
> that we can't cover with errno.
>=20
> In this patch, we have three errors that we can't cover with errno:
>=20
> NFT_PARSE_EBADINPUT : Bad XML/JSON format in the input
> NFT_PARSE_EMISSINGNODE : Missing node in our input
> NFT_PARSE_EBADTYPE : Wrong type value in a node

This looks good. Applied, thanks Alvaro.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
