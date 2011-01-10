From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: ebtables: make broute table work again
Date: Mon, 10 Jan 2011 20:51:51 +0100
Message-ID: <4D2B6357.4080103@netfilter.org>
References: <20110110162009.GD31228@Chamillionaire.breakpoint.cc> <1294676914.3491.10.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38475 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1AJTv4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:51:56 -0500
In-Reply-To: <1294676914.3491.10.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/01/11 17:28, Eric Dumazet wrote:
> Le lundi 10 janvier 2011 =C3=A0 17:20 +0100, Florian Westphal a =C3=A9=
crit :
>> broute table init hook sets up the "br_should_route_hook" pointer,
>> which then gets called from br_input.
>>
>> commit a386f99025f13b32502fe5dedf223c20d7283826
>> (bridge: add proper RCU annotation to should_route_hook)
>> introduced a typedef, and then changed this to:
>>
>> br_should_route_hook_t *rhook;
>> [..]
>> rhook =3D rcu_dereference(br_should_route_hook);
>> if (*rhook(skb))
>>
>> problem is that "br_should_route_hook" contains the address of the f=
unction,
>> so calling *rhook() results in kernel panic.
>>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> ---
>>  include/linux/if_bridge.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>> index f7e73c3..dd3f201 100644
>> --- a/include/linux/if_bridge.h
>> +++ b/include/linux/if_bridge.h
>> @@ -103,7 +103,7 @@ struct __fdb_entry {
>> =20
>>  extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned in=
t, void __user *));
>> =20
>> -typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
>> +typedef int br_should_route_hook_t(struct sk_buff *skb);
>>  extern br_should_route_hook_t __rcu *br_should_route_hook;
>> =20
>>  #endif
>=20
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks guys!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
