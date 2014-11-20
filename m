From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH v2] netfilter: bridge: unshare bridge info before change
 it
Date: Thu, 20 Nov 2014 09:16:12 +0800
Message-ID: <546D40DC.6060505@cn.fujitsu.com>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com> <20141119130751.GA10748@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932209AbaKTBQQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:16:16 -0500
In-Reply-To: <20141119130751.GA10748@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/19/2014 09:07 PM, Pablo Neira Ayuso wrote:
> On Wed, Nov 19, 2014 at 11:07:32AM +0800, Gao feng wrote:
>> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
>> index c755e49..dca7337 100644
>> --- a/include/linux/netfilter_bridge.h
>> +++ b/include/linux/netfilter_bridge.h
>> @@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>>  	return 0;
>>  }
>>  
>> +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
>> +{
>> +	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
>> +	if (likely(skb->nf_bridge))
>> +		atomic_set(&(skb->nf_bridge->use), 1);
>> +
>> +	return skb->nf_bridge;
>> +}
>> +
>> +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
>> +{
>> +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>> +
>> +	if (atomic_read(&nf_bridge->use) > 1) {
>> +		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
> 
> nf_bridge_alloc() overwrites the original skb->nf_bridge when
> unsharing, so this leaks and likely breaks other things.
> 

overwrite is what we expected, we store the original nfbridge in the var
nf_bridge, copy the original to the new. and release the reference of original
nfbridge. I cannot find anything wrong.

>> +
>> +		if (tmp) {
>> +			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
>> +			atomic_set(&tmp->use, 1);
>> +		}
>> +		nf_bridge_put(nf_bridge);
>> +		nf_bridge = tmp;
>> +	}
>> +	return nf_bridge;
>> +}
> 

