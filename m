From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: delete table via table handle
Date: Mon, 8 Jan 2018 00:38:52 +0530
Message-ID: <CANMOCy3BBJcD3MaU2tXgp3iUZ_iRjBadU5aXRJOUZHZ5ps9w=w@mail.gmail.com>
References: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
 <20180106230245.ipgffikudoff3hus@salvia> <CANMOCy3LC4K+heV78Cj_WLKJwdy8rM4r074UHcdw3Jdfya9KVQ@mail.gmail.com>
 <20180107175601.s6t3cporc5gpmip4@salvia> <CANMOCy1_Lf7PNyumYx1mVwnXOFbxovxj3vO50hRGOt=fkxJRcw@mail.gmail.com>
 <20180107181654.voznijwdgjmv6wa3@salvia> <CANMOCy2qZF9rhWmm3CWVtEa=atgNDbBGEVP5qHqku_y+_MbBmA@mail.gmail.com>
 <20180107185106.pfig2wrw45zyocfd@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:33845 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754215AbeAGTIx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 14:08:53 -0500
Received: by mail-ua0-f196.google.com with SMTP id v22so5565425uaj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jan 2018 11:08:53 -0800 (PST)
In-Reply-To: <20180107185106.pfig2wrw45zyocfd@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 8, 2018 at 12:21 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jan 07, 2018 at 11:58:49PM +0530, Harsha Sharma wrote:
>> On Sun, Jan 7, 2018 at 11:46 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Sun, Jan 07, 2018 at 11:40:47PM +0530, Harsha Sharma wrote:
>> >> On Sun, Jan 7, 2018 at 11:26 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> > On Sun, Jan 07, 2018 at 02:49:29PM +0530, Harsha Sharma wrote:
>> >> >> On Sun, Jan 7, 2018 at 4:32 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> >> > On Sun, Jan 07, 2018 at 12:00:15AM +0530, Harsha Sharma wrote:
>> >> >> >> This patch add code to delete table via unique table handle.
>> >> >> >>
>> >> >> >> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
>> >> >> >> ---
>> >> >> >>  net/netfilter/nf_tables_api.c | 99 ++++++++++++++++++++++++++++++++++++++++---
>> >> >> >>  1 file changed, 92 insertions(+), 7 deletions(-)
>> >> >> >>
>> >> >> >> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> >> >> >> index dabdd2ed66c8..3b1c879fdf61 100644
>> >> >> >> --- a/net/netfilter/nf_tables_api.c
>> >> >> >> +++ b/net/netfilter/nf_tables_api.c
>> >> >> >> @@ -73,6 +73,24 @@ static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
>> >> >> >>       return NULL;
>> >> >> >>  }
>> >> >> >>
>> >> >> >> +static struct nft_af_info *nft_afinfo_lookup_byhandle(struct net *net,
>> >> >> >> +                                                   u64 handle)
>> >> >> >> +{
>> >> >> >> +     struct nft_af_info *afi;
>> >> >> >> +     struct nft_table *table;
>> >> >> >> +     int table_handle_check_flag = 0;
>> >> >> >> +
>> >> >> >> +     list_for_each_entry(afi, &net->nft.af_info, list) {
>> >> >> >> +             list_for_each_entry(table, &afi->tables, list) {
>> >> >> >> +                     if (table->handle == handle)
>> >> >> >> +                             table_handle_check_flag = 1;
>> >> >> >
>> >> >> > Use:
>> >> >> >                                 return table;
>> >> >> >
>> >> >> > instead.
>> >> >>
>> >> >> I have tried to do that but we need to have afi struct for flushing
>> >> >> the tables so nft_afinfo_lookup_byhandle is required iirc.
>> >> >> ctx.afi = afi;
>> >> >> ctx.table = table;
>> >> >
>> >> > If you need the afi structure, you can get the afi via the existing
>> >> > nft_afinfo_lookup() function.
>> >> >
>> >> >> >> +             }
>> >> >> >> +             if (table_handle_check_flag)
>> >> >> >> +                     return afi;
>> >> >> >> +     }
>> >> >> >> +     return NULL;
>> >> >> >> +}
>> >> >> >> +
>> >> >> >>  static struct nft_af_info *
>> >> >> >>  nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>> >> >> >>  {
>> >> >> >> @@ -94,6 +112,27 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>> >> >> >>       return ERR_PTR(-EAFNOSUPPORT);
>> >> >> >>  }
>> >> >> >>
>> >> >> >> +static struct nft_af_info *
>> >> >> >> +nf_tables_afinfo_lookup_byhandle(struct net *net, u64 handle, bool autoload)
>> >> >> >> +{
>> >> >> >> +     struct nft_af_info *afi;
>> >> >> >> +
>> >> >> >> +     afi = nft_afinfo_lookup_byhandle(net, handle);
>> >> >> >> +     if (afi != NULL)
>> >> >> >> +             return afi;
>> >> >> >> +#ifdef CONFIG_MODULES
>> >> >> >> +     if (autoload) {
>> >> >> >> +             nfnl_unlock(NFNL_SUBSYS_NFTABLES);
>> >> >> >> +             request_module("nft-afinfo");
>> >> >> >> +             nfnl_lock(NFNL_SUBSYS_NFTABLES);
>> >> >> >> +             afi = nft_afinfo_lookup_byhandle(net, handle);
>> >> >> >> +             if (afi != NULL)
>> >> >> >> +                     return ERR_PTR(-EAGAIN);
>> >> >> >> +     }
>> >> >> >> +#endif
>> >> >> >> +     return ERR_PTR(-EAFNOSUPPORT);
>> >> >> >> +}
>> >> >> >
>> >> >> > I don't think you need this new nf_tables_afinfo_lookup_byhandle()
>> >> >> > function. The handle parameter is never used. That will simplify your
>> >> >> > patchset.
>> >> >>
>> >> >> Using handle parameter in nft_afinfo_lookup_byhandle allows returning
>> >> >> afi for which afi->family is same as family of table (which has to be
>> >> >> deleted via table handle).
>> >> >> For deleting table via table name, family is required (unless default
>> >> >> ip family) nft delete table ip6 test-ip6, but as handle identifies
>> >> >> each table uniquely, a check is required
>> >> >> in nft_afinfo_lookup_byhandle for returning afi struct.
>> >> >> So, this new func nf_tables_afinfo_lookup_byhandle is required for
>> >> >> calling nft_afinfo_lookup_byhandle and otherwise returning error and
>> >> >> also for checking CONFIG_MODULES.
>> >> >
>> >> > Nope :), this is not required. You can just:
>> >> >
>> >> > #1 Get afi structure via existing nft_afinfo_lookup() function.
>> >>
>> >> I have tried that but with that I'm not able to delete table families
>> >> other than ip.
>> >> With (e.g nft delete table handle 4 ), as no family is scpecified (it
>> >> doesn't even make sense to specify family with handle), family is
>> >> defaulted to 2 (for ip) and nft_afiinfo_lookup return afi with family
>> >> 2, and this function allows returning afi with family same as family
>> >> of table which has to be deleted via table handle.
>> >
>> > If you want to delete an ip6 table, you have to specify this from the
>> > command line, ie.
>> >
>> >         nft delete table ip6 handle 4
>> >                          ^^^
>>
>> But if the handle uniquely identifies table, then we should be able to
>> delete the table via table handle only.
>
> I see your point in that the handle number is already unique.
>
> However, we need to provide consistent behaviour with regards to what
> we already support via rule deletion:
>
>         nft delete rule ip handle 3
>         nft delete rule ip6 handle 4
>
> And there, family is always specified.
>
> Note that:
>
>         nft delete rule handle 3
>
> actually _implicitly_ means 'ip', so if we add this feature in the way
> you propose, we'll introduce an inconsistency given "no family
> specified" means "default to ip".
>
> Anyway, we can revisit this in the future, to allow to delete things
> only by handle, but this would be new feature. Let's keep this in mind
> for the future.
>
> At this stage, what I'm suggesting will simplify your patchset.

Yes,okay. I'll send a v2 for this.
Thanks for the quick review. :)

> Thanks!
