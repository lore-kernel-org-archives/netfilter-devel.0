Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AAF13D28C;
	Thu,  6 Jun 2024 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717674280; cv=none; b=jCkNZ55jd5ZHU64bpFiDsT3mAt7XEFr/NIEu7EAgSVYaVh0zhRc1QtaLaNOQbkp4LptOablEINd/NoykLBHaxcXNWdWUzQhbJL9hSYhPBqprq2w1k6KQUyvfWX+lT1HqLyXlIi6mbLCQ7T+Un0dUBKcCRmxLPFSragBqPAc8RTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717674280; c=relaxed/simple;
	bh=nUpqla2jcsToxh54iswvNIOvkWWhl1XB8V75JEur0Aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PEUtVqjlUxsgmOIRiRBAxly6KX7soPtT9Xlqwn6ojCATVyozdcqultHP0UHNbehMxXQq1jbG/OHxQRJXmnPeHaC2YxkceOGOSyPhBi8Xw9lhSxi0bX7k5gTm2L13cZp3XNMuW/4Ok3V043lJqIGkG0if61pFRNVeoEaxohPBUwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Vw2SG4xqFzmW4P;
	Thu,  6 Jun 2024 19:39:58 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 78F6F14022D;
	Thu,  6 Jun 2024 19:44:33 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 19:44:29 +0800
Message-ID: <ebd680cc-25d6-ee14-4856-310f5e5e28e4@huawei-partners.com>
Date: Thu, 6 Jun 2024 14:44:23 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/12] Socket type control for Landlock
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240604.c18387da7a0e@gnoack.org>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240604.c18387da7a0e@gnoack.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)



6/4/2024 11:22 PM, Günther Noack wrote:
> On Fri, May 24, 2024 at 05:30:03PM +0800, Mikhail Ivanov wrote:
>> Hello! This is v2 RFC patch dedicated to socket protocols restriction.
>>
>> It is based on the landlock's mic-next branch on top of v6.9 kernel
>> version.
> 
> Hello Mikhail!
> 
> I patched in your patchset and tried to use the feature with a small
> demo tool, but I ran into what I think is a bug -- do you happen to
> know what this might be?
> 
> I used 6.10-rc1 as a base and patched your patches on top.
> 
> The code is a small tool called "nonet", which does the following:
> 
>    - Disable socket creation with a Landlock ruleset with the following
>      attributes:
>    
>      struct landlock_ruleset_attr attr = {
>        .handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>      };
> 
>    - open("/dev/null", O_WRONLY)
> 
> Expected result:
> 
>    - open() should work
> 
> Observed result:
> 
>    - open() fails with EACCES.
> 
> I traced this with perf, and found that the open() gets rejected from
> Landlock's hook_file_open, whereas hook_socket_create does not get
> invoked.  This is surprising to me -- Enabling a policy for socket
> creation should not influence the outcome of opening files!
> 
> Tracing commands:
> 
>    sudo perf probe hook_socket_create '$params'
>    sudo perf probe 'hook_file_open%return $retval'
>    sudo perf record -e 'probe:*' -g -- ./nonet
>    sudo perf report
>   
> You can find the tool in my landlock-examples repo in the nonet_bug branch:
> https://github.com/gnoack/landlock-examples/blob/nonet_bug/nonet.c
> 
> Landlock is enabled like this:
> https://github.com/gnoack/landlock-examples/blob/nonet_bug/sandbox_socket.c
> 
> Do you have a hunch what might be going on?

Hello Günther!
Big thanks for this research!

I figured out that I define LANDLOCK_SHIFT_ACCESS_SOCKET macro in
really strange way (see landlock/limits.h):

   #define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET

With this definition, socket access mask overlaps the fs access
mask in ruleset->access_masks[layer_level]. That's why
landlock_get_fs_access_mask() returns non-zero mask in hook_file_open().

So, the macro must be defined in this way:

   #define LANDLOCK_SHIFT_ACCESS_SOCKET	(LANDLOCK_NUM_ACCESS_NET +
                                          LANDLOCK_NUM_ACCESS_FS)

With this fix, open() doesn't fail in your example.

I'm really sorry that I somehow made such a stupid typo. I will try my
best to make sure this doesn't happen again.

> 
> Thanks,
> –Günther
> 
