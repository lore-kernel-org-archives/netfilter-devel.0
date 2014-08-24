From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: nf_tables: add pkttype support to meta
 expression
Date: Sun, 24 Aug 2014 14:55:10 +0200
Message-ID: <20140824125510.GB7864@salvia>
References: <1402643720-6915-1-git-send-email-anarey@gmail.com>
 <1407325969-14531-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59649 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaHXMy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:54:29 -0400
Content-Disposition: inline
In-Reply-To: <1407325969-14531-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 06, 2014 at 01:52:49PM +0200, Ana Rey wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Add pkttype support for ip, ipv6 and inet families of tables.
>=20
> This allows you to fetch the meta packet type based on the link layer
> information. The loopback traffic is a special case, the packet type
> is guessed from the network layer header.
>=20
> No special handling for bridge and arp since we're not going to see
> such traffic in the loopback interface.
>=20
> Joint work with Alvaro Neira Ayuso <alvaroneay@gmail.com>

Applied with minor change in the documentation area in nf_tables.h.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
