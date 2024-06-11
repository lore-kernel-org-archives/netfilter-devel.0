Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F51E17C7D3;
	Tue, 11 Jun 2024 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718105763; cv=none; b=Nj/f8sxN4odXUGZvxbvLO09lV3Mnp592qt8Ikyk9Neb2IG4aS9igUl7YC+NcL0ZNxPKDBTDEdvqaRJK2XJ6BAf31RO7YWr1xgRbB6KQ4sOmWugarPyLb/xtG6EqCHs1M1PO6GxGCcl6cskty2xXKFhbiwBNNj+xHAnloB9FlncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718105763; c=relaxed/simple;
	bh=X+Vr5x7b/jaeilN4C9JCZliYRRivqC4zJPAs6RBXedg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dwVpnIOGa6LjvhUzHk1Fl2t1FfFg9Iu8y0Lzw3qF/h1SIgs2LKimsDiXM4lgzTLY/qN+dQdOLPtfO22qjBbK0qJ11atEsgK4afFURVbkLGBWsZSmWczb4qAqTOyCIs79355tn9VFeps7vKYLgR3/wQxrGDxXyXnSlYwl9urb5p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Vz63H1gk6zPqgD;
	Tue, 11 Jun 2024 19:32:27 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EDDE18006C;
	Tue, 11 Jun 2024 19:35:51 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 19:35:46 +0800
Message-ID: <00f459b5-8aac-4312-8327-fa2bb4964ba6@huawei-partners.com>
Date: Tue, 11 Jun 2024 14:35:41 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/12] Socket type control for Landlock
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>, <mic@digikod.net>,
	<willemdebruijn.kernel@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, Tahera Fahimi <fahimitahera@gmail.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240604.c18387da7a0e@gnoack.org>
 <ebd680cc-25d6-ee14-4856-310f5e5e28e4@huawei-partners.com>
 <ZmazTKVNlsH3crwP@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZmazTKVNlsH3crwP@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 dggpemm500020.china.huawei.com (7.185.36.49)

6/10/2024 11:03 AM, Günther Noack wrote:
> On Thu, Jun 06, 2024 at 02:44:23PM +0300, Mikhail Ivanov wrote:
>> 6/4/2024 11:22 PM, Günther Noack wrote:
>> I figured out that I define LANDLOCK_SHIFT_ACCESS_SOCKET macro in
>> really strange way (see landlock/limits.h):
>>
>>    #define LANDLOCK_SHIFT_ACCESS_SOCKET	LANDLOCK_NUM_ACCESS_SOCKET
>>
>> With this definition, socket access mask overlaps the fs access
>> mask in ruleset->access_masks[layer_level]. That's why
>> landlock_get_fs_access_mask() returns non-zero mask in hook_file_open().
>>
>> So, the macro must be defined in this way:
>>
>>    #define LANDLOCK_SHIFT_ACCESS_SOCKET	(LANDLOCK_NUM_ACCESS_NET +
>>                                           LANDLOCK_NUM_ACCESS_FS)
>>
>> With this fix, open() doesn't fail in your example.
>>
>> I'm really sorry that I somehow made such a stupid typo. I will try my
>> best to make sure this doesn't happen again.
> 
> I found that we had the exact same bug with a wrongly defined "SHIFT" value in
> [1].
> 
> Maybe we should define access_masks_t as a bit-field rather than doing the
> bit-shifts by hand.  Then the compiler would keep track of the bit-offsets
> automatically.
> 
> Bit-fields have a bad reputation, but in my understanding, this is largely
> because they make it hard to control the exact bit-by-bit layout.  In our case,
> we do not need such an exact control though, and it would be fine.
> 
> To quote Linus Torvalds on [2],
> 
>    Bitfields are fine if you don't actually care about the underlying format,
>    and want gcc to just randomly assign bits, and want things to be
>    convenient in that situation.
> 
> Let me send you a proposal patch which replaces access_masks_t with a bit-field
> and removes the need for the "SHIFT" definition, which we already got wrong in
> two patch sets now.  It has the additional benefit of making the code a bit
> shorter and also removing a few static_assert()s which are now guaranteed by the
> compiler.
> 
> —Günther
> 
> [1] https://lore.kernel.org/all/ZmLEoBfHyUR3nKAV@google.com/
> [2] https://yarchive.net/comp/linux/bitfields.html

Thank you, Günther! It really looks more clear.

This patch should be applied to Landlock separately, right?
