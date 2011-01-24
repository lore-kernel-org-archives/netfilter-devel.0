From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition between
 dump_table and destroy
Date: Mon, 24 Jan 2011 13:46:37 +0100
Message-ID: <4D3D74AD.5080300@trash.net>
References: <20110123231602.3383.31480.stgit@decadence> <1295851305.28358.16.camel@edumazet-laptop> <4D3D691F.3050403@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61202 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AXMqq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:46:46 -0500
In-Reply-To: <4D3D691F.3050403@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.01.2011 12:57, Pablo Neira Ayuso wrote:
> On 24/01/11 07:41, Eric Dumazet wrote:
>> Le lundi 24 janvier 2011 =E0 00:16 +0100, Pablo Neira Ayuso a =E9cri=
t :
>>> In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinlocks
>>> to protect the dump of the conntrack table according to reports fro=
m
>>> Stephen and acknowledgments on the issue from Eric.
>>
>> When a commit is referred, always give its title, and you can use a
>> short id (12 digits are OK)
>=20
> I'm using the id that git log --oneline shows, is it OK?
>=20
>> In 13ee6ac57957 (netfilter: fix race in conntrack between dump_table=
 and
>> destroy)
>>
>>> However, Stephen removed the refcount bump in that patch that allow=
s
>>> to keep a reference to the current ct object we are interating over=
=2E
>>> That code avoids race conditions between ct object destruction and
>>> the iteration itself. This patch reintroduces these lines since the
>>> ct object may vanish between two recvmgs() invocations.
>>>
>>> This patch fixes ocasional crashes while dumping the conntrack tabl=
e
>>> intensively.
>>>
>>> Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
>>
>> Thats not true, Stephen was not in CC on your mail
>=20
> I'm sorry, I forgot to add --cc to stgit.
>=20
>> I add him right now.
>>
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>> ---
>>>  net/netfilter/nf_conntrack_netlink.c |    8 ++++++--
>>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/n=
f_conntrack_netlink.c
>>> index 93297aa..519e245 100644
>>> --- a/net/netfilter/nf_conntrack_netlink.c
>>> +++ b/net/netfilter/nf_conntrack_netlink.c
>>> @@ -654,14 +654,16 @@ restart:
>>>  			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
>>>  				continue;
>>>  			ct =3D nf_ct_tuplehash_to_ctrack(h);
>>> +			if (!atomic_inc_not_zero(&ct->ct_general.use))
>>> +				continue;
>>>  			/* Dump entries of a given L3 protocol number.
>>>  			 * If it is not specified, ie. l3proto =3D=3D 0,
>>>  			 * then dump everything. */
>>>  			if (l3proto && nf_ct_l3num(ct) !=3D l3proto)
>>> -				continue;
>>> +				goto releasect;
>>>  			if (cb->args[1]) {
>>>  				if (ct !=3D last)
>>> -					continue;
>>> +					goto releasect;
>>>  				cb->args[1] =3D 0;
>>>  			}
>>>  			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
>>> @@ -679,6 +681,8 @@ restart:
>>>  				if (acct)
>>>  					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX])=
);
>>>  			}
>>> +releasect:
>>> +		nf_ct_put(ct);
>>>  		}
>>>  		if (cb->args[1]) {
>>>  			cb->args[1] =3D 0;
>>>
>>
>>
>> Hmm...
>>
>> Only the RCU lookup should need this extra check (atomic_inc_not_zer=
o),
>> not a writer. (And a dumper is a "writer" since it holds nf_conntrac=
k
>> spinlock)
>>
>> In Stephen commit, we switched from RCU lookup to traditional one
>> (spinlock protected), so, we should not need to touch individual obj=
ects
>> refcount ?
>>
>> I feel the right fix is not to increment refcount then decrement it.
>>
>> Only to _test_ it being zero, and not dumping the ct, eventually ?
>>
>>
>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf=
_conntrack_netlink.c
>> index 93297aa..a977cc7 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -654,6 +654,8 @@ restart:
>>  			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
>>  				continue;
>>  			ct =3D nf_ct_tuplehash_to_ctrack(h);
>> +			if (!atomic_read(&ct->ct_general.use))
>> +				continue;
>>  			/* Dump entries of a given L3 protocol number.
>>  			 * If it is not specified, ie. l3proto =3D=3D 0,
>>  			 * then dump everything. */
>=20
> No, that won't work.
>=20
> Sorry, I didn't explain the problem appropriately. We still do a
> nf_ct_put() for last ct. In that patch, you forgot to add the refcoun=
t
> bump that we need to keep the reference to the object.
>=20
> The following patch attached is smaller, it also fixes the problem an=
d
> we don't have to increase the refcount for each object. Now it looks
> similar to how it was before the RCU patches.

This looks correct to me, we need to keep a reference for continuations=
=2E
Eric, do you agree with this patch?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
