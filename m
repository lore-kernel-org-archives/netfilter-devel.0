From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH RESEND] netfilter: bridge: unshare bridge info before
 change it
Date: Wed, 19 Nov 2014 10:11:25 +0800
Message-ID: <546BFC4D.7070203@cn.fujitsu.com>
References: <1416203323-22745-1-git-send-email-gaofeng@cn.fujitsu.com> <20141118183419.GA5078@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25065 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650AbaKSCLa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:11:30 -0500
In-Reply-To: <20141118183419.GA5078@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/19/2014 02:34 AM, Pablo Neira Ayuso wrote:
> On Mon, Nov 17, 2014 at 01:48:43PM +0800, Gao feng wrote:
>> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
>> index 1a4f32c..b4612b9 100644
>> --- a/net/bridge/br_netfilter.c
>> +++ b/net/bridge/br_netfilter.c
>> @@ -653,7 +643,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
>>  		in = nf_bridge->physindev;
>>  		if (nf_bridge->mask & BRNF_PKT_TYPE) {
>>  			skb->pkt_type = PACKET_OTHERHOST;
>> -			nf_bridge->mask ^= BRNF_PKT_TYPE;
>> +
>> +			if (!nf_bridge_unset_mask(skb, BRNF_PKT_TYPE)) {
>> +				kfree_skb(skb);
>> +				return 0;
>> +			}
> 
> This can now release the packet and, thus, drop it.
> 
> However, br_nf_forward_ip() always returns NF_STOLEN.
> 
> Could you revisit the error paths and confirm they are correct?

Since br_nf_forward_ip() returns NF_STOLEN, br_nf_forward_finish should make
sure this skb will be released. if unser_mask for this skb is failed, we free
it. if unset successed, the hooks on NF_BR_FORWARD or br_forward_finish will
free this skb.

I check the error paths again, find a missing null check of nf_bridge. I will
post v2 patch.


