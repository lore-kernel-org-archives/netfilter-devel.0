From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Fix translation of
 --set-xmark option
Date: Wed, 22 Jun 2016 12:23:42 +0200
Message-ID: <20160622102342.GA6696@breakpoint.cc>
References: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arturo.borrero.glez@gmail.com, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
To: rodanber@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33136 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbcFVKXv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 06:23:51 -0400
Content-Disposition: inline
In-Reply-To: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

rodanber@gmail.com <rodanber@gmail.com> wrote:
> From: Roberto Garc=EDa <rodanber@gmail.com>
>=20
> Fix translation of MARK target's --set-xmark option.
>=20
> Before:
>=20
>  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x6=
4/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and 0xaf
>=20
> After:
>=20
>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x=
64/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and \
>   0xffffff50

Hmm, I wonder if this is correct...  iptables man page says:

 --set-xmark value[/mask]
   Zeroes out the bits given by mask and XORs value into the packet
   mark ("nfmark"). If mask is omitted, 0xFFFFFFFF is assumed.

So the iptables command is supposed to

   mark =3D skb->mark
   mark =3D mark & ~0xaf
   mark ^=3D 0x64
   skb->mark =3D mark

The proposed translation results in:
nft --debug=3Dnetlink add rule ip mangle PREROUTING meta mark set mark =
xor 0x64 and 0xffffff50
 [ meta load mark =3D> reg 1 ]
 [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000040 ]
 [ meta set mark with reg 1 ]

 As you can see nft did perform the '0x64 and 0xffffff50' part in an
 optimization pass so we end up not masking anything and then xor'ing
 0x40.

I think this should be:
nft --debug=3Dnetlink add rule ip mangle PREROUTING meta mark set mark =
and 0xffffff50 xor 0x64
 [ meta load mark =3D> reg 1 ]
 [ bitwise reg 1 =3D (reg=3D1 & 0xffffff50 ) ^ 0x00000064 ]
 [ meta set mark with reg 1 ]

which -- afaiu -- matches what the xtables target would do.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
