From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH v2] netlink: Allow to invert the ranges
Date: Sun, 1 Jun 2014 21:20:07 +0100
Message-ID: <20140601202006.GB19396@macbook.localnet>
References: <1401210934-4900-1-git-send-email-alvaroneay@gmail.com>
 <1401271702-12124-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55171 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaFAUUK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:20:10 -0400
Content-Disposition: inline
In-Reply-To: <1401271702-12124-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 28, 2014 at 12:08:22PM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> This patch fix the bug:
>=20
> http://bugzilla.netfilter.org/show_bug.cgi?id=3D924
>=20
> Before, nftables doesn't permit invert ranges. This patch allows
> add rules like this:
>=20
> nft add rule ip test input ip daddr !=3D 192.168.1.2-192.168.1.55
> or
> nft add rule ip test input ip daddr =3D=3D 192.168.1.2-192.168.1.55
>=20
> Also, we still have the option for adding rules like this:
>=20
> sudo nft add rule ip test output frag id 33-45
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
> * I have added OP_RANGE in netlink_gen_range. I have supposed that al=
ways
>   we have a comparison before the range and I have forbidden to add r=
ules
>   with ranges without comparison symbol (=3D=3D or !=3D).

That seems fine. The implicit op for ranges is OP_EQ.

The patch looks fine to me. Minor improvement might be to factor out th=
e common
code from netlink_gen_range(), but might not be worth it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
