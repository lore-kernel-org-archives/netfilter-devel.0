From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/9] netfilter: provide correct argument to nla_strlcpy()
Date: Tue, 29 May 2018 01:42:18 +0200
Message-ID: <20180528234221.31254-7-pablo@netfilter.org>
References: <20180528234221.31254-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528234221.31254-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Recent patch forgot to remove nla_data(), upsetting syzkaller a bit.

BUG: KASAN: slab-out-of-bounds in nla_strlcpy+0x13d/0x150 lib/nlattr.c:314
Read of size 1 at addr ffff8801ad1f4fdd by task syz-executor189/4509

CPU: 1 PID: 4509 Comm: syz-executor189 Not tainted 4.17.0-rc6+ #62
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1b9/0x294 lib/dump_stack.c:113
 print_address_description+0x6c/0x20b mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:354 [inline]
 kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
 __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
 nla_strlcpy+0x13d/0x150 lib/nlattr.c:314
 nfnl_acct_new+0x574/0xc50 net/netfilter/nfnetlink_acct.c:118
 nfnetlink_rcv_msg+0xdb5/0xff0 net/netfilter/nfnetlink.c:212
 netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2448
 nfnetlink_rcv+0x1fe/0x1ba0 net/netfilter/nfnetlink.c:513
 netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
 netlink_unicast+0x58b/0x740 net/netlink/af_netlink.c:1336
 netlink_sendmsg+0x9f0/0xfa0 net/netlink/af_netlink.c:1901
 sock_sendmsg_nosec net/socket.c:629 [inline]
 sock_sendmsg+0xd5/0x120 net/socket.c:639
 sock_write_iter+0x35a/0x5a0 net/socket.c:908
 call_write_iter include/linux/fs.h:1784 [inline]
 new_sync_write fs/read_write.c:474 [inline]
 __vfs_write+0x64d/0x960 fs/read_write.c:487
 vfs_write+0x1f8/0x560 fs/read_write.c:549
 ksys_write+0xf9/0x250 fs/read_write.c:598
 __do_sys_write fs/read_write.c:610 [inline]
 __se_sys_write fs/read_write.c:607 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:607

Fixes: 4e09fc873d92 ("netfilter: prefer nla_strlcpy for dealing with NLA_STRING attributes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c     | 2 +-
 net/netfilter/nfnetlink_cthelper.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 6ddf89183e7b..a0e5adf0b3b6 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -115,7 +115,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		nfacct->flags = flags;
 	}
 
-	nla_strlcpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
+	nla_strlcpy(nfacct->name, tb[NFACCT_NAME], NFACCT_NAME_MAX);
 
 	if (tb[NFACCT_BYTES]) {
 		atomic64_set(&nfacct->bytes,
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index fa026b269b36..cb5b5f207777 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -150,7 +150,7 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 		return -EINVAL;
 
 	nla_strlcpy(expect_policy->name,
-		    nla_data(tb[NFCTH_POLICY_NAME]), NF_CT_HELPER_NAME_LEN);
+		    tb[NFCTH_POLICY_NAME], NF_CT_HELPER_NAME_LEN);
 	expect_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
 	if (expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
@@ -235,7 +235,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		goto err1;
 
 	nla_strlcpy(helper->name,
-		    nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
+		    tb[NFCTH_NAME], NF_CT_HELPER_NAME_LEN);
 	size = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
 	if (size > FIELD_SIZEOF(struct nf_conn_help, data)) {
 		ret = -ENOMEM;
-- 
2.11.0
