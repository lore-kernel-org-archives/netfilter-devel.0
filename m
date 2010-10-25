From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Mon, 25 Oct 2010 17:39:08 +0200
Message-ID: <4CC5A49C.1040405@trash.net>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com> <1287998810.2826.46.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48148 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0JYPjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:39:12 -0400
In-Reply-To: <1287998810.2826.46.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 25.10.2010 11:26, schrieb Eric Dumazet:
> Le dimanche 24 octobre 2010 =C3=A0 11:40 +0800, Changli Gao a =C3=A9c=
rit :
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ---
>>  net/netfilter/xt_NFQUEUE.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
>> index 039cce1..3962770 100644
>> --- a/net/netfilter/xt_NFQUEUE.c
>> +++ b/net/netfilter/xt_NFQUEUE.c
>> @@ -72,10 +72,12 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct =
xt_action_param *par)
>> =20
>>  	if (info->queues_total > 1) {
>>  		if (par->family =3D=3D NFPROTO_IPV4)
>> -			queue =3D hash_v4(skb) % info->queues_total + queue;
>> +			queue =3D (((u64) hash_v4(skb) * info->queues_total) >>
>> +				 32) + queue;
>>  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABL=
ES_MODULE)
>>  		else if (par->family =3D=3D NFPROTO_IPV6)
>> -			queue =3D hash_v6(skb) % info->queues_total + queue;
>> +			queue =3D (((u64) hash_v6(skb) * info->queues_total) >>
>> +				 32) + queue;
>>  #endif
>>  	}
>>  	return NF_QUEUE_NR(queue);
>=20
>=20
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

This looks fine to me, however I'm currently only taking bugfixes.
Please resend once net-next opens up for new patches again.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
