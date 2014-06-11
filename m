From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH v2] queue: More compact syntax
Date: Wed, 11 Jun 2014 11:13:52 +0200
Message-ID: <20140611091352.GA5201@localhost>
References: <1402406110-14892-1-git-send-email-alvaroneay@gmail.com>
 <1402406784-15693-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52728 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbaFKJOC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:14:02 -0400
Content-Disposition: inline
In-Reply-To: <1402406784-15693-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 03:26:24PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to use a new syntax more compact and break
> the current syntax. This new syntax is more similar than the nftables
> syntax that we use usually. We can use range like we have used in
> other case in nftables. Here, we have some examples:
>=20
> Before, If we want to declare a queue, we have used a syntax like thi=
s:
>=20
> nft add rule test input queue num 1 total 3 options bypass,fanout
>=20
> If we want to use the queue number 1 and the two next (total 3),
> we use a range in the new syntax, for example:
>=20
> nft add rule test input queue num 1-3 bypass fanout
>=20
> Also if we want to use only one queue, the new rules are like:
>=20
> nft add rule test input queue num 1	//queue 1
> or
> nft add rule test input queue	//queue 0
>=20
> And if we want to add a specific flags we only need to put
> what flags we want to use:
>=20
> nft add rule test input queue bypass
>=20
> we don't need to use options and the comma for indicating the
> flags.

Applied, thanks =C1lvaro.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
