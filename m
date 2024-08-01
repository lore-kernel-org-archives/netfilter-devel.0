Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B5182D8;
	Thu,  1 Aug 2024 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722534152; cv=none; b=MfbK1n2pme4qt1dSMUrsV07c/b5M2ixiuudslq779N4IIIiG7Bjl9LMWSGUAJX0ENF5sE9tvPahTMiwnYmSR2RcQhF89IbRUJCOxyiCi0cRg77LgZOImp9lU6rxUqiC0seJ9IFUg0kbsv4F9g7nE28vyi3XC3LOhuZk2A7EUeQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722534152; c=relaxed/simple;
	bh=cmfIGnKINzdZlBL5hIS52WEXlNaTuy02vwjO0xUPTfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LwJ+4zQhEEhFlRAz2T0Q0ePq2pj9PaZE5NLrHvzI3oPF/RAl/MWZ7gso0Q1W5JJ6I4plNfSNj0IqbuzM/miTP0ofTd14kgR0+2tWljOB5/cIoqRE+RaFEnUI8NZLKY0Xg42FIUc2mAuG3tz72WEpjZBT2UnTozvfW/L4x83L6fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WZbqS4hJnznctB;
	Fri,  2 Aug 2024 01:41:24 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 161531800A0;
	Fri,  2 Aug 2024 01:42:26 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 2 Aug 2024 01:42:22 +0800
Message-ID: <cc50cc99-a89b-9a02-e1a7-23fd5ef1093a@huawei-partners.com>
Date: Thu, 1 Aug 2024 20:42:18 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 7/9] selftests/landlock: Test listen on ULP socket
 without clone method
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-8-ivanov.mikhail1@huawei-partners.com>
 <20240801.rae2can8ooT9@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240801.rae2can8ooT9@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/1/2024 6:08 PM, Mickaël Salaün wrote:
> On Sun, Jul 28, 2024 at 08:26:00AM +0800, Mikhail Ivanov wrote:
>> Test checks that listen(2) doesn't wrongfully return -EACCES instead of
>> -EINVAL when trying to listen on a socket which is set to ULP that doesn't
>> have clone method in inet_csk(sk)->icsk_ulp_ops (espintcp).
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   tools/testing/selftests/landlock/config     |  1 +
>>   tools/testing/selftests/landlock/net_test.c | 38 +++++++++++++++++++++
>>   2 files changed, 39 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>> index 0086efaa7b68..014401fe6114 100644
>> --- a/tools/testing/selftests/landlock/config
>> +++ b/tools/testing/selftests/landlock/config
>> @@ -12,3 +12,4 @@ CONFIG_SHMEM=y
>>   CONFIG_SYSFS=y
>>   CONFIG_TMPFS=y
>>   CONFIG_TMPFS_XATTR=y
>> +CONFIG_INET_ESPINTCP=y
>> \ No newline at end of file
> 
> There are missing dependencies, and also please sort entries. I think it should
> be:
> 
>   CONFIG_CGROUPS=y
>   CONFIG_CGROUP_SCHED=y
>   CONFIG_INET=y
> +CONFIG_INET_ESPINTCP=y
> +CONFIG_INET_ESP=y
>   CONFIG_IPV6=y
> +CONFIG_IPV6_ESP=y
> +CONFIG_INET6_ESPINTCP=y
>   CONFIG_NET=y
>   CONFIG_NET_NS=y
>   CONFIG_OVERLAY_FS=y
> 
> This works with check-linux.sh from
> https://github.com/landlock-lsm/landlock-test-tools

Thanks, I'll fix this.

> 
> IPv6 is currently not tested, which should be the case (with the "protocol"
> variants).
