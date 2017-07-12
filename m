From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named sets
Date: Wed, 12 Jul 2017 18:30:47 +0200
Message-ID: <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
References: <20170712123658.25363-1-phil@nwl.cc> <20170712123658.25363-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34398 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753250AbdGLQbK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 12:31:10 -0400
Received: by mail-it0-f66.google.com with SMTP id o202so2652597itc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 09:31:10 -0700 (PDT)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com. [209.85.214.53])
        by smtp.gmail.com with ESMTPSA id m30sm1401389iti.26.2017.07.12.09.31.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2017 09:31:09 -0700 (PDT)
Received: by mail-it0-f53.google.com with SMTP id m84so16531458ita.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2017 09:31:09 -0700 (PDT)
In-Reply-To: <20170712123658.25363-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Well, we can probably merge all the patches in this one.

On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
> When adding or removing ranges from named sets, the kernel sends
> separate netlink events for the lower and upper boundary of the range,
> so 'nft monitor' incorrectly treated them as separate elements.
>
> An intuitive approach to fix this is to cache the first element reported
> for sets with 'interval' flag set and use it to reconstruct the range
> when the second one is reported. Though this does not work for unclosed
> intervals: If a range's upper boundary aligns with the maximum value
> allowed for the given set datatype, an unclosed interval is created
> which consists of only the lower boundary. The kernel then reports this
> range as a single element (which does not have EXPR_F_INTERVAL_END flag
> set).
>
> This patch solves both cases: netlink_events_setelem_cb() caches the
> first reported element of a range. If the upper boundary is reported
> afterwards, the same function takes care of the reassembling and cache
> removal. If not, 'nft monitor' will eventually receive a NEWGEN message
> indicating the end of the transaction. To convert the cached lower
> boundary into an unclosed range element, a new callback
> netlink_events_setelem_newgen_cb() is introduced which after printing
> the element also clears the cache.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/netlink.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 68 insertions(+), 4 deletions(-)
>

Somme comments below.

> diff --git a/src/netlink.c b/src/netlink.c
> index 2e30622de4bb1..65c6f05a57649 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -2196,6 +2196,14 @@ out:
>         return MNL_CB_OK;
>  }
>
> +static struct {
> +       int type;
> +       uint32_t family;
> +       char *table;
> +       char *setname;
> +       struct set *set;
> +} setelem_cache;
> +

Most of this info is available in 'struct set'.
Why not using it? We have the set cached anyway, the event for the set
creation was reported before, and we surely cache it, in
netlink_events_cache_addset().
All following set elements belong to this already cached set. That's
why in my patch I simply added a new field to 'struct set'.

In fact, I used the 'dummyset' trick to avoid touching the cached set.
But reading again the code, it seems that in this very case we indeed
would like to modify the cached set.. to add our new elements.

>  }
>
> +static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
> +                                           int type,
> +                                           struct netlink_mon_handler *monh)
> +{
> +       if (!setelem_cache.set ||
> +           monh->format != NFTNL_OUTPUT_DEFAULT)
> +               return MNL_CB_OK;
> +
> +       interval_map_decompose(setelem_cache.set->init);
> +
> +       switch (setelem_cache.type) {
> +       case NFT_MSG_NEWSETELEM:
> +               printf("add ");
> +               break;
> +       case NFT_MSG_DELSETELEM:
> +               printf("delete ");
> +               break;
> +       default:
> +               goto out;
> +       }
> +       printf("element %s %s %s ", family2str(setelem_cache.family),
> +              setelem_cache.table, setelem_cache.setname);
> +       expr_print(setelem_cache.set->init, monh->ctx->octx);
> +       printf("\n");
> +
^^^

In this function you are somehow re-implementing what
netlink_events_setelem_cb() does, which
is the logic for printing.

Could this logic be merged into that function? My goal is to only
print from one code path.

> +
>  static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
>                                  struct netlink_mon_handler *monh)
>  {
> @@ -2914,6 +2976,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
>         case NFT_MSG_DELOBJ:
>                 ret = netlink_events_obj_cb(nlh, type, monh);
>                 break;
> +       case NFT_MSG_NEWGEN:
> +               ret = netlink_events_setelem_newgen_cb(nlh, type, monh);
>         }
>         fflush(stdout);
>

I'm almost sure that we should be doing the cache stuff in the routine
we start at netlink_events_cache_update(). My patch is lacking this
too.

My proposal, keep each thing in it's stage:

netlink_events_cb() <-- main event cb function
netlink_events_cache_update() <--- we do here all the stuff regarding
caching sets/elements
netlink_events_setelem_cb() <--- printing (or ignoring event, if required)
