Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0CF16F0C1;
	Thu, 30 May 2024 12:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071638; cv=none; b=NO5UkpIFP3U434H7ACjAz4vHM7M9jhBqjAI33q/lUMPctMfVFQnmbI2tdkUQcCQ7p0rSo2z9OF5B81HsXjcu41vE0edxYm/vvJrN69dcYGA7SAWx1jUxjyq7+Pe0nF3DgNcc8dpUqad6lF8uSC9Aae/IbPypSdXLLwzgG5VzY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071638; c=relaxed/simple;
	bh=9iJ/TuMIlthLg5LqLwNJiT/ocP0v0J3ubZ8OoWOEiZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=POhrlJQPoHP6BvEDAa2d2XzY8X27OwOOqkj/nrg/Ww3MaJDA0M58W6Nw++kc/3yjNjb56zqFB6G9ADEV6ta/HZd9ct5ZRvnOK5ITUnt+bh6lSvTQ5lckMK1OrvrBgJvbcqjH86PtAViWs7pfgvD5Q/67TMe75GiG5wWsVGrMqeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Vqlfj3qQbzckHh;
	Thu, 30 May 2024 20:19:09 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id DF57B18007A;
	Thu, 30 May 2024 20:20:30 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 20:20:26 +0800
Message-ID: <3cd4fad8-d72e-87cd-3cf9-2648a770f13c@huawei-partners.com>
Date: Thu, 30 May 2024 15:20:21 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/12] landlock: Add hook on socket creation
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-3-ivanov.mikhail1@huawei-partners.com>
 <ZlRI-gqDNkYOV_Th@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlRI-gqDNkYOV_Th@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/27/2024 11:48 AM, Günther Noack wrote:
> Hello Mikhail!
> 
> Thanks for sending another revision of this patch set!
> 
> On Fri, May 24, 2024 at 05:30:05PM +0800, Mikhail Ivanov wrote:
>> Add hook to security_socket_post_create(), which checks whether the socket
>> type and family are allowed by domain. Hook is called after initializing
>> the socket in the network stack to not wrongfully return EACCES for a
>> family-type pair, which is considered invalid by the protocol.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> 
> ## Some observations that *do not* need to be addressed in this commit, IMHO:
> 
> get_raw_handled_socket_accesses, get_current_socket_domain and
> current_check_access_socket are based on the similarly-named functions from
> net.c (and fs.c), and it makes sense to stay consistent with these.
> 
> There are some possible refactorings that could maybe be applied to that code,
> but given that the same ones would apply to net.c as well, it's probably best to
> address these separately.
> 
>    * Should get_raw_handled_socket_accesses be inlined
It's a fairly simple and compact function, so compiler should inline it
without any problems. Mickaël was against optional inlines [1].

[1] 
https://lore.kernel.org/linux-security-module/5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net/

>    * Does the WARN_ON_ONCE(dom->num_layers < 1) check have the right return code?

Looks like a rudimental check. `dom` is always NULL when `num_layers`< 1
(see get_*_domain functions).

>    * Can we refactor out commonalities (probably not worth it right now though)?

I had a few ideas about refactoring commonalities, as currently landlock
has several repetitive patterns in the code. But solution requires a
good design and a separate patch. Probably it's worth opening an issue
on github. WDYT?

> 
> 
> ## The only actionable feedback that I have that is specific to this commit is:
> 
> In the past, we have introduced new (non-test) Landlock functionality in a
> single commit -- that way, we have no "loose ends" in the code between these two
> commits, and that simplifies it for people who want to patch your feature onto
> other kernel trees.  (e.g. I think we should maybe merge commit 01/12 and 02/12
> into a single commit.)  WDYT?

Yeah, this two should be merged and tests commits as well. I just wanted
to do this in one of the latest patch versions to simplify code review.

> 
> —Günther
