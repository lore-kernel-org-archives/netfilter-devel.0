Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAFB15B122;
	Sat,  5 Oct 2024 18:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153141; cv=none; b=jIOdkYgpjS3WIXXc3ex+iaZ+T68C5SuCidfO229juhEBHk2b+RKngUp5biHEN/kPMJbtcyHCSv+F+qZleMWtvwAubHz1SajJX9LFl0QwPZSzVDbUUxlvsUtLVpKReD4zolSp/d+yK1LmB0Go8FI2/4tVaHItQ6z/eWEi4KMMfwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153141; c=relaxed/simple;
	bh=4TgtMzQ2frjKLCe7JvlupUDfeuKbwFeVOZauDhWDRrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HlSVPe17RCXinTayxG+OWoM9vRc0ksot085oVU8X+8tKFN0aijyKRGPkU8t3NL6Xj5aeDv267rAUNtGXtVbCSv+R0vsg0zX/rBGlaNQii5lqvBmt5OrS845emfN5IltuvUNzhhKsGshNx3ul1k9k14njnSEe/inMXxZvn2UF+Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XLYt50JPKz1ymlj;
	Sun,  6 Oct 2024 02:32:13 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 5097714022D;
	Sun,  6 Oct 2024 02:32:09 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 6 Oct 2024 02:32:05 +0800
Message-ID: <fd3760b7-7e66-e426-22fe-24170cf43f33@huawei-partners.com>
Date: Sat, 5 Oct 2024 21:32:01 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/9] landlock: Support TCP listen access-control
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-3-ivanov.mikhail1@huawei-partners.com>
 <20241005.bd6123d170b4@gnoack.org>
 <47ff2457-59e2-b08e-0bb4-5d7c70be2ad1@huawei-partners.com>
 <20241005.e820f4fae74e@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241005.e820f4fae74e@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 10/5/2024 9:22 PM, Günther Noack wrote:
> On Sat, Oct 05, 2024 at 08:53:55PM +0300, Mikhail Ivanov wrote:
>> On 10/5/2024 7:56 PM, Günther Noack wrote:
>>> On Wed, Aug 14, 2024 at 11:01:44AM +0800, Mikhail Ivanov wrote:
>>>> +	port = htons(inet_sk(sk)->inet_num);
>>>> +	release_sock(sk);
>>>> +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
>>>
>>> Nit: The last two lines could just be
>>>
>>>     err = check_access_socket(...);
>>>
>>> and then you would only need the release_sock(sk) call in one place.
>>> (And maybe rename the goto label accordingly.)
>> This split was done in order to not hold socket lock while doing some
>> Landlock-specific logic. It might be identical in performance to
>> your suggestion, but I thought that (1) security module should have as
>> little impact on network stack as possible and (2) it is more
>> clear that locking is performed only for a few socket state checks which
>> are not related to the access control.
>>
>> I'll add this explanation with a comment if you agree that everything is
>> correct.
> 
> 
> IMHO, when you grab a lock in this function, it is clear that you'd
> unconditionally want to release it before you return from the
> function, and that in C, the normal way to guarantee unconditional
> cleanup work would be to apply the "single exit point" rule.

Yes, these 2 release_lock()s can really raise questions when reading.

> 
> That being said, the scenario is simple enough here that it's not a
> big issue in my eyes.  It was more of a minor nit about having more
> than one place where the lock has to be released.  Either way is fine
> (and also should not require excessive comments :)).

Ok

> 
>>>> +
>>>> +release_nocheck:
>>>> +	release_sock(sk);
>>>> +	return err;
>>>> +}
> 
> –Günther
