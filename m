Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9B4E73A1;
	Fri, 18 Sep 2026 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730942; cv=none; b=tv2399q7ftL1Z4/0QIJDOBEitu4Ljefse4yhjScf44Cqq3VRvm3gsFAJ+YV3SfsXkUYDNt/lt+eogE0VD0lv11T79ldz10VUxa1hLST7YU/ai2vgLaft/m02gVmTNhx5o8+QXW+5UXb9Y1btSvykV3F9P1XEw0XjDbwjJ6opAyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730942; c=relaxed/simple;
	bh=02KFQrqiwT+bUDem6JcDIolJMQI61/hdrs7e+UScFOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhPTcYDRAI5NLs9/FLDpwMjiVcWyYUJSdwYwAB6p8Z/w9C8+udQ6XmG3zlwdlu49yJzY2h+6eeNzMrb0ASPZKIKx6KdFm96hOjGmZkNjh60pZw8xo2Q9hkkrdLj5S/U65b1u9+cUtNcONKvphgRjNOfHKIacL9zOaDrT7O2kYxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H43QyIhT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H43QyIhT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730938;
	bh=DFWomdDR05PGETabdUvkIcRsf8UFfiEDT9qwLhun5gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H43QyIhTfrB2KJ75w95KYuqm1lzqMmDKW8in8Rlcwa6fxqZe3IObferqRUkVfB29n
	 aJjZv3PWEaiqTC8F1HAIAgfdCNGtNNRYkDHyv+bpY06QzR+MzWBjGQfJ+8JkYvpG4h
	 SDkrQumhkK+Knh9h+4xOjEQh/ibZYjKT7sosNRxp4glk2ei7Tzfy5sGF6CyZepibEg
	 V5JQqZnUQhCH9v80vgcnpAV3QW9ZIhFNbT9mGJHbQGMFokaz4nqL1wLW5rERhX6cMA
	 YAGfOlH2Ixk/bltHbUjmbFRui68DvN5eVlmOpT6LyJfAPuuGlhAolF3On8/vt1gqLl
	 Hl7GSENPwQwwg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2E75360076;
	Fri, 18 Sep 2026 13:28:58 +0200 (CEST)
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
Subject: [PATCH net 7/8] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
Date: Fri, 18 Sep 2026 13:28:43 +0200
Message-ID: <20260918112844.194503-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
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

