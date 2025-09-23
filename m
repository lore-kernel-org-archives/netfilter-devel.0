Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF13595C;
	Tue, 23 Sep 2025 10:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622313; cv=none; b=Z+vm5qRN1fMFcHV5ij992YQQ3QzAq5ax7+AzMQXLe17bHnEDLwBt7/OWjgroqTW73zEQeMzf9ecbyLkJfGwx+feZfCSz1SYw2aOzcXq2bKczX+Q+PBDlwEsAVD4bc+02i2a4a8oNZmaCxEobH8rX0OWcrQMf6YTGhynRtWVdsaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622313; c=relaxed/simple;
	bh=GFmsJyXnqb++URYJgUqltJiv7Geg8m8D9ZUDLpR3hrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KId7Xh8x1Q1byEl+KONBezGSUnEH51NGhJbDkq8xtLYCojyQWs3U69BVQlmaYXxzsO8bprX5GQVwyXchayEfwcrkA/zYyiEHpKq6eeaixxM4Lcd1DecFknp+X8ZkfUdisakqA7THKtYPyOFdpqpp0qaqd117nTfNprGR/VxTXI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=fw9/bMSM; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="fw9/bMSM"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:7394:0:640:5a8a:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id D0034C028B;
	Tue, 23 Sep 2025 13:11:46 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:d98::1:24] (unknown [2a02:6bf:8080:d98::1:24])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id fBUo1C0GwGk0-UBWnQyRm;
	Tue, 23 Sep 2025 13:11:46 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1758622306;
	bh=mw66Zn9tRawIgkhwxW7ceJWPwiEJCHN3d99R4FBrImU=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=fw9/bMSMA9KYipgxy6El4P9xWafYO9DwKWVjYcukKtlDGR/uyXrR/mkXocJGqHjgZ
	 cHIyLofjzoUP76KtrAsNtuPD9s7ExMg/ZgOrX7rRs0AUP+I95Vqvp1TKG1NBIBdy7C
	 ZR3/FbZCjgI6D3rfSFs34JDy2gJ5C6a4flcKu25M=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <5f1ff52a-d2c2-40de-b00c-661b75c18dc7@yandex-team.ru>
Date: Tue, 23 Sep 2025 13:11:41 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] netfilter/x_tables: go back to using vmalloc for
 xt_table_info
To: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250922194819.182809-1-d-tatianin@yandex-team.ru>
 <20250922194819.182809-2-d-tatianin@yandex-team.ru>
 <CANn89i+GoVZLcdHxuf33HpmgyPNKxGqEjXGpi=XiB-QOsAG52A@mail.gmail.com>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <CANn89i+GoVZLcdHxuf33HpmgyPNKxGqEjXGpi=XiB-QOsAG52A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/25 12:12 AM, Eric Dumazet wrote:

> On Mon, Sep 22, 2025 at 12:48 PM Daniil Tatianin
> <d-tatianin@yandex-team.ru> wrote:
>> This code previously always used vmalloc for anything above
>> PAGE_ALLOC_COSTLY_ORDER, but this logic was changed in
>> commit eacd86ca3b036 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()").
>>
>> The commit that changed it did so because "xt_alloc_table_info()
>> basically opencodes kvmalloc()", which is not actually what it was
>> doing. kvmalloc() does not attempt to go directly to vmalloc if the
>> order the caller is trying to allocate is "expensive", instead it only
>> uses vmalloc as a fallback in case the buddy allocator is not able to
>> fullfill the request.
>>
>> The difference between the two is actually huge in case the system is
>> under memory pressure and has no free pages of a large order. Before the
>> change to kvmalloc we wouldn't even try going to the buddy allocator for
>> large orders, but now we would force it to try to find a page of the
>> required order by waking up kswapd/kcompactd and dropping reclaimable memory
>> for no reason at all to satisfy our huge order allocation that could easily
>> exist within vmalloc'ed memory instead.
> This would hint at an issue with kvmalloc(), why not fixing it, instead
> of trying to fix all its users ?

Thanks for the quick reply! From my understanding, there is a lot of 
callers of kvmalloc
who do indeed benefit from the physical memory being contiguous, because 
it is then
used for hardware DMA etc., so I'm not sure that would be feasible.

>
> There was a time where PAGE_ALLOC_COSTLY_ORDER was used.

Out of curiosity, do you mean kvmalloc used to always fall back to 
vmalloc for > COSTLY_ORDER?
If so, do you happen to know, which commit changed that behavior? I 
tried grepping the logs and
looking at the git blame of slub.c but I guess it was changed too long 
ago so I wasn't successful.

>
>
>
>> Revert the change to always call vmalloc, since this code doesn't really
>> benefit from contiguous physical memory, and the size it allocates is
>> directly dictated by the userspace-passed table buffer thus allowing it to
>> torture the buddy allocator by carefully crafting a huge table that fits
>> right at the maximum available memory order on the system.
>>
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
>> ---
>>   net/netfilter/x_tables.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index 90b7630421c4..c98f4b05d79d 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -1190,7 +1190,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>>          if (sz < sizeof(*info) || sz >= XT_MAX_TABLE_SIZE)
>>                  return NULL;
>>
>> -       info = kvmalloc(sz, GFP_KERNEL_ACCOUNT);
>> +       info = __vmalloc(sz, GFP_KERNEL_ACCOUNT);
>>          if (!info)
>>                  return NULL;
>>
>> @@ -1210,7 +1210,7 @@ void xt_free_table_info(struct xt_table_info *info)
>>                  kvfree(info->jumpstack);
>>          }
>>
>> -       kvfree(info);
>> +       vfree(info);
>>   }
>>   EXPORT_SYMBOL(xt_free_table_info);
>>
>> --
>> 2.34.1
>>
