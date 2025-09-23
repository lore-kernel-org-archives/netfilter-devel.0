Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731062FC86F;
	Tue, 23 Sep 2025 12:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758629101; cv=none; b=uxMhPYbOtRjlKMJSIdrreaCbQDAjrnrZxLJhp2AUyyacjdjTWRFOCAxVfjfczm0iezBn9k8GOWs7cvL5dexFHykYkY9g7LGftpxyA58W90ZoGCN3YJZ/8iJF5ce8nWPPOJOzxW5tiXubK/v8fgfXlGs2YdW2XgIx6yLk5dd0dII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758629101; c=relaxed/simple;
	bh=ThjKCuq/Gkaa6sxkQ2iw8pcH9Scy6bno0C+2htC9uZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1vZbYLbMyZcOg6K/Kcrir6+QpsyFuaE00FAmwU5sPEDSDbWuhA81yNW3rpowGRatVO3CYzyFHJqGsiPoz+xz+NJgfTq1moAT1P77zezHczsf6RWfCOxYfiYwPZaVnhNvP92ndj9OXshGZZQv+z68oZXbjrQxSwQfhY4+fkHw10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=L0C9g3J+; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="L0C9g3J+"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:cf2d:0:640:140f:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 1672F80C96;
	Tue, 23 Sep 2025 15:04:53 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:c77::1:3b] (unknown [2a02:6bf:8080:c77::1:3b])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id o4WuUE0FriE0-fAFtdmJZ;
	Tue, 23 Sep 2025 15:04:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758629092;
	bh=Vf6v1fCk8K2cHd1wSxGVsZZHow2DvCl4rn6gHJ3UDJw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=L0C9g3J+Buq5IlPqK24blre2NyAlID7zKCiGaanAQ7d0uVqQ7U304SQTzWELPkSL8
	 HMobw6+QoJSStHaluNL8R7Het0vAbLmykTCNFFkLIWSdda7hRKRd9vIeNFOXeEU84z
	 XBO11aEutOxbdbL3c7nPknSeN0QFZpXNj6RbvJwM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <348f209e-89bc-4289-aaf9-e57437e31b0d@yandex-team.ru>
Date: Tue, 23 Sep 2025 15:04:50 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] netfilter/x_tables: go back to using vmalloc for
 xt_table_info
To: Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <edumazet@google.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
 <20250922194819.182809-2-d-tatianin@yandex-team.ru>
 <CANn89i+GoVZLcdHxuf33HpmgyPNKxGqEjXGpi=XiB-QOsAG52A@mail.gmail.com>
 <5f1ff52a-d2c2-40de-b00c-661b75c18dc7@yandex-team.ru>
 <aNKGWZSxY9RC0VWS@strlen.de>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <aNKGWZSxY9RC0VWS@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/25 2:36 PM, Florian Westphal wrote:

> Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
>>> On Mon, Sep 22, 2025 at 12:48 PM Daniil Tatianin
>>> <d-tatianin@yandex-team.ru> wrote:
>>>> This code previously always used vmalloc for anything above
>>>> PAGE_ALLOC_COSTLY_ORDER, but this logic was changed in
>>>> commit eacd86ca3b036 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()").
>>>>
>>>> The commit that changed it did so because "xt_alloc_table_info()
>>>> basically opencodes kvmalloc()", which is not actually what it was
>>>> doing. kvmalloc() does not attempt to go directly to vmalloc if the
>>>> order the caller is trying to allocate is "expensive", instead it only
>>>> uses vmalloc as a fallback in case the buddy allocator is not able to
>>>> fullfill the request.
>>>>
>>>> The difference between the two is actually huge in case the system is
>>>> under memory pressure and has no free pages of a large order. Before the
>>>> change to kvmalloc we wouldn't even try going to the buddy allocator for
>>>> large orders, but now we would force it to try to find a page of the
>>>> required order by waking up kswapd/kcompactd and dropping reclaimable memory
>>>> for no reason at all to satisfy our huge order allocation that could easily
>>>> exist within vmalloc'ed memory instead.
>>> This would hint at an issue with kvmalloc(), why not fixing it, instead
>>> of trying to fix all its users ?
> I agree with Eric.  There is nothing special in xtables compared to
> kvmalloc usage elsewhere in the stack.  Why "fix" xtables and not e.g.
> rhashtable?
>
> Please work with mm hackers to improve the situation for your use case.
>
> Maybe its enough to raise __GFP_NORETRY in kmalloc_gfp_adjust() if size
> results in >= PAGE_ALLOC_COSTLY_ORDER allocation.

Thanks for your reply! Perhaps this is the way to go, although this 
might have
much broader implications since there are tons of other callers to take 
into account.

I'm not sure whether rhashtable's size also directly depends on user 
input, I was only
aware of x_table since this is the case we ran into specifically.

>
>> Thanks for the quick reply! From my understanding, there is a lot of
>> callers of kvmalloc
>> who do indeed benefit from the physical memory being contiguous, because
>> it is then
>> used for hardware DMA etc., so I'm not sure that would be feasible.
> How can that work?  kvmalloc won't make vmalloc backed memory
> physically contiguous.

The allocated physical memory won't be contiguous only for fallback 
cases (which should be rare),
I assume in that case the hardware operation may end up being more 
expensive with larger scatter-gather
lists etc. So most of the time such code can take optimized paths for 
fully contiguous memory. This is not
the case for x_tables etc.

