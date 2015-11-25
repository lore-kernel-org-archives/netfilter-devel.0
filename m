From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: Add new function nf_ct_helper_init to
 init ct helper easily
Date: Wed, 25 Nov 2015 15:08:52 +0000
Message-ID: <20151125150851.GF18449@macbook.localdomain>
References: <BAY403-EAS869240A915D1543054A10395150@phx.gbl>
 <20151125130542.GA27382@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Feng Gao <gfree.wind@outlook.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:57926 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbbKYPIz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 10:08:55 -0500
Content-Disposition: inline
In-Reply-To: <20151125130542.GA27382@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 10, 2015 at 07:47:02AM +0800, Feng Gao wrote:
> > Hi Pablo,
> > 
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  include/net/netfilter/nf_conntrack_helper.h | 17 +++++-
> >  net/netfilter/nf_conntrack_ftp.c            | 51 ++++++++---------
> >  net/netfilter/nf_conntrack_helper.c         | 35 ++++++++++++
> >  net/netfilter/nf_conntrack_irc.c            | 16 ++----
> >  net/netfilter/nf_conntrack_sane.c           | 50 ++++++++--------
> >  net/netfilter/nf_conntrack_sip.c            | 89
> > +++++++++++++++++------------
> >  net/netfilter/nf_conntrack_tftp.c           | 47 +++++++--------
> >  7 files changed, 179 insertions(+), 126 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h
> > b/include/net/netfilter/nf_conntrack_helper.h
> > index 6cf614bc..0c49c78 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -58,7 +58,22 @@ struct nf_conntrack_helper
> > *__nf_conntrack_helper_find(const char *name,
> >  struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char
> > *name,
> >  							       u16 l3num,
> >  							       u8 protonum);
> 
> I wish I could say "Yes, applied" but I cannot :-(
> 
> Your MUA keeps mangling your emails, which basically result in
> unappliable patches.
> 
> I spent 15 minutes trying to fix this but I couldn't so I'm giving up.
> 
> Please, resolve this and resubmit. Sorry.

I also couldn't find this patch on the list, not sure why. Please make sure
you copy netfilter-devel.
