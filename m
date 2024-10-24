Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB9EEA6;
	Thu, 24 Oct 2024 01:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729735058; cv=none; b=aJfXAOgEuTpvXW9QjABhnFbaXyhfDLTMr2jJFT35+tve9tM6L2pIk9brtTOYN2Z60WQZuu1m9kziX2JGUU7roHBZHYIepXLX8EQYDIrmBUv2GLxOqsVl18niz8xHbODIKOSWOVX9HhLYxIOGZU4VXl4DDyOtU3NXChiKbmzU/xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729735058; c=relaxed/simple;
	bh=oZMUhWVO7+3xn3dgd26Vi2YryHIADS7A4b4fmRkRi4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pDp6Tbb1YDXXMdMcFfqhVHOQPAT24/hescmUKZIvOPRujilJBsFKC+jaHBNKz8Vf+rWDGZHMAF7I+Up4ieq7+tPAuGN0pjZsL9ZIsSFlvvX55Qvr99tzOx3OZ1fiPmVBk8+sBugMg83tXN7tsog+1jGuKyavWu03UeEch3vaewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XYpss1kfPz1SD6P;
	Thu, 24 Oct 2024 09:56:01 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (unknown [7.221.188.33])
	by mail.maildlp.com (Postfix) with ESMTPS id C530A1A016C;
	Thu, 24 Oct 2024 09:57:25 +0800 (CST)
Received: from [10.174.177.223] (10.174.177.223) by
 kwepemd100023.china.huawei.com (7.221.188.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 24 Oct 2024 09:57:24 +0800
Message-ID: <e1f97171-8655-44be-b3e4-ce4c4c197e8a@huawei.com>
Date: Thu, 24 Oct 2024 09:57:23 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
To: Dan Carpenter <dan.carpenter@linaro.org>, <oe-kbuild@lists.linux.dev>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<fw@strlen.de>, <kuniyu@amazon.com>
CC: <lkp@intel.com>, <oe-kbuild-all@lists.linux.dev>,
	<netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<yuehaibing@huawei.com>
References: <01b2bdd1-39f4-43d1-a7e6-f8e8061175a4@stanley.mountain>
From: "dongchenchen (A)" <dongchenchen2@huawei.com>
In-Reply-To: <01b2bdd1-39f4-43d1-a7e6-f8e8061175a4@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd100023.china.huawei.com (7.221.188.33)


On 2024/10/24 1:16, Dan Carpenter wrote:
> Hi Dong,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Dong-Chenchen/net-netfilter-Fix-use-after-free-in-get_info/20241022-165936
> base:   net/main
> patch link:    https://lore.kernel.org/r/20241022085753.2069639-1-dongchenchen2%40huawei.com
> patch subject: [PATCH net] net: netfilter: Fix use-after-free in get_info()
> config: x86_64-randconfig-161-20241023 (https://download.01.org/0day-ci/archive/20241024/202410240020.Cqi2d68p-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202410240020.Cqi2d68p-lkp@intel.com/
>
> smatch warnings:
> net/netfilter/x_tables.c:1280 xt_find_table_lock() warn: passing zero to 'ERR_PTR'
>
> vim +/ERR_PTR +1280 net/netfilter/x_tables.c
>
> 03d13b6868a261 Florian Westphal  2017-12-08  1234  /* Find table by name, grabs mutex & ref.  Returns ERR_PTR on error. */
> 76108cea065cda Jan Engelhardt    2008-10-08  1235  struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
> 76108cea065cda Jan Engelhardt    2008-10-08  1236  				    const char *name)
> 2e4e6a17af35be Harald Welte      2006-01-12  1237  {
> 1d610d4d31a8ed Florian Westphal  2021-04-01  1238  	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
> fdacd57c79b79a Florian Westphal  2021-08-03  1239  	struct module *owner = NULL;
> fdacd57c79b79a Florian Westphal  2021-08-03  1240  	struct xt_template *tmpl;
> fdacd57c79b79a Florian Westphal  2021-08-03  1241  	struct xt_table *t;
> f4f502d5a8ea29 Dong Chenchen     2024-10-22  1242  	int err = -ENOENT;
> 2e4e6a17af35be Harald Welte      2006-01-12  1243
> 7926dbfa4bc14e Pablo Neira Ayuso 2014-07-31  1244  	mutex_lock(&xt[af].mutex);
> 1d610d4d31a8ed Florian Westphal  2021-04-01  1245  	list_for_each_entry(t, &xt_net->tables[af], list)
> 2e4e6a17af35be Harald Welte      2006-01-12  1246  		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
> 2e4e6a17af35be Harald Welte      2006-01-12  1247  			return t;
> b9e69e12739718 Florian Westphal  2016-02-25  1248
> fdacd57c79b79a Florian Westphal  2021-08-03  1249  	/* Table doesn't exist in this netns, check larval list */
> fdacd57c79b79a Florian Westphal  2021-08-03  1250  	list_for_each_entry(tmpl, &xt_templates[af], list) {
> fdacd57c79b79a Florian Westphal  2021-08-03  1251  		if (strcmp(tmpl->name, name))
> b9e69e12739718 Florian Westphal  2016-02-25  1252  			continue;
> fdacd57c79b79a Florian Westphal  2021-08-03  1253  		if (!try_module_get(tmpl->me))
> 03d13b6868a261 Florian Westphal  2017-12-08  1254  			goto out;
> fdacd57c79b79a Florian Westphal  2021-08-03  1255
> fdacd57c79b79a Florian Westphal  2021-08-03  1256  		owner = tmpl->me;
> fdacd57c79b79a Florian Westphal  2021-08-03  1257
> b9e69e12739718 Florian Westphal  2016-02-25  1258  		mutex_unlock(&xt[af].mutex);
> fdacd57c79b79a Florian Westphal  2021-08-03  1259  		err = tmpl->table_init(net);
> 03d13b6868a261 Florian Westphal  2017-12-08  1260  		if (err < 0) {
> fdacd57c79b79a Florian Westphal  2021-08-03  1261  			module_put(owner);
> 03d13b6868a261 Florian Westphal  2017-12-08  1262  			return ERR_PTR(err);
> b9e69e12739718 Florian Westphal  2016-02-25  1263  		}
> b9e69e12739718 Florian Westphal  2016-02-25  1264

If rmmod is executed concurrently here, xtable will be remove from 
xt_net list，

which may lead to ERR_PTR(0).

Thank you for your review. v2 has been sent

> b9e69e12739718 Florian Westphal  2016-02-25  1265  		mutex_lock(&xt[af].mutex);
> b9e69e12739718 Florian Westphal  2016-02-25  1266  		break;
> b9e69e12739718 Florian Westphal  2016-02-25  1267  	}
> b9e69e12739718 Florian Westphal  2016-02-25  1268
> f4f502d5a8ea29 Dong Chenchen     2024-10-22  1269  	if (err < 0)
> f4f502d5a8ea29 Dong Chenchen     2024-10-22  1270  		goto out;
> f4f502d5a8ea29 Dong Chenchen     2024-10-22  1271
> b9e69e12739718 Florian Westphal  2016-02-25  1272  	/* and once again: */
> 1d610d4d31a8ed Florian Westphal  2021-04-01  1273  	list_for_each_entry(t, &xt_net->tables[af], list)
> b9e69e12739718 Florian Westphal  2016-02-25  1274  		if (strcmp(t->name, name) == 0)
> b9e69e12739718 Florian Westphal  2016-02-25  1275  			return t;
>
> ret it zero here, but if we fail to find the name then we should set ret =
> -ENOENT;
>
> b9e69e12739718 Florian Westphal  2016-02-25  1276
> fdacd57c79b79a Florian Westphal  2021-08-03  1277  	module_put(owner);
> b9e69e12739718 Florian Westphal  2016-02-25  1278   out:
> 9e19bb6d7a0959 Ingo Molnar       2006-03-25  1279  	mutex_unlock(&xt[af].mutex);
> f4f502d5a8ea29 Dong Chenchen     2024-10-22 @1280  	return ERR_PTR(err);
> 2e4e6a17af35be Harald Welte      2006-01-12  1281  }
>
