Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A49198E7F;
	Tue, 22 Oct 2024 09:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588984; cv=none; b=cnBcdD7cOY4VWxdy054jvRBkSaxRuX/fxAWJ6mZ+X54ggY3Z+xGY+IAEFcDIRwU30gJpud4RTo/cHpdlXmbMSvCpbo+lp9F+AyLbyRY+tdrW1Yb4H/g/AIoQS7f1wHQNgwsudwDpuFTZgn1ofGdM3f2WJ6P9V2uTq4clnzgz/gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588984; c=relaxed/simple;
	bh=kJ2S20Sg7oN3zYohr7hzpWZrhh5+78y+mYTmv+AwEIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rBRdnlMEOOY1x6yx7iqdkBqVlT3TI3Ae3DU5SfqqLsVVeTa2WMSsawKjCELysQUq2kdPVdOVQ8MQOmYTMU5DvFwppLqV1j4FoUbq7b70i7/+mAS2XM88+HUVPLNpFz/avBhV3BLLD1EmbkHnzQJdyK6nyROp98v2YDARaUvuGE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XXmrB3N3Pz10N0G;
	Tue, 22 Oct 2024 17:20:58 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E0C4140360;
	Tue, 22 Oct 2024 17:22:59 +0800 (CST)
Received: from [10.174.179.113] (10.174.179.113) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 22 Oct 2024 17:22:58 +0800
Message-ID: <8ab6afec-b021-5327-9be4-c58c1e29b874@huawei.com>
Date: Tue, 22 Oct 2024 17:22:57 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Content-Language: en-US
To: Dong Chenchen <dongchenchen2@huawei.com>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <fw@strlen.de>, <kuniyu@amazon.com>
CC: <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20241022085753.2069639-1-dongchenchen2@huawei.com>
From: Yue Haibing <yuehaibing@huawei.com>
In-Reply-To: <20241022085753.2069639-1-dongchenchen2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

On 2024/10/22 16:57, Dong Chenchen wrote:
> ip6table_nat module unload has refcnt warning for UAF. call trace is:
> 
> WARNING: CPU: 1 PID: 379 at kernel/module/main.c:853 module_put+0x6f/0x80
> Modules linked in: ip6table_nat(-)
> CPU: 1 UID: 0 PID: 379 Comm: ip6tables Not tainted 6.12.0-rc4-00047-gc2ee9f594da8-dirty #205
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> RIP: 0010:module_put+0x6f/0x80
> Call Trace:
>  <TASK>
>  get_info+0x128/0x180
>  do_ip6t_get_ctl+0x6a/0x430
>  nf_getsockopt+0x46/0x80
>  ipv6_getsockopt+0xb9/0x100
>  rawv6_getsockopt+0x42/0x190
>  do_sock_getsockopt+0xaa/0x180
>  __sys_getsockopt+0x70/0xc0
>  __x64_sys_getsockopt+0x20/0x30
>  do_syscall_64+0xa2/0x1a0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Concurrent execution of module unload and get_info() trigered the warning.
> The root cause is as follows:
> 
> cpu0				      cpu1
> module_exit
> //mod->state = MODULE_STATE_GOING
>   ip6table_nat_exit
>     xt_unregister_template
>     //remove table from templ list
> 				      getinfo()
> 					  t = xt_find_table_lock
> 						list_for_each_entry(tmpl, &xt_templates[af]...)
> 							if (strcmp(tmpl->name, name))
> 								continue;  //table not found
> 							try_module_get
> 						list_for_each_entry(t, &xt_net->tables[af]...)
> 							return t;  //not get refcnt
> 					  module_put(t->me) //uaf
>     unregister_pernet_subsys
>     //remove table from xt_net list
> 
> While xt_table module was going away and has been removed from
> xt_templates list, we couldnt get refcnt of xt_table->me. Skip
> the re-traversal of xt_net->tables list to fix it.
> 
> Fixes: c22921df777d ("netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().")

This should be
Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")

> Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
> ---
>  net/netfilter/x_tables.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index da5d929c7c85..359c880ecb07 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  	struct module *owner = NULL;
>  	struct xt_template *tmpl;
>  	struct xt_table *t;
> +	int err = -ENOENT;
>  
>  	mutex_lock(&xt[af].mutex);
>  	list_for_each_entry(t, &xt_net->tables[af], list)
> @@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  
>  	/* Table doesn't exist in this netns, check larval list */
>  	list_for_each_entry(tmpl, &xt_templates[af], list) {
> -		int err;
> -
>  		if (strcmp(tmpl->name, name))
>  			continue;
>  		if (!try_module_get(tmpl->me))
> @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  		break;
>  	}
>  
> +	if (err < 0)
> +		goto out;
> +
>  	/* and once again: */
>  	list_for_each_entry(t, &xt_net->tables[af], list)
>  		if (strcmp(t->name, name) == 0)
> @@ -1275,7 +1277,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
>  	module_put(owner);
>   out:
>  	mutex_unlock(&xt[af].mutex);
> -	return ERR_PTR(-ENOENT);
> +	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL_GPL(xt_find_table_lock);
>  
