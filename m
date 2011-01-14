From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: netfilter: nf_conntrack: use is_vmalloc_addr()
Date: Fri, 14 Jan 2011 15:46:44 +0100
Message-ID: <4D3061D4.2020705@trash.net>
References: <4D3052AA.40100@trash.net> <1295015623.3937.23.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36692 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1ANOqt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:46:49 -0500
In-Reply-To: <1295015623.3937.23.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.01.2011 15:33, schrieb Eric Dumazet:
> Le vendredi 14 janvier 2011 =C3=A0 14:42 +0100, Patrick McHardy a =C3=
=A9crit :
>> I'll add this to my tree unless someone spots a bug.
>>
>> netfilter: nf_conntrack: use is_vmalloc_addr()
>>
>> Use is_vmalloc_addr() in nf_ct_free_hashtable() and get rid of
>> the vmalloc flags to indicate that a hash table has been allocated
>> using vmalloc().
>>
>=20
> Seems fine to me, you could shrink this chunk to one line :
>=20
> @@ -1271,7 +1271,7 @@ static void nf_conntrack_cleanup_net(struct net=
 *net)
>  		goto i_see_dead_people;
>  	}
> =20
> -	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
> +	nf_ct_free_hashtable(net->ct.hash,=20
>  			     net->ct.htable_size);

Thanks, I've fixed this and committed the patch to my tree.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
