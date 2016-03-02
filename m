From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Wed, 2 Mar 2016 19:17:36 +0530
Message-ID: <CAKHNQQFDEQ2Wp_rV4TG2OgdayuFJmORdaBhzyAx7VghvjNiBcg@mail.gmail.com>
References: <20160301215243.GA19576@gmail.com> <20160302114928.GB3493@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37581 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbcCBNsR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 08:48:17 -0500
Received: by mail-wm0-f49.google.com with SMTP id p65so78635190wmp.0
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 05:48:17 -0800 (PST)
In-Reply-To: <20160302114928.GB3493@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 2, 2016 at 5:19 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 02, 2016 at 03:22:43AM +0530, Shivani Bhardwaj wrote:
>> Add translation for module hop-by-hop to nftables.
>> Full translation of this match awaits the support for --hbh-opts option.
>>
>> Examples:
>>
>> $ sudo ip6tables-translate -A INPUT -m hbh --hbh-len 33
>> nft add rule ip6 filter INPUT hbh hdrlength 33 counter
>>
>> $ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 33
>> nft add rule ip6 filter INPUT hbh hdrlength != 33 counter
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  extensions/libip6t_hbh.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
>> index c0389ed..f968036 100644
>> --- a/extensions/libip6t_hbh.c
>> +++ b/extensions/libip6t_hbh.c
>> @@ -164,6 +164,22 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
>>       print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
>>  }
>>
>> +static int hbh_xlate(const struct xt_entry_match *match,
>> +                  struct xt_xlate *xl, int numeric)
>> +{
>> +     const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
>> +
>> +     xt_xlate_add(xl, "hbh ");
>> +
>> +     if (optinfo->flags & IP6T_OPTS_LEN) {
>
> If no header length is passed, then this will print:
>
> nft add rule ip6 filter INPUT hbh counter
>

What should be the rule generated in case none of the options is mentioned?

# iptables-translate -A INPUT -m hbh
?

> which will not work.
