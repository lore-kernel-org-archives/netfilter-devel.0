From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] log: define variable flags in xml parser
Date: Tue, 15 Jul 2014 15:37:54 +0200
Message-ID: <20140715133754.GA5425@salvia>
References: <1405364671-26103-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbaGONh6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:37:58 -0400
Content-Disposition: inline
In-Reply-To: <1405364671-26103-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 14, 2014 at 09:04:31PM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> In the xml parser, we have used a variable flags for parsing it
> but we have forgot define it. This patch solves a compile error
> like:
>=20
> expr/log.c:263:12: error: 'flags' undeclared (first use in this funct=
ion)

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
