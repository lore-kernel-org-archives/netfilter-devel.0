From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [libnftnl PATCH] mxml: test if the root node name is initialized
 before to compare it.
Date: Tue, 03 Mar 2015 14:45:34 +0100
Message-ID: <54F5BAFE.3070000@gmail.com>
References: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com> <20150302233504.GA5166@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44146 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbCCNpO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 08:45:14 -0500
Received: by wiwl15 with SMTP id l15so22816564wiw.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Mar 2015 05:45:13 -0800 (PST)
In-Reply-To: <20150302233504.GA5166@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 03/03/15 a las 00:35, Pablo Neira Ayuso escribi=F3:
> On Mon, Mar 02, 2015 at 08:58:38PM +0100, Alvaro Neira Ayuso wrote:
>> If the root node name is not correctly initialized, we have a crash.
>
> Under what circunstances may tree->value.opaque be NULL?

The function mxmlLoadFile doesn't work correctly. With my patch to=20
import ruleset in json and xml. I have seen that if we use a ruleset in=
=20
json and use the command nft import xml. The function mxmlLoadFile=20
returns a tree without any information inside. Therefore, when we try t=
o=20
verify that the name of the first node is the same of the parameter, we=
=20
have a crash.

We have two ways to solve it. Test if the node is NULL and:
  1- show an error that the node is not found.
  2- show an error that the input is not correctly.

I have thought that the best is the first. But I can change it.

>
>> ---
>>   src/mxml.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/mxml.c b/src/mxml.c
>> index 0001ba0..b68f86f 100644
>> --- a/src/mxml.c
>> +++ b/src/mxml.c
>> @@ -43,7 +43,8 @@ mxml_node_t *nft_mxml_build_tree(const void *data,=
 const char *treename,
>>   		goto err;
>>   	}
>>
>> -	if (strcmp(tree->value.opaque, treename) =3D=3D 0)
>> +	if (tree->value.opaque !=3D NULL &&
>> +	    strcmp(tree->value.opaque, treename) =3D=3D 0)
>>   		return tree;
>>
>>   	err->error =3D NFT_PARSE_EMISSINGNODE;
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
