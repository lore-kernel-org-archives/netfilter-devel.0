From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] scanner: Add udplite value for parsing it.
Date: Wed, 28 May 2014 11:24:56 +0200
Message-ID: <20140528092456.GA7351@localhost>
References: <1401201011-25109-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaE1JZB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2014 05:25:01 -0400
Content-Disposition: inline
In-Reply-To: <1401201011-25109-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 27, 2014 at 04:30:11PM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> When we add a udplite rule, we can't because we have forgot
> to add this parameter in the scanner and nft doesn't detect it.

Applied. For the record, I have renamed the title of this patch to:

scanner: Add udplite token

Please, try to select better patch titles, the idea is that a quick
glance via git log --oneline provides a description sufficiently
expressive to the reader so you only need to read the full description
in case you want details. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
