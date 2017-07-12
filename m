From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named
 sets
Date: Wed, 12 Jul 2017 21:05:45 +0200
Message-ID: <20170712190545.GC16375@orbyte.nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-2-phil@nwl.cc>
 <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35453 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752772AbdGLTFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 15:05:47 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 06:30:47PM +0200, Arturo Borrero Gonzalez wrote:
> Well, we can probably merge all the patches in this one.
> 
> On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
[...]
> > diff --git a/src/netlink.c b/src/netlink.c
> > index 2e30622de4bb1..65c6f05a57649 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -2196,6 +2196,14 @@ out:
> >         return MNL_CB_OK;
> >  }
> >
> > +static struct {
> > +       int type;
> > +       uint32_t family;
> > +       char *table;
> > +       char *setname;
> > +       struct set *set;
> > +} setelem_cache;
> > +
> 
> Most of this info is available in 'struct set'.
> Why not using it? We have the set cached anyway, the event for the set
> creation was reported before, and we surely cache it, in
> netlink_events_cache_addset().

Oh, I overlooked it's handle field. That's indeed all I need!

> All following set elements belong to this already cached set. That's
> why in my patch I simply added a new field to 'struct set'.
> 
> In fact, I used the 'dummyset' trick to avoid touching the cached set.
> But reading again the code, it seems that in this very case we indeed
> would like to modify the cached set.. to add our new elements.

Hmm. For no obvious reason I ignored that cache_update function
altogether, and I think that was a mistake: At the time
netlink_events_setelem_cb() is called, the element is already present in
the cache. So we can just copy the last element in there (or the last
two for interval sets) to dummy set and run interval_map_decompose().

The only remaining bit then should be half-open ranges. To get that
sorted, I think we can get by with a pointer to the set we have
unfinished business with and deal with it upon NEWGEN message.

> > +static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
> > +                                           int type,
> > +                                           struct netlink_mon_handler *monh)
> > +{
> > +       if (!setelem_cache.set ||
> > +           monh->format != NFTNL_OUTPUT_DEFAULT)
> > +               return MNL_CB_OK;
> > +
> > +       interval_map_decompose(setelem_cache.set->init);
> > +
> > +       switch (setelem_cache.type) {
> > +       case NFT_MSG_NEWSETELEM:
> > +               printf("add ");
> > +               break;
> > +       case NFT_MSG_DELSETELEM:
> > +               printf("delete ");
> > +               break;
> > +       default:
> > +               goto out;
> > +       }
> > +       printf("element %s %s %s ", family2str(setelem_cache.family),
> > +              setelem_cache.table, setelem_cache.setname);
> > +       expr_print(setelem_cache.set->init, monh->ctx->octx);
> > +       printf("\n");
> > +
> ^^^
> 
> In this function you are somehow re-implementing what
> netlink_events_setelem_cb() does, which
> is the logic for printing.

Ah yes, that was copy'n'paste, sorry for not cleaning it up in
beforehand.

> Could this logic be merged into that function? My goal is to only
> print from one code path.

Yes, that makes sense. I found it too cumbersome to squeeze the
additional logic into netlink_events_setelem_cb(), hence why I went with
a separate function. I'll give it another try. In doubt I'll move the
printing logic into a separate function to be called from both places.

I'll prepare a v2 tomorrow, also merging the previous two patches as
suggested.

Thanks, Phil
