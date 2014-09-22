From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables 1/3] netfilter: nf_tables: store and dump sets
 mechanism options
Date: Mon, 22 Sep 2014 12:01:02 +0200
Message-ID: <CAOkSjBjFUm=yB+JkznJU8cVEYJJaGUHVrhnSXB=Ogpr_Fr8mtA@mail.gmail.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com> <20140920113919.GA5825@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:40664 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaIVKBZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:01:25 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so6418437lam.14
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Sep 2014 03:01:23 -0700 (PDT)
In-Reply-To: <20140920113919.GA5825@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 September 2014 13:39, Patrick McHardy <kaber@trash.net> wrote:
> On Thu, Sep 18, 2014 at 08:18:18PM +0200, Arturo Borrero Gonzalez wro=
te:
>> --- a/include/net/netfilter/nf_tables.h
>> +++ b/include/net/netfilter/nf_tables.h
>> @@ -231,6 +231,14 @@ struct nft_set_ops {
>>  int nft_register_set(struct nft_set_ops *ops);
>>  void nft_unregister_set(struct nft_set_ops *ops);
>>
>> +/* internal flags to know which attributes were originally set
>> + * from userspace.
>> + */
>> +enum nft_set_attr {
>> +     NFT_SET_ATTR_POLICY     =3D 0x1,
>> +     NFT_SET_ATTR_DESC_SIZE  =3D 0x2,
>> +};
>
> We don't need the size, any value !=3D 0 is set by userspace. I'm uns=
ure
> about the policy, we don't really *need* to dump if it is the default=
,
> and otherwise its obvious that it originated from userspace.
>
>> @@ -241,6 +249,8 @@ void nft_unregister_set(struct nft_set_ops *ops)=
;
>>   *   @dtype: data type (verdict or numeric type defined by userspac=
e)
>>   *   @size: maximum set size
>>   *   @nelems: number of elements
>> + *   @attr_flags: (enum nft_set_flags)
>> + *   @policy: (enum nft_set_policies)
>>   *   @ops: set ops
>>   *   @flags: set flags
>>   *   @klen: key length
>> @@ -255,6 +265,8 @@ struct nft_set {
>>       u32                             dtype;
>>       u32                             size;
>>       u32                             nelems;
>> +     u16                             attr_flags;
>> +     u32                             policy;
>
> These are way to big and introduce holes in the structure.
>
>>       /* runtime data below here */
>>       const struct nft_set_ops        *ops ____cacheline_aligned;
>>       u16                             flags;
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables=
_api.c
>> index 8237460..d1c3f3e 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -2342,13 +2342,24 @@ static int nf_tables_fill_set(struct sk_buff=
 *skb, const struct nft_ctx *ctx,
>>                       goto nla_put_failure;
>>       }
>>
>> -     desc =3D nla_nest_start(skb, NFTA_SET_DESC);
>> -     if (desc =3D=3D NULL)
>> -             goto nla_put_failure;
>> -     if (set->size &&
>> -         nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
>> -             goto nla_put_failure;
>> -     nla_nest_end(skb, desc);
>> +     /* dump policy and desc info only if they were explicitly set =
*/
>> +     if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY)) {
>> +             if (nla_put_be32(skb, NFTA_SET_POLICY, htonl(set->poli=
cy)))
>> +                     goto nla_put_failure;
>> +     }
>> +
>> +     if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
>> +             desc =3D nla_nest_start(skb, NFTA_SET_DESC);
>> +             if (desc =3D=3D NULL)
>> +                     goto nla_put_failure;
>> +
>> +             if (set->size &&
>> +                 nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->s=
ize))) {
>> +                     goto nla_put_failure;
>> +             }
>> +
>> +             nla_nest_end(skb, desc);
>> +     }
>
> As mentioned earlier, dumping the parameters is not necessary for set=
s
> with NFT_SET_CONSTANT as they have been determined automatically.


Ok Patrick, so I understand we can drop this patch.
I can patch the fill_set() function to simply dump the policy if
policy !=3D PERFORMANCE (the default).

How many bits should I use to store the policy?

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
