From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf-next 1/1] netfilter: nf_tables: Refine the codes to
 eliminate useless condition checks in nf_tables_api.c
Date: Thu, 12 Jan 2017 23:10:11 +0800
Message-ID: <CA+6hz4rCrD_d6+TdhNOTF4B0AGk8jJjF_NPbC=PgJN9ZQq77Hg@mail.gmail.com>
References: <1484098335-13300-1-git-send-email-fgao@ikuai8.com> <20170112112142.GA1666@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:52897 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbdALPKf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 10:10:35 -0500
Received: from mail-vk0-f42.google.com (unknown [209.85.213.42])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 23:10:12 +0800 (CST)
Received: by mail-vk0-f42.google.com with SMTP id r136so14218166vke.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 07:10:13 -0800 (PST)
In-Reply-To: <20170112112142.GA1666@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, Jan 12, 2017 at 7:21 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jan 11, 2017 at 09:32:15AM +0800, fgao@ikuai8.com wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> The return value of nf_tables_table_lookup is valid pointer or one
>> pointer error. There are two cases totally.
>> case1: IS_ERR(table) is true, it would return the error or reset the
>> table as NULL, it is unnecessary to perform the latter check
>> "table != NULL".
>> case2: IS_ERR(obj) is false, the table is one valid pointer. It is also
>> unnecessary to perform that check.
>> The nf_tables_newset and nf_tables_newobj have same logic codes.
>>
>> In summary, we could move the block of condition check "table != NULL"
>> in the else block to eliminate the original condition checks.
>>
>> Signed-off-by: Gao Feng <fgao@ikuai8.com>
>> ---
>>  net/netfilter/nf_tables_api.c | 12 +++---------
>>  1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index a019a87..3d7267f 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -697,9 +697,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>>               if (PTR_ERR(table) != -ENOENT)
>>                       return PTR_ERR(table);
>>               table = NULL;
>
> We follow up with table = NULL down the code, I think this breaks.

Look at the following nf_tables_table_lookup codes, it won't return NULL.
It returns one valid table pointer or one error.

static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
                                                const struct nlattr *nla,
                                                u8 genmask)
{
        struct nft_table *table;

        if (nla == NULL)
                return ERR_PTR(-EINVAL);

        table = nft_table_lookup(afi, nla, genmask);
        if (table != NULL)
                return table;

        return ERR_PTR(-ENOENT);
}

When returns one error, IS_ERR(table) is true, it then returns error
or reset table as NULL.
Wehn returns a valid table pointer, IS_ERR(table) is false, we could
perform the latter codes like "if (nlh->nlmsg_flags & NLM_F_EXCL)"
directly.

Regards
Feng

>
>> -     }
>> -
>> -     if (table != NULL) {
>> +     } else {
>>               if (nlh->nlmsg_flags & NLM_F_EXCL)
>>                       return -EEXIST;
>>               if (nlh->nlmsg_flags & NLM_F_REPLACE)


