From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Mon, 1 Feb 2016 18:56:25 +0100
Message-ID: <20160201175625.GA2421@salvia>
References: <20160201110423.GH8095@salvia>
 <1454329022.4393.1@x201s.roaming.asbjorn.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48165 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbcBAR43 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 12:56:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A2A286C21
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:56:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92D89DA862
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:56:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B0B7DA801
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:56:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454329022.4393.1@x201s.roaming.asbjorn.biz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 12:17:02PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Hi Pablo,
>=20
> On Mon, 1 Feb 2016 12:04:23 +0100, Pablo Neira Ayuso <pablo@netfilter=
=2Eorg> wrote:
> > On Mon, Jan 25, 2016 at 11:15:47AM +0000, Asbj=F8rn Sloth T=F8nnese=
n wrote:
> > > This patch extends --mask-src and --mask-dst to also work
> > > with the conntrack table, with commands -L, -D, -E and -U.
> > >=20
> > > Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> > > ---
> > >=20
> > > Notes:
> > >     This is almost completely backward compatible,
> > >     since the --mask-* arguments previously gave
> > >     an error is used with these commands and the
> > >     conntrack table.
> > >    =20
> > >     I have changed the global_family to filter_family,
> > >     and it is only used to pass the family to the callback,
> > >     the alternative would be to change the data argument of
> > >     the callbacks to a struct.
> >=20
> > I see changes with regards to previous patchset, not we don't use
> > cidr. I think this is better since it allows a more compact way.
> >=20
> > I prefer the cidr-based approach, any reason to drop it?
>=20
> I decided to split them up in several patchsets, each having its
> own merits. The netmask and CIDR patches are related, but one is abou=
t
> filtering, and the other about adding some sugar to the option parsin=
g.

But we don't get anything with this extra option since it's basically
equivalent to the cidr based filtering, right?

> BTW: I mistakenly also marked the test patch v2, but this only is
> the only one in this patchset from the old one.

No problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
