From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: delete table via table handle
Date: Sun, 7 Jan 2018 23:58:49 +0530
Message-ID: <CANMOCy2qZF9rhWmm3CWVtEa=atgNDbBGEVP5qHqku_y+_MbBmA@mail.gmail.com>
References: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
 <20180106230245.ipgffikudoff3hus@salvia> <CANMOCy3LC4K+heV78Cj_WLKJwdy8rM4r074UHcdw3Jdfya9KVQ@mail.gmail.com>
 <20180107175601.s6t3cporc5gpmip4@salvia> <CANMOCy1_Lf7PNyumYx1mVwnXOFbxovxj3vO50hRGOt=fkxJRcw@mail.gmail.com>
 <20180107181654.voznijwdgjmv6wa3@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:39752 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754215AbeAGS2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 13:28:50 -0500
Received: by mail-vk0-f65.google.com with SMTP id x64so6185041vkd.6
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jan 2018 10:28:50 -0800 (PST)
In-Reply-To: <20180107181654.voznijwdgjmv6wa3@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 7, 2018 at 11:46 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jan 07, 2018 at 11:40:47PM +0530, Harsha Sharma wrote:
>> On Sun, Jan 7, 2018 at 11:26 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Sun, Jan 07, 2018 at 02:49:29PM +0530, Harsha Sharma wrote:
>> >> On Sun, Jan 7, 2018 at 4:32 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> > On Sun, Jan 07, 2018 at 12:00:15AM +0530, Harsha Sharma wrote:
>> >> >> This patch add code to delete table via unique table handle.
>> >> >>
>> >> >> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
>> >> >> ---
>> >> >>  net/netfilter/nf_tables_api.c | 99 ++++++++++++++++++++++++++++++++++++++++---
>> >> >>  1 file changed, 92 insertions(+), 7 deletions(-)
>> >> >>
>> >> >> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> >> >> index dabdd2ed66c8..3b1c879fdf61 100644
>> >> >> --- a/net/netfilter/nf_tables_api.c
>> >> >> +++ b/net/netfilter/nf_tables_api.c
>> >> >> @@ -73,6 +73,24 @@ static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
>> >> >>       return NULL;
>> >> >>  }
>> >> >>
>> >> >> +static struct nft_af_info *nft_afinfo_lookup_byhandle(struct net *net,
>> >> >> +                                                   u64 handle)
>> >> >> +{
>> >> >> +     struct nft_af_info *afi;
>> >> >> +     struct nft_table *table;
>> >> >> +     int table_handle_check_flag = 0;
>> >> >> +
>> >> >> +     list_for_each_entry(afi, &net->nft.af_info, list) {
>> >> >> +             list_for_each_entry(table, &afi->tables, list) {
>> >> >> +                     if (table->handle == handle)
>> >> >> +                             table_handle_check_flag = 1;
>> >> >
>> >> > Use:
>> >> >                                 return table;
>> >> >
>> >> > instead.
>> >>
>> >> I have tried to do that but we need to have afi struct for flushing
>> >> the tables so nft_afinfo_lookup_byhandle is required iirc.
>> >> ctx.afi = afi;
>> >> ctx.table = table;
>> >
>> > If you need the afi structure, you can get the afi via the existing
>> > nft_afinfo_lookup() function.
>> >
>> >> >> +             }
>> >> >> +             if (table_handle_check_flag)
>> >> >> +                     return afi;
>> >> >> +     }
>> >> >> +     return NULL;
>> >> >> +}
>> >> >> +
>> >> >>  static struct nft_af_info *
>> >> >>  nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>> >> >>  {
>> >> >> @@ -94,6 +112,27 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
>> >> >>       return ERR_PTR(-EAFNOSUPPORT);
>> >> >>  }
>> >> >>
>> >> >> +static struct nft_af_info *
>> >> >> +nf_tables_afinfo_lookup_byhandle(struct net *net, u64 handle, bool autoload)
>> >> >> +{
>> >> >> +     struct nft_af_info *afi;
>> >> >> +
>> >> >> +     afi = nft_afinfo_lookup_byhandle(net, handle);
>> >> >> +     if (afi != NULL)
>> >> >> +             return afi;
>> >> >> +#ifdef CONFIG_MODULES
>> >> >> +     if (autoload) {
>> >> >> +             nfnl_unlock(NFNL_SUBSYS_NFTABLES);
>> >> >> +             request_module("nft-afinfo");
>> >> >> +             nfnl_lock(NFNL_SUBSYS_NFTABLES);
>> >> >> +             afi = nft_afinfo_lookup_byhandle(net, handle);
>> >> >> +             if (afi != NULL)
>> >> >> +                     return ERR_PTR(-EAGAIN);
>> >> >> +     }
>> >> >> +#endif
>> >> >> +     return ERR_PTR(-EAFNOSUPPORT);
>> >> >> +}
>> >> >
>> >> > I don't think you need this new nf_tables_afinfo_lookup_byhandle()
>> >> > function. The handle parameter is never used. That will simplify your
>> >> > patchset.
>> >>
>> >> Using handle parameter in nft_afinfo_lookup_byhandle allows returning
>> >> afi for which afi->family is same as family of table (which has to be
>> >> deleted via table handle).
>> >> For deleting table via table name, family is required (unless default
>> >> ip family) nft delete table ip6 test-ip6, but as handle identifies
>> >> each table uniquely, a check is required
>> >> in nft_afinfo_lookup_byhandle for returning afi struct.
>> >> So, this new func nf_tables_afinfo_lookup_byhandle is required for
>> >> calling nft_afinfo_lookup_byhandle and otherwise returning error and
>> >> also for checking CONFIG_MODULES.
>> >
>> > Nope :), this is not required. You can just:
>> >
>> > #1 Get afi structure via existing nft_afinfo_lookup() function.
>>
>> I have tried that but with that I'm not able to delete table families
>> other than ip.
>> With (e.g nft delete table handle 4 ), as no family is scpecified (it
>> doesn't even make sense to specify family with handle), family is
>> defaulted to 2 (for ip) and nft_afiinfo_lookup return afi with family
>> 2, and this function allows returning afi with family same as family
>> of table which has to be deleted via table handle.
>
> If you want to delete an ip6 table, you have to specify this from the
> command line, ie.
>
>         nft delete table ip6 handle 4
>                          ^^^

But if the handle uniquely identifies table, then we should be able to
delete the table via table handle only.
As there can be two tables with same name but different family, we
should specify family for deleting table via table name but as there
is no same handle for any two tables, we should we able to delete
table via table handle only.

> Then, family because NFPROTO_IPV6, which is what we pass to:
>
>         afi = nf_tables_afinfo_lookup(net, family, false);
>
> as the second parameter for this function.

Let me know which option seems better.
Thanks for your time :)

Regards,
Harsha Sharma
