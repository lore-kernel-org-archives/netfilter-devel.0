From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] src: buffer is not null terminated
Date: Mon, 9 Oct 2017 00:58:12 +0530
Message-ID: <CANMOCy1X_FBbSEkJmqkwDZZ5KAvdhXEAH6kuzuuJ-1tdTDm5Lw@mail.gmail.com>
References: <20171008185825.21202-1-harshasharmaiitr@gmail.com> <alpine.DEB.2.20.1710082104010.2160@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33486 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753553AbdJHT2N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2017 15:28:13 -0400
Received: by mail-ua0-f193.google.com with SMTP id 103so5149838uas.0
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Oct 2017 12:28:13 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.20.1710082104010.2160@hadrien>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 9, 2017 at 12:36 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> The subject line is not very clear.  Apparently, some buffer (which one?)
> is not null terminated (but what will you do about it?).  It would be
> better to say what is done inthe subject line, eg Use snprintf rather than
> strncpy, and then as you already do explain why the change is desirable in
> the commit log.  Then one is somehow better oriented to what is going on.
>

Hi,
Thanks for your feedback.
I have sent another version for the patch.
Thanks for your time :)

Regards,
Harsha Sharma

> julia
>
> On Mon, 9 Oct 2017, Harsha Sharma wrote:
>
>> Use snprintf() over strncpy() functions as the buffer is not null
>> terminated in strncpy().
>>
>> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
>> ---
>>  src/datatype.c | 2 +-
>>  src/iface.c    | 4 ++--
>>  src/netlink.c  | 4 ++--
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/src/datatype.c b/src/datatype.c
>> index 94b1224..9439ea3 100644
>> --- a/src/datatype.c
>> +++ b/src/datatype.c
>> @@ -858,7 +858,7 @@ static uint32_t str2int(char *tmp, const char *c, int k)
>>       if (k == 0)
>>               return 0;
>>
>> -     strncpy(tmp, c-k, k+1);
>> +     snprintf(tmp, k+1, "%s", c-k);
>>       return atoi(tmp);
>>  }
>>
>> diff --git a/src/iface.c b/src/iface.c
>> index 9936388..d0e1834 100644
>> --- a/src/iface.c
>> +++ b/src/iface.c
>> @@ -53,7 +53,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
>>       iface = xmalloc(sizeof(struct iface));
>>       iface->ifindex = ifm->ifi_index;
>>       mnl_attr_parse(nlh, sizeof(*ifm), data_attr_cb, tb);
>> -     strncpy(iface->name, mnl_attr_get_str(tb[IFLA_IFNAME]), IFNAMSIZ);
>> +     snprintf(iface->name, IFNAMSIZ, "%s", mnl_attr_get_str(tb[IFLA_IFNAME]));
>>       list_add(&iface->list, &iface_list);
>>
>>       return MNL_CB_OK;
>> @@ -139,7 +139,7 @@ char *nft_if_indextoname(unsigned int ifindex, char *name)
>>
>>       list_for_each_entry(iface, &iface_list, list) {
>>               if (iface->ifindex == ifindex) {
>> -                     strncpy(name, iface->name, IFNAMSIZ);
>> +                     snprintf(name, IFNAMSIZ, "%s", iface->name);
>>                       return name;
>>               }
>>       }
>> diff --git a/src/netlink.c b/src/netlink.c
>> index d5d410a..f69a5b9 100644
>> --- a/src/netlink.c
>> +++ b/src/netlink.c
>> @@ -386,7 +386,7 @@ static void netlink_gen_verdict(const struct expr *expr,
>>       switch (expr->verdict) {
>>       case NFT_JUMP:
>>       case NFT_GOTO:
>> -             strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
>> +             snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", expr->chain);
>>               data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
>>               break;
>>       }
>> @@ -2915,7 +2915,7 @@ static int netlink_events_newgen_cb(const struct nlmsghdr *nlh, int type,
>>               case NFTA_GEN_PROC_NAME:
>>                       if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
>>                               break;
>> -                     strncpy(name, mnl_attr_get_str(attr), sizeof(name));
>> +                     snprintf(name, sizeof(name), "%s", mnl_attr_get_str(attr));
>>                       break;
>>               case NFTA_GEN_PROC_ID:
>>                       if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
>> --
>> 2.11.0
>>
>> --
>> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
>> To post to this group, send email to outreachy-kernel@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20171008185825.21202-1-harshasharmaiitr%40gmail.com.
>> For more options, visit https://groups.google.com/d/optout.
>>
