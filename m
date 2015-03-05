From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: check for overflow of rule
 dlen field
Date: Thu, 5 Mar 2015 18:11:50 +0100
Message-ID: <20150305171150.GA7275@salvia>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-3-git-send-email-kaber@trash.net>
 <20150305163127.GA6878@salvia>
 <20150305163122.GW29092@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbbCERIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 12:08:09 -0500
Content-Disposition: inline
In-Reply-To: <20150305163122.GW29092@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 05, 2015 at 04:31:22PM +0000, Patrick McHardy wrote:
> On 05.03, Pablo Neira Ayuso wrote:
> > On Tue, Mar 03, 2015 at 08:04:19PM +0000, Patrick McHardy wrote:
> > > Check that the space required for the expressions doesn't exceed the
> > > size of the dlen field, which would lead to the iterators crashing.
> > > 
> > > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > > ---
> > >  net/netfilter/nf_tables_api.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 6fb532b..7baafd5 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -1968,6 +1968,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
> > >  			n++;
> > >  		}
> > >  	}
> > > +	/* Check for overflow of dlen field */
> > > +	err = -EFBIG;
> > 
> > Should we use -EOVERFLOW instead as we use in other nf_tables spots?
> > 
> > The error in userspace will be: "Value too large for defined data type".
> 
> I think the difference here is that we don't use a userspace provided
> value but overflow because of the size of kernel internal structures and
> the data type limit.

OK, we also have it when we pass too large amount of data for a
register IIRC.

> I don't have any strong feelings either way, but I think its different
> from the cases where we use EOVERFLOW so far.

I don't have any strong opinion, just asking. You know we shouldn't
change this afterwards.

Let me know.
