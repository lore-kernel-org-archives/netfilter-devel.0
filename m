From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: delete table via table handle
Date: Sun, 7 Jan 2018 18:56:01 +0100
Message-ID: <20180107175601.s6t3cporc5gpmip4@salvia>
References: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
 <20180106230245.ipgffikudoff3hus@salvia>
 <CANMOCy3LC4K+heV78Cj_WLKJwdy8rM4r074UHcdw3Jdfya9KVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754313AbeAGR4G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 12:56:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5926BC0B20
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jan 2018 18:56:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4651BDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jan 2018 18:56:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CANMOCy3LC4K+heV78Cj_WLKJwdy8rM4r074UHcdw3Jdfya9KVQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 07, 2018 at 02:49:29PM +0530, Harsha Sharma wrote:
> On Sun, Jan 7, 2018 at 4:32 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Jan 07, 2018 at 12:00:15AM +0530, Harsha Sharma wrote:
> >> This patch add code to delete table via unique table handle.
> >>
> >> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> >> ---
> >>  net/netfilter/nf_tables_api.c | 99 ++++++++++++++++++++++++++++++++++++++++---
> >>  1 file changed, 92 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> >> index dabdd2ed66c8..3b1c879fdf61 100644
> >> --- a/net/netfilter/nf_tables_api.c
> >> +++ b/net/netfilter/nf_tables_api.c
> >> @@ -73,6 +73,24 @@ static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
> >>       return NULL;
> >>  }
> >>
> >> +static struct nft_af_info *nft_afinfo_lookup_byhandle(struct net *net,
> >> +                                                   u64 handle)
> >> +{
> >> +     struct nft_af_info *afi;
> >> +     struct nft_table *table;
> >> +     int table_handle_check_flag = 0;
> >> +
> >> +     list_for_each_entry(afi, &net->nft.af_info, list) {
> >> +             list_for_each_entry(table, &afi->tables, list) {
> >> +                     if (table->handle == handle)
> >> +                             table_handle_check_flag = 1;
> >
> > Use:
> >                                 return table;
> >
> > instead.
> 
> I have tried to do that but we need to have afi struct for flushing
> the tables so nft_afinfo_lookup_byhandle is required iirc.
> ctx.afi = afi;
> ctx.table = table;

If you need the afi structure, you can get the afi via the existing
nft_afinfo_lookup() function.

> >> +             }
> >> +             if (table_handle_check_flag)
> >> +                     return afi;
> >> +     }
> >> +     return NULL;
> >> +}
> >> +
> >>  static struct nft_af_info *
> >>  nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
> >>  {
> >> @@ -94,6 +112,27 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
> >>       return ERR_PTR(-EAFNOSUPPORT);
> >>  }
> >>
> >> +static struct nft_af_info *
> >> +nf_tables_afinfo_lookup_byhandle(struct net *net, u64 handle, bool autoload)
> >> +{
> >> +     struct nft_af_info *afi;
> >> +
> >> +     afi = nft_afinfo_lookup_byhandle(net, handle);
> >> +     if (afi != NULL)
> >> +             return afi;
> >> +#ifdef CONFIG_MODULES
> >> +     if (autoload) {
> >> +             nfnl_unlock(NFNL_SUBSYS_NFTABLES);
> >> +             request_module("nft-afinfo");
> >> +             nfnl_lock(NFNL_SUBSYS_NFTABLES);
> >> +             afi = nft_afinfo_lookup_byhandle(net, handle);
> >> +             if (afi != NULL)
> >> +                     return ERR_PTR(-EAGAIN);
> >> +     }
> >> +#endif
> >> +     return ERR_PTR(-EAFNOSUPPORT);
> >> +}
> >
> > I don't think you need this new nf_tables_afinfo_lookup_byhandle()
> > function. The handle parameter is never used. That will simplify your
> > patchset.
> 
> Using handle parameter in nft_afinfo_lookup_byhandle allows returning
> afi for which afi->family is same as family of table (which has to be
> deleted via table handle).
> For deleting table via table name, family is required (unless default
> ip family) nft delete table ip6 test-ip6, but as handle identifies
> each table uniquely, a check is required
> in nft_afinfo_lookup_byhandle for returning afi struct.
> So, this new func nf_tables_afinfo_lookup_byhandle is required for
> calling nft_afinfo_lookup_byhandle and otherwise returning error and
> also for checking CONFIG_MODULES.

Nope :), this is not required. You can just:

#1 Get afi structure via existing nft_afinfo_lookup() function.
#2 Call your new nf_tables_table_lookup_byhandle() function.

That will simplify this patch.
