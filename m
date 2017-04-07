From: Gargi Sharma <gs051095@gmail.com>
Subject: Re: [RFC v2] extensions: libxt_TOS: Add translation to nft
Date: Sat, 8 Apr 2017 00:29:40 +0530
Message-ID: <CAOCi2DHcxn19npm6U_=UwKooT_qgBSV9K7h_1er4OFLJ2G+VQQ@mail.gmail.com>
References: <1490727018-25703-1-git-send-email-gs051095@gmail.com> <20170406224324.GA1661@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: gsoc2013@lists.netfilter.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34162 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933390AbdDGTAL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 15:00:11 -0400
Received: by mail-io0-f194.google.com with SMTP id n76so8373551ioe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 12:00:11 -0700 (PDT)
In-Reply-To: <20170406224324.GA1661@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 7, 2017 at 4:13 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 29, 2017 at 12:20:18AM +0530, Gargi Sharma wrote:
>> Add translation for TOS to nftables. TOS is deprecated
>> ans DSCP is ued in place of it. The first 6 bits of
>> TOS specify the DSCP value.
>>
>> Examples:
>>
>> $ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
>> nft add rule ip mangle PREROUTING tcp dport 22 counter  ip6 dscp set 0x04
>
> Applied, but I had to mangle this patch.
>
> Coding style is not correct, for two reason, see below.
>
>> diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
>> index cef5876..f284d83 100644
>> --- a/extensions/libxt_TOS.c
>> +++ b/extensions/libxt_TOS.c
>> @@ -183,6 +183,30 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
>>       printf(" --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
>>  }
>>
>> +static int tos_xlate(struct xt_xlate *xl,
>> +                  const struct xt_xlate_tg_params *params)
>> +{
>> +     const struct ipt_tos_target_info *info =
>> +                     (struct ipt_tos_target_info *) params->target->data;
>> +
> ^^^
> No need for new line here.
>
>> +     __u8 dscp = (info->tos)>>2;
>
> Missing space here between declaration and code.
> You can just use uint8_t from stdint.h BTW.
> And the parens are not required, plus missing spaces:
>
>         __u8 dscp = info->tos >> 2;

In hindsight, I should have ran checkpatch before submitting this
patch. I forgot, and would not do this in future.

Thanks,
Gargi
