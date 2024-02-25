Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C191BC27;
	Sun, 25 Feb 2024 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708901940; cv=none; b=m2+8ib/yXNn45fHjp8D8UhqMP6zWggXyaVF5pDslVhNPW6xZ/xHct0xdqLGU74LIGaqXFm9JBaVnrcF8HNZnm0qjSMw6YqmQLIHi+Hn1FI+JCiofodXHCSTxxpvQSCaworoyoCO0txBr1LBKo4aBdfdvulqYcMLzzffVeLhglTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708901940; c=relaxed/simple;
	bh=DpAFu1e0ATBu7V0f5PNmDqZLD8jKe1zkpOETPU8QAKA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X/jomdQIqXCnYGSk/p3bXwOEsLp8u2GcglHZqrUnYtax4j++Z7C20sZAp0qpoS7o/aIv/5CwTicC/6/iSUziyHEmTLFlIu0NGm7bo2Wkb3LLAutA7+gxbqg2FvHmKD2TKaGTtNS/EzH/beIcJRn8TNxzRoKpJSsSO7LHVKambAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net] netlink: validate length of NLA_{BE16,BE32} types
Date: Sun, 25 Feb 2024 23:58:45 +0100
Message-Id: <20240225225845.45555-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports:

=====================================================
BUG: KMSAN: uninit-value in nla_validate_range_unsigned lib/nlattr.c:222 [inline]
BUG: KMSAN: uninit-value in nla_validate_int_range lib/nlattr.c:336 [inline]
BUG: KMSAN: uninit-value in validate_nla lib/nlattr.c:575 [inline]
BUG: KMSAN: uninit-value in __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 nla_validate_range_unsigned lib/nlattr.c:222 [inline]
 nla_validate_int_range lib/nlattr.c:336 [inline]
 validate_nla lib/nlattr.c:575 [inline]
 __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 __nla_parse+0x5f/0x70 lib/nlattr.c:728
 nla_parse_deprecated include/net/netlink.h:703 [inline]
 nfnetlink_rcv_msg+0x723/0xde0 net/netfilter/nfnetlink.c:275
 netlink_rcv_skb+0x371/0x650 net/netlink/af_netlink.c:2543
 nfnetlink_rcv+0x372/0x4950 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1341 [inline]
 netlink_unicast+0xf49/0x1250 net/netlink/af_netlink.c:1367
 netlink_sendmsg+0x1238/0x13d0 net/netlink/af_netlink.c:1908
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3819 [inline]
 slab_alloc_node mm/slub.c:3860 [inline]
 kmem_cache_alloc_node+0x5cb/0xbc0 mm/slub.c:3903
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:560
 __alloc_skb+0x352/0x790 net/core/skbuff.c:651
 alloc_skb include/linux/skbuff.h:1296 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1213 [inline]
 netlink_sendmsg+0xb34/0x13d0 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

NLA_BE16 and NLA_BE32 minimum attribute length is not validated, update
nla_attr_len and nla_attr_minlen accordingly.

After this update, kernel displays:

  netlink: 'x': attribute type 2 has an invalid length.

in case that the attribute payload is too small and it reports -ERANGE
to userspace.

Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
Reported-by: xingwei lee <xrivendell7@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 lib/nlattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index ed2ab43e1b22..be9c576b6e2d 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -30,6 +30,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
@@ -43,6 +45,8 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_BE16]	= sizeof(__be16),
+	[NLA_BE32]	= sizeof(__be32),
 };
 
 /*
-- 
2.30.2

