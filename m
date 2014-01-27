From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH RESEND v2 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 27 Jan 2014 08:35:38 -0700
Message-ID: <CANLsYkxaBuQz2-Bos+mE1YYXY9AbXX6HxLEGO9xgYGnKU9RXGA@mail.gmail.com>
References: <1390766673-21444-1-git-send-email-mathieu.poirier@linaro.org>
	<1390766673-21444-2-git-send-email-mathieu.poirier@linaro.org>
	<20140126230231.GA29022@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kaber <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61812 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaA0Pfj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:35:39 -0500
Received: by mail-vc0-f182.google.com with SMTP id id10so3473063vcb.41
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jan 2014 07:35:38 -0800 (PST)
In-Reply-To: <20140126230231.GA29022@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 January 2014 16:02, Florian Westphal <fw@strlen.de> wrote:
> mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> wrote:
>
> [ removed netfilter@ from CC ]
>
>> Adding packet and byte quota support.  Once a quota has been
>> reached a noticifaction is sent to user space that includes
>> the name of the accounting object along with the current byte
>> and packet count.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
>> index 3e19c8a..d38104f 100644
>> --- a/include/uapi/linux/netfilter/xt_nfacct.h
>> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
>> @@ -3,11 +3,25 @@
>>
>> +struct xt_nfacct_match_info_v1 {
>> +     char            name[NFACCT_NAME_MAX];
>> +     struct nf_acct  *nfacct;
>> +
>> +     __u32 flags;
>> +     __aligned_u64 quota;
>> +     struct nf_acct_quota    *priv;
>> +};
>
> I think that pointers should be aligned to 8-byte boundary, else
> this can cause issues with 32-bit-userspace-on-64-bit-kernel.

Something like  "struct nf_acct_quota    *priv __attribute__((aligned(8)));" ?

>
> It also should be flagged as "kernel only", e.g. via comment.
>
>> index b3be0ef..ff66792 100644
>> --- a/net/netfilter/xt_nfacct.c
>> +++ b/net/netfilter/xt_nfacct.c
>> @@ -8,10 +8,14 @@
>>  #include <linux/netfilter/xt_nfacct.h>
>> +#include <linux/netfilter_ipv4/ipt_ULOG.h>
>
> ULOG is the ipv4-only predecessor of NFLOG target, why this include?

Good catch - it was from a previous idea.

>
>> +     nfacct = nfnl_acct_find_get(info->name);
>> +     if (nfacct == NULL) {
>> +             pr_info("xt_nfacct: invalid accounting object `%s'\n",
>> +                    info->name);
>> +             return -ENOENT;
>> +     }
>> +
>> +     info->nfacct = nfacct;
>> +
>> +     if ((info->flags & XT_NFACCT_QUOTA) && !info->priv) {
>> +             info->priv =  kmalloc(sizeof(struct nf_acct_quota), GFP_KERNEL);
>> +             if (info->priv == NULL)
>> +                     return -ENOMEM;
>
> I think this misses a _put of nfacct object.

Ok, let me think about this.

>
> Thanks for your patience.

Many many thanks for reviewing.
