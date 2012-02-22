From: Tony Zelenoff <antonz@parallels.com>
Subject: Re: [PATCH 2/3] net/netfilter: refactor notifier registration
Date: Wed, 22 Feb 2012 12:18:51 +0400
Message-ID: <4F44A4EB.50804@parallels.com>
References: <1329893281-508699-1-git-send-email-antonz@parallels.com>  <1329893281-508699-3-git-send-email-antonz@parallels.com> <1329897260.18384.86.camel@edumazet-laptop>
Reply-To: <antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:48075 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2BVIWn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:22:43 -0500
In-Reply-To: <1329897260.18384.86.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22.02.2012 11:54, Eric Dumazet wrote:
> Le mercredi 22 f=C3=A9vrier 2012 =C3=A0 10:48 +0400, Tony Zelenoff a =
=C3=A9crit :
>> * ret variable initialization removed as useless
>> * Similar code strings concatenated and functions code
>>    flow became more plain
>>
>> Signed-off-by: Tony Zelenoff<antonz@parallels.com>
>> ---
>>   net/netfilter/nf_conntrack_ecache.c |   26 ++++++++++-------------=
---
>>   1 files changed, 10 insertions(+), 16 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_=
conntrack_ecache.c
>> index aa15977..9b8e986 100644
>> --- a/net/netfilter/nf_conntrack_ecache.c
>> +++ b/net/netfilter/nf_conntrack_ecache.c
>> @@ -81,21 +81,18 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
>>   int nf_conntrack_register_notifier(struct net *net,
>>   				   struct nf_ct_event_notifier *new)
>>   {
>> -	int ret =3D 0;
>> +	int ret;
>>   	struct nf_ct_event_notifier *notify;
>>
>>   	mutex_lock(&nf_ct_ecache_mutex);
>>   	notify =3D rcu_dereference_protected(net->ct.nf_conntrack_event_c=
b,
>>   					   lockdep_is_held(&nf_ct_ecache_mutex));
>> -	if (notify !=3D NULL) {
>> +	if (likely(!notify)) {
>> +		rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
>> +		ret =3D 0;
>> +	} else
>>   		ret =3D -EBUSY;
>> -		goto out_unlock;
>> -	}
>> -	rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
>> -	mutex_unlock(&nf_ct_ecache_mutex);
>> -	return ret;
>>
>> -out_unlock:
>>   	mutex_unlock(&nf_ct_ecache_mutex);
>>   	return ret;
>>   }
>> @@ -118,21 +115,18 @@ EXPORT_SYMBOL_GPL(nf_conntrack_unregister_noti=
fier);
>>   int nf_ct_expect_register_notifier(struct net *net,
>>   				   struct nf_exp_event_notifier *new)
>>   {
>> -	int ret =3D 0;
>> +	int ret;
>>   	struct nf_exp_event_notifier *notify;
>>
>>   	mutex_lock(&nf_ct_ecache_mutex);
>>   	notify =3D rcu_dereference_protected(net->ct.nf_expect_event_cb,
>>   					   lockdep_is_held(&nf_ct_ecache_mutex));
>> -	if (notify !=3D NULL) {
>> +	if (likely(!notify)) {
>> +		rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
>> +		ret =3D 0;
>> +	} else
>>   		ret =3D -EBUSY;
>> -		goto out_unlock;
>> -	}
>> -	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
>> -	mutex_unlock(&nf_ct_ecache_mutex);
>> -	return ret;
>>
>> -out_unlock:
>>   	mutex_unlock(&nf_ct_ecache_mutex);
>>   	return ret;
>>   }
>
> Please leave the code as is, I find it more readable.
>
> It is standard coding practice, and permits stacking of new init code=
,
> with proper error path.

Do not agree a bit. Of course, the code stacking and so on is good, but=
=20
there is no reason to write:

	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
	mutex_unlock(&nf_ct_ecache_mutex);
	return ret;

out_unlock:
    	mutex_unlock(&nf_ct_ecache_mutex);
    	return ret;

if you can do it (without breaking logic and stacking ability and as it=
=20
done everywhere) this way:

	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);

out_unlock:
    	mutex_unlock(&nf_ct_ecache_mutex);
    	return ret;

with only one exit with proper locks freeing or deinitialization.

Ok, after that i've remove ret initialization at start and without goto=
=20
this label became unused and compiler warn about it. Thus it was remove=
d.

>
> Dont add likely()/unlikely() clauses in slow path, this obfuscate cod=
e
> for litle gain.
ok
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
