Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE9824DFFB;
	Thu,  3 Apr 2025 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743681490; cv=none; b=aPxo72PeqzW21SAexqClmllZ3emNkPKu3hYA1XoNAmCp+M3puFeVvWd51yMKb5p31tyDWSu3wOSVFuySqwWg+N9NyjqHpJZo6eRuw12N8XDX6xl3oLaXSCMugLU+i+cYt5hM4myuuISZ+nzlITyIjE8KKhJqMLEI/KSNvx4dTEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743681490; c=relaxed/simple;
	bh=k5hvQEz/STmJKgeZt2USNb0VrNwUmC16D3AGQuq/6Jw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iSlsOrmB19iXWYapzMedS0s2UqwV4Ft3x83xebUK8DIQnEFE2Z4EoDHcptsbQQNVKw2NiOnULul7NYq/gV5j5l8nS8vavOZlmy98TBsKwwxJ8WNhG40ieymgorTrLwf6kr/CsPyXUYGeWyKj9o7NdfCFD8he2IhlBKi2liRsxyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=l7361x+f; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g8xVozvR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="l7361x+f";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g8xVozvR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3B45960646; Thu,  3 Apr 2025 13:58:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681487;
	bh=aUfowwFMwu3r7vT13ntNy4QxMXB7CT89vJJ20UkVpMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7361x+fYYRhoUEU9do0N16or+CkbD3/yPONpO/x4l33D/y0693HmlE5wNE011q6W
	 tmfFpIPrqvLqHozQQMpnIDrVKegCDeFaYzdawlh/EvnZNh6FmKqJPyE7Ig+G7pCvxa
	 Am97eMPN9iqFTOgdKyeL7M4rJt3tZ1cp3M912MmSwA/mJGwStUSvvd7lGD4NVJ4PsT
	 jscbTbd86WW3sHf5yc9A/n3tbSImper0dFjoDvu3SM0n6lxzeSWv6RV1W4O3D+lNgB
	 pwWIOA9xf5vkfqaqtBngtq2dxI3NvR/onWSOfeSuG0Qpwj4WGqz8oIt0GGKeFEf2IY
	 xiilnqCKWl/tg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E75F60639;
	Thu,  3 Apr 2025 13:58:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681482;
	bh=aUfowwFMwu3r7vT13ntNy4QxMXB7CT89vJJ20UkVpMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8xVozvRTJG9CelDdNJPHu6LfSUNz6W1GYzsxxNbsoFYU83sMHEmJPhRNuR9rXMx1
	 Z6Un6I7a+avHORCCmZEiwVP7L6g7eT4l1d9fl94E4boEMDq6xDoJl++iOMYYxLsqSG
	 v85P6AHRyNi5g4PXATvT/f+G8KQs1ItmrAUPv6tSh7MlYG+q+PsOC0UzTFRQCd+X/A
	 SL+K6yWEeWr/0U5ZX6Iv1a5ku9mMAe/H59HfPLd8Sn5FdMayZUU6s4pjPFuxlByC6h
	 0+ViSeBtFR51XBeKDczN9a4lkUxesShyoEpEv5hLcdwJTi98Mm1RQhAAnO6S8HhD7g
	 L6oblfWNtK/4Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/3] netfilter: nft_tunnel: fix geneve_opt type confusion addition
Date: Thu,  3 Apr 2025 13:57:52 +0200
Message-Id: <20250403115752.19608-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250403115752.19608-1-pablo@netfilter.org>
References: <20250403115752.19608-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

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

Fix this bug with correct pointer addition and conversion in parse
and dump code.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.30.2

