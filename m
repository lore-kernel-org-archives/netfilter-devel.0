From: Joe Stringer <joestringer@nicira.com>
Subject: Re: [PATCH nf-next] netfilter: connlabels: Export setting connlabel length
Date: Mon, 3 Aug 2015 10:58:40 -0700
Message-ID: <CANr6G5wDbCU94YVOz7hCbjSvz9v1cFHtLqrc7g4qyEC2tu3rKw@mail.gmail.com>
References: <1438386624-52057-1-git-send-email-joestringer@nicira.com> <20150801004034.GC20471@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33612 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbHCR7A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Aug 2015 13:59:00 -0400
Received: by ykoo205 with SMTP id o205so26986304yko.0
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Aug 2015 10:59:00 -0700 (PDT)
In-Reply-To: <20150801004034.GC20471@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 July 2015 at 17:40, Florian Westphal <fw@strlen.de> wrote:
> Joe Stringer <joestringer@nicira.com> wrote:
>> diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
>> index bb53f12..00df4e71 100644
>> --- a/net/netfilter/nf_conntrack_labels.c
>> +++ b/net/netfilter/nf_conntrack_labels.c
>> @@ -91,6 +91,30 @@ int nf_connlabels_replace(struct nf_conn *ct,
>>  EXPORT_SYMBOL_GPL(nf_connlabels_replace);
>>  #endif
>>
>> +int nf_connlabels_get(struct net *net, unsigned int n_bits)
>> +{
>> +     size_t words;
>> +
>> +     if (n_bits > XT_CONNLABEL_MAXBIT + 1)
>
> Perhaps use
>
>   if (n_bits >= (NF_CT_LABELS_MAX_SIZE * BITS_PER_BYTE)))
>
> To avoid the XT_CONNLABEL_MAXBIT in the nf_* part.
>
>> +             return -ERANGE;
>> +
>> +     net->ct.labels_used++;
>> +     words = BITS_TO_LONGS(n_bits);
>> +     if (words > net->ct.label_words)
>> +             net->ct.label_words = words;
>> +
>> +     return 0;
>> +}
>
> I think we should add a lock here, currently this is protected by the
> xtables mutex -- I'd suggest to just add a spinlock for this.
>
>>               return ret;
>>       }
>>
>> -     par->net->ct.labels_used++;
>> -     words = BITS_TO_LONGS(info->bit+1);
>> -     if (words > par->net->ct.label_words)
>> -             par->net->ct.label_words = words;
>> -
>> -     return ret;
>> +     return nf_connlabels_get(par->net, info->bit + 1);
>
> This can leak the refcnt on l3_proto_module we obtained earlier.
>
> Other than that, this looks good.
>
> Thanks,
> Florian

Thanks for the review, I'll fix these up and send a v2 soon.
