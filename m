From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/18]: ctnetlink: remove unused variable
Date: Thu,  5 Jan 2006 05:06:41 +0100 (MET)
Message-ID: <20060105040606.23512.77770.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ctnetlink: remove unused variable

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1227b054c63788ad08053b0af4435df9fb65a6bb
tree eade765b1c62946537e89d9030cb93b0d515ee2f
parent d83898b5b202d40e7ab16170143661d99b7f5a0e
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:55:55 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:55:55 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 589e9e7..1763764 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1203,7 +1203,6 @@ static int ctnetlink_expect_event(struct
 	unsigned int type;
 	unsigned char *b;
 	int flags = 0;
-	u16 proto;
 
 	if (events & IPEXP_NEW) {
 		type = IPCTNL_MSG_EXP_NEW;
@@ -1230,7 +1229,6 @@ static int ctnetlink_expect_event(struct
 		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
-	proto = exp->tuple.dst.protonum;
 	nfnetlink_send(skb, 0, NFNLGRP_CONNTRACK_EXP_NEW, 0);
 	return NOTIFY_DONE;
 
