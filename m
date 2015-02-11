From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [libnftnl PATCH] rule: don't release the tree parameter in the
 function nft_jansson_parse_rule
Date: Wed, 11 Feb 2015 21:44:57 +0100
Message-ID: <54DBBF49.8050102@gmail.com>
References: <1423586774-20383-1-git-send-email-alvaroneay@gmail.com> <20150210234934.GB4547@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56631 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbBKUoj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 15:44:39 -0500
Received: by mail-wg0-f49.google.com with SMTP id l18so5971255wgh.8
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2015 12:44:38 -0800 (PST)
In-Reply-To: <20150210234934.GB4547@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 11/02/15 a las 00:49, Pablo Neira Ayuso escribi=F3:
> On Tue, Feb 10, 2015 at 05:46:13PM +0100, Alvaro Neira Ayuso wrote:
>> The function nft_jansson_parse_rule receives the tree like parameter=
 and we
>> release it inside the functions. We use this function in the ruleset=
 import
>> support. Therefore, we release the child nodes in the tree that  con=
tains the
>> rule information before to release the tree. Then, if we import a ru=
leset,
>> valgrind shows:
>>
>> =3D=3D16551=3D=3D Invalid write of size 8
>> =3D=3D16551=3D=3D    at 0x5EC92AA: json_delete (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC4FC4: ??? (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC5058: ??? (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC9270: json_delete (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC92B4: json_delete (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC4FC4: ??? (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC5058: ??? (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x5EC9270: json_delete (in
>> /usr/lib/x86_64-linux-gnu/libjansson.so.4.3.1)
>> =3D=3D16551=3D=3D    by 0x50455D0: nft_ruleset_json_parse (ruleset.c=
:557)
>> =3D=3D16551=3D=3D    by 0x50458AE: nft_ruleset_do_parse (ruleset.c:6=
96)
>> =3D=3D16551=3D=3D    by 0x408AEC: do_command (rule.c:1317)
>> =3D=3D16551=3D=3D    by 0x406B05: nft_run (main.c:194)
>>
>> With this patch, we release the tree only in the function nft_rule_j=
son_parse
>> (the caller function of nft_jansson_parse_rule).
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>>   src/rule.c |    8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/src/rule.c b/src/rule.c
>> index 7f4d049..028dc2e 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -597,10 +597,8 @@ int nft_jansson_parse_rule(struct nft_rule *r, =
json_t *tree,
>>   		nft_rule_add_expr(r, e);
>>   	}
>>
>> -	nft_jansson_free_root(tree);
>>   	return 0;
>>   err:
>> -	nft_jansson_free_root(tree);
>>   	return -1;
>>   }
>>   #endif
>> @@ -613,12 +611,16 @@ static int nft_rule_json_parse(struct nft_rule=
 *r, const void *json,
>>   #ifdef JSON_PARSING
>>   	json_t *tree;
>>   	json_error_t error;
>> +	int ret;
>>
>>   	tree =3D nft_jansson_create_root(json, &error, err, input);
>>   	if (tree =3D=3D NULL)
>>   		return -1;
>>
>> -	return nft_jansson_parse_rule(r, tree, err, set_list);
>> +	ret =3D nft_jansson_parse_rule(r, tree, err, set_list);
>> +
>> +	nft_jansson_free_root(tree);
>
> I like this cleanup.
>
> It's a good idea to release things from the same function where you
> allocate for tracebility and readability reasons.
>
> But I don't understand why this is fixing the valgrind spot that you
> indicate above.
>

Sure, maybe the description is confused. The goal of this patch is a=20
cleanup because I release a tree that we receive from the parameter. An=
d=20
this is not clear. It's better release the tree where we create it.

Moreover, I remember that the node json_t in Jansson has a reference=20
counter. Info from Jansson website=20
(https://jansson.readthedocs.org/en/2.2/apiref.html):

json_t

This data structure is used throughout the library to represent all JSO=
N=20
values. It always contains the type of the JSON value it holds and the=20
value=92s reference count.

I have to take a look the code of Jansson. But to release a tree, we=20
decrease this reference counter (using the function json_decref) and=20
later delete it.

Maybe I'm wrong, Pablo. But if we release the tree in the function=20
nft_jansson_parse_rule, we will say that this node are unused.=20
Therefore, when we decrease the reference counter of the tree in=20
nft_ruleset_parse, we try to decrease the reference counter for nodes=20
that is already decreased. And Valgrind shows that we're trying to do a=
=20
invalid write because we try to write in nodes that they are not availa=
ble.

This patch removes this error.

In short, you're right. It's confused, add the Valgrind output in this=20
description. I'm going to rework the description and send you another=20
patch like a cleanup. Sorry for the noise.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
