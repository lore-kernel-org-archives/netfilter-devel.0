From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/22]: nfnetlink: remove duplicate checks in
	nfnetlink_check_attributes
Date: Wed, 14 Mar 2007 09:50:32 +0100 (MET)
Message-ID: <20070314085017.15282.85833.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: remove duplicate checks in nfnetlink_check_attributes

Remove nfnetlink_check_attributes duplicates message size and callback
id checks. nfnetlink_find_client and nfnetlink_rcv_msg already do
such checks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6399e6156d65ce163cc77aeb6d53eacf9d9a1fb2
tree a5a5206f0e21e755c7d076be09ba1459412b21a6
parent 750623a576cf1a6cd62d138be4da5b95a8419c35
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 08 Mar 2007 18:25:28 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:30:57 +0100

 net/netfilter/nfnetlink.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c8b4f0d..9d33807 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -149,17 +149,10 @@ static int
 nfnetlink_check_attributes(struct nfnetlink_subsystem *subsys,
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
-	int min_len;
+	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	u_int16_t attr_count;
 	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 
-	if (unlikely(cb_id >= subsys->cb_count))
-		return -EINVAL;
-
-	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
-	if (unlikely(nlh->nlmsg_len < min_len))
-		return -EINVAL;
-
 	attr_count = subsys->cb[cb_id].attr_count;
 	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
 
