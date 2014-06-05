From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH v2] netlink: Allow to invert the ranges
Date: Thu, 5 Jun 2014 17:01:26 +0200
Message-ID: <20140605150125.GA25244@localhost>
References: <1401210934-4900-1-git-send-email-alvaroneay@gmail.com>
 <1401271702-12124-1-git-send-email-alvaroneay@gmail.com>
 <20140601202006.GB19396@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alvaro Neira Ayuso <alvaroneay@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37511 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaFEPBi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:01:38 -0400
Content-Disposition: inline
In-Reply-To: <20140601202006.GB19396@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 01, 2014 at 09:20:07PM +0100, Patrick McHardy wrote:
> On Wed, May 28, 2014 at 12:08:22PM +0200, Alvaro Neira Ayuso wrote:
> > From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
> >=20
> > This patch fix the bug:
> >=20
> > http://bugzilla.netfilter.org/show_bug.cgi?id=3D924
> >=20
> > Before, nftables doesn't permit invert ranges. This patch allows
> > add rules like this:
> >=20
> > nft add rule ip test input ip daddr !=3D 192.168.1.2-192.168.1.55
> > or
> > nft add rule ip test input ip daddr =3D=3D 192.168.1.2-192.168.1.55
> >=20
> > Also, we still have the option for adding rules like this:
> >=20
> > sudo nft add rule ip test output frag id 33-45
> >=20
> > Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> > ---
> > [changes in v2]
> > * I have added OP_RANGE in netlink_gen_range. I have supposed that =
always
> >   we have a comparison before the range and I have forbidden to add=
 rules
> >   with ranges without comparison symbol (=3D=3D or !=3D).
>=20
> That seems fine. The implicit op for ranges is OP_EQ.
>=20
> The patch looks fine to me. Minor improvement might be to factor out =
the common
> code from netlink_gen_range(), but might not be worth it.

I have applied this, we can revisit this later. Thanks Alvaro and
Patrick.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
