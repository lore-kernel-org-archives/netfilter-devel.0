Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D816333993;
	Wed,  2 Apr 2025 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743613271; cv=none; b=lqMMgNu0PmrjkrTmUwofaqXjfHn/1ubKuXyVq0f+PzR496NNbzUjK2BCer0seN8vqmmtsXV5XoT88kL5F+UsXVlciXC1xwizaSHkXPWQ9BreTj3K6v6FUMrTscgJVJ1M4IhFpTtARANvN1BCNpNt7wbE0gIrETJMQETCBWRX1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743613271; c=relaxed/simple;
	bh=Mw1X+1hu+47rrKXTu8ZK6ZH36IWcj4glSHoD8EYem8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ofa4HcT9X2npYt6P/m0943UR06UxyDXK3ckDr3twABN4krR74KFs7eKiDerT1piYTOnq3lRxQxI/hwlRhI2NLIzfb39dquSRFtmX21YPBDKbacWlmhbJpB/2kyR5ABL3REZFyZWU4lbyeaY3kLq2VyGBno+Q5tl3tdGP63L2P3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.193.154.185])
	by mtasvr (Coremail) with SMTP id _____wBHG5A0be1ndbUtAQ--.43S3;
	Thu, 03 Apr 2025 01:00:36 +0800 (CST)
Received: from localhost (unknown [10.193.154.185])
	by mail-app3 (Coremail) with SMTP id zS_KCgAHInQzbe1nucEaAQ--.64538S2;
	Thu, 03 Apr 2025 01:00:35 +0800 (CST)
From: Lin Ma <linma@zju.edu.cn>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	lucien.xin@gmail.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Cc: Lin Ma <linma@zju.edu.cn>
Subject: [PATCH net] netfilter: nft_tunnel: fix geneve_opt type confusion addition
Date: Thu,  3 Apr 2025 01:00:26 +0800
Message-Id: <20250402170026.9696-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgAHInQzbe1nucEaAQ--.64538S2
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-CM-DELIVERINFO: =?B?ctDmNAXKKxbFmtjJiESix3B1w3tPqcowV1L23Bze5QtIr9Db75bEBiiEybVhThS0pI
	APHkyPSxI2Xdeyd3ul0ToYuuaa6ydc/d9u26TTikvtWydc2/+aUjRNbJE+cEEqqrcdbOD6
	kGcEq7bRdzEG7BBmbwCE69bPlRaDnS6o/Is3qDBX
X-Coremail-Antispam: 1Uk129KBj93XoWxWFyfur4xurW3Kw4kJF43Arc_yoW5uFWUpr
	Z8K3ySkr48Kryktr18tF18AFyUJryqyF1xGr93GrW8t3W5Xw1UGay8KrWjgFn3CrWDZrW3
	trn8ta12qrn8G3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjcxG0xvY0x
	0EwIxGrVCF72vEw4AK0wACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
	IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07URlksUUUUU=

When handling multiple NFTA_TUNNEL_KEY_OPTS_GENEVE attributes, the
parsing logic should place every geneve_opt structure one by one
compactly. Hence, when deciding the next geneve_opt position, the
pointer addition should be in units of char *.

However, the current implementation erroneously does type conversion
before the addition, which will lead to heap out-of-bounds write.

[    6.989857] ==================================================================
[    6.990293] BUG: KASAN: slab-out-of-bounds in nft_tunnel_obj_init+0x977/0xa70
[    6.990725] Write of size 124 at addr ffff888005f18974 by task poc/178
[    6.991162]
[    6.991259] CPU: 0 PID: 178 Comm: poc-oob-write Not tainted 6.1.132 #1
[    6.991655] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[    6.992281] Call Trace:
[    6.992423]  <TASK>
[    6.992586]  dump_stack_lvl+0x44/0x5c
[    6.992801]  print_report+0x184/0x4be
[    6.993790]  kasan_report+0xc5/0x100
[    6.994252]  kasan_check_range+0xf3/0x1a0
[    6.994486]  memcpy+0x38/0x60
[    6.994692]  nft_tunnel_obj_init+0x977/0xa70
[    6.995677]  nft_obj_init+0x10c/0x1b0
[    6.995891]  nf_tables_newobj+0x585/0x950
[    6.996922]  nfnetlink_rcv_batch+0xdf9/0x1020
[    6.998997]  nfnetlink_rcv+0x1df/0x220
[    6.999537]  netlink_unicast+0x395/0x530
[    7.000771]  netlink_sendmsg+0x3d0/0x6d0
[    7.001462]  __sock_sendmsg+0x99/0xa0
[    7.001707]  ____sys_sendmsg+0x409/0x450
[    7.002391]  ___sys_sendmsg+0xfd/0x170
[    7.003145]  __sys_sendmsg+0xea/0x170
[    7.004359]  do_syscall_64+0x5e/0x90
[    7.005817]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[    7.006127] RIP: 0033:0x7ec756d4e407
[    7.006339] Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 faf
[    7.007364] RSP: 002b:00007ffed5d46760 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[    7.007827] RAX: ffffffffffffffda RBX: 00007ec756cc4740 RCX: 00007ec756d4e407
[    7.008223] RDX: 0000000000000000 RSI: 00007ffed5d467f0 RDI: 0000000000000003
[    7.008620] RBP: 00007ffed5d468a0 R08: 0000000000000000 R09: 0000000000000000
[    7.009039] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[    7.009429] R13: 00007ffed5d478b0 R14: 00007ec756ee5000 R15: 00005cbd4e655cb8

Fix this bug with correct pointer addition and conversion.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 681301b46aa4..2df4b2a02f27 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -341,7 +341,7 @@ static const struct nla_policy nft_tunnel_opts_geneve_policy[NFTA_TUNNEL_KEY_GEN
 static int nft_tunnel_obj_geneve_init(const struct nlattr *attr,
 				      struct nft_tunnel_opts *opts)
 {
-	struct geneve_opt *opt = (struct geneve_opt *)opts->u.data + opts->len;
+	struct geneve_opt *opt = (struct geneve_opt *)(opts->u.data + opts->len);
 	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1];
 	int err, data_len;
 
-- 
2.17.1

