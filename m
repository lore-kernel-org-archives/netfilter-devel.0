Received: from zg8tmty1ljiyny4xntuumtyw.icoremail.net (zg8tmty1ljiyny4xntuumtyw.icoremail.net [165.227.155.160])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58222AD32;
	Thu,  3 Apr 2025 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=165.227.155.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743643202; cv=none; b=TE+UMn2n6NheNey4zGBWSDJUof9x2IHJ8Zq9ACFPj50ywvpyL6a5DgC9mnBAqQNxlNOhhv5XC7sS7lNIFhl4IV7h59kov3LRkbo8BnqjA4L40CnUlfvBg63/bOmJaNSCe8ZRb5frvBrr1FuwleV9Jpe03E0CXa9M2FPFAdGI7Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743643202; c=relaxed/simple;
	bh=QkKZf+bIJFjw1ctLPnQcZCZYEhM8oQC/Tl3mbusg9S0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KnZn1rk2xsWwtfI0DIIyvOZpXPT8Raq4nEMe9qZ6WZaQ4Bg9m7j8RY7zPgBvY9FUlytbA9KcELwyybejlgN4h+cvpGbqs8AdxXaEOzFRYLoB2iNBCrnP0zvUeoSAZq0qXRiCwSCVfvgMOOwopPO1OCiE1SyTdIvEZBsXmBKd5uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=165.227.155.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.193.154.185])
	by mtasvr (Coremail) with SMTP id _____wBXL_Qo4u1nk4MyAQ--.8615S3;
	Thu, 03 Apr 2025 09:19:37 +0800 (CST)
Received: from localhost (unknown [10.193.154.185])
	by mail-app3 (Coremail) with SMTP id zS_KCgBHsXEd4u1nsWAdAQ--.60803S2;
	Thu, 03 Apr 2025 09:19:25 +0800 (CST)
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
Subject: [PATCH net v1] netfilter: nft_tunnel: fix geneve_opt type confusion addition
Date: Thu,  3 Apr 2025 09:19:21 +0800
Message-Id: <20250403011921.37208-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgBHsXEd4u1nsWAdAQ--.60803S2
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-CM-DELIVERINFO: =?B?IkaDHAXKKxbFmtjJiESix3B1w3tPqcowV1L23Bze5QtIr9Db75bEBiiEybVhThS0pI
	APHkyPSxI2Xdeyd3ul0ToYuubhPK9TUcP4mAz12595LEFzza1ZiEkHbM+9bqFwePnsbkxJ
	SRpTVJmBpSg9s7/MEoC7IioAAjnOAt8rYZw12Biq
X-Coremail-Antispam: 1Uk129KBj93XoWxWFyfur4xurW3Kw4kJF43Arc_yoWrXF4rpr
	Z8KaySkr48tryktF18tF18AFyUtrWqy3WxGr93Gry8t3W5Xw1UWay8KrWUKFn3CrWDAr43
	trn8ta12vwn8G3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Eb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48IcxkI7V
	AKI48G6xCjnVAKz4kxM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI7VAKI48JMxC2
	0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU801v3UUUUU==

When handling multiple NFTA_TUNNEL_KEY_OPTS_GENEVE attributes, the
parsing logic should place every geneve_opt structure one by one
compactly. Hence, when deciding the next geneve_opt position, the
pointer addition should be in units of char *.

However, the current implementation erroneously does type conversion
before the addition, which will lead to heap out-of-bounds access.

The related KASAN log is like:

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

Fix this bug with correct pointer addition and conversion in parse
and dump code.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
v0 -> v1: also fix the buggy code in nft_tunnel_opts_dump as suggested
          by Pablo Neira Ayuso.

 net/netfilter/nft_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 681301b46aa4..2e40f575aed9 100644
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
 
@@ -625,7 +625,7 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		if (!inner)
 			goto failure;
 		while (opts->len > offset) {
-			opt = (struct geneve_opt *)opts->u.data + offset;
+			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
 			    nla_put_u8(skb, NFTA_TUNNEL_KEY_GENEVE_TYPE,
-- 
2.17.1

