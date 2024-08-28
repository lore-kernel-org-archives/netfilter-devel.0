Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B2C15746F;
	Wed, 28 Aug 2024 07:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828843; cv=none; b=pGNSsvPDc0tBDiqeZxVz/CTuVf+/iwVKpRvRs4uy6qxHcjC9qwJ492bU0R9RvwQ1UuKfLJ0MFOTtkl82JW7k9/8OMDPsVblzpofKqrN4xT/nW4QRZbRAlqOt0nGhjcMkIIccWOmJUHwbPb3KpfzPA9Ie3NZD0gojOiyRbk8I7zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828843; c=relaxed/simple;
	bh=baz+r8sOC5vESVgOK6V0Pgo9GoPVQ9PgVhZe276Dig4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MrthAyYH88s+Qn0GzvTJCD33MN+xU1uKyH5EjPX9/RWa1Qat1IMhy6EhECb3mNk/k6T24WS5JiKqGzvlBIMh08luYrHBKhfcclkmBlfR4iafj4t9cNdFNTpH5q1dB3BZFXbdu2LZXai6QVn6LzAqhv8VtCxDCqeWSgyKX9o0HAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WtwT83VjKz2DbZT;
	Wed, 28 Aug 2024 15:07:08 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id 966C01401F1;
	Wed, 28 Aug 2024 15:07:19 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemh500013.china.huawei.com (7.202.181.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 28 Aug 2024 15:07:18 +0800
Message-ID: <9f8e0482-0521-a4e2-45f9-256b42927d06@huawei.com>
Date: Wed, 28 Aug 2024 15:07:18 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH -next 0/5] net: Use kmemdup_array() instead of kmemdup()
 for multiple allocation
Content-Language: en-US
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <dsahern@kernel.org>,
	<krzk@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240828071004.1245213-1-ruanjinjie@huawei.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20240828071004.1245213-1-ruanjinjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemh500013.china.huawei.com (7.202.181.146)

Please ignore this email, didn't notice there was already a patch for this

On 2024/8/28 15:09, Jinjie Ruan wrote:
> Let the kmemdup_array() take care about multiplication and possible
> overflows.
> 
> Jinjie Ruan (5):
>   nfc: core: Use kmemdup_array() instead of kmemdup() for multiple
>     allocation
>   netfilter: Use kmemdup_array() instead of kmemdup() for multiple
>     allocation
>   netfilter: arptables: Use kmemdup_array() instead of kmemdup() for
>     multiple allocation
>   netfilter: iptables: Use kmemdup_array() instead of kmemdup() for
>     multiple allocation
>   netfilter: nf_nat: Use kmemdup_array() instead of kmemdup() for
>     multiple allocation
> 
>  net/bridge/netfilter/ebtables.c | 2 +-
>  net/ipv4/netfilter/arp_tables.c | 2 +-
>  net/ipv4/netfilter/ip_tables.c  | 2 +-
>  net/netfilter/nf_nat_core.c     | 2 +-
>  net/nfc/core.c                  | 5 ++---
>  5 files changed, 6 insertions(+), 7 deletions(-)
> 
