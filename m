From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 4/4] monitor: Ignore ranges' zero segment
Date: Wed, 12 Jul 2017 21:11:45 +0200
Message-ID: <20170712191145.GE16375@orbyte.nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-5-phil@nwl.cc>
 <CAOkSjBg1gVW5yVwz3upSNi4KC9yqfUTMqeG1iZZ8iNMjUk6MeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59011 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbdGLTLr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 15:11:47 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBg1gVW5yVwz3upSNi4KC9yqfUTMqeG1iZZ8iNMjUk6MeA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 05:49:33PM +0200, Arturo Borrero Gonzalez wrote:
> On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
> > The internal representation of ranges in a set consists of segments
> > which either match or not. Each segment is identified by the lower
> > boundary and simply spans till the next segment. Upon insertion,
> > adjacent (matching) segments are joined into a single one, but only if
> > both are new. This means that the inverse operation, namely converting
> > segments back into ranges, may use the non-matching segments' lower
> > boundary as range end marker. But there is one catch: If the first range
> > doesn't start at zero, the first segment is a non-matching one. Code
> > indicates that by EXPR_F_INTERVAL_END flag. So when monitor sees a lower
> > boundary of zero with that flag set, it has to ignore it.
> >
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/netlink.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/src/netlink.c b/src/netlink.c
> > index 65c6f05a57649..8f9864129ea94 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -2214,6 +2214,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
> >         struct set *set;
> >         const char *setname, *table;
> >         uint32_t family;
> > +       struct expr *expr;
> >
> >         nls = netlink_setelem_alloc(nlh);
> >         table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
> > @@ -2267,6 +2268,13 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
> >                                 free(setelem_cache.table);
> >                                 free(setelem_cache.setname);
> >                         } else {
> > +                               expr = compound_expr_last(dummyset->init);
> > +
> > +                               if (!mpz_cmp_ui(expr->key->value, 0) &&
> > +                                   expr->flags & EXPR_F_INTERVAL_END) {
> > +                                       set_free(dummyset);
> > +                                       goto out;
> > +                               }
> 
> This seems mostly the same than in my patch, function
> netlink_event_ignore_range_event()
> What I liked about having a separate function is that the code is
> clear/explicit in what we are doing.

What I like in my version is that it doesn't extract the data from
nftnl_set again but reuses what netlink_delinearize_setelem has already
done. But indeed, putting the logic into a separate function is the
cleaner solution. I'll see what comes out with v2 of the other patch and
then have a look at this again.

Thanks, Phil
