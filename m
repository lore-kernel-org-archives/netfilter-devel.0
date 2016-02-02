From: =?iso-8859-1?q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Tue, 02 Feb 2016 15:55:53 +0000
Message-ID: <1454419553.4393.4@x201s.roaming.asbjorn.biz>
References: <20160201175625.GA2421@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-W5f3DgdCPI54c7r9tqVV"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:38843 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399AbcBBQAe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2016 11:00:34 -0500
In-Reply-To: <20160201175625.GA2421@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=-W5f3DgdCPI54c7r9tqVV
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

On Mon, 1 Feb 2016 18:56:25 +0100, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Feb 01, 2016 at 12:17:02PM +0000, Asbjørn Sloth Tønnesen wrote:
> > On Mon, 1 Feb 2016 12:04:23 +0100, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Mon, Jan 25, 2016 at 11:15:47AM +0000, Asbjørn Sloth Tønnesen wrote:
> > > > This patch extends --mask-src and --mask-dst to also work
> > > > with the conntrack table, with commands -L, -D, -E and -U.
> > > > 
> > > > Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.dk>
> > > > ---
> > > > 
> > > > Notes:
> > > >     This is almost completely backward compatible,
> > > >     since the --mask-* arguments previously gave
> > > >     an error is used with these commands and the
> > > >     conntrack table.
> > > >     
> > > >     I have changed the global_family to filter_family,
> > > >     and it is only used to pass the family to the callback,
> > > >     the alternative would be to change the data argument of
> > > >     the callbacks to a struct.
> > > 
> > > I see changes with regards to previous patchset, not we don't use
> > > cidr. I think this is better since it allows a more compact way.
> > > 
> > > I prefer the cidr-based approach, any reason to drop it?
> > 
> > I decided to split them up in several patchsets, each having its
> > own merits. The netmask and CIDR patches are related, but one is about
> > filtering, and the other about adding some sugar to the option parsing.
> 
> But we don't get anything with this extra option since it's basically
> equivalent to the cidr based filtering, right?

Except backwards compatability for the expectation table, on the other hand
--mask-* has been broken since August, but thats only v1.4.3 so properly not
long enough to just drop it.

Since the filtering internally uses a bitmask in ct.mask, then keeping the --mask-*
option for all cases is simpler, since it uses the same option flags.

Keeping them also makes it possible to inject funky bitmasks.


-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541

--=-W5f3DgdCPI54c7r9tqVV--
