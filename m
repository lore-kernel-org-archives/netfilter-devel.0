From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 3/4] datatype: add symbolic_constant_parse_table()
Date: Mon, 22 Sep 2014 12:06:12 +0200
Message-ID: <20140922100612.GO4971@acer.localdomain>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
 <1411327957-19379-3-git-send-email-alvaroneay@gmail.com>
 <20140922075902.GJ4971@acer.localdomain>
 <541FE676.6080807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36546 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaIVKGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:06:15 -0400
Content-Disposition: inline
In-Reply-To: <541FE676.6080807@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 22, 2014 at 11:05:58AM +0200, =C1lvaro Neira Ayuso wrote:
> El 22/09/14 09:59, Patrick McHardy escribi=F3:
> >On Sun, Sep 21, 2014 at 09:32:36PM +0200, Alvaro Neira Ayuso wrote:
> >>This function finds the symbol inside the table that you pass as pa=
rameter.
> >>If the symbol doesn't exist we use the basetype to parse it and
> >>symbolic_constant_parse().
> >
> >I'm thinking that we should probably do this in all cases and not
> >specific to mark and ICMP types. At least I can't see a reason not
> >to.
> >
>=20
> Sorry Patrick, I don't understand your answer. Could you elaborate th=
at?
> Looks good for you?
>

No, I'm suggesting to not add some new function for specific cases
but always fall back to parsing in the base type.

tcp flags 0x3
mark 0x1
ct state 4

and so on. Basically what we're doing for mark now, just for everything=
,
I don't see a reason not do to this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
