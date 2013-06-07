From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v3] src: add _unset functions
Date: Fri, 7 Jun 2013 14:13:01 +0200
Message-ID: <CAOkSjBgogTrGwto9dcwBDGOWhZ00fH7_8w-ycON99tniCLK7fw@mail.gmail.com>
References: <20130607105104.17347.95207.stgit@nfdev.cica.es> <20130607120631.GA6657@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:53796 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3FGMNY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:13:24 -0400
Received: by mail-la0-f47.google.com with SMTP id fe20so3651803lab.34
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2013 05:13:22 -0700 (PDT)
In-Reply-To: <20130607120631.GA6657@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/6/7 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Fri, Jun 07, 2013 at 12:52:17PM +0200, Arturo Borrero wrote:
>> These functions unset the flag for the given attribute in each objec=
t and free data in some cases.
>
> Applied with minor changes, thanks Arturo.
>
> See below.
>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>> v2: improved unset operation and freed data pointer set to NULL
>> v3: set to null c->table
>>
>>  include/libnftables/chain.h |    1 +
>>  include/libnftables/rule.h  |    1 +
>>  include/libnftables/set.h   |    2 ++
>>  include/libnftables/table.h |    1 +
>>  src/chain.c                 |   26 ++++++++++++++++++++++++++
>>  src/libnftables.map         |    5 +++++
>>  src/rule.c                  |   23 +++++++++++++++++++++++
>>  src/set.c                   |   23 +++++++++++++++++++++++
>>  src/set_elem.c              |   13 +++++++++++++
>>  src/table.c                 |   15 ++++++++++++++-
>>  10 files changed, 109 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/libnftables/chain.h b/include/libnftables/chain=
=2Eh
>> index b12474f..f06f743 100644
>> --- a/include/libnftables/chain.h
>> +++ b/include/libnftables/chain.h
>> @@ -26,6 +26,7 @@ enum {
>>       NFT_CHAIN_ATTR_TYPE,
>>  };
>>
>> +void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr);
>>  void nft_chain_attr_set(struct nft_chain *t, uint16_t attr, const v=
oid *data);
>>  void nft_chain_attr_set_u32(struct nft_chain *t, uint16_t attr, uin=
t32_t data);
>>  void nft_chain_attr_set_s32(struct nft_chain *t, uint16_t attr, int=
32_t data);
>> diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
>> index 9c4ab0d..9989f19 100644
>> --- a/include/libnftables/rule.h
>> +++ b/include/libnftables/rule.h
>> @@ -23,6 +23,7 @@ enum {
>>       NFT_RULE_ATTR_COMPAT_FLAGS,
>>  };
>>
>> +void nft_rule_attr_unset(struct nft_rule *r, uint16_t attr);
>>  void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, const voi=
d *data);
>>  void nft_rule_attr_set_u32(struct nft_rule *r, uint16_t attr, uint3=
2_t val);
>>  void nft_rule_attr_set_u64(struct nft_rule *r, uint16_t attr, uint6=
4_t val);
>> diff --git a/include/libnftables/set.h b/include/libnftables/set.h
>> index 53c2947..211c065 100644
>> --- a/include/libnftables/set.h
>> +++ b/include/libnftables/set.h
>> @@ -16,6 +16,7 @@ struct nft_set;
>>  struct nft_set *nft_set_alloc(void);
>>  void nft_set_free(struct nft_set *s);
>>
>> +void nft_set_attr_unset(struct nft_set *s, uint16_t attr);
>>  void nft_set_attr_set(struct nft_set *s, uint16_t attr, const void =
*data);
>>  void nft_set_attr_set_u32(struct nft_set *s, uint16_t attr, uint32_=
t val);
>>  void nft_set_attr_set_str(struct nft_set *s, uint16_t attr, const c=
har *str);
>> @@ -61,6 +62,7 @@ void nft_set_elem_free(struct nft_set_elem *s);
>>
>>  void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)=
;
>>
>> +void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)=
;
>>  void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr, c=
onst void *data, size_t data_len);
>>  void nft_set_elem_attr_set_u32(struct nft_set_elem *s, uint16_t att=
r, uint32_t val);
>>  void nft_set_elem_attr_set_str(struct nft_set_elem *s, uint16_t att=
r, const char *str);
>> diff --git a/include/libnftables/table.h b/include/libnftables/table=
=2Eh
>> index 658230c..09cd204 100644
>> --- a/include/libnftables/table.h
>> +++ b/include/libnftables/table.h
>> @@ -18,6 +18,7 @@ enum {
>>       NFT_TABLE_ATTR_FLAGS,
>>  };
>>
>> +void nft_table_attr_unset(struct nft_table *t, uint16_t attr);
>>  void nft_table_attr_set(struct nft_table *t, uint16_t attr, const v=
oid *data);
>>  const void *nft_table_attr_get(struct nft_table *t, uint16_t attr);
>>
>> diff --git a/src/chain.c b/src/chain.c
>> index 093e3ea..2a1a7ce 100644
>> --- a/src/chain.c
>> +++ b/src/chain.c
>> @@ -59,6 +59,32 @@ void nft_chain_free(struct nft_chain *c)
>>  }
>>  EXPORT_SYMBOL(nft_chain_free);
>>
>> +void nft_chain_attr_unset(struct nft_chain *c, uint16_t attr)
>> +{
>> +     switch (attr) {
>> +     case NFT_CHAIN_ATTR_TABLE:
>> +             if (c->flags & (1 << NFT_CHAIN_ATTR_TABLE))
>> +                     if (c->table) {
>> +                             free(c->table);
>> +                             c->table =3D NULL;
>> +                     }
>> +             break;
>> +     case NFT_CHAIN_ATTR_USE:
>> +             /* cannot be unset?, ignore it */
>> +             return;
>> +     case NFT_CHAIN_ATTR_TYPE:
>> +             if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
>> +                     if (c->type) {
>> +                             free(c->type);
>> +                             c->type =3D NULL;
>> +                     }
>> +             break;
>
>         default:
>                 return;
>
> Added this just to skip for unknown attributes. It should not harm
> though the current code, but just to ensure we don't spend cycles on
> no operations.
>

mmmmm...
I think that if the attr is not selected in the switch, you will never =
reach:
c->flags &=3D ~(1 << attr);

Or am I wrong?

Regards

--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
