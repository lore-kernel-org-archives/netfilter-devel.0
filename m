From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition between
 dump_table and destroy
Date: Mon, 24 Jan 2011 14:06:21 +0100
Message-ID: <4D3D794D.9010401@netfilter.org>
References: <20110123231602.3383.31480.stgit@decadence>	 <1295851305.28358.16.camel@edumazet-laptop>	 <4D3D691F.3050403@netfilter.org>  <4D3D74AD.5080300@trash.net> <1295873689.2755.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101090002020001060207"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1AXNG0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:06:26 -0500
In-Reply-To: <1295873689.2755.22.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020101090002020001060207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 24/01/11 13:54, Eric Dumazet wrote:
> Le lundi 24 janvier 2011 à 13:46 +0100, Patrick McHardy a écrit :
>> On 24.01.2011 12:57, Pablo Neira Ayuso wrote:
>>> On 24/01/11 07:41, Eric Dumazet wrote:
>>>> Le lundi 24 janvier 2011 à 00:16 +0100, Pablo Neira Ayuso a écrit :
>>>>> In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinlocks
>>>>> to protect the dump of the conntrack table according to reports from
>>>>> Stephen and acknowledgments on the issue from Eric.
>>>>
>>>> When a commit is referred, always give its title, and you can use a
>>>> short id (12 digits are OK)
>>>
>>> I'm using the id that git log --oneline shows, is it OK?
>>>
>>>> In 13ee6ac57957 (netfilter: fix race in conntrack between dump_table and
>>>> destroy)
>>>>
>>>>> However, Stephen removed the refcount bump in that patch that allows
>>>>> to keep a reference to the current ct object we are interating over.
>>>>> That code avoids race conditions between ct object destruction and
>>>>> the iteration itself. This patch reintroduces these lines since the
>>>>> ct object may vanish between two recvmgs() invocations.
>>>>>
>>>>> This patch fixes ocasional crashes while dumping the conntrack table
>>>>> intensively.
>>>>>
>>>>> Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
>>>>
>>>> Thats not true, Stephen was not in CC on your mail
>>>
>>> I'm sorry, I forgot to add --cc to stgit.
>>>
>>>> I add him right now.
>>>>
>>>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>>>> ---
>>>>>  net/netfilter/nf_conntrack_netlink.c |    8 ++++++--
>>>>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
>>>>> index 93297aa..519e245 100644
>>>>> --- a/net/netfilter/nf_conntrack_netlink.c
>>>>> +++ b/net/netfilter/nf_conntrack_netlink.c
>>>>> @@ -654,14 +654,16 @@ restart:
>>>>>  			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
>>>>>  				continue;
>>>>>  			ct = nf_ct_tuplehash_to_ctrack(h);
>>>>> +			if (!atomic_inc_not_zero(&ct->ct_general.use))
>>>>> +				continue;
>>>>>  			/* Dump entries of a given L3 protocol number.
>>>>>  			 * If it is not specified, ie. l3proto == 0,
>>>>>  			 * then dump everything. */
>>>>>  			if (l3proto && nf_ct_l3num(ct) != l3proto)
>>>>> -				continue;
>>>>> +				goto releasect;
>>>>>  			if (cb->args[1]) {
>>>>>  				if (ct != last)
>>>>> -					continue;
>>>>> +					goto releasect;
>>>>>  				cb->args[1] = 0;
>>>>>  			}
>>>>>  			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
>>>>> @@ -679,6 +681,8 @@ restart:
>>>>>  				if (acct)
>>>>>  					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
>>>>>  			}
>>>>> +releasect:
>>>>> +		nf_ct_put(ct);
>>>>>  		}
>>>>>  		if (cb->args[1]) {
>>>>>  			cb->args[1] = 0;
>>>>>
>>>>
>>>>
>>>> Hmm...
>>>>
>>>> Only the RCU lookup should need this extra check (atomic_inc_not_zero),
>>>> not a writer. (And a dumper is a "writer" since it holds nf_conntrack
>>>> spinlock)
>>>>
>>>> In Stephen commit, we switched from RCU lookup to traditional one
>>>> (spinlock protected), so, we should not need to touch individual objects
>>>> refcount ?
>>>>
>>>> I feel the right fix is not to increment refcount then decrement it.
>>>>
>>>> Only to _test_ it being zero, and not dumping the ct, eventually ?
>>>>
>>>>
>>>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
>>>> index 93297aa..a977cc7 100644
>>>> --- a/net/netfilter/nf_conntrack_netlink.c
>>>> +++ b/net/netfilter/nf_conntrack_netlink.c
>>>> @@ -654,6 +654,8 @@ restart:
>>>>  			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
>>>>  				continue;
>>>>  			ct = nf_ct_tuplehash_to_ctrack(h);
>>>> +			if (!atomic_read(&ct->ct_general.use))
>>>> +				continue;
>>>>  			/* Dump entries of a given L3 protocol number.
>>>>  			 * If it is not specified, ie. l3proto == 0,
>>>>  			 * then dump everything. */
>>>
>>> No, that won't work.
>>>
>>> Sorry, I didn't explain the problem appropriately. We still do a
>>> nf_ct_put() for last ct. In that patch, you forgot to add the refcount
>>> bump that we need to keep the reference to the object.
>>>
>>> The following patch attached is smaller, it also fixes the problem and
>>> we don't have to increase the refcount for each object. Now it looks
>>> similar to how it was before the RCU patches.
>>
>> This looks correct to me, we need to keep a reference for continuations.
>> Eric, do you agree with this patch?
> 
> Taking a reference I agree for sure, this is the full
> atomic_inc_not_zero(&ct->ct_general.use) I disagree.
> 
> Pablo, the refcount cannot be 0 at this point, or something is really
> wrong ?
> 
> Why not using
> 
> atomic_inc(&ct->ct_general.use);
> 
> ?

Yes, we can use nf_conntrack_get (which does atomic_inc) instead. New
patch attached.

--------------020101090002020001060207
Content-Type: text/x-patch;
 name="fix-ct-dump.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-ct-dump.patch"

netfilter: ctnetlink: fix missing refcount increment during dumps

From: Pablo Neira Ayuso <pablo@netfilter.org>

In 13ee6ac netfilter: fix race in conntrack between dump_table and
destroy, we recovered spinlocks to protect the dump of the conntrack
table according to reports from Stephen and acknowledgments on the
issue from Eric.

In that patch, the refcount bump that allows to keep a reference
to the current ct object was removed. However, we still decrement
the refcount for that object in the output path of
ctnetlink_dump_table():

        if (last)
                nf_ct_put(last)

Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 93297aa..eead9db 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -667,6 +667,7 @@ restart:
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 						cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}

--------------020101090002020001060207--
