Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1F1370AFE
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779187874; cv=none; b=WX7U97/bqhTplobM53osBlMJ8BxYRXWH3suO8xKMXG0jdXGk130lWKs5eIvR5uaf4wdwIQK3BtHbx1uptTRmb39IyfPMeVr4U2lAFPP/xDwH2XDsVlq8slMx8qKs4cQG62mCj5Dz4nUkR1H+88PimUdytOIramzhqGfHjWE2ZNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779187874; c=relaxed/simple;
	bh=PeEBkY1CNEPFKSe/J0NkWerJVO/X3uLmpZrY5tgvokc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jihBEOmW4rDeGNlTx+SNIXYFrfCppULlKxpwbW6i7HStMjOhAJRkEbHxuctdNUgFQgRSXNCqJ94Gj8EnYpybpt2K2RX6GZA141NMeSV8jmfeisHMzNfJR99uo9zrV3Aav+455cxSIxnFly6k2pTM9AcwT22zsnabrp5qpWp55rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AqgsO/gI; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AqgsO/gI"
Message-ID: <7da4fc46-0432-4f3d-b1bb-1691a2464df0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779187864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8n96lsxRVIrD96zj1R14KLDTBGb0m6IdyBe3EwkwOg=;
	b=AqgsO/gIZYY4FYs0BfjjDO+MQ/FWrl5Bofi7ORUY9Xq5Y6Rx5MsbreLBRfGsrngqNLWUAE
	9wF61thTfoHbGjg40zzwDq+kTzQlH2bh9wgrYBZV6dAMDMwkOU8lEWYr6TXEXB9HeOrud/
	bxK5Wxa2a8CHNF88TKGtiZeel5kiNiE=
Date: Tue, 19 May 2026 18:50:55 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf 1/2] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 coreteam@netfilter.org
References: <20260519041431.396218-1-jiayuan.chen@linux.dev>
 <agw2kQHigTsMoJKt@orbyte.nwl.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <agw2kQHigTsMoJKt@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Phil,

Thanks for your review.

On 5/19/26 6:08 PM, Phil Sutter wrote:
> Hi,
>
> On Tue, May 19, 2026 at 12:14:30PM +0800, Jiayuan Chen wrote:
>> fib6_info has a union:
>>
>>      union {
>>          struct list_head fib6_siblings;
>>          struct list_head nh_list;
>>      };
>>
>> Old-style multipath (ip -6 route add ... nexthop ... nexthop ...) uses
>> fib6_siblings.  External nexthop (ip -6 route add ... nhid N) uses
>> nh_list, linked into &nh->f6i_list.
>>
>> nft_fib6_info_nh_uses_dev() blindly walks &rt->fib6_siblings, causing
>> an OOB read past the struct nexthop slab when rt->nh is set:
>>
>>    ==================================================================
>>    BUG: KASAN: slab-out-of-bounds in nft_fib6_eval+0x1362/0x16c0
>>    Read of size 8 at addr ffff888103a099d0 by task ping/386
>>
>>    CPU: 2 UID: 0 PID: 386 Comm: ping Not tainted 7.1.0-rc3+ #251 PREEMPT
>>    Call Trace:
>>     <IRQ>
>>     dump_stack_lvl+0x76/0xa0
>>     print_report+0xd1/0x5f0
>>     kasan_report+0xe7/0x130
>>     __asan_report_load8_noabort+0x14/0x30
>>     nft_fib6_eval+0x1362/0x16c0
>>     nft_do_chain+0x279/0x18c0
>>     nft_do_chain_ipv6+0x1a8/0x230
>>     nf_hook_slow+0xad/0x200
>>     ipv6_rcv+0x152/0x380
>>     __netif_receive_skb_one_core+0x118/0x1c0
>>    ==================================================================
>>
>> Branch by route shape: when rt->nh is set, walk via
>> nexthop_for_each_fib6_nh() (also covers nh groups, which the original
>> code missed); otherwise walk fib6_siblings, guarded by fib6_nsiblings.
>>
>> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
>> ---
>>   net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
>> index 8b2dba88ee96..a44919f46de9 100644
>> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
>> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
>> @@ -160,16 +160,32 @@ static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
>>   	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
>>   }
>>   
>> +static int nft_fib6_nh_match_dev_cb(struct fib6_nh *nh, void *arg)
>> +{
>> +	const struct net_device *dev = arg;
>> +
>> +	return nft_fib6_info_nh_dev_match(nh->fib_nh_dev, dev) ? 1 : 0;
> Why the ternary here? The function returns bool, but the iterator merely
> checks the value for 0 and caller returns the value as bool as well.
>
>> +}
>> +
>>   static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
>>   				      const struct net_device *dev)
>>   {
>>   	const struct net_device *nh_dev;
>>   	struct fib6_info *iter;
>>   
>> +	/* External nexthop: fib6_siblings slot aliases nh_list, walk via nh. */
>> +	if (rt->nh)
>> +		return nexthop_for_each_fib6_nh(rt->nh,
>> +						nft_fib6_nh_match_dev_cb,
>> +						(void *)dev) != 0;


All make sense !


>> +
>>   	nh_dev = fib6_info_nh_dev(rt);
>>   	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
>>   		return true;
>>   
>> +	if (!rt->fib6_nsiblings)
> Should this access using READ_ONCE() as per commit 31d7d67ba127 ("ipv6:
> annotate data-races around rt->fib6_nsiblings")?


You are right, we need READ_ONCE since fib6_add_rt2node will modify 
@fib6_nsiblings .


>> +		return false;
>> +
>>   	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {


Now I think we should also change list_for_each_entry  into 
list_for_each_entry_rcu for the same reason.

But I'm not sure whether it is appropriate or not since this patch 
target to commit in Fiexes tag.

May be a followup patch is necessary.



>>   		nh_dev = fib6_info_nh_dev(iter);
> I thought about open-coding this to void the need for the callback
> wrapper, but it's not worth it.
>
> Cheers, Phil
