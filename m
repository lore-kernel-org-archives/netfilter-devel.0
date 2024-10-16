Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D74F13AF2;
	Wed, 16 Oct 2024 03:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729048178; cv=none; b=bMjzzyknL2RXGjXhEl8ahB5IfZ3bo2JASJ8Xe/NX0P9BMo/Bo81SkyLnKQgYNPE+12R2mq/YwaXAliaufmDSpJKYN77Mq3gMX2HQzlXVec8wzPuFJjNRYivClCDY1w2Si5jBh4KaZLmOBqS2LPYCDZpRS5hOWG/xV4bW/BDJ1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729048178; c=relaxed/simple;
	bh=OKAMghoRJ2LZ0i6U4LMdB9qPgn7xWjVcezisFvum2Fw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lWS/dg6kdo1QV5OJP0BUhGTnj8kprTiYLzwsGCcB+mUzC7E9h2ScztCtSuhscILZiqIsfV/m6XeVSroeLjALSiMVyO0RcYJO0sbq0bXVesug8OR8ak8ZxngmY3evFsyPsVW2Qlp3VHrWbwcNoyZvpfR00tTzopQNIkhcjY2MlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WUD7snep; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WUD7snep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KDRaE
	hkuNS6IKPKtjIb7HvHeocvWk3GB1HdynBeEZQE=; b=WUD7snepv9NQfcjv0vkGk
	Ffz0w4y506K9ZFfQ8xarH8oHefTgerjkvJ0XHNsZhTZRsZUvBE9v3QKb5K/qD6yo
	al+ZhvHLK8xqh2i0MF5uHyKnr5m4R3Jak28V4n1K1N8tu/Jwge+zT4FKXOzJf5v2
	tbd+9KZ7T3Xt2j+bPJMeco=
Received: from localhost.localdomain (unknown [116.128.244.171])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wC3lUZfLg9nhbd8BQ--.586S2;
	Wed, 16 Oct 2024 11:09:20 +0800 (CST)
From: Rongguang Wei <clementwei90@163.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org
Cc: coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Rongguang Wei <weirongguang@kylinos.cn>
Subject: [PATCH v1] netfilter: x_tables: fix ordering of get and update table private
Date: Wed, 16 Oct 2024 11:09:09 +0800
Message-Id: <20241016030909.64932-1-clementwei90@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3lUZfLg9nhbd8BQ--.586S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFy5trW3Zw15Aw1kGFWxJFb_yoW5uw4rpr
	W5Gr9rKrWruryUKr1UC3y2yry3Jr4DAa18C3W5Ca45Z3Zruw4FgF4UKrW7Ca17Xry5Xr1a
	qa4jqw1vqr43CaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnfHUUUUUU=
X-CM-SenderInfo: 5fohzv5qwzvxizq6il2tof0z/1tbiXQJ6a2cPJjuSQwABsr

From: Rongguang Wei <weirongguang@kylinos.cn>

Meet a kernel panic in ipt_do_table:
PANIC: "Unable to handle kernel paging request at virtual address 00706f746b736564"

and the stack is:
     PC: ffff5e1dbecf0750  [ipt_do_table+1432]
     LR: ffff5e1dbecf04e4  [ipt_do_table+812]
     SP: ffff8021f7643370  PSTATE: 20400009
    X29: ffff8021f7643390  X28: ffff802900c3990c  X27: ffffa0405245a000
    X26: ffff80400ad645a8  X25: ffffa0201c4d8000  X24: ffff5e1dbed00228
    X23: ffff80400ad64738  X22: 0000000000000000  X21: ffff80400ad64000
    X20: ffff802114980ae8  X19: ffff8021f7643570  X18: 00000007ea9ec175
    X17: 0000fffde7b52460  X16: ffff5e1e181e8f20  X15: 0000fffd9a0ae078
    X14: 610d273b56961dbc  X13: 0a08010100007ecb  X12: f5011880fd874f59
    X11: ffff5e1dbed10600  X10: ffffa0405245a000   X9: 569b063f004015d5
     X8: ffff80400ad64738   X7: 0000000000010002   X6: 0000000000000000
     X5: 0000000000000000   X4: 0000000000000000   X3: 0000000000000000
     X2: 0000000000000000   X1: 2e706f746b736564   X0: ffff80400ad65850
[ffff8021f7643390] ipt_do_table at ffff5e1dbecf074c [ip_tables]
[ffff8021f76434d0] iptable_filter_hook at ffff5e1dbfe700a4 [iptable_filter]
[ffff8021f76434f0] nf_hook_slow at ffff5e1e18c31c2c
[ffff8021f7643530] ip_forward at ffff5e1e18c41924
[ffff8021f76435a0] ip_rcv_finish at ffff5e1e18c3fddc
[ffff8021f76435d0] ip_rcv at ffff5e1e18c40214
[ffff8021f7643630] __netif_receive_skb_one_core at ffff5e1e18bbbed4
[ffff8021f7643670] __netif_receive_skb at ffff5e1e18bbbf3c
[ffff8021f7643690] process_backlog at ffff5e1e18bbd52c
[ffff8021f76436f0] __napi_poll at ffff5e1e18bbc464
[ffff8021f7643730] net_rx_action at ffff5e1e18bbc9a8

The panic happend in ipt_do_table function:

	private = READ_ONCE(table->private);
	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
	[...]
	jumpstack[stackid++] = e;	// panic here

In vmcore, the cpu is 4, I read the private->jumpstack[cpu] is 007365325f6b6365,
this address between user and kernel address ranges which caused kernel panic.
Also the kmem shows that the private->jumpstack address is free.
It looks like we get a UAF address here.

But in xt_replace_table function:

	private = table->private;
	[...]
	smp_wmb();
	table->private = newtable_info;
	smp_mb();

It seems no chance to get a free private member in ipt_do_table.
May have a ordering error which looks impossible:

	smp_wmb();
	table->private = newtable_info;
	private = table->private;
	smp_mb();

we get table->private after we set new table->private. After that, the
private was free in xt_free_table_info and also used in ipt_do_table.
Here use READ_ONCE to ensure we get private before we set the new one.

Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index da5d929c7c85..1ce7a4f268d6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1399,7 +1399,7 @@ xt_replace_table(struct xt_table *table,
 
 	/* Do the substitution. */
 	local_bh_disable();
-	private = table->private;
+	private = READ_ONCE(table->private);
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
-- 
2.25.1

