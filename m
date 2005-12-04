From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/9]: nfnetlink: Fix calculation of minimum message
	length
Date: Sun, 04 Dec 2005 22:01:19 +0100
Message-ID: <20051204210118.24032.220.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: Fix calculation of minimum message length

At least, valid nfnetlink message should have nlmsghdr and nfgenmsg.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1ec1f9de65434db4bac6141e25c5b8a6b5110e4f
tree 0eaed90532d67c3ba3281628bfbd256f5cc1163d
parent e512e47b2238a9e367f05a36b4ac2ba53f5ad12e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 04 Dec 2005 16:26:36 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:26:36 +0100

 net/netfilter/nfnetlink.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a60c59b..95fdf04 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -162,7 +162,7 @@ nfnetlink_check_attributes(struct nfnetl
 		return -EINVAL;
 	}
 
-	min_len = NLMSG_ALIGN(sizeof(struct nfgenmsg));
+	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	if (unlikely(nlh->nlmsg_len < min_len))
 		return -EINVAL;
 
@@ -236,8 +236,7 @@ static inline int nfnetlink_rcv_msg(stru
 	}
 
 	/* All the messages must at least contain nfgenmsg */
-	if (nlh->nlmsg_len < 
-			NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct nfgenmsg)))) {
+	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg))) {
 		DEBUGP("received message was too short\n");
 		return 0;
 	}
