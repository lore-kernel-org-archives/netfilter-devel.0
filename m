Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276E501F47;
	Wed, 16 Sep 2026 23:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600630; cv=none; b=RrBGeJnDVl3lIaSlF/20q6ijWsuq5S2Do3leb5oHz9bruHqaUmXDoHM7H3jwL46QowZyEuQKxoao/AbnZYGf2VaN8wv8qK8uWk+pRdk2X3zVkHAVz/+KhsjgLxEs2GX1bK8MQUkwtUxV74ADoqfOwy4C0mFtDKnqBICV4/v1LZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600630; c=relaxed/simple;
	bh=02KFQrqiwT+bUDem6JcDIolJMQI61/hdrs7e+UScFOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3BWgMJaIveljTcuEWJlF/xSw/Qg1FAIWHCTuuGBcr6kcnkDjYOaDNgphlp11pc4iWckh0n5NgXigZpshaHNhD0QuNjIpfwjBwhQx3iInKD1+oxHFVQ3a5CMbqs7AO2ig6nw3XLz//cNnq8KTNp4G3QbK8wZJBRFZi2lK+/UAek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r4NzupiN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r4NzupiN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600627;
	bh=DFWomdDR05PGETabdUvkIcRsf8UFfiEDT9qwLhun5gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4NzupiNHR7Gyuyy2sM9Fhlb6vF+QZU76sxdtKCFGh3BANn5JJP01msJyYGOdGfDY
	 nJ7V+4Qfj9fU+QpYwTiKbr2TvDgOygrcfrwE8emmi3xxkpSOqWl9GWGRS9pzsDM6oT
	 QgtW/p1mJWheEyRFRcPWZE0tlORikRhMnUX47TSWSrqWSQVOVtXjoW75yGdRoDDJqm
	 M+VIIwBobuVY4jGtd7kzwUC/w5NaNHzuwAiKCRIrJ+KdJvt0ZAKMdkFxLDMDqA9D8x
	 E349dSsVpR1oJk8EZkUqAmMpVORKs96dGVkCDEWQeZUotkkqNzDUPaxwME0T50E2jC
	 FSzATwgPKMj3w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C20106008D;
	Thu, 17 Sep 2026 01:17:06 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/10] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
Date: Thu, 17 Sep 2026 01:16:49 +0200
Message-ID: <20260916231652.127456-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Naman Gulati <namangulati@google.com>

expect_iter_name() is invoked by nf_ct_expect_iterate_net() under
spin_lock_bh(&nf_conntrack_expect_lock). It does not hold
rcu_read_lock().

When accessing exp->helper with rcu_dereference() in syzbot's report,
lockdep warns:

  =============================
  WARNING: suspicious RCU usage
  syzkaller #0 Not tainted
  -----------------------------
  net/netfilter/nf_conntrack_netlink.c:3393 suspicious rcu_dereference_check() usage!

  locks held by syz-executor381/5628: 2, last CPU#1:
   #0: ffffffff9aee42a0 (nfnl_subsys_ctnetlink_exp){+.+.}-{4:4},
       at: nfnetlink_rcv_msg+0xa69/0x12b0
   #1: ffffffff8ea74d58 (nf_conntrack_expect_lock){+...}-{3:3},
       at: nf_ct_expect_iterate_net+0x38/0x180

  Call Trace:
   <TASK>
   dump_stack_lvl+0xe8/0x150
   lockdep_rcu_suspicious+0x140/0x1d0
   expect_iter_name+0xfb/0x100
   nf_ct_expect_iterate_net+0xf2/0x180
   ctnetlink_del_expect+0x45d/0x640
   nfnetlink_rcv_msg+0xcc2/0x12b0
   netlink_rcv_skb+0x226/0x4a0
   nfnetlink_rcv+0x2b9/0x28c0
   netlink_unicast+0x7bd/0x940
   netlink_sendmsg+0x813/0xb40
   ____sys_sendmsg+0x54e/0x850
   ___sys_sendmsg+0x2a5/0x360
   __sys_sendmsg+0x2a5/0x360
   do_syscall_64+0x166/0x520
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Use rcu_dereference_protected() with lockdep_is_held() on
nf_conntrack_expect_lock instead, similar to expect_iter_me() in
nf_conntrack_helper.c.

Fixes: f01794106042 ("netfilter: nf_conntrack_expect: use expect->helper")
Reported-by: syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6aa4a377.f81106d8.2ab401.0024.GAE@google.com/T/#u
Signed-off-by: Naman Gulati <namangulati@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 579ada063b1b..4e5d7c701436 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3392,7 +3392,8 @@ static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 	struct nf_conntrack_helper *helper;
 	const char *name = data;
 
-	helper = rcu_dereference(exp->helper);
+	helper = rcu_dereference_protected(exp->helper,
+					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (!helper)
 		return false;
 
-- 
2.47.3

