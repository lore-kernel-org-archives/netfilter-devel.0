Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056A3282F02
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 02:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780023338; cv=none; b=fImrc6g6WGPceEOOJgjezyBA0qarlsiPe7x7gDw1HBAHwSmNxO6RVMDguzKUyGft/J9YWM2uIYK07A/Xv2zVvqhvA2/Q9tVAKPIqrYdHIbisX2/RiB+Kyz47o2R5/d0bnC8HAZRMUgv9Mv/8rvoYhXl/RcXnF0MRG9Y6JGjlSac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780023338; c=relaxed/simple;
	bh=qUfPxwAwmDYwnD5xLs6H31wYemSThChWfFKjvKsL9bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlIdA3zw0353hcDBk8H5ccW+YC7a6pk9iomUoJpy3VeGX/Ie5wEWC25WoyKfImUEjRalw6+tVtJY9HRw4UwHH6dqivpfCAz62D3b7Ei4g+9i5shsC7L/TRBK0eII3iAKRIqBBq75l1J4VJjypRgXKT/In9cRmlUFRoXFTy5URp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VIEbyFVc; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VIEbyFVc"
Message-ID: <83d1be8a-34fd-4ebe-860f-5e026b554c74@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780023325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kj5I51avC3hWYqDOC659uwRMfrZ2MPVYVjwufZNJYFM=;
	b=VIEbyFVcssQ6WehxssnkXZsXKp0PXyErqVzr42Dgqp92cp8cMaON+y+fHA8z32mV7NzFJo
	sJcoVGer91DrtbQrhQM1dXnNU130nF+8rBbSYbcxvt5xtbcz/S1WzQLbaz/ieKThrd1ZxK
	OzIeK6tLB/Msg/OWpB8O+Ozi6S8FS6k=
Date: Fri, 29 May 2026 10:55:07 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net] ipv4: validate ip_forward_options() option fields
 against skb tail
To: Qi Tang <tpluszz77@gmail.com>, netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
 idosch@nvidia.com, horms@kernel.org, lyutoon@gmail.com,
 stable@vger.kernel.org
References: <b1447f76-0ca4-49b1-a1ba-2670dbbe5eea@linux.dev>
 <20260528163226.573363-1-tpluszz77@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260528163226.573363-1-tpluszz77@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 5/29/26 12:32 AM, Qi Tang wrote:
> On 5/28/26 9:48 PM, Jiayuan Chen wrote:
>> The bug is real, but I'm curious what kernel version and driver you're on.
>> On my side the skb falls into SKB_SMALL_HEAD_CACHE_SIZE (704), so the
>> linear area is pretty long, and optptr[2] maxes out at 255, which doesn't
>> look like it can reach frag_list.
>>
>> May the driver use alloc_skb to allocate small liner buffer?
> net.git at e1914add2799 (7.1-rc3), x86_64 + KASAN, plain QEMU, no special
> driver. You're right that with a normal small nh_off the +250 write stays in
> the linear area. We get the reach from a large nh_off instead.
>
> The packet is forwarded over a VXLAN-over-IPv6 tunnel, so after decap the
> inner IP packet still has the outer eth/IPv6/UDP/VXLAN/inner-eth in front of
> it in the same head (nh_off ~112 here). Inner options are 12 NOPs + RR, so
> opt->rr = 32, and nft rewrites the RR pointer byte to 0xff on the forward
> hook:
>
>    nft add rule ip filter forward @nh,272,8 set 0xff
>
> so ip_forward_options() does
>
>    write = head + nh_off + opt->rr + (0xff - 5)
>          = head + 112 + 32 + 250 = head + 394
>
> with end = 384 that lands at shinfo+10, inside frag_list. ip_rt_get_source()
> writes the route source there, and kfree_skb_list_reason() walks the corrupted
> frag_list when the skb is dropped.
>
> VXLAN was just convenient. Other paths likely work too: any encap that pushes
> the options deeper, or a smaller head like you suggested. Pre-6.3 without
> skb_small_head_cache a plain forwarded packet already has end=192. I can send
> the PoC off-list if you want to repro.
>
> Thanks,
> Qi


An alternative would be to re-validate the options by calling 
__ip_options_compile()
for writes targeting NFT_PAYLOAD_NETWORK_HEADER. Let's wait for the 
netfilter maintainers' opinion.

