From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [HEADS UP] Migrating ebtables and arptables to netfilter.org
Date: Thu, 29 May 2014 11:00:32 +0200
Message-ID: <20140529090032.GA14999@localhost>
References: <20140527083359.GA4342@localhost>
 <CAHo-OoxDb6rREH1kZNKSGWzVL6pwwuzgEgYbHWA-NAUX9fRJqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	bridge@lists.linux-foundation.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55948 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021AbaE2JAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 05:00:39 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OoxDb6rREH1kZNKSGWzVL6pwwuzgEgYbHWA-NAUX9fRJqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 29, 2014 at 01:37:43AM -0700, Maciej =C5=BBenczykowski wrot=
e:
> Missing tags if there were any previously.

It seems there is no tags, according to what I see in
ebtables.old-history which is a copy of the original tree.

BTW, please, stop top posting.

These are the mailing list rules:

http://www.netfilter.org/mailinglists.html#list-rules

Thank you.

> On Tue, May 27, 2014 at 1:33 AM, Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> > Hi!
> >
> > We're migrating arptables and ebtables to git.netfilter.org. The ne=
w
> > location for the repositories are:
> >
> > 1) arptables:
> >
> >         git://git.netfilter.org/arptables
> >         http://git.netfilter.org/arptables/
> >
> > 2) ebtables:
> >
> >         git://git.netfilter.org/ebtables
> >         http://git.netfilter.org/ebtables/
> >
> > Originally, these two applications were located in the same reposit=
ory
> > which has been kept at:
> >
> >         http://git.netfilter.org/ebtables.old-history/
> >
> > just for the record.
> >
> > I have git-filter-branch the original repository to separate the
> > ebtables and the arptables in two independent repositories.
> >
> > Let me know if you experience any problem in this migration,
> > Thanks.
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter=
-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
