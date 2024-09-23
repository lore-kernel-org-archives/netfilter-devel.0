Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB136BFC7;
	Mon, 23 Sep 2024 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727103931; cv=none; b=FUUync9bDJq84KZmnr4Cb0saGMQXeO7213goSWMXDafy/XhiDdZfG3zIcTIKXejgdF1W0mY5MQ5S6HdVvkHHtDvirA1ZjsAYjuDRnp0DdIcLfbNM9GYs8vZv8eBo/IBs5mT+IMBV08VYEl1Svq2o+CO+sCeIa4eirR8gM1FXtCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727103931; c=relaxed/simple;
	bh=kcwURsfs+4HqgkiR2fGs+ShStw7nDn6N5z+9REMEdBE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=D7St12ed15FHreowa4vm8ccLgdQspZcjZLsIfA6+BhjF9NyR/yg3jOOMkoiFZ/vXrKPQGuPwPAChdXN2eyvzyZGgm+tdVrXSboXF48w7J6m0VI4fw33mcOc+3tGNq9NLvI3smcn5rJDNnvIR7SS7ZLdItg7MikvmPSpj4Fpu8Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XC5mc72pDz1HK3k;
	Mon, 23 Sep 2024 23:01:36 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 7753A1400F4;
	Mon, 23 Sep 2024 23:05:25 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 23 Sep 2024 23:05:22 +0800
Message-ID: <2567b018-c536-0bb9-9b2d-fb0ffb2b5ae8@huawei-partners.com>
Date: Mon, 23 Sep 2024 18:05:18 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/4] Implement performance impact measurement tool
Content-Language: ru
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240816005943.1832694-1-ivanov.mikhail1@huawei-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 8/16/2024 3:59 AM, Mikhail Ivanov wrote:
> Hello! This is v1 RFC patch dedicated to Landlock performance measurement.
> 
> Landlock LSM hooks are executed with many operations on Linux internal
> objects (files, sockets). This hooks can noticeably affect performance
> of such operations as it was demonstrated in the filesystem caching
> patchset [1]. Having ability to calculate Landlock performance overhead
> allows to compare kernel changes and estimate the acceptability
> of new features (e.g. [2], [3], [4]).

Hello! Kindly reminder about this patchset. UDP-dedicated RFC v1 [1]
patchset was published and this patchset can be useful to benchmark
sendmsg/recvmsg hooks. But it would probably be better to apply other
network patches first. WDYT?

[1] 
https://lore.kernel.org/all/20240916122230.114800-1-matthieu@buffet.re/#t
