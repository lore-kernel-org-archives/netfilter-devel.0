From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_NFQUEUE: Add translation to nft
Date: Sun, 7 Feb 2016 20:41:57 +0530
Message-ID: <CAKHNQQGy8EDrMbPQb2Og_Dk8wf62GaeKq1zO+uz2UB6HbZ9hAQ@mail.gmail.com>
References: <20160207060721.GA11310@gmail.com> <20160207092504.GB32181@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33824 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbcBGPMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2016 10:12:38 -0500
Received: by mail-wm0-f67.google.com with SMTP id p63so11543743wmp.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Feb 2016 07:12:37 -0800 (PST)
In-Reply-To: <20160207092504.GB32181@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 7, 2016 at 2:55 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
>> nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30
>>
>> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
>> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass
>>
>> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
>> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout
>
> translation look correct, thanks!
>
>> +bool sep_need = false;
>
> Is this really needed?
> If it is, please add static keyword too.
>

Done. Please check the new version of this patch.

>> +static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
>> +                         struct xt_xlate *xl, int numeric)
>> +{
>> +     const struct xt_NFQ_info_v2 *info = (void *) target->data;
>> +
>> +     NFQUEUE_xlate_v1(target, xl, numeric);
>> +
>> +     if (info->bypass & NFQ_FLAG_BYPASS) {
>> +             xt_xlate_add(xl, "bypass");
>> +             sep_need = true;
>> +     }
>> +
>> +     return 1;
>> +}
>> +
>> +static int NFQUEUE_xlate_v3(const struct xt_entry_target *target,
>> +                         struct xt_xlate *xl, int numeric)
>> +{
>> +     const struct xt_NFQ_info_v3 *info = (void *)target->data;
>> +
>> +     NFQUEUE_xlate_v2(target, xl, numeric);
>> +     if (info->flags & NFQ_FLAG_CPU_FANOUT)
>> +             xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
>> +
>
> Seems this could be written similar to something like:
>
> if (info->flags & NFQ_FLAG_CPU_FANOUT) {
>         bool sep_needed = info->bypass & NFQ_FLAG_BYPASS;
>         xt_xlate_add(xl, "%sfanout ", sep_need ? "," : "");
> ...

The pointer info used in both the versions (of NFQUEUE_xlate) is for
different structures. Sadly, this doesn't work as v3 structure doesn't
have a member for bypass field.

Thanks a lot.
