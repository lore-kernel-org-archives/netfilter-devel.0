Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BC52C9A;
	Thu, 24 Oct 2024 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729734414; cv=none; b=tPth/FTAeOrriEIk8IyN2daTQbyp57OQSHoD8O8aMmB0tIrFmjSG7vSxKR8BdsqV/FvWh8D1c6ia/7FAKPiLsh4O5fBqlxocO826HNX/eA6yQ6Ryjabseb2ANoTWwuU7tRPjWMbCfy3WQWBON13kFYjbStMLlVDXfTJ8N+cli3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729734414; c=relaxed/simple;
	bh=JJ3pxSuWPTEwJ9w0DNfAWH/58BCS2BCuUzUwJsNLduA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UgM6xyh0HZl4s+57hfsC7e+xsTPC66BEpH/IOqo1UUR48RVycKEz7i9HEu6Oxck82Pto+v5085TIB3t4gAl8r3Es17qfG9whl46FaOYGwkhCN5WNapTpHvqA5kXyo8P528lhHlEo8sCYUZOPlYpahSYVNa9CtEalJy+LBcmYW+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XYpdW6JlWz2FbJM;
	Thu, 24 Oct 2024 09:45:19 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (unknown [7.221.188.33])
	by mail.maildlp.com (Postfix) with ESMTPS id D2ACE1A0188;
	Thu, 24 Oct 2024 09:46:43 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 kwepemd100023.china.huawei.com (7.221.188.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 24 Oct 2024 09:46:42 +0800
From: Dong Chenchen <dongchenchen2@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<fw@strlen.de>, <kuniyu@amazon.com>
CC: <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<yuehaibing@huawei.com>, Dong Chenchen <dongchenchen2@huawei.com>
Subject: [PATCH net v2] net: netfilter: Fix use-after-free in get_info()
Date: Thu, 24 Oct 2024 09:47:01 +0800
Message-ID: <20241024014701.2086286-1-dongchenchen2@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
	kfree(t)
	//removed from templ_list
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
xt_templates list, we couldnt get refcnt of xt_table->me. Check
module in xt_net->tables list re-traversal to fix it.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index da5d929c7c85..709840612f0d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1269,7 +1269,7 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 
 	/* and once again: */
 	list_for_each_entry(t, &xt_net->tables[af], list)
-		if (strcmp(t->name, name) == 0)
+		if (strcmp(t->name, name) == 0 && owner == t->me)
 			return t;
 
 	module_put(owner);
-- 
2.25.1

