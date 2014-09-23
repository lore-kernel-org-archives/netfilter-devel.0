From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 4/4 v3] nft: complete reject support
Date: Tue, 23 Sep 2014 08:43:47 +0200
Message-ID: <20140923064347.GB14535@acer.localdomain>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
 <1411327957-19379-4-git-send-email-alvaroneay@gmail.com>
 <20140922082058.GK4971@acer.localdomain>
 <54204CF6.6050007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44589 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIWGnv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:43:51 -0400
Content-Disposition: inline
In-Reply-To: <54204CF6.6050007@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 22, 2014 at 06:23:18PM +0200, =C1lvaro Neira Ayuso wrote:
> El 22/09/14 10:20, Patrick McHardy escribi=F3:
> >I actually think we should add full support for this by adding an
> >inet-specific ICMP type table which is the intersection of the ICMP
> >and ICMPv6 types for inet and map those to the corresponding real
> >types:
> >
> >nft inet filter input reject with host-unreachable
> >
>=20
> I have seen the ICMP and ICMPv6 types and I have done this map:
>=20
> CODE		 |	ICMPv6		|	ICMPv4
> admin-prohibited | admin-prohibited	|	admin-prohibited
> port-unreach	 | port-unreach		|	port-unreach
> no-route	 | no-route		|	net-unreach
> host-unreach	 | addr-unreach		|	host-unreach
>=20
> What do you think?

Looks reasonable. We need to do mapping to the real codes at runtime
in nft_reject_inet. I'd suggest to use the same numeric values as
in IPv4 and only map those for IPv6, so we can avoid the translation
in at least one case.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
