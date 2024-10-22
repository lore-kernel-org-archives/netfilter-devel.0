Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF8A19923D;
	Tue, 22 Oct 2024 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729587458; cv=none; b=NLgUJ2GlDSldq2Y9jbXwelaQvlo/A1qnRM6XPWooIN3CAS8Ullns3LJE3JNyJmSX/C04BKAalRQ43g1lYTHd0oUIAS9J/Q8LNnUii8FQayD52x0Q1u9D4tto3GfbJHhrQL5omoOj/JNSb4btLyrNQAGebtjX9kclwb6ZpkHWyVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729587458; c=relaxed/simple;
	bh=CSDIdrsCl4FE8/0Omz+BP48e9uK4dqAaWfIDnDhupAI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WXzguizmhDZkG8qRcTKP1CYsRqUXn0OIjqQtBJDv/8ikRAM/wsdiz//gDKs1Sdh/kD/ICLidx+A/SKsKd7zahT11YlRub4mlHmfrF5s4XcjE0v+8oTO3/9sMTOliUiLlmYyI7Uft8ZN7Qn/2029h7OU877aNLgd8PrC3Oz5+lXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XXmJB0bd8z20qdB;
	Tue, 22 Oct 2024 16:56:42 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (unknown [7.221.188.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A28861400CB;
	Tue, 22 Oct 2024 16:57:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 kwepemd100023.china.huawei.com (7.221.188.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 22 Oct 2024 16:57:31 +0800
From: Dong Chenchen <dongchenchen2@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<fw@strlen.de>, <kuniyu@amazon.com>
CC: <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<yuehaibing@huawei.com>, Dong Chenchen <dongchenchen2@huawei.com>
Subject: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Date: Tue, 22 Oct 2024 16:57:53 +0800
Message-ID: <20241022085753.2069639-1-dongchenchen2@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd100023.china.huawei.com (7.221.188.33)

ip6table_nat module unload has refcnt warning for UAF. call trace is:

WARNING: CPU: 1 PID: 379 at kernel/module/main.c:853 module_put+0x6f/0x80
Modules linked in: ip6table_nat(-)
CPU: 1 UID: 0 PID: 379 Comm: ip6tables Not tainted 6.12.0-rc4-00047-gc2ee9f594da8-dirty #205
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:module_put+0x6f/0x80
Call Trace:
 <TASK>
 get_info+0x128/0x180
 do_ip6t_get_ctl+0x6a/0x430
 nf_getsockopt+0x46/0x80
 ipv6_getsockopt+0xb9/0x100
 rawv6_getsockopt+0x42/0x190
 do_sock_getsockopt+0xaa/0x180
 __sys_getsockopt+0x70/0xc0
 __x64_sys_getsockopt+0x20/0x30
 do_syscall_64+0xa2/0x1a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Concurrent execution of module unload and get_info() trigered the warning.
The root cause is as follows:

cpu0				      cpu1
module_exit
//mod->state = MODULE_STATE_GOING
  ip6table_nat_exit
    xt_unregister_template
    //remove table from templ list
				      getinfo()
					  t = xt_find_table_lock
						list_for_each_entry(tmpl, &xt_templates[af]...)
							if (strcmp(tmpl->name, name))
								continue;  //table not found
							try_module_get
						list_for_each_entry(t, &xt_net->tables[af]...)
							return t;  //not get refcnt
					  module_put(t->me) //uaf
    unregister_pernet_subsys
    //remove table from xt_net list

While xt_table module was going away and has been removed from
xt_templates list, we couldnt get refcnt of xt_table->me. Skip
the re-traversal of xt_net->tables list to fix it.

Fixes: c22921df777d ("netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
---
 net/netfilter/x_tables.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index da5d929c7c85..359c880ecb07 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 	struct module *owner = NULL;
 	struct xt_template *tmpl;
 	struct xt_table *t;
+	int err = -ENOENT;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt_net->tables[af], list)
@@ -1247,8 +1248,6 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 
 	/* Table doesn't exist in this netns, check larval list */
 	list_for_each_entry(tmpl, &xt_templates[af], list) {
-		int err;
-
 		if (strcmp(tmpl->name, name))
 			continue;
 		if (!try_module_get(tmpl->me))
@@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 		break;
 	}
 
+	if (err < 0)
+		goto out;
+
 	/* and once again: */
 	list_for_each_entry(t, &xt_net->tables[af], list)
 		if (strcmp(t->name, name) == 0)
@@ -1275,7 +1277,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 	module_put(owner);
  out:
 	mutex_unlock(&xt[af].mutex);
-	return ERR_PTR(-ENOENT);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(xt_find_table_lock);
 
-- 
2.25.1

