Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A98B327C13
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201253; cv=none; b=mQUPLHNZBuEhwpWbeAw+Az20eRYUCqsmmQL/xAqcY6rA6Htr5DqlnszLPi4vllU8ttNlAmUyVTKBEKVNrS1QiI1rArRWjx+X7mRUALo+3dr5Uig788aXzIkUVmtcZhqGG1lqCRGkY8zpHL3+wiHK3TW9Mm2fNcDbBZT7NSdeyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201253; c=relaxed/simple;
	bh=t0nm6yuJ4/fW0ep/fbPuMz2fS9oPQlBGHwa/WaGMkzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vg6mnXgect/vxL08WQpg0C6q1x+UEMb+rvHS9ki2n+8Nxnvdd4c+c2/hE+ziZDoLZma7VXyVRxRfmO+6HYKycoSKh5bHu1oSvjcTEqdZrdVJoXltfbnOQjcgBRxS0q7OKduQRQSQcPYfI3AQNpWT0jAQIhTTggls1zPVcwvH1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YsP80veW; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YsP80veW"
Message-ID: <546f713a-679c-40c5-b231-30ba274fac8a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779201248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8tzOeJHN5d3IIEtNIth2aA1jXODL8qBco/DpqxAnmY=;
	b=YsP80veW1GSN2x5KVDR5ci4WvszEEde7saLwX2T89DkyuERWpuOZnRntRi+mjcIPJFuWVy
	JNQxCmZ2RdIzW3dR9nYlhrdX6K1Ds6XAP7+PlHlu2XSRT5y/bIvo2wBGrWLv/qXiWYOMbl
	elzNgM4i/uwAx+cOgVVYsF3VxpBcmM8=
Date: Tue, 19 May 2026 22:33:53 +0800
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
 <7da4fc46-0432-4f3d-b1bb-1691a2464df0@linux.dev>
 <agxwjNJ2PJg25kVF@orbyte.nwl.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <agxwjNJ2PJg25kVF@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 5/19/26 10:15 PM, Phil Sutter wrote:
> On Tue, May 19, 2026 at 06:50:55PM +0800, Jiayuan Chen wrote:
> [...]
>> On 5/19/26 6:08 PM, Phil Sutter wrote:
>>> Hi,
>>>
>>> On Tue, May 19, 2026 at 12:14:30PM +0800, Jiayuan Chen wrote:
>>>> fib6_info has a union:
>>>>
>>>>       union {
>>>>           struct list_head fib6_siblings;
>>>>           struct list_head nh_list;
>>>>       };
>>>>
>>>> Old-style multipath (ip -6 route add ... nexthop ... nexthop ...) uses
>>>> fib6_siblings.  External nexthop (ip -6 route add ... nhid N) uses
>>>> nh_list, linked into &nh->f6i_list.
>>>>
>>>> nft_fib6_info_nh_uses_dev() blindly walks &rt->fib6_siblings, causing
>>>> an OOB read past the struct nexthop slab when rt->nh is set:
>>>>
>>>>     ==================================================================
>>>>     BUG: KASAN: slab-out-of-bounds in nft_fib6_eval+0x1362/0x16c0
>>>>     Read of size 8 at addr ffff888103a099d0 by task ping/386
>>>>
>>>>     CPU: 2 UID: 0 PID: 386 Comm: ping Not tainted 7.1.0-rc3+ #251 PREEMPT
>>>>     Call Trace:
>>>>      <IRQ>
>>>>      dump_stack_lvl+0x76/0xa0
>>>>      print_report+0xd1/0x5f0
>>>>      kasan_report+0xe7/0x130
>>>>      __asan_report_load8_noabort+0x14/0x30
>>>>      nft_fib6_eval+0x1362/0x16c0
>>>>      nft_do_chain+0x279/0x18c0
>>>>      nft_do_chain_ipv6+0x1a8/0x230
>>>>      nf_hook_slow+0xad/0x200
>>>>      ipv6_rcv+0x152/0x380
>>>>      __netif_receive_skb_one_core+0x118/0x1c0
>>>>     ==================================================================
>>>>
>>>> Branch by route shape: when rt->nh is set, walk via
>>>> nexthop_for_each_fib6_nh() (also covers nh groups, which the original
>>>> code missed); otherwise walk fib6_siblings, guarded by fib6_nsiblings.
>>>>
>>>> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
>>>> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
>>>> ---
>>>>    net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++++++++++++++++
>>>>    1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
>>>> index 8b2dba88ee96..a44919f46de9 100644
>>>> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
>>>> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
>>>> @@ -160,16 +160,32 @@ static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
>>>>    	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
>>>>    }
>>>>    
>>>> +static int nft_fib6_nh_match_dev_cb(struct fib6_nh *nh, void *arg)
>>>> +{
>>>> +	const struct net_device *dev = arg;
>>>> +
>>>> +	return nft_fib6_info_nh_dev_match(nh->fib_nh_dev, dev) ? 1 : 0;
>>> Why the ternary here? The function returns bool, but the iterator merely
>>> checks the value for 0 and caller returns the value as bool as well.
>>>
>>>> +}
>>>> +
>>>>    static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
>>>>    				      const struct net_device *dev)
>>>>    {
>>>>    	const struct net_device *nh_dev;
>>>>    	struct fib6_info *iter;
>>>>    
>>>> +	/* External nexthop: fib6_siblings slot aliases nh_list, walk via nh. */
>>>> +	if (rt->nh)
>>>> +		return nexthop_for_each_fib6_nh(rt->nh,
>>>> +						nft_fib6_nh_match_dev_cb,
>>>> +						(void *)dev) != 0;
>>
>> All make sense !
>>
>>
>>>> +
>>>>    	nh_dev = fib6_info_nh_dev(rt);
>>>>    	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
>>>>    		return true;
>>>>    
>>>> +	if (!rt->fib6_nsiblings)
>>> Should this access using READ_ONCE() as per commit 31d7d67ba127 ("ipv6:
>>> annotate data-races around rt->fib6_nsiblings")?
>>
>> You are right, we need READ_ONCE since fib6_add_rt2node will modify
>> @fib6_nsiblings .
>>
>>
>>>> +		return false;
>>>> +
>>>>    	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
>>
>> Now I think we should also change list_for_each_entry  into
>> list_for_each_entry_rcu for the same reason.
> Seems legit! I missed that one because most examples in net/ipv6/route.c
> use a non-RCU variant, I guess because exclusive access is ensured via
> other means.
>
>> But I'm not sure whether it is appropriate or not since this patch
>> target to commit in Fiexes tag.
>>
>> May be a followup patch is necessary.
> I'd submit the _rcu fix in an initial patch of the series, so the one
> introducing the fib6_nsiblings check extends correct code (using _rcu)
> with a correct pattern (READ_ONCE).
>
> Thanks, Phil



Got it - will respin as v2.
Sending after a short cool-down.

Respect

