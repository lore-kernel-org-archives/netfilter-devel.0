From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [libnftnl PATCH 2/2] src/rule: Changed parser support for having
 consistent with the new print support
Date: Wed, 12 Mar 2014 12:37:16 +0100
Message-ID: <532046EC.1030904@gmail.com>
References: <20140309125959.23270.43422.stgit@Ph0enix> <20140309130005.23270.28970.stgit@Ph0enix> <CAOkSjBgLvyAxsnqx4CAuZziQaOj4ximZ2YAqd542HuEi-J9BCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58869 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaCLLha (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:37:30 -0400
Received: by mail-bk0-f51.google.com with SMTP id 6so1356343bkj.24
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2014 04:37:29 -0700 (PDT)
In-Reply-To: <CAOkSjBgLvyAxsnqx4CAuZziQaOj4ximZ2YAqd542HuEi-J9BCQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 11/03/14 21:16, Arturo Borrero Gonzalez escribi=F3:
> Hi Alvaro,
>
> a few coments below about this patch.
>
> On 9 March 2014 14:00, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrot=
e:
>> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>   src/rule.c |   77 +++++++++++++++++++++++++++++++-----------------=
------------
>>   1 file changed, 40 insertions(+), 37 deletions(-)
>>
>
> I would suggest to describe this parser change.
>
>> diff --git a/src/rule.c b/src/rule.c
>> index f0cafd3..e7335f8 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -540,28 +540,36 @@ int nft_jansson_parse_rule(struct nft_rule *r,=
 json_t *tree,
>>          if (root =3D=3D NULL)
>>                  return -1;
>>
>> -       if (nft_jansson_parse_family(root, &family, err) !=3D 0)
>> -               goto err;
>> +       if (nft_jansson_node_exist(root, "family")) {
>> +               if (nft_jansson_parse_family(root, &family, err) !=3D=
 0)
>> +                       goto err;
>>
>>          nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
>> +       }
>>
>
> Fix indentation. The nft_rule_attr_set_u32() is now inside the if sta=
tement.
>
>
>> -       if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uva=
l64,
>> -                                 err) < 0)
>> -               goto err;
>> +       if (nft_jansson_node_exist(root, "handle")) {
>> +               if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U=
64, &uval64,
>> +                                         err) < 0)
>
> Mixed tab/spaces indentation before 'err) < 0)'
>
>
>> @@ -640,39 +648,34 @@ int nft_mxml_rule_parse(mxml_node_t *tree, str=
uct nft_rule *r,
>>
>>          family =3D nft_mxml_family_parse(tree, "family", MXML_DESCE=
ND_FIRST,
>>                                         NFT_XML_MAND, err);
>> -       if (family < 0)
>> -               return -1;
>> -
>> -       r->family =3D family;
>> -       r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
>> +       if (family >=3D 0) {
>> +               r->family =3D family;
>> +               r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
>> +       }
>>
>
> I would suggest to, while at it, switch to nft_rule_attr_set_xx() fun=
ctions.
> IMHO, we will save some LOCs, among other benefits.

Yes, i have put this like that for following the same format that you=20
have had. The next time, i'm going to ask before :D. I'm going to chang=
e=20
that.

>
>> -       r->table =3D strdup(table);
>> -       r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
>> +               r->table =3D strdup(table);
>> +               r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
>> +       }
>
> Just for completeness:
> remember that for string attributes, the strdup() is done internally,
> inside nft_rule_attr_set_str().

I know that ^^.

>
>>          if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, =
BASE_DEC,
>> -                              &r->handle, NFT_TYPE_U64, NFT_XML_MAN=
D, err) !=3D 0)
>> -               return -1;
>> -
>> -       r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
>> +                              &r->handle, NFT_TYPE_U64, NFT_XML_MAN=
D, err) >=3D 0)
>
> The line above is 82 characters long.

Thanks Arturo for helping me. I'm going to fix all the stuff.

Regards

=C1lvaro

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
