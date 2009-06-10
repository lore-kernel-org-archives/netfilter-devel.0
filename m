From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 03:18:17 +0200
Message-ID: <4A2F09D9.7090507@gmail.com>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([212.99.114.194]:40914 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFJBSZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:18:25 -0400
In-Reply-To: <4A2EE907.70609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso a =E9crit :
> Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> Pablo Neira Ayuso wrote:
>>>> Hi Patrick,
>>>>
>>>> A couple of minor issues related to this patch.
>>>>
>>>> Patrick McHardy wrote:
>>>>>> +    hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnno=
de);
>>>>> Why is _rcu used? The lists are never used for a lookup.
>>>> There's no hlist_nulls_del() operation without rcu. I have a patch=
 here
>>>> to add hlist_nulls_add_head() and hlist_nulls_del() although I gue=
ss
>>>> that you are going to tell me that you cannot apply that patch? So=
,
>>>> where to go?
>>> Either way is fine I guess. Adding non _rcu function makes sense
>>> I think (Eric CCed to correct me :)). But there's also no harm
>>> in using the RCU functions as long as you add a comment stating
>>> that you don't in fact rely on the RCU properties to avoid confusin=
g
>>> people.
>> But to clarify: the non-RCU functions would be preferred :)
>=20
> OK :). Eric, could you tell what if this patch is OK? It's based on t=
he
> RCU version.
>=20
>=20

Sure, this patch is fine !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thank you
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
