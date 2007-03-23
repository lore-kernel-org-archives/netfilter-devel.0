From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER] nfnetlink: netlink_run_queue() already checks for
	NLM_F_REQUEST
Date: Fri, 23 Mar 2007 15:05:15 +0100 (MET)
Message-ID: <20070323140449.22987.76864.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

[NETFILTER] nfnetlink: netlink_run_queue() already checks for NLM_F_REQUEST

Patrick has made use of netlink_run_queue() in nfnetlink while my patches
have been waiting for net-2.6.22 to open. So this check for NLM_F_REQUEST
can go as well.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 65374601f87e77135967ccd508669b3a92775720
tree 1ad354f932d676c23d734114a1c94dfc6849bfc7
parent 3435a23f0ddf1b795860e4cf03ce50a9092d34e7
author Thomas Graf <tgraf@suug.ch> Thu, 22 Mar 2007 23:03:39 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 14:59:14 +0100

 net/netfilter/nfnetlink.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c37ed01..b0da853 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -204,10 +204,6 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (security_netlink_recv(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	/* Only requests are handled by kernel now. */
-	if (!(nlh->nlmsg_flags & NLM_F_REQUEST))
-		return 0;
-
 	/* All the messages must at least contain nfgenmsg */
 	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg)))
 		return 0;
