From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH RESEND] netfilter: bridge: unshare bridge info before
 change it
Date: Thu, 20 Nov 2014 09:14:23 +0800
Message-ID: <546D406F.9050403@cn.fujitsu.com>
References: <1416203323-22745-1-git-send-email-gaofeng@cn.fujitsu.com> <20141118183419.GA5078@salvia> <546BFC4D.7070203@cn.fujitsu.com> <20141119111720.GA4537@salvia> <20141119114909.GA5014@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28927 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755334AbaKTBO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:14:28 -0500
In-Reply-To: <20141119114909.GA5014@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/19/2014 07:49 PM, Pablo Neira Ayuso wrote:
> On Wed, Nov 19, 2014 at 12:17:20PM +0100, Pablo Neira Ayuso wrote:
>> On Wed, Nov 19, 2014 at 10:11:25AM +0800, Gao feng wrote:
>>> On 11/19/2014 02:34 AM, Pablo Neira Ayuso wrote:
>>>> On Mon, Nov 17, 2014 at 01:48:43PM +0800, Gao feng wrote:
>>>>> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
>>>>> index 1a4f32c..b4612b9 100644
>>>>> --- a/net/bridge/br_netfilter.c
>>>>> +++ b/net/bridge/br_netfilter.c
>>>>> @@ -653,7 +643,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
>>>>>  		in = nf_bridge->physindev;
>>>>>  		if (nf_bridge->mask & BRNF_PKT_TYPE) {
>>>>>  			skb->pkt_type = PACKET_OTHERHOST;
>>>>> -			nf_bridge->mask ^= BRNF_PKT_TYPE;
>>>>> +
>>>>> +			if (!nf_bridge_unset_mask(skb, BRNF_PKT_TYPE)) {
>>>>> +				kfree_skb(skb);
>>>>> +				return 0;
>>>>> +			}
>>>>
>>>> This can now release the packet and, thus, drop it.
>>>>
>>>> However, br_nf_forward_ip() always returns NF_STOLEN.
>>>>
>>>> Could you revisit the error paths and confirm they are correct?
>>>
>>> Since br_nf_forward_ip() returns NF_STOLEN, br_nf_forward_finish should make
>>> sure this skb will be released. if unser_mask for this skb is failed, we free
>>> it. if unset successed, the hooks on NF_BR_FORWARD or br_forward_finish will
>>> free this skb.
>>
>> OK, but I think this should return NF_DROP instead of NF_STOLEN so you
>> don't explicitly need to kfree_skb it.
> 
> After a further look, I noticed what I suggest needs to replace:
> 
>         NF_HOOK_THRESH(...);
>         return 0;
> 
> by:
>         return NF_HOOK_THRESH(...);
> 
> And review the return value of all the existing okfn() functions so
> they return netfilter verdicts.
> 

NF_HOOK(_THRESH) will do kfree_skb if some hooks return NF_DROP,
and the return value of NF_HOOK_THRESH is not NF_DROP/NF_ACCEPT/NF_STOP....
it is the return value of nf_hook_slow.

If we call NF_HOOK/NF_HOOK_THRESH in some hooks, such as NF_HOOK(, NF_INET_FORWARD)
in br_nf_forward_ip, since packets may be dropped by INET FORWARD CHAIN,
we cannot return any NF_value but NF_STOLEN in br_nf_forward_ip, this packet
cannot be handled by the hooks next to br_nf_forward_ip since this packet may
already be freed.

> The existing code always returns NF_STOLEN from many other hooks, not
> only when dropped but also when accepted to make this work...
> 

I think this the right way.

> I'm going to have a look at your v2. Thanks.
> .
> 

