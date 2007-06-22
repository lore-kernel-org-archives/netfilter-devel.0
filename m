From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: nfctnetlink: Don't allow to change helper
Date: Fri, 22 Jun 2007 13:47:33 +0200 (MEST)
Message-ID: <20070622114658.14839.83293.sendpatchset@localhost.localdomain>
References: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070622114656.14839.1945.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfctnetlink: Don't allow to change helper

There is no realistic situation to change helper (Who wants IRC helper to
track FTP traffic ?). Moreover, if we want to do that, we need to fix race
issue by nfctnetlink and running helper. That will add overhead to packet
processing. It wouldn't pay. So this rejects the request to change
helper. The requests to add or remove helper are accepted as ever.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4c56b708f2c447527749492fd53e85d1e1483f02
tree 6d3f9fd34752e010f5c597a5e2b1611469cb2917
parent 845abcbe6c8ef918b3499e820aafe4d26119c737
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 20 Jun 2007 14:52:57 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Jun 2007 14:52:57 +0200

 net/netfilter/nf_conntrack_netlink.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3f73327..d0fe3d7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -869,8 +869,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 		return 0;
 
 	if (help->helper)
-		/* we had a helper before ... */
-		nf_ct_remove_expectations(ct);
+		return -EBUSY;
 
 	/* need to zero data of old helper */
 	memset(&help->help, 0, sizeof(help->help));
