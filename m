From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Fri, 3 Aug 2012 13:24:49 +0200
Message-ID: <20120803112449.GA19641@1984>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
 <1343856436-11129-6-git-send-email-eric@regit.org>
 <20120803093533.GE12107@1984>
 <1343987038.3284.6.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2HCLYz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:24:55 -0400
Content-Disposition: inline
In-Reply-To: <1343987038.3284.6.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 03, 2012 at 11:43:58AM +0200, Eric Leblond wrote:
> Hello,
>=20
> Le vendredi 03 ao=FBt 2012 =E0 11:35 +0200, Pablo Neira Ayuso a =E9cr=
it :
> > On Wed, Aug 01, 2012 at 11:27:16PM +0200, Eric Leblond wrote:
> > > This patch adds a timestamp option to the nfacct plugin.
> > > If activated, nfacct output a timestamp which is computed just
> > > after sending the nfacct request.
> >=20
> > I think it makes sense to make it unconditionally.
> >=20
> > The dump of the counters without the time doesn't make too much sen=
se
> > to me?
> >=20
> > Let me know.
>=20
> I think it was not originally added because some output format did no=
t
> need it.

I guess you refer to GPRINT.

> Maybe we can make output of a timestamp by default and let
> people who want to spare the cycles of gettimeofday() set it to 0.

Hm, that means that we'll have two gettimeofday in case that GPRINT is
used (specifically if people configure this wrong, ie. setting on
timestamp both in GPRINT and NFACCT, that's likely to happen IMO).

I'm still undecided, but it seems to me we provide more fine-grain
control if timestamp is calculated in the output for the nfacct case.

I think we have to agree where to calculate the timestamp (input or
output plugins?) for consistency, or at least agreed on some policy
for this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
