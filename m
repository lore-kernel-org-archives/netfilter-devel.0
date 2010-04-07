From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
 lookup by id
Date: Wed, 07 Apr 2010 15:03:16 +0200
Message-ID: <4BBC8294.50501@trash.net>
References: <4BBBFE21.9070507@gmail.com>  <4BBC711E.7050602@trash.net> <1270643136.2091.1013.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xiaosuo@gmail.com, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47133 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0DGNDU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:03:20 -0400
In-Reply-To: <1270643136.2091.1013.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le mercredi 07 avril 2010 =E0 13:48 +0200, Patrick McHardy a =E9crit =
:
>> Changli Gao wrote:
>>> use idr instead of list to speed up packet lookup by id.
>>>
>>> The current implementations of nfnetlink_queue, ip_queue and ip6_qu=
eue
>>> are all use list to save the packets queued. If the verdicts aren't
>>> received in order, the lookup for the corresponding packets isn't
>>> efficient. As the ids is generated and maintained in kernel, we can=
 use
>>> idr to speed up the lookup. The side effect of this patch is fixing=
 the
>>> potential id overlap in nfnetlink_queue.
>> I'm interested in how this affects performance for the vast majority
>> of users, which process messages in order. A simple hash table looks
>> like a better choice here since we know the maximum number of entrie=
s
>> in advance and also could have the user specify the desired hash siz=
e.
>=20
> Yes, a hash table would be good, but cost 8 bytes per slot.
>=20
> Changli, did you tried RBL tree ? It might fit better both your needs
> and Patrick concerns...

RB-trees OTOH cost 8 bytes extra per element. If we'd use a hash,
I think the size should be configurable by userspace and default
to 1 (simple list as used currently). That way only those people
actually processing packets out of order have to pay the price.
But an RB-tree would be fine too I guess.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
