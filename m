From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] scanner: fix reading of really long line
Date: Wed, 3 Dec 2014 12:53:30 +0100
Message-ID: <20141203115330.GA12030@salvia>
References: <E1XvRIr-00046W-Nj@ks28632.kimsufi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56524 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbaLCLvQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:51:16 -0500
Content-Disposition: inline
In-Reply-To: <E1XvRIr-00046W-Nj@ks28632.kimsufi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 01, 2014 at 02:46:04PM +0100, Eric Leblond wrote:
> Hello,
> Le 1 d=E9c. 2014 12:55, Pablo Neira Ayuso <pablo@netfilter.org> a =E9=
crit :
> >
> > On Sat, Nov 29, 2014 at 05:24:38PM +0100, Eric Leblond wrote:=20
> > > Current code is causing a failure in adding a set containing=20
> > > a really long list of elements. The failure occurs as soon as=20
> > > the line is longer than flex read buffer.=20
> > >=20
> > > When a line is longer than scanner buffer size, the code in YY_IN=
PUT=20
> > > forces a rewind to the beginning of the string because it does no=
t=20
> > > find a end of line. The result is that the string is never parsed=
=2E=20
> > >=20
> > > This patch updates the code by rewinding till we found a space.=20
> >
> > But the part that didn't fit in will be ignore, right? So the user=20
> > will lose some elements in the set?=20
>=20
> This is not the case as there is a fseek below to rewind at the corre=
ct position. So next read get the data from the correct point.

OK. Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
